local lib = require('neotest.lib')
local async = require('neotest.async')
local logger = require('neotest.logging')
local utils = require('neotest-pest.utils')

---@class neotest.Adapter
---@field name string
local NeotestAdapter = { name = "neotest-pest" }

---Find the project root directory given a current directory to work from.
---Should no root be found, the adapter can still be use dina non-project context
---if a test file matches.
---@async
---@param dir string @Directory to treat as cwd
---@return string | nil @Absolute root dir of test suite
NeotestAdapter.root = lib.files.match_root_pattern("composer.json", "tests/Pest.php")

---Filter directories when searching for test files
---@async
---@param name string Name of directory
---@param rel_path string Path to directory, relative to root
---@param root string Root directory of project
---@return boolean True when matching
function NeotestAdapter.filter_dir(name, rel_path, root)
    return vim.startswith(rel_path, "tests")
end

---@async
---@param file_path string
---@return boolean
function NeotestAdapter.is_test_file(file_path)
    return vim.endswith(file_path, "Test.php")
end

function NeotestAdapter.discover_positions(path)
    local query = [[
        ((expression_statement
            (member_call_expression
                name: (name) @member_name (#eq? @member_name "group")
                arguments: (arguments . (argument (string (string_value) @namespace.name)))
            ) @member
        )) @namespace.definition

        ((function_call_expression
            function: (name) @func_name (#match? @func_name "^(test|it)$")
            arguments: (arguments . (argument (string (string_value) @test.name)))
        )) @test.definition
    ]]

    return lib.treesitter.parse_positions(path, query, {
        position_id = "require('neotest-pest.utils').make_test_id",
    })
end

local function get_pest_cmd()
    local binary = "pest"

    if vim.fn.filereadable("vendor/bin/pest") == 1 then
        binary = "vendor/bin/pest"
    end

    return binary
end

local is_callable = function(obj)
    return type(obj) == "function" or (type(obj) == "table" and obj.__call)
end

---@param args neotest.RunArgs
---@return neotest.RunSpec | nil
function NeotestAdapter.build_spec(args)
    local position = args.tree:data()
    local results_path = "storage/app/" .. os.date("junit-%Y%m%d-%H%M%S")

    local binary = get_pest_cmd()

    local command = {}

    if vim.fn.filereadable("vendor/bin/sail") == 1 then
        command = vim.tbl_flatten({
            "vendor/bin/sail", "bin", "pest",
            position.name ~= "tests" and ("/var/www/html" .. string.sub(position.path, string.len(vim.loop.cwd()) + 1)),
            "--log-junit=" .. results_path,
        })
    else
        command = vim.tbl_flatten({
            binary,
            position.name ~= "tests" and position.path,
            "--log-junit=" .. results_path,
        })
    end


    if position.type == "test" then
        local script_args = vim.tbl_flatten({
            "--filter",
            position.name,
        })

        command = vim.tbl_flatten({
            command,
            script_args,
        })
    end

    return {
        command = command,
        context = {
            results_path = results_path,
        },
    }
end

---@async
---@param spec neotest.RunSpec
---@param result neotest.StrategyResult
---@param tree neotest.Tree
---@return neotest.Result[]
function NeotestAdapter.results(test, result, tree)
    local output_file = test.context.results_path

    local ok, data = pcall(lib.files.read, output_file)
    if not ok then
        logger.error("No test output file found:", output_file)
        return {}
    end

    local ok, parsed_data = pcall(lib.xml.parse, data)
    if not ok then
        logger.error("Failed to parse test output:", output_file)
        return {}
    end

    local ok, results = pcall(utils.get_test_results, parsed_data, output_file)
    if not ok then
        logger.error("Could not get test results", output_file)
        return {}
    end

    return results
end

setmetatable(NeotestAdapter, {
    __call = function(_, opts)
        if is_callable(opts.pest_cmd) then
            get_pest_cmd = opts.pest_cmd
        elseif opts.pest_cmd then
            get_pest_cmd = function()
                return opts.pest_cmd
            end
        end
        return NeotestAdapter
    end,
})

return NeotestAdapter

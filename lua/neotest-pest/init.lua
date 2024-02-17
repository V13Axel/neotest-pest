local lib = require('neotest.lib')
local logger = require('neotest.logging')
local utils = require('neotest-pest.utils')
local config = require('neotest-pest.config')
local debug = logger.debug

local notify = function(msg, level)
    vim.notify(msg, level, {
        title = "neotest-pest",
    })
end

local error = function(msg)
    notify(msg, "error")
end

local info = function(msg)
    notify(msg, "info")
end

---@class neotest.Adapter
---@field name string
local NeotestAdapter = { name = "neotest-pest" }

---Find the project root directory given a current directory to work from.
---Should no root be found, the adapter can still be use dina non-project context
---if a test file matches.
---@async
---@param dir string @Directory to treat as cwd
---@return string | nil @Absolute root dir of test suite
function NeotestAdapter.root(dir)
    local result = nil

    debug("Finding root...")

    for _, root_ignore_file in ipairs(config("root_ignore_files")) do
        debug("Checking root ignore file", root_ignore_file)

        result = lib.files.match_root_pattern(root_ignore_file)(dir)

        if result then
            debug("Ignoring root because file", root_ignore_file)
            return nil
        end
    end

    for _, root_file in ipairs(config("root_files")) do
        debug("Checking root file", root_file)

        result = lib.files.match_root_pattern(root_file)(dir)

        if result then
            debug("Found root", result)
            break
        end
    end

    debug("Root not found")

    return result
end

---Filter directories when searching for test files
---@async
---@param name string Name of directory
---@param rel_path string Path to directory, relative to root
---@param root string Root directory of project
---@return boolean True when matching
function NeotestAdapter.filter_dir(name, rel_path, root)
    for _, filter_dir in ipairs(config("filter_dirs")) do
        if name == filter_dir then return false end
    end

    return true
end

---@async
---@param file_path string
---@return boolean
function NeotestAdapter.is_test_file(file_path)
    for _, suffix in ipairs(config("test_file_suffix")) do
        if vim.endswith(file_path, suffix) then return true end
    end

    return false
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

---@param args neotest.RunArgs
---@return neotest.RunSpec | nil
function NeotestAdapter.build_spec(args)
    local position = args.tree:data()
    local results_path = config('results_path')

    debug("Building spec for:", position)
    debug("Results path:", results_path)

    local path = position.path;

    if config('sail_enabled') then
        debug("Sail enabled, adjusting path")
        path = "/var/www/html" .. string.sub(position.path, string.len(vim.loop.cwd() or "") + 1)
    end

    local command = vim.tbl_flatten({
        config('pest_cmd'),
        path,
        "--log-junit=" .. results_path,
    })

    if position.type == "test" then
        command = vim.tbl_flatten({
            command,
            "--filter",
            position.name,
        })
    else
        debug("Position type:", position.type)
    end

    debug("Command:", command)

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
        error("No test output file found! Should have been at: " .. output_file)
        logger.error("No test output file found:", output_file)
        return {}
    end

    local ok, parsed_data = pcall(lib.xml.parse, data)
    if not ok then
        error("Failed to parse test output!")
        logger.error("Failed to parse test output:", output_file)
        return {}
    end

    local ok, results = pcall(utils.get_test_results, parsed_data, output_file)
    if not ok then
        error("Could not get test results!")
        logger.error("Could not get test results", output_file)
        return {}
    end

    return results
end

setmetatable(NeotestAdapter, {
    __call = function(_, opts)
        config.merge(opts or {})

        return NeotestAdapter
    end,
})

return NeotestAdapter

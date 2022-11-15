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
NeotestAdapter.root = lib.files.match_root_pattern("composer.json", "pest.xml")

---@async
---@param file_path string
---@return boolean
function NeotestAdapter.is_test_file(file_path)
    if string.match(file_path, "vendor/") or not string.match(file_path, "tests/") then
        return false
    end
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

    if vim.fn.filereadable("vendor/bin/pest") then
        binary = "vendor/bin/pest"
    end

    return binary
end

local is_callable = function(obj)
    return type(obj) == "function" or (type(obj) == "table" and obj.__call)
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

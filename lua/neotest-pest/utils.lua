local logger = require("neotest.logging")

local M = {}
local separator = "::"

---Generate an id which we can use to match Treesitter queries and Pest tests
---@param position neotest.Position The position to return an ID for
---@return string
M.make_test_id = function(position)
    -- Treesitter ID needs to look like 'tests/Unit/ColsHelperTest.php::it returns the proper format'
    -- which means it should include position.path. However, as of PHPUnit 10, position.path
    -- includes the root directory of the project, which breaks the ID matching.
    -- As such, we need to remove the root directory from the path.
    local path = string.sub(position.path, string.len(vim.loop.cwd()) + 2)

    local id = path .. separator .. position.name
    logger.debug("Path to test file:", { position.path })
    logger.debug("Treesitter id:", { id })

    return id
end

local function get_match_type(captured_nodes)
  if captured_nodes["test.name"] then
    return "test"
  end
  if captured_nodes["namespace.name"] then
    return "namespace"
  end
end

---Given a file path and the captured information for the treesitter query, build out the
---position information for enriching with parameterized tests and use later by neotest
---@param file_path string
---@param source string|integer
---@param captured_nodes table
---@return table|nil
M.build_position = function(file_path, source, captured_nodes)
    local match_type = get_match_type(captured_nodes)
    if not match_type then
        return
    end

    local name = vim.treesitter.get_node_text(captured_nodes[match_type .. ".name"], source)
    local definition = captured_nodes[match_type .. ".definition"]

    logger.debug(captured_nodes)

    return {
        type = match_type,
        path = file_path,
        name = name,
        range = { definition:range() },
        is_parameterized = captured_nodes["with_call"] and true or false,
    }
end

---Recursively iterate through a deeply nested table to obtain specified keys
---@param data_table table
---@param key string
---@param output_table table
---@return table
local function iterate_key(data_table, key, output_table)
    if type(data_table) == "table" then
        for k, v in pairs(data_table) do
            if key == k then
                table.insert(output_table, v)
            end
            iterate_key(v, key, output_table)
        end
    end
    return output_table
end

---Extract the failure messages from the tests
---@param tests table,
---@return boolean,table,table
local function errors_or_fails(tests)
    local failed = false
    local errors = {}
    local fails = {}

    iterate_key(tests, "error", errors)
    iterate_key(tests, "failure", fails)

    if #errors > 0 or #fails > 0 then
        failed = true
    end

    return failed, errors, fails
end

local function make_short_output(test_attr, status)
    return string.upper(status) .. " | " .. test_attr.name
end

---Make the outputs for a given test
---@param test table
---@param output_file string
---@return string, table
local function make_outputs(test, output_file)
    logger.debug("Pre-output test:", test)
    local test_attr = test["_attr"] or test[1]["_attr"]
    local name = string.gsub(test_attr.name, "^it (.*)", "%1")

    -- Difference to neotest-phpunit as of PHPUnit 10:
    -- Pest's test IDs are in the format "path/to/test/file::test name"
    local test_id = string.gsub(test_attr.file, "(.*)::(.*)", "%1") .. separator .. name
    logger.debug("Pest id:", { test_id })

    local test_output = {
        status = "passed",
        short = make_short_output(test_attr, "passed"),
        output_file = output_file,
    }

    local test_failed, errors, fails = errors_or_fails(test)

    if test_failed then
        logger.debug("test_failed:", { test_failed, errors, fails })
        test_output.status = "failed"

        if #errors > 0 then
            local message = errors[1][1]
            test_output.short = make_short_output(test_attr, "error") .. "\n\n" .. message
            test_output.errors = {
                {
                    message = message
                },
            }
        elseif #fails > 0 then
            local message = fails[1][1]
            test_output.short = make_short_output(test_attr, "failed") .. "\n\n" .. message
            test_output.errors = {
                {
                    message = message
                }
            }
        end
    end

    if test['skipped'] then
        test_output.status = "skipped"
        test_output.short = make_short_output(test_attr, "skipped")
    end

    logger.debug("test_output:", test_output)

    return test_id, test_output
end

---Iterate through test results and create a table of test IDs and outputs
---@param tests table
---@param output_file string
---@param output_table table
---@return table
local function iterate_test_outputs(tests, output_file, output_table)
    for i = 1, #tests, 1 do
        if #tests[i] == 0 then
            local test_id, test_output = make_outputs(tests[i], output_file)
            output_table[test_id] = test_output
        else
            iterate_test_outputs(tests[i], output_file, output_table)
        end
    end
    return output_table
end

---Get the test results from the parsed xml
---@param parsed_xml_output table
---@param output_file string
---@return neotest.Result[]
M.get_test_results = function(parsed_xml_output, output_file)
    local tests = iterate_key(parsed_xml_output, "testcase", {})
    return iterate_test_outputs(tests, output_file, {})
end

return M

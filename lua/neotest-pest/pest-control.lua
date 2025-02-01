local lib = require("neotest.lib")
local config = require("neotest-pest.config")
local debug = require('neotest.logging').debug

local M = {}

--- Synchronously runs `pest` with the --list-tests-xml option,
--- pointed at /dev/stdout so we can capture the xml it outputs.
---
--- Because the command assumes it's writing a file, that output 
--- contains some extra text at the end that is trimmed off, then
--- we can use the XML from there.
M.run_pest_test_discovery = function(file_path)
    local command = config('pest_cmd')

    vim.list_extend(command, {
        "--list-tests-xml",
        "/dev/stdout", -- Since list-tests-xml requires a filename, write to stdout
        "--colors=never", -- This makes it so that we can use a simple find/replace for the INFO text after the XML
        file_path,
    })

    local result = { lib.process.run(command, { stdout = true }) }

    if not result[2] then
        debug("pest command failed somehow")
        debug(result)
    end

    debug(result[2].stdout)
end


return M

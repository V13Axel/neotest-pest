local logger = require('neotest.logging')

local is_callable = function(obj)
    return type(obj) == "function" or (type(obj) == "table" and obj.__call)
end

local M = {
    opts = {},
}

function M.get(key)
    if M.opts[key] then
        if is_callable(M.opts[key]) then
            return M.opts[key]()
        end

        return M.opts[key]
    end

    return M[key]()
end

function M.enable_sail()
    if vim.fn.filereadable("vendor/bin/sail") ~= 1 then
        logger.error("Sail executable not found")
        return false
    end

    logger.debug("Attempting to check if sail is running")
    local sail_ps_output = vim.fn.system("vendor/bin/sail ps | wc -l")

    logger.debug("Sail ps output:", sail_ps_output)

    if sail_ps_output > 1 then
        logger.debug("Sail is running")
        return true
    end

    logger.debug("Sail is not running")

    return false
end

function M.pest_cmd()
    local binary = "pest"

    if vim.fn.filereadable("vendor/bin/pest") == 1 then
        binary = "vendor/bin/pest"
    end

    return binary
end

function M.env()
    return {}
end

function M.root_ignore_files()
    return {}
end

function M.root_files()
    return { "tests/Pest.php" }
end

function M.filter_dirs()
    return { "tests" }
end

return M

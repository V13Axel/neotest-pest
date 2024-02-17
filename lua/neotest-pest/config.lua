local logger = require('neotest.logging')
local ok, async = pcall(require, "nio")
if not ok then
  async = require("neotest.async")
end

local is_callable = function(obj)
    return type(obj) == "function" or (type(obj) == "table" and obj.__call)
end

local M = {
    env = {
        root_ignore_files = {},
        root_files = { "tests/Pest.php" },
        filter_dirs = { "vendor" },
        test_file_suffix = { "Test.php" },
        autostart_sail = false,
        sail_executable = "vendor/bin/sail",
    },

    _sail_error = false,
    _sail_running = false,
}

function M.get(key)
    if is_callable(M.env[key] or nil) then
        return M.env[key]()
    end

    return M.env[key] or {}
end

function M.env.sail_enabled()
    if M.sail_available() == false then
        logger.error("Sail executable not found")
        return false
    end

    if M.sail_running() then
        logger.info("Sail is already running")
        return true
    end

    if M.get('autostart_sail') then
        return M.start_sail();
    end

    vim.api.nvim_echo({ {
        "Sail not running, and not configured to autostart! add 'autostart_sail = true' to your config or start it manually",
        "None",
    } }, false, {})
    return false
end

function M.env.results_path()
    if M.get('sail_enabled') then
        return "storage/app/" .. os.date("junit-%Y%m%d-%H%M%S")
    end

    return async.fn.tempname()
end

function M.sail_error()
    return M._sail_error
end

function M.sail_available()
    return vim.fn.filereadable(M.get('sail_executable')) == 1
end

function M.sail_running()
    if (M._sail_running) then
        return true
    end

    logger.info("Attempting to check if sail is running")
    local sail_ps_output = vim.fn.system("vendor/bin/sail ps | wc -l")

    logger.info("Sail ps output:", sail_ps_output)

    if tonumber(sail_ps_output) > 1 then
        logger.info("Sail is running")
        M._sail_running = true
        return true
    end

    logger.info("Sail is not running")

    return false
end

function M.start_sail()
    logger.info("Attempting to start sail")
    vim.api.nvim_echo({ { "Sail not running! Attempting to start it...", "None" } }, false, {})

    local sail_up_output = vim.fn.system("vendor/bin/sail up -d") or ""
    logger.info("Sail up output:", sail_up_output)

    if vim.v.shell_error == 0 then
        logger.info("Sail started successfully")
        vim.api.nvim_echo({ { "Sail started!", "None" } }, false, {})
        M._sail_running = true
        return true
    end

    logger.error("Failed to start sail")
    logger.error("Sail up output:", sail_up_output)
    logger.error("Sail up error:", vim.v.shell_error)
    vim.api.nvim_echo({ { "Failed to start sail!", "ErrorMsg" } }, false, {})
    M._sail_error = true

    return false
end

function M.env.pest_cmd()
    local binary = "pest"

    if vim.fn.filereadable("vendor/bin/pest") == 1 then
        binary = "vendor/bin/pest"
    end

    return binary
end

function M.merge(env)
    for key, value in pairs(env) do
        M.env[key] = value
    end
end

return M

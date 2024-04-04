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
        ignore_dirs = { "vendor", "node_modules" },
        test_file_suffixes = { "Test.php" },
        sail_executable = "vendor/bin/sail",
        sail_project_path = "/var/www/html",
        parallel = 0,
        compact = false,
    },

    _sail_error = false,
    _sail_enabled = false,
}

function M.env.sail_enabled()
    -- Cache and short-circuit so we don't have to check the disk for
    -- vnedor/bin/sail every time. If the user removes the sail executable
    -- out from under us, that's their problem.
    if M._sail_enabled then
        return true
    end

    return M.sail_available()
end

function M.env.is_parallel()
    return M('parallel') > 0
end

function M.env.pest_cmd()
    if M('sail_enabled') then
        return { "vendor/bin/sail", "bin", "pest" }
    end

    return { "vendor/bin/pest" }
end

function M.env.results_path()
    if M('sail_enabled') then
        return "storage/app/" .. os.date("pest-%Y%m%d-%H%M%S")
    end

    return async.fn.tempname()
end

function M.sail_error()
    return M._sail_error
end

function M.sail_available()
    if (vim.fn.filereadable(M('sail_executable')) == 1) and (vim.fn.filereadable("docker-compose.yml") == 1) then
        M._sail_enabled = true
        return true
    end

    M._sail_error = true
    logger.debug("Sail executable not found")
end

function M.merge(env)
    for key, value in pairs(env) do
        M.env[key] = value
    end
end

setmetatable(M, {
    __call = function(_, key)
        if is_callable(M.env[key] or nil) then
            return M.env[key]()
        end

        return M.env[key] or {}
    end
})

return M

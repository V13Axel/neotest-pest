local is_callable = function(obj)
    return type(obj) == "function" or (type(obj) == "table" and obj.__call)
end

local M = {}

M.opts = {}

M.available_opts = {
    "enable_sail",
    "pest_cmd",
    "root_ignore_files",
    "root_files",
    "filter_dirs",
    "env",
}

M.get = function(key)
    if M.opts[key] then
        if is_callable(M.opts[key]) then
            return M.opts[key]()
        end

        return M.opts[key]
    end

    if M[key] then
        return M[key]()
    end

    return {}
end

M.enable_sail = function()
    return vim.fn.filereadable("vendor/bin/sail") == 1
end

M.pest_cmd = function()
    local binary = "pest"

    if vim.fn.filereadable("vendor/bin/pest") == 1 then
        binary = "vendor/bin/pest"
    end

    return binary
end

M.env = function()
    return {}
end

M.root_ignore_files = function()
    return {}
end

M.root_files = function()
    return { "tests/Pest.php" }
end

M.filter_dirs = function()
    return { ".git", "node_modules", "vendor" }
end

return M

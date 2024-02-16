local M = {}

M.enable_sail = function()
    return vim.fn.filereadable("vendor/bin/sail") == 1
end

M.get_pest_cmd = function()
    local binary = "pest"

    if vim.fn.filereadable("vendor/bin/pest") == 1 then
        binary = "vendor/bin/pest"
    end

    return binary
end

M.get_env = function()
  return {}
end

M.get_root_ignore_files = function()
  return {}
end

M.get_root_files = function()
  return { "tests/Pest.php" }
end

M.get_filter_dirs = function()
  return { ".git", "node_modules", "vendor" }
end

return M

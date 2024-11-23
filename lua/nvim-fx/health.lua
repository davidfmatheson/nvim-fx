local M = {}

M.check = function()
    vim.health.start("fx overlay")

    -- Check if fx is available
    if vim.fn.executable("fx") == 0 then
        vim.health.error("fx not found on path")
        return
    end

    -- Indicate that we found fx, which is good!
    vim.health.ok("fx found on path")

    -- Pull the version information about fx
    local results = vim.system({ "fx", "--version" }, { text = true }):wait()

    -- If we get a non-zero exit code, something went wrong
    if results.code ~= 0 then
        vim.health.error("failed to retrieve fx's version", results.stderr)
        return
    end

    -- Attempt to parse fx's version string to get the
    -- semantic version string, which comes after the word
    -- fx and before the parentheses. (e.g. "fx 8.6.0 (...)")
    --
    -- NOTE: While `vim.version.parse` should return nil on invalid input,
    --       having something really invalid like "abc" will cause it to
    --       throw an error on neovim 0.10.0! Make sure you're using 0.10.2!
    local v = vim.version.parse(vim.split(results.stdout or "", " ")[2])
    if not v then
        vim.health.error("invalid fx version output", results.stdout)
        return
    end

    -- Require fx 8.x.x
    if v.major ~= 8 then
        vim.health.error("fx must be 8.x.x, but got " .. tostring(v))
        return
    end

    -- Fx is a good version, so lastly we'll test the weather site
    vim.health.ok("fx " .. tostring(v) .. " is an acceptable version")
end

return M

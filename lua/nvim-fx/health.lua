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

    local v = vim.version.parse(results.stdout or "")
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

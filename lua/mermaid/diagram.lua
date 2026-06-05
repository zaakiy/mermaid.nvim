local M = {}

--- Extract mermaid diagram from ```mermaid ... ``` fenced code blocks.
--- If no fences found, returns original content (for pure mermaid files).
function M.extract(content)
    local fence_start = content:find("```mermaid", 1, true)
    if not fence_start then
        return content
    end

    -- Find the closing fence: ``` at start of a new line
    local end_pos = 0
    local search_from = fence_start + 10

    while true do
        local pos = content:find("\n```", search_from)
        if not pos then break end

        -- Verify this ``` is at the start of a line
        local before = pos > 1 and content:sub(pos - 1, pos - 1) or ""
        if before == "\n" or before == "\r" then
            -- Check it's actually the start of a line
            local line_start = pos
            while line_start > 1 and content:sub(line_start - 1, line_start - 1) ~= "\n" do
                line_start = line_start - 1
            end
            -- Check there's no content before the ``` on this line (only whitespace)
            local line_before = content:sub(line_start, pos - 1)
            if line_before:match("^%s*$") then
                end_pos = pos + 3
                break
            end
        end
        search_from = pos + 1
    end

    if end_pos == 0 then
        -- No closing fence found; return from fence_start to end
        return content:sub(fence_start)
    end

    return content:sub(fence_start, end_pos)
end

return M

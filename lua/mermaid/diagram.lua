local M = {}

--- Extract mermaid diagram content from fenced code blocks.
--- Returns only the diagram content (excluding fence markers).
--- If no fences found, returns original content (for pure mermaid files).
function M.extract(content)
    -- Find opening fence: ```mermaid (or ```flowchart, etc.)
    local fence_start = content:find("```", 1, true)
    if not fence_start then
        return content
    end

    -- Get the fence type (e.g., "mermaid", "flowchart") between fences
    local fence_type_end = content:find("\n", fence_start)
    if not fence_type_end then
        return content
    end
    local fence_type = content:sub(fence_start + 3, fence_type_end - 1):gsub("^%s+", "")
    
    -- Only process if the content looks like a mermaid fence
    -- Accept "mermaid" or any known mermaid diagram type keyword
    local is_mermaid_fence = fence_type == "mermaid" or fence_type:match("^[a-z]")
    
    local content_start = fence_type_end + 1

    -- Find closing fence: ``` on its own line (possibly with trailing whitespace)
    local end_pos = 0
    local search_from = content_start

    while true do
        local rest = content:sub(search_from)
        local newline = rest:find("\n")
        if not newline then break end
        local line_start = search_from + newline - 1
        -- Check if this line starts with ```
        local fence_candidate = content:sub(line_start, line_start + 2)
        if fence_candidate == "```" then
            local after_fence = content:sub(line_start + 3, line_start + 10)
            if after_fence == "" or after_fence:match("^[%s\r\n]*$") then
                end_pos = line_start
                break
            end
        end
        search_from = line_start + 1
    end

    local content_end
    if end_pos == 0 then
        -- No closing fence found; return from content_start to end, trim trailing whitespace
        content_end = #content
    else
        content_end = end_pos - 1
    end

    -- Strip trailing whitespace/newlines at end
    while content_end >= content_start and content:sub(content_end, content_end):match("[%s\n\r]") do
        content_end = content_end - 1
    end

    return content:sub(content_start, content_end)
end

return M

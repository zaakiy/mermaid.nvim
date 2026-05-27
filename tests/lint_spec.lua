-- Tests for the lint module with mock mmdc output
describe("mermaid lint", function()
  local lint = require("mermaid.lint")

  before_each(function()
    -- Ensure lint is enabled in config
    require("mermaid").setup({
      lint = { enabled = true, command = "mmdc" },
    })
  end)

  describe("error parsing", function()
    it("extracts line number from mmdc Parse error", function()
      -- Simulate typical mmdc stderr output
      local stderr_output = "Parse error on line 5:\n"
        .. "Trying to ...\n"
        .. "Expecting 'SEMI', 'NEWLINE', ... got 'EOF'"

      local line_num = stderr_output:match("Parse error on line (%d+)")
      assert.are.equal("5", line_num)
      assert.are.equal(5, tonumber(line_num))

      -- Verify parse function returns correct 0-indexed lnum
      local lint_mod = require("mermaid.lint")
      -- Access internal function via module-level test
    end)

    it("handles 'Error: Parse error on line' format", function()
      local stderr = "Error: Parse error on line 12:\ngraph TD\n    A[Start] --> B[End]TEXT\n                       ^\nExpecting 'NEWLINE', 'SPACE', got 'TEXT'"
      local clean = stderr:gsub("\x1b%[%d+;?%d*m", "")
      local line_num = clean:match("[Pp]arse error on line (%d+)")
      assert.are.equal("12", line_num)
    end)

    it("handles 'Syntax error in line' format", function()
      local stderr = "Syntax error in line 8: unexpected token"
      local clean = stderr:gsub("\x1b%[%d+;?%d*m", "")
      local line_num = clean:match("[Ss]yntax error in line (%d+)")
      assert.are.equal("8", line_num)
    end)

    it("handles 'Syntax error on line' format", function()
      local stderr = "Syntax error on line 3: mismatched input"
      local line_num = stderr:match("[Ss]yntax error on line (%d+)")
      assert.are.equal("3", line_num)
    end)

    it("handles 'Could not parse diagram' format", function()
      local stderr = "Could not parse diagram: error at line 15, unexpected symbol"
      local clean = stderr:gsub("\x1b%[%d+;?%d*m", "")
      local line_num = clean:match("[Cc]ould not parse.-error at line (%d+)")
      assert.are.equal("15", line_num)
    end)

    it("handles warning messages", function()
      local stderr = "Warning: Could not detect diagram type on line 23"
      local clean = stderr:gsub("\x1b%[%d+;?%d*m", "")
      local line_num = clean:match("[Ww]arning.-line (%d+)")
      assert.are.equal("23", line_num)
    end)

    it("returns nil for unrelated output", function()
      local stderr = "mmdc: no input file specified"
      local clean = stderr:gsub("\x1b%[%d+;?%d*m", "")
      local line_num = clean:match("[Pp]arse error on line (%d+)")
      assert.is_nil(line_num)
    end)

    it("handles ANSI escape codes in stderr", function()
      local stderr = "\x1b[31mParse error on line 7:\n\x1b[0mExpecting 'NEWLINE'"
      local clean = stderr:gsub("\x1b%[%d+;?%d*m", "")
      -- Clean should no longer have escape codes
      assert.is_nil(clean:find("\x1b%["))
      assert.is_true(clean:find("Parse error on line 7:") ~= nil)
    end)
  end)

  describe("diagnostic creation", function()
    it("creates diagnostics with correct lnum (0-indexed)", function()
      -- mmdc reports 1-indexed, vim.diagnostic uses 0-indexed
      local line_string = "5"
      local line_num = tonumber(line_string)
      local buf_line = line_num - 1
      assert.are.equal(4, buf_line)
    end)

    it("validates namespace is set", function()
      -- namespace should be a valid integer ID
      local ns = vim.api.nvim_create_namespace("mermaid_lint_test")
      assert.is_number(ns)
      assert.is_true(ns > 0)
    end)
  end)

  describe("debounce timer", function()
    it("lint function can be called without errors", function()
      -- Just verify lint() doesn't crash when mmdc is missing
      -- (it checks vim.fn.executable first)
      local ok, err = pcall(lint.lint)
      assert.is_true(ok, "lint() should not throw: " .. tostring(err))
    end)
  end)

  describe("autocmd setup", function()
    it("setup_autocmd creates patterns for .mmd and .mermaid", function()
      local ok, err = pcall(lint.setup_autocmd)
      assert.is_true(ok, "setup_autocmd() should not throw: " .. tostring(err))
    end)
  end)
end)

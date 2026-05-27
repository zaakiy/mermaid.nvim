-- Tests for the render module
describe("mermaid render", function()
  local render

  before_each(function()
    render = require("mermaid.render")
  end)

  describe("capability detection", function()
    it("detect_capability always returns a valid string", function()
      local cap = render.detect_capability()
      assert.is_string(cap)
      local valid = { kitty = true, iterm2 = true, sixel = true, chafa = true, none = true }
      assert.is_true(valid[cap] ~= nil, "Unexpected capability: " .. cap)
    end)

    it("capability_label returns a human-readable label", function()
      local label = render.capability_label("kitty")
      assert.is_string(label)
      assert.is_true(#label > 0)

      assert.is_string(render.capability_label("none"))
      assert.is_string(render.capability_label("chafa"))
    end)

    it("capability_label handles unknown values", function()
      local label = render.capability_label("unknown_protocol")
      assert.is_string(label)
    end)

    it("is_available returns boolean", function()
      local avail = render.is_available()
      assert.is_boolean(avail)
    end)
  end)

  describe("SVG generation", function()
    it("generate_svg returns error when mmdc is absent", function()
      -- This test should work regardless of mmdc being installed
      local result = render.generate_svg("graph TD\nA-->B")
      -- If mmdc exists, it might succeed. If not, should return error.
      assert.is_table(result)
      assert.is_boolean(result.ok)
      if not result.ok then
        assert.is_string(result.error)
      end
    end)

    it("generate_svg accepts custom output path", function()
      local tmp = os.tmpname() .. ".svg"
      local result = render.generate_svg("graph LR\nX-->Y", tmp)
      -- Cleanup if file was created
      pcall(os.remove, tmp)
      assert.is_table(result)
    end)
  end)

  describe("file rendering", function()
    it("render_file returns error for non-existent file", function()
      local result = render.render_file("/nonexistent/file.svg")
      assert.is_false(result.ok)
      assert.is_string(result.error)
    end)
  end)

  describe("source rendering", function()
    it("render_source works end-to-end or returns a clear error", function()
      local result = render.render_source("graph TD\nA-->B")
      assert.is_table(result)
      -- Either succeeds (uncommon without mmdc) or gives a clear error
      if not result.ok then
        assert.is_string(result.error)
      end
    end)
  end)
end)

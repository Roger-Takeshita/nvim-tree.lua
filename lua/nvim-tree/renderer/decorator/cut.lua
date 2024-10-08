local HL_POSITION = require("nvim-tree.enum").HL_POSITION
local ICON_PLACEMENT = require("nvim-tree.enum").ICON_PLACEMENT

local Decorator = require("nvim-tree.renderer.decorator")

---@class (exact) DecoratorCut: Decorator
---@field enabled boolean
---@field icon HighlightedString|nil
local DecoratorCut = Decorator:new()

---@param opts table
---@param explorer Explorer
---@return DecoratorCut
function DecoratorCut:new(opts, explorer)
  local o = Decorator.new(self, {
    explorer = explorer,
    enabled = true,
    hl_pos = HL_POSITION[opts.renderer.highlight_clipboard] or HL_POSITION.none,
    icon_placement = ICON_PLACEMENT.none,
  })
  ---@cast o DecoratorCut

  return o
end

---Cut highlight: renderer.highlight_clipboard and node is cut
---@param node Node
---@return string|nil group
function DecoratorCut:calculate_highlight(node)
  if self.hl_pos ~= HL_POSITION.none and self.explorer.clipboard:is_cut(node) then
    return "NvimTreeCutHL"
  end
end

return DecoratorCut

local view = require("nvim-tree.view")
local utils = require("nvim-tree.utils")
local core = require("nvim-tree.core")

local M = {}

---@param should_close boolean|nil
---@return fun(node: Node): boolean|nil
function M.fn(should_close)
  should_close = should_close or false

  return function(node)
    local explorer = core.get_explorer()
    node = node:last_group_node()
    if should_close and node.open then
      node.open = false
      if explorer then
        explorer.renderer:draw()
      end
      return
    end

    local parent = node:get_parent_of_group().parent

    if not parent or not parent.parent then
      return view.set_cursor({ 1, 0 })
    end

    local _, line = utils.find_node(core.get_explorer().nodes, function(n)
      return n.absolute_path == parent.absolute_path
    end)

    view.set_cursor({ line + 1, 0 })
    if should_close then
      parent.open = false
      if explorer then
        explorer.renderer:draw()
      end
    end
  end
end

return M

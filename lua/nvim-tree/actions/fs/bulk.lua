local utils = require("nvim-tree.utils")
local Node = require("nvim-tree.node")

local M = {}

---@param node_or_nodes Node|Node[]|nil
---@return Node[]
local function normalize_nodes(node_or_nodes)
  if not node_or_nodes then
    return {}
  end

  local nodes
  if type(node_or_nodes) == "table" and node_or_nodes.is and node_or_nodes:is(Node) then
    nodes = { node_or_nodes }
  else
    nodes = node_or_nodes
  end

  local filtered = {}
  for _, node in ipairs(nodes) do
    if node and node.absolute_path and node.name ~= ".." then
      table.insert(filtered, node)
    end
  end

  -- A selected folder already contains every selected descendant.
  -- Operating only on the top-level folder performs one recursive move/delete.
  return utils.filter_descendant_nodes(filtered)
end

---Cut one or more nodes to the nvim-tree clipboard.
---@param explorer Explorer
---@param node_or_nodes Node|Node[]|nil
function M.cut(explorer, node_or_nodes)
  local is_array = type(node_or_nodes) == "table" and not (node_or_nodes.is and node_or_nodes:is(Node))
  local nodes = normalize_nodes(node_or_nodes)
  if #nodes == 0 then
    return
  end

  vim.schedule(function()
    if is_array then
      explorer.clipboard:cut(nodes)
    else
      explorer.clipboard:cut(nodes[1])
    end
  end)
end

---Delete one or more nodes with a single confirmation prompt.
---@param node_or_nodes Node|Node[]|nil
function M.remove(node_or_nodes)
  local is_array = type(node_or_nodes) == "table" and not (node_or_nodes.is and node_or_nodes:is(Node))
  local nodes = normalize_nodes(node_or_nodes)
  if #nodes == 0 then
    return
  end

  vim.schedule(function()
    require("nvim-tree.actions.fs.remove-file").fn(is_array and nodes or nodes[1])
  end)
end

---Paste the clipboard at a node or at the tree root.
---@param explorer Explorer
---@param node Node|nil
---@param opts? { cut?: boolean }
function M.paste(explorer, node, opts)
  explorer.clipboard:paste(node, opts)
end

---Copy one or more nodes to the nvim-tree clipboard.
---@param explorer Explorer
---@param node_or_nodes Node|Node[]|nil
function M.copy(explorer, node_or_nodes)
  local is_array = type(node_or_nodes) == "table" and not (node_or_nodes.is and node_or_nodes:is(Node))
  local nodes = normalize_nodes(node_or_nodes)
  if #nodes == 0 then
    return
  end

  vim.schedule(function()
    if is_array then
      explorer.clipboard:copy(nodes)
    else
      explorer.clipboard:copy(nodes[1])
    end
  end)
end

return M

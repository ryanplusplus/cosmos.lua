Cosmos = {}

function Cosmos:new()
  local o = {}
  setmetatable(o, Cosmos)
  self.__index = self
  return o
end

function Cosmos:newEntity()
  return Entity:new()
end

Entity = {}

function Entity:new()
  local o = {}
  setmetatable(o, Entity)
  self.__index = self
  o.components = {}
  return o
end

function Entity:addComponent(name, data)
  data = data or {}
  self.components[name] = data
end

return Cosmos

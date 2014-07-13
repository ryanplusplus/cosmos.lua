Scene = {}

function Scene:new()
  local o = {}
  setmetatable(o, Scene)
  self.__index = self
  o.updateSystems = {}
  o.renderSystems = {}
  return o
end

function Scene:newEntity()
  return Entity:new()
end

function Scene:addUpdateSystem(updateSystem)
  self.updateSystems[updateSystem] = true
end

function Scene:removeUpdateSystem(updateSystem)
  self.updateSystems[updateSystem] = nil
end

function Scene:update(dt)
  for updateSystem in pairs(self.updateSystems) do
    updateSystem(self, dt)
  end
end

function Scene:addRenderSystem(renderSystem)
  self.renderSystems[renderSystem] = true
end

function Scene:removeRenderSystem(renderSystem)
  self.renderSystems[renderSystem] = nil
end

function Scene:render()
  for renderSystem in pairs(self.renderSystems) do
    renderSystem(self)
  end
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

return Scene

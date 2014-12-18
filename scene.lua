local scene_api = {}
scene_api.__index = scene_api

function Scene()
  return setmetatable({ render_systems = {}, update_systems = {} }, scene_api)
end

function scene_api:new_entity()
  return Entity()
end

function scene_api:add_update_system(update_system)
  self.update_systems[update_system] = true
end

function scene_api:remove_update_system(update_system)
  self.update_systems[update_system] = nil
end

function scene_api:update(dt)
  for update_system in pairs(self.update_systems) do
    update_system(self, dt)
  end
end

function scene_api:add_render_system(render_system)
  self.render_systems[render_system] = true
end

function scene_api:remove_render_system(render_system)
  self.render_systems[render_system] = nil
end

function scene_api:render()
  for render_system in pairs(self.render_systems) do
    render_system(self)
  end
end

entity_api = {}
entity_api.__index = entity_api

function Entity()
  return setmetatable({ components = {} }, entity_api)
end

function entity_api:add_component(name, data)
  data = data or {}
  self.components[name] = data
end

return Scene

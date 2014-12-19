local scene_api = {}
scene_api.__index = scene_api

function remove_value(t, value)
  local to_remove = {}

  for i, v in ipairs(t) do
    if v == value then
      table.insert(to_remove, i)
    end
  end

  for _, i in ipairs(to_remove) do
    table.remove(t, i)
  end
end

function Scene()
  return setmetatable({ render_systems = {}, update_systems = {} }, scene_api)
end

function scene_api:new_entity()
  return Entity()
end

function scene_api:add_update_system(update_system)
  table.insert(self.update_systems, update_system)
end

function scene_api:remove_update_system(update_system)
  remove_value(self.update_systems, update_system)
end

function scene_api:update(dt)
  for _, update_system in ipairs(self.update_systems) do
    update_system(self, dt)
  end
end

function scene_api:add_render_system(render_system)
  table.insert(self.render_systems, render_system)
end

function scene_api:remove_render_system(render_system)
  remove_value(self.render_systems, render_system)
end

function scene_api:render()
  for _, render_system in ipairs(self.render_systems) do
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

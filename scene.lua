-- local scene_api = {}
-- scene_api.__index = scene_api

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
  local render_systems = {}
  local update_systems = {}
  local entities = {}

  return {
    new_entity = function()
      local entity = Entity()
      entities[entity] = true
      return entity
    end,

    entities = function()
      return entities
    end,

    entities_with = function(self, ...)
      local entities_with = {}
      local components = table.pack(...)

      for entity in pairs(entities) do
        local has_all = true

        for _, component in ipairs(components) do
          if not entity[component] then has_all = false end
        end

        if has_all then entities_with[entity] = true end
      end

      return entities_with
    end,

    add_update_system = function(self, update_system)
      table.insert(update_systems, update_system)
      return self
    end,

    remove_update_system = function(self, update_system)
      remove_value(update_systems, update_system)
      return self
    end,

    update = function(self, dt)
      for _, update_system in ipairs(update_systems) do
        update_system(self, dt)
      end
    end,

    add_render_system = function(self, render_system)
      table.insert(render_systems, render_system)
      return self
    end,

    remove_render_system = function(self, render_system)
      remove_value(render_systems, render_system)
      return self
    end,

    render = function(self)
      for _, render_system in ipairs(render_systems) do
        render_system(self)
      end
    end
  }
end

entity_api = {}
entity_api.__index = entity_api

function Entity()
  return setmetatable({ }, entity_api)
end

function entity_api:add_component(name, data)
  data = data or {}
  self[name] = data
  return self
end

return Scene

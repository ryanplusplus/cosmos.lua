if not table.pack then
  function table.pack (...)
    return { n = select('#', ...); ... }
  end
end

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

function has_components(entity, components)
  local has_all = true

  for _, component in ipairs(components) do
    if not entity[component] then has_all = false end
  end

  return has_all
end

function update_caches(caches, entity)
  for s, cache in pairs(caches) do
    cache.entities[entity] = has_components(entity, cache.components) or nil
  end
end

function Scene()
  local render_systems = {}
  local update_systems = {}
  local entities = {}
  local caches = {}

  function Entity()
    local components = {}

    return setmetatable({}, {
      __index = function(entity, component)
        return components[component]
      end,

      __newindex = function(entity, component, v)
        if v == nil or components[component] == nil then
          components[component] = v
          update_caches(caches, entity)
        else
          components[component] = v
        end
      end
    })
  end

  return {
    new_entity = function(self, components)
      components = components or {}

      local entity = Entity()
      entities[entity] = true

      for k, v in pairs(components) do
        entity[k] = v
      end

      return entity
    end,

    remove_entity = function(self, entity)
      entities[entity] = nil
    end,

    entities = function(self)
      return entities
    end,

    entities_with = function(self, ...)
      local entities_with = {}
      local components = table.pack(...)
      local component_string = table.concat(components, ';')

      if caches[component_string] then
        return caches[component_string].entities
      end

      for entity in pairs(entities) do
        if has_components(entity, components) then
          entities_with[entity] = true
        end
      end

      caches[component_string] = {
        components = components,
        entities = entities_with
      }

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

return Scene

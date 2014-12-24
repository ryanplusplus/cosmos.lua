scene.lua
==========

Entity-component-system scene library in Lua

## Development Dependencies
### Mach
luarocks install mach

### Busted
luarocks install busted

## Usage
### Creating a Scene

```lua
local Scene = require 'scene'
local scene = Scene()
```

### Creating an Entity

```lua
local entity = scene:new_entity()
```

### Adding a Component to an Entity

```lua
entity.position = { x = 5, y = 10 }
```

### Removing a Component From an Entity

```lua
entity.position = nil
```

### Updating

```lua
local update_system = function(scene, dx) print('Updating with timestep ' .. dx) end
scene:add_update_system(update_system)

scene:update(0.16) --> Updating with timestep 0.16

scene:remove_update_system(update_system)
```

### Rendering

```lua
local render_system = function(scene) print('Rendering') end
scene:add_render_system(render_system)

scene:render() --> Rendering

scene:remove_render_system(render_system)
```

### Retrieving Entities

```lua
-- Retrieve a set of all entities
scene:entities()

-- Retrieve a set of entities with position and velocity components
-- Requests are cached to maintain performance even with a large number of entities
scene:entities_with('position', 'velocity')
```

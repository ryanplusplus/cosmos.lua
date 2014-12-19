describe('The scene.lua ECS', function()
  local Scene = require 'scene'
  local mach = require 'mach'

  it('should allow you to create a new scene', function()
    Scene()
  end)

  describe('(once instantiated)', function()
    local scene

    local s1 = mach.mock_function('s1')
    local s2 = mach.mock_function('s2')
    local s3 = mach.mock_function('s3')

    before_each(function()
      scene = Scene()
    end)

    it('should allow you to create a new entity with no components', function()
      local some_entity = scene:new_entity()

      assert.is_not.falsy(some_entity)

      for _ in pairs(some_entity.components) do
        assert.falsy('should have no components')
      end
    end)

    it('should allow you to add a component to an entity', function()
      local some_entity = scene:new_entity()
      some_entity:add_component('component')

      assert.is_not.falsy(some_entity.components.component)
    end)

    it('should allow you to add a component with data to an entity', function()
      local some_entity = scene:new_entity()
      local component_data = {a = 1, b = 2}
      some_entity:add_component('component_with_data', component_data)

      assert.is.equal(component_data, some_entity.components.component_with_data)
    end)

    it('should allow you to add an update system', function()
      local s = mach.mock_function('s')

      scene:add_update_system(s)

      mach(s):should_be_called_with(scene, 0.25):
      when(function() scene:update(0.25) end)
    end)

    it('should allow you to add multiple update systems that will be invoked in order', function()
      scene:add_update_system(s1)
      scene:add_update_system(s3)
      scene:add_update_system(s2)

      mach(s1):should_be_called_with(scene, 0.25):
      and_then(mach(s3):should_be_called_with(scene, 0.25)):
      and_then(mach(s2):should_be_called_with(scene, 0.25)):
      when(function() scene:update(0.25) end)
    end)

    it('should allow you to remove an update system', function()
      scene:add_update_system(s1)
      scene:add_update_system(s2)
      scene:add_update_system(s3)
      scene:remove_update_system(s2)

      mach(s1):should_be_called_with(scene, 0.25):
      and_also(mach(s3):should_be_called_with(scene, 0.25)):
      when(function() scene:update(0.25) end)
    end)

    it('should not blow up if you update with no update systems', function()
      scene:update(0.12)
    end)

    it('should allow you to add a render system', function()
      local s = mach.mock_function('s')

      scene:add_render_system(s)

      mach(s):should_be_called_with(scene):
      when(function() scene:render() end)
    end)

    it('should allow you to add multiple render systems that will be invoked in order', function()
      scene:add_render_system(s1)
      scene:add_render_system(s3)
      scene:add_render_system(s2)

      mach(s1):should_be_called_with(scene):
      and_then(mach(s3):should_be_called_with(scene)):
      and_then(mach(s2):should_be_called_with(scene)):
      when(function() scene:render() end)
    end)

    it('should allow you to remove a render system', function()
      scene:add_render_system(s1)
      scene:add_render_system(s2)
      scene:add_render_system(s3)
      scene:remove_render_system(s2)

      mach(s1):should_be_called_with(scene):
      and_also(mach(s3):should_be_called_with(scene)):
      when(function() scene:render() end)
    end)

    it('should not blow up if you render with no render systems', function()
      scene:render()
    end)
  end)
end)

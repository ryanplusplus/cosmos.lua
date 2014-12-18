describe('The scene.lua ECS', function()
  local Scene = require 'scene'
  local mach = require 'mach'

  it('should allow you to create a new scene', function()
    local scene = Scene()
  end)

  describe('(once instantiated)', function()
    local scene = Scene()

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
      local componentData = {a = 1, b = 2}
      some_entity:add_component('component_with_data', componentData)

      assert.is.equal(componentData, some_entity.components.component_with_data)
    end)

    it('should allow you to add an update system', function()
      local s = spy.new(function() end)

      scene:add_update_system(s)
      scene:update(0.25)

      assert.spy(s).was.called_with(scene, 0.25)
    end)

    it('should allow you to add multiple update systems', function()
      local s1 = spy.new(function() end)
      local s2 = spy.new(function() end)

      scene:add_update_system(s1)
      scene:add_update_system(s2)
      scene:update(0.25)

      assert.spy(s1).was.called_with(scene, 0.25)
      assert.spy(s2).was.called_with(scene, 0.25)
    end)

    it('should allow you to remove an update system', function()
      local s = spy.new(function() end)

      scene:add_update_system(s)
      scene:remove_update_system(s)
      scene:update(0.25)

      assert.spy(s).was.not_called()
    end)

    it('should allow you to add update systems with priorities', function()
      local s1 = spy.new(function() end)
      local s2 = spy.new(function() end)
      local s3 = spy.new(function() end)

      scene:add_update_system(s1, 1)
      scene:add_update_system(s3, 3)
      scene:add_update_system(s2, 2)
      scene:update(0.15)

      assert.spy(s1).was.called_with(scene, 0.15)
      assert.spy(s2).was.called_with(scene, 0.15)
      assert.spy(s3).was.called_with(scene, 0.15)

      error('need to enforce ordering...')
    end)

    it('should not blow up if you update with no update systems', function()
      scene:update(0.12)
    end)

    it('should allow you to add a render system', function()
      local s = spy.new(function() end)

      scene:add_render_system(s)
      scene:render()

      assert.spy(s).was.called_with(scene)
    end)

    it('should allow you to add multiple render systems', function()
      local s1 = spy.new(function() end)
      local s2 = spy.new(function() end)

      scene:add_render_system(s1)
      scene:add_render_system(s2)
      scene:render()

      assert.spy(s1).was.called_with(scene)
      assert.spy(s2).was.called_with(scene)
    end)

    it('should allow you to remove a render system', function()
      local s = spy.new(function() end)

      scene:add_render_system(s)
      scene:remove_render_system(s)
      scene:render()

      assert.spy(s).was.not_called()
    end)

    it('should allow you to add render systems with priorities', function()
      local s1 = spy.new(function() end)
      local s2 = spy.new(function() end)
      local s3 = spy.new(function() end)

      scene:add_render_system(s1, 1)
      scene:add_render_system(s3, 3)
      scene:add_render_system(s2, 2)
      scene:render()

      assert.spy(s1).was.called_with(scene)
      assert.spy(s2).was.called_with(scene)
      assert.spy(s3).was.called_with(scene)

      error('need to enforce ordering...')
    end)

    it('should not blow up if you render with no render systems', function()
      scene:render()
    end)
  end)
end)

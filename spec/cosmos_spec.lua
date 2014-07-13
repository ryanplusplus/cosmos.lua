describe('The Scene ECS', function()
  local Scene = require 'scene'

  it('should allow you to create a new scene', function()
    local scene = Scene:new()
  end)

  describe('(once instantiated)', function()
    local scene = Scene:new()

    it('should allow you to create a new entity with no components', function()
      local someEntity = scene:newEntity()

      assert.is_not.falsy(someEntity)

      for _ in pairs(someEntity.components) do
        assert.falsy('should have no components')
      end
    end)

    it('should allow you to add a component to an entity', function()
      local someEntity = scene:newEntity()
      someEntity:addComponent('component')

      assert.is_not.falsy(someEntity.components.component)
    end)

    it('should allow you to add a component with data to an entity', function()
      local someEntity = scene:newEntity()
      local componentData = {a = 1, b = 2}
      someEntity:addComponent('component_with_data', componentData)

      assert.is.equal(componentData, someEntity.components.component_with_data)
    end)

    it('should allow you to add an update system', function()
      local s = spy.new(function() end)

      scene:addUpdateSystem(s)
      scene:update(0.25)

      assert.spy(s).was.called_with(scene, 0.25)
    end)

    it('should allow you to add multiple update systems', function()
      local s1 = spy.new(function() end)
      local s2 = spy.new(function() end)

      scene:addUpdateSystem(s1)
      scene:addUpdateSystem(s2)
      scene:update(0.25)

      assert.spy(s1).was.called_with(scene, 0.25)
      assert.spy(s2).was.called_with(scene, 0.25)
    end)

    it('should allow you to remove an update system', function()
      local s = spy.new(function() end)

      scene:addUpdateSystem(s)
      scene:removeUpdateSystem(s)
      scene:update(0.25)

      assert.spy(s).was.not_called()
    end)

    it('should allow you to add update systems with priorities', function()
      error('todo')
    end)

    it('should not blow up if you update with no update systems', function()
      scene:update(0.12)
    end)

    it('should allow you to add a render system', function()
      local s = spy.new(function() end)

      scene:addRenderSystem(s)
      scene:render()

      assert.spy(s).was.called_with(scene)
    end)

    it('should allow you to add multiple render systems', function()
      local s1 = spy.new(function() end)
      local s2 = spy.new(function() end)

      scene:addRenderSystem(s1)
      scene:addRenderSystem(s2)
      scene:render()

      assert.spy(s1).was.called_with(scene)
      assert.spy(s2).was.called_with(scene)
    end)

    it('should allow you to remove a render system', function()
      local s = spy.new(function() end)

      scene:addRenderSystem(s)
      scene:removeRenderSystem(s)
      scene:render()

      assert.spy(s).was.not_called()
    end)

    it('should allow you to add render systems with priorities', function()
      error('todo')
    end)

    it('should not blow up if you render with no render systems', function()
      scene:render()
    end)
  end)
end)

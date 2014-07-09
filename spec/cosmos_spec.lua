describe('The Cosmos ECS', function()
  local Cosmos = require 'cosmos'

  it('should allow you to create a new cosmos', function()
    local cosmos = Cosmos:new()
  end)

  describe('(once instantiated)', function()
    local cosmos = Cosmos:new()

    it('should allow you to create a new entity with no components', function()
      local someEntity = cosmos:newEntity()

      assert.is_not.falsy(someEntity)

      for _ in pairs(someEntity.components) do
        assert.falsy('should have no components')
      end
    end)

    it('should allow you to add a component to an entity', function()
      local someEntity = cosmos:newEntity()
      someEntity:addComponent('component')

      assert.is_not.falsy(someEntity.components.component)
    end)

    it('should allow you to add a component with data to an entity', function()
      local someEntity = cosmos:newEntity()
      local componentData = {a = 1, b = 2}
      someEntity:addComponent('component_with_data', componentData)

      assert.is.equal(componentData, someEntity.components.component_with_data)
    end)

    it('should allow you to add an update system', function()
      local s = spy.new(function() end)

      cosmos:addUpdateSystem(s)
      cosmos:update(0.25)

      assert.spy(s).was.called_with(cosmos, 0.25)
    end)

    it('should allow you to add multiple update systems', function()
      local s1 = spy.new(function() end)
      local s2 = spy.new(function() end)

      cosmos:addUpdateSystem(s1)
      cosmos:addUpdateSystem(s2)
      cosmos:update(0.25)

      assert.spy(s1).was.called_with(cosmos, 0.25)
      assert.spy(s2).was.called_with(cosmos, 0.25)
    end)

    it('should allow you to remove an update system', function()
      local s = spy.new(function() end)

      cosmos:addUpdateSystem(s)
      cosmos:removeUpdateSystem(s)
      cosmos:update(0.25)

      assert.spy(s).was.not_called()
    end)

    it('should allow you to add update systems with priorities', function()
      error('todo')
    end)

    it('should not blow up if you update with no update systems', function()
      cosmos:update(0.12)
    end)

    it('should allow you to add a render system', function()
      local s = spy.new(function() end)

      cosmos:addRenderSystem(s)
      cosmos:render()

      assert.spy(s).was.called_with(cosmos)
    end)

    it('should allow you to add multiple render systems', function()
      local s1 = spy.new(function() end)
      local s2 = spy.new(function() end)

      cosmos:addRenderSystem(s1)
      cosmos:addRenderSystem(s2)
      cosmos:render()

      assert.spy(s1).was.called_with(cosmos)
      assert.spy(s2).was.called_with(cosmos)
    end)

    it('should allow you to remove a render system', function()
      local s = spy.new(function() end)

      cosmos:addRenderSystem(s)
      cosmos:removeRenderSystem(s)
      cosmos:render()

      assert.spy(s).was.not_called()
    end)

    it('should allow you to add render systems with priorities', function()
      error('todo')
    end)

    it('should not blow up if you render with no render systems', function()
      cosmos:render()
    end)
  end)
end)

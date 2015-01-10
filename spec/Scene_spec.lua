describe('The scene.lua ECS', function()
  local Scene = require 'Scene'
  local mach = require 'mach'

  local function count(t)
    local count = 0

    for _ in pairs(t) do count = count + 1 end

    return count
  end

  local scene

  local s1 = mach.mock_function('s1')
  local s2 = mach.mock_function('s2')
  local s3 = mach.mock_function('s3')

  before_each(function()
    scene = Scene()
  end)

  it('should allow you to create a new entity', function()
    local entity = scene:new_entity()

    assert.is_not.falsy(entity)

    assert.are.equal(1, count(scene:entities()))

    for e in pairs(scene:entities()) do
      assert.are.equal(entity, e)
    end
  end)

  it('should allow you to create a new entity with components', function()
    local entity = scene:new_entity({
      a = 1,
      b = true
    })

    assert.are.equal(1, entity.a)
    assert.are.equal(true, entity.b)

    assert.are.equal(1, count(scene:entities_with('a', 'b')))
  end)

  it('should allow you to remove an entity', function()
    scene:remove_entity(scene:new_entity())

    assert.are.equal(0, count(scene:entities()))
  end)

  it('should remove an entity from all caches', function()
    local entity = scene:new_entity({ a = 1 })
    scene:entities_with('a')

    scene:remove_entity(entity)

    assert.are.equal(0, count(scene:entities_with('a')))
  end)

  it('should allow you to add a component to an entity', function()
    local entity = scene:new_entity()
    entity.component = 5
    assert.are.equal(5, entity.component)
  end)

  it('should allow you to remove a component from an entity', function()
    local entity = scene:new_entity()
    entity.component = {}
    entity.component = nil

    assert.is.falsy(entity.component)
  end)

  it('should allow you to get a list of all entities', function()
    for i = 1, 5 do
      scene:new_entity()
    end

    assert.are.equal(5, count(scene:entities()))
  end)

  it('should allow you to get a list of all entities that have multiple components', function()
    for i = 1, 5 do
      local entity = scene:new_entity()
      entity.component1 = true
      entity.component2 = true
    end

    for i = 1, 5 do
      local entity = scene:new_entity()
      entity.component1 = true
    end

    local entities_with_component = scene:entities_with('component1', 'component2')

    assert.are.equal(5, count(entities_with_component))

    for entity in pairs(entities_with_component) do
      assert.is_not.falsy(entity.component1)
      assert.is_not.falsy(entity.component2)
    end
  end)

  it('should allow you to get a list of all entities that have a component', function()
    for i = 1, 5 do
      scene:new_entity().some_component = true
    end

    for i = 1, 5 do
      scene:new_entity().another_component = true
    end

    local entities_with_component = scene:entities_with('some_component')

    assert.are.equal(5, count(entities_with_component))

    for entity in pairs(entities_with_component) do
      assert.is_not.falsy(entity.some_component)
    end
  end)

  it('should cache entity requests to remain performant', function()
    local start = os.clock()

    for i = 1, 1000 do
      local entity = scene:new_entity()
      entity.c1 = true
      entity.c2 = true
    end

    for i = 1, 10000 do
      scene:entities_with('c1', 'c2')
      scene:entities_with('c1')
    end

    assert(os.difftime(os.clock(), start) <= 1, 'implementation is too slow')
  end)

  it('should update entity caches when components are added', function()
    local e1 = scene:new_entity()
    e1.c1 = true
    e1.c2 = true

    local e2 = scene:new_entity()
    e2.c1 = true

    scene:entities_with('c1', 'c2')

    e2.c2 = true

    assert.is_not.falsy(scene:entities_with('c1', 'c2')[e2])
  end)

  it('should update entity caches when false components are added', function()
    local e1 = scene:new_entity()
    e1.c1 = true
    e1.c2 = true

    local e2 = scene:new_entity()
    e2.c1 = false

    scene:entities_with('c1', 'c2')

    e2.c2 = true

    assert.is_not.falsy(scene:entities_with('c1', 'c2')[e2])
  end)

  it('should update entity caches when components are removed', function()
    local e1 = scene:new_entity()
    e1.c1 = true
    e1.c2 = true

    local e2 = scene:new_entity()
    e2.c1 = true
    e2.c2 = true

    scene:entities_with('c1', 'c2')

    e2.c2 = nil

    assert.is.falsy(scene:entities_with('c1', 'c2')[e2])
  end)

  it('should allow you to add an update system', function()
    local s = mach.mock_function('s')

    scene:add_update_system(s)

    s:should_be_called_with(scene, 0.25):when(function() scene:update(0.25)
    end)
  end)

  it('should allow you to add multiple update systems that will be invoked in order', function()
    scene:add_update_system(s1):add_update_system(s3):add_update_system(s2)

    s1:should_be_called_with(scene, 0.5)
      :and_then(s3:should_be_called_with(scene, 0.5))
      :and_then(s2:should_be_called_with(scene, 0.5))
      :when(function() scene:update(0.5) end)
  end)

  it('should allow you to remove update systems', function()
    scene:add_update_system(s1):add_update_system(s2):add_update_system(s3)
    scene:remove_update_system(s2):remove_update_system(s1)

    s3:should_be_called_with(scene, 0.75):when(function() scene:update(0.75) end)
  end)

  it('should not blow up if you update with no update systems', function()
    scene:update(0.12)
  end)

  it('should allow you to add a render system', function()
    local s = mach.mock_function('s')

    scene:add_render_system(s)

    s:should_be_called_with(scene):when(function() scene:render() end)
  end)

  it('should allow you to add multiple render systems that will be invoked in order', function()
    scene:add_render_system(s1)
    scene:add_render_system(s3)
    scene:add_render_system(s2)

    s1:should_be_called_with(scene)
      :and_then(s3:should_be_called_with(scene))
      :and_then(s2:should_be_called_with(scene))
      :when(function() scene:render() end)
  end)

  it('should allow you to remove render systems', function()
    scene:add_render_system(s1):add_render_system(s2):add_render_system(s3)
    scene:remove_render_system(s2):remove_render_system(s1)

    s3:should_be_called_with(scene):when(function() scene:render() end)
  end)

  it('should not blow up if you render with no render systems', function()
    scene:render()
  end)

  it('should not blow up if you update with no update systems', function()
    scene:update(0.1)
  end)
end)

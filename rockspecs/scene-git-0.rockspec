package = 'scene'
version = 'git-0'
source = {
  url = 'git://github.com/ryanplusplus/scene.lua.git'
}
description = {
  summary = 'Entity-component-system library in Lua.',
  homepage = 'https://github.com/ryanplusplus/scene.lua/',
  license = 'MIT <http://opensource.org/licenses/MIT>'
}
dependencies = {
  'lua >= 5.2',
  'mach >= 3.0-0'
}
build = {
  type = 'builtin',
  modules = {
    ['scene'] = 'scene.lua'
  }
}

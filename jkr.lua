--[[
 -- Jkr Villian Super Class 
 -- Started at 1:22am, April 15th 2014
 -- Dan
]]--

require "enemies";

jkrVillian = {}
local joker_mt = { __index = enemy };

function jkrVillian:create()
  local newinst = {};
  setmetatable( newinst, joker_mt );
  return newinst;
end

function jkrVillian:update( dt, colmap, gameSpeed )
  enemy:update(dt, colmap, gameSpeed);
end

function jkrVillian:draw()
  enemy:draw();
end

return jkrVillian;
--[[
 -- Joker Villian Super Class 
 -- Started at 1:22am, April 15th 2014
 -- Dan
]]--

require "enemies";

jokerVillian = {}
local joker_mt = { __index = enemies };

function jokerVillian:create()
  local newinst = {};
  setmetatable( newinst, joker_mt );
  return newinst;
end

function jokerVillian:update(dt, colmap, gameSpeed)
  enemy:update(dt, colmap, gameSpeed);
end

function jokerVillian:draw()
  enemy:draw();
end

return jokerVillian;
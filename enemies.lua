--[[
 -- Enemies Base Class
 -- Mainly for thugs & the like, generic enemies behaviour 
 -- Started at roughly 10pm, April 14th 2014
 -- Dan
]]--

local LEFT = -1;
local RIGHT = 1;

enemies = {};

function enemies:update(dt, colmap, gameSpeed)
  gameSpeed = gameSpeed or 1;
  
  if (enemies.state == "idle") then
    -- enemies is standing around
  elseif (enemies.state == "patrol") then
    -- Patrol area
  elseif (enemies.state == "actioned") then
    -- enemies is actioned, ready to fight
  elseif (enemies.state == "punch") then
    -- Fighting Batman
  elseif (enemies.state == "kick") then
    -- Fighting Batman
  elseif (enemies.state == "knockout") then
    -- enemies has been defeated
  end
  
  -- Update Collision Rectangle
  enemies.collisionRect.x = (player.x + offset.x) + global.offsetX + global.tx;
  enemies.collisionRect.y = (player.y - offset.y) + global.offsetY + global.ty;
end

function enemies:draw()
  love.graphics.draw(enemies.img, enemies.x + global.tx + global.offsetX, enemies.y + global.offsetY + global.ty, 0, 1, 1);
  
  -- Debug; Draw State Text
  love.graphics.setColor(255, 255, 255, 255); 
  love.graphics.print(
    "State: " .. enemies.state, 
    enemies.x + global.tx + global.offsetX, 
    enemies.y - 15 + global.offsetY +  global.ty
  );
end

return enemies;
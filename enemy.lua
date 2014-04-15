--[[
 -- Enemy Base Class
 -- Mainly for thugs & the like, generic enemy behaviour 
 -- Started at roughly 10pm, April 14th 2014
 -- Dan
]]--

local LEFT = -1;
local RIGHT = 1;

enemy = {};

-- Attributes
enemy.img = love.graphics.newImage("Content/Images/testEnemy.png");
enemy.height = 32;
enemy.width = 32;
enemy.x = 200;
enemy.y = 256;
enemy.speedX = 2;
enemy.direction = RIGHT;
enemy.health = 100;

-- State
enemy.state = "idle";

-- Collision Rect
offset = {x = 0, y = 0};
enemy.collisionRect = {x = (enemy.x + offset.x) - global.tx, y = (enemy.y + offset.y) - global.ty, width = enemy.width,                    height = enemy.height };

function enemy:update(dt, colmap, gameSpeed)
  gameSpeed = gameSpeed or 1;
  
  if (enemy.state == "idle") then
    -- Enemy is standing around
  elseif (enemy.state == "patrol") then
    -- Patrol area
  elseif (enemy.state == "actioned") then
    -- Enemy is actioned, ready to fight
  elseif (enemy.state == "punch") then
    -- Fighting Batman
  elseif (enemy.state == "kick") then
    -- Fighting Batman
  elseif (enemy.state == "knockout") then
    -- Enemy has been defeated
  end
  
  -- Update Collision Rectangle
  enemy.collisionRect.x = (player.x + offset.x) + global.offsetX + global.tx;
  enemy.collisionRect.y = (player.y - offset.y) + global.offsetY + global.ty;
end

function enemy:draw()
  love.graphics.draw(enemy.img, enemy.x + global.tx + global.offsetX, enemy.y + global.offsetY + global.ty, 0, 1, 1);
end

return enemy;
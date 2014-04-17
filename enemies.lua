--[[
 -- Enemy Base Class
 -- Mainly for thugs & the like, generic enemies behaviour 
 -- Started at roughly 10pm, April 14th 2014
 -- Dan
]]--
require("./Libraries/class");

local LEFT = -1;
local RIGHT = 1;

-- Global Table of Enemies that will contain enemies per scene
enemies = {}

-- Enemy Base Clas
enemy = class(function(enemy,x,y,width,height,speedX, typeOf, state, nxtState, msg, offsetX, offsetY)
              enemy.x = x;
              enemy.y = y;
              enemy.width = width;
              enemy.height = height;
              enemy.speedX = speedX;
              enemy.direction = -1;
              enemy.health = 100;
              enemy.typeOf = typeOf;
              enemy.img = nil;
              enemy.animations = {};
              enemy.currentAnimation = nil;
              enemy.state = state;
              enemy.nxtState = nxtState;
              enemy.message = msg;
              enemy.offset = {x = offsetX, y = offsetY};
              enemy.collisionRect = {
                x = (x + offsetX) - global.tx;
                y = (y + offsetY) - global.ty;
                width = width;
                height = height;
              };
           end);
         
function enemy:update(dt, colmap, gameSpeed)
  gameSpeed = gameSpeed or 1;
  
  if (self.state == "idle") then
    -- enemies is standing around
  elseif (self.state == "patrol") then
    -- Patrol area
  elseif (self.state == "actioned") then
    -- Enemies is actioned, ready to fight
  elseif (self.state == "punch") then
    -- Fighting Batman
  elseif (self.state == "kick") then
    -- Fighting Batman
  elseif (self.state == "knockout") then
    -- Enemies has been defeated
  end
  
  -- Update Collision Rectangle
  self.collisionRect.x = (self.x + self.offset.x) + global.offsetX + global.tx;
  self.collisionRect.y = (self.y - self.offset.y) + global.offsetY + global.ty;
end

function enemy:draw()
  love.graphics.draw(self.img, 
    self.x + global.tx + global.offsetX, 
    self.y + global.offsetY + global.ty, 
    0, 
    1, 
    1);
  
  -- Debug; Draw State Text
  love.graphics.setColor(255, 255, 255, 255); 
  love.graphics.print(
    "State: " .. self.state, 
    self.x - 16 + global.tx + global.offsetX, 
    self.y - 16 + global.offsetY +  global.ty
  );
end
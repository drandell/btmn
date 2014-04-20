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
              enemy.dly = 500;
              enemy.oldDly = 500;
              enemy.alpha = 255;
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
  -- TODO: Each enemy should have an individual range, but generic thugs 
  -- Will probably all have the same 
  local RANGE = 250;
  
  if (self.state == "idle") then
    -- enemies is standing around
    if (self.x > btmn.x and btmn.x + btmn.width + RANGE > self.x or
        self.x < btmn.x and btmn.x - RANGE < self.x) then
      if (self.nxtState ~= nil) then
        self.state = self.nxtState;
      else
        self.state = "actioned";
      end
    end
  
  elseif (self.state == "speak") then
    -- Enemy has something to say
    global.currentGameSpeed = 0; -- STOP THE PRESS!
    local delta = (love.timer.getAverageDelta() * 1000);
    self.dly = self.dly - delta;
    
    -- Either a) have a timer delay and then re-begin action automatically
    -- or b) let player press button to resume action.
    -- future; What if the enemy has a LOT to say?
    if (self.dly < 0) then
      global.currentGameSpeed = 1;
      self.alpha = self.alpha - 10;
      
      if (self.alpha < 0) then
        self.state = "actioned";
        self.dly = self.oldDly;
      end
    end
    
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
  if (self.state ~= "speak") then 
    if (self.x + self.width + global.tx > 0) then 
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
  else
    love.graphics.draw(self.img, 
        self.x + global.tx + global.offsetX, 
        self.y + global.offsetY + global.ty, 
        0, 
        1, 
        1);
    
    love.graphics.setColor(255, 255, 255, self.alpha); 
    -- TODO: Edit this properly later to show the message
    local numOfLines = (love.graphics.getFont():getWidth(self.message) / 100);
    local heightOffset = (love.graphics.getFont():getHeight(self.message) * (numOfLines + 1));
    love.graphics.print(
        "State: " .. self.state, 
        self.x - 18 + global.tx + global.offsetX, 
        self.y - 16 - heightOffset + global.offsetY +  global.ty
      );
    love.graphics.printf(
        "" .. self.message, 
        self.x - 18 + global.tx + global.offsetX, 
        self.y - heightOffset + global.offsetY +  global.ty, 100, "left"
    );
    love.graphics.reset();
  end
end
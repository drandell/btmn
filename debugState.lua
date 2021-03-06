--[[
 -- Debug State File
 -- Shows debug information/new features in progress along with map & collision information
 -- Created roughly 3 months ago initally (Around Feburary 2014)
 -- Dan
]]--

debugState = {};

-- New
function debugState:new()
   local gs = {}

   gs = setmetatable(gs, self)
   self.__index = self
   _gs = gs
   
   return gs
end
-- Load
function debugState:load()
end
-- Close
function debugState:close()
end
-- Enable
function debugState:enable()
end
-- Disable
function debugState:disable()
end

-- Update
function debugState:update( dt )
end
-- Draw
function debugState:draw()
  love.graphics.setFont(gameFont);
  love.graphics.setColor(red);
  
  local major, minor, revision, codename = love.getVersion()
  local vers = string.format("Version %d.%d.%d - %s", major, minor, revision, codename)  
  love.graphics.printf("Using version: " .. vers, 0, 0, global.viewportWidth - 6, "right");
  love.graphics.printf("FPS: " .. tostring(love.timer.getFPS()), 0, 0, global.viewportWidth, "left");
  love.graphics.printf("Current State: ".. getActiveStates()[1], 0, 10, global.viewportWidth, "left");
  
  love.graphics.print("Scroll X: " .. global.tx, 6, 280);
  love.graphics.print("Health: " .. btmn.health, 6, 290);
  love.graphics.print("X: " .. btmn.x, 6, 300);
  love.graphics.print("Y: " .. btmn.y, 6, 310);
  love.graphics.print("Hit? " .. tostring(enemies[1].hit), 6, 360);
  love.graphics.print("Anim: " .. btmn.currentState, 6, 370);
  love.graphics.print("Anim Frame: " .. btmn.currentAnim[1].position, 6, 380);
  love.graphics.print("Anim Status: " .. btmn.currentAnim[1].status, 150, 380);
  
  
  love.graphics.setNewFont(12);
end
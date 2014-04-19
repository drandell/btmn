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
function debugState:update(dt)
end

-- Draw
function debugState:draw()
  love.graphics.setFont(gameFont);

  love.graphics.printf("Using version: " .. version, 0, 0, love.window.getWidth() - 6, "right");
  love.graphics.printf("FPS: " .. tostring(love.timer.getFPS()), 0, 0, love.window.getWidth(), "left");
  
  love.graphics.print("Scroll X: " .. global.tx, 6, 280);
  love.graphics.print("X: " .. btmn.x, 6, 300);
  
  love.graphics.setNewFont(12);
  
    -- Draw Player Debug
  if (btmn.drawDebug) then 
    love.graphics.setColor(255, 255, 0);
    love.graphics.rectangle("line", btmn.collisionRect.x, btmn.collisionRect.y, btmn.collisionRect.width, btmn.collisionRect.height);  
    love.graphics.reset();
  end
end
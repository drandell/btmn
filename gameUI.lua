--[[
 -- Game UI File
 -- Render UI Information
 -- Created 15th July 2014, 4pm
 -- Dan
]]--

gameUI = {};

-- New
function gameUI:new()
   local gs = {}

   gs = setmetatable(gs, self)
   self.__index = self
   _gs = gs
   
   return gs
end
-- Load
function gameUI:load()
end
-- Close
function gameUI:close()
end
-- Enable
function gameUI:enable()
end
-- Disable
function gameUI:disable()
end

-- Update
function gameUI:update( dt )
end
-- Draw
function gameUI:draw()
  -- UI Elements 
  love.graphics.setColor(black);
  love.graphics.rectangle("fill", global.offsetX + 5, global.offsetY + 5, 60, 12); 
  love.graphics.reset();
  
  if (btmn.health > 0) then
    for i = 1, btmn.health / 20 do
      love.graphics.setColor(red);
      love.graphics.rectangle("fill", global.offsetX + 6 + (i-1)*10 + ((i-1)*2), global.offsetY + 6, 10, 10); 
      love.graphics.reset();
    end
  end 
  
  -- TODO: Add different font for scene name, to make it look comic like.
  love.graphics.rectangle("fill", 
    global.offsetX + global.gameWorldWidth - (love.graphics.getFont():getWidth(map.properties.scene) + 5), 
    global.offsetY + global.gameWorldHeight - (love.graphics.getFont():getHeight(map.properties.scene) + 5), 
    love.graphics.getFont():getWidth(map.properties.scene), 
    love.graphics.getFont():getHeight(map.properties.scene));
  --love.graphics.setFont(); -- TODO: Add comic font!
  love.graphics.setColor(black); -- We want black text
  love.graphics.print("" .. map.properties.scene, 
    global.offsetX + global.gameWorldWidth - (love.graphics.getFont():getWidth(map.properties.scene) + 5),
    global.offsetY + global.gameWorldHeight - (love.graphics.getFont():getHeight(map.properties.scene) + 5));
  love.graphics.setColor(white); -- Reset Color
end
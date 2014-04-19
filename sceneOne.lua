--[[
 -- Scene One
 -- Created 10:40pm, 15th April 2014
 -- Dan
]]--

sceneOne = {}
map = nil;
overlay = nil;

-- New
function sceneOne:new()
   local gs = {}

   gs = setmetatable(gs, self)
   self.__index = self
   _gs = gs
   
   return gs
end

-- Load
function sceneOne:load()
  -- Load Map
  map = loader.load("test.tmx");
  
  -- Load Enemies
  loadEnemies(map);
  
  --Load Images
  overlay = love.graphics.newImage("Content/Images/overlay.png");
end

-- Close
function sceneOne:close()
end

-- Enable
function sceneOne:enable()
end

-- Disable
function sceneOne:disable()
end

-- Update
function sceneOne:update(dt)
  -- Update BTMN
  btmn:update(dt, map, global.currentGameSpeed);
  
  -- Update Enemies
  for i, enemy in pairs( enemies ) do
      enemy:update(dt, map, global.currentGameSpeed);
    end
end

-- Draw
function sceneOne:draw()
    love.graphics.clear();
    
    -- Scale and translate the game screen for map drawing
    local ftx, fty = math.floor(global.tx), math.floor(global.ty)
    love.graphics.push()
    love.graphics.scale(global.scale)
    love.graphics.translate(global.offsetX + ftx, global.offsetY + fty)
    
    -- Set the draw range 
    map:autoDrawRange(global.offsetX + ftx, global.offsetY + fty, global.scale, 50);  
    map:setDrawRange( 0, 0 , global.gameWorldWidth + global.tSize - ftx, global.gameWorldHeight - fty);
    -- Draw the map
    map:draw() 
    
    -- Reset the scale and translation
    love.graphics.pop()   
    
    -- Draw Enemies
    for i, enemy in pairs( enemies ) do
      enemy:draw();
    end
    
    -- Draw overlay
    love.graphics.draw(overlay, 0, 0);
    
    -- Draw BTMN
    btmn.draw();
    
    -- Draw UI Border 
    -- TODO: Move to UI implementation
    love.graphics.setColor(255, 255, 255);
    love.graphics.setLineWidth(4);
    love.graphics.rectangle("line", global.offsetX, global.offsetY, global.gameWorldWidth, global.gameWorldHeight);  
    love.graphics.setLineWidth(1);
    love.graphics.reset();
end

-- KeyPressed
function sceneOne:keypressed(key, unicode)
  if (key == "f1") then map("Collision Layer").visible = not map("Collision Layer").visible; end
  
  btmn:keypressed(key, unicode);
end

-- KeyReleased
function sceneOne:keyreleased(key, unicode)
end

-- MousePressed
function sceneOne:mousepressed(x, y, button)
end

-- MouseReleased
function sceneOne:mousereleased(x, y, button)
end

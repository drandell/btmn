--[[
 -- First Stage/Map
 -- Dan
]]--

stageOne = {}
map = nil;
overlay = nil;

--New
function stageOne:new()
   local gs = {}

   gs = setmetatable(gs, self)
   self.__index = self
   _gs = gs
   
   return gs
end

--Load
function stageOne:load()
  -- Load Map
  map = loader.load("test.tmx");
  
  --Load Images
  overlay = love.graphics.newImage("Content/Images/overlay.png");
end

--Close
function stageOne:close()
end

--Enable
function stageOne:enable()
end

--Disable
function stageOne:disable()
end

--Update
function stageOne:update(dt)
  playerObj:update(dt, map, global.currentGameSpeed);
end

--Draw
function stageOne:draw()
    love.graphics.clear();
    
    -- Scale and translate the game screen for map drawing
    local ftx, fty = math.floor(global.tx), math.floor(global.ty)
    love.graphics.push()
    love.graphics.scale(global.scale)
    love.graphics.translate(global.offsetX + ftx, global.offsetY + fty)
    
    -- Set the draw range 
    map:autoDrawRange(global.offsetX + ftx, global.offsetY + fty, global.scale, 50);  
    map:setDrawRange( 0, 0 , 640 + 32 - ftx, 320 - fty);
    -- Draw the map
    map:draw() 
    
    -- Reset the scale and translation
    love.graphics.pop()   
    
    -- Draw overlay
    love.graphics.draw(overlay, 0, 0);
    
    playerObj.draw();
    
    love.graphics.setColor(255, 255, 255);
    love.graphics.setLineWidth(4);
    love.graphics.rectangle("line", global.offsetX, global.offsetY, global.gameWorldWidth, global.gameWorldHeight);  
    love.graphics.setLineWidth(1);
    love.graphics.reset();
end

--KeyPressed
function stageOne:keypressed(key, unicode)
  if (key == "f1") then map("Collision Layer").visible = not map("Collision Layer").visible; end
  
  playerObj:keypressed(key, unicode);
end

--KeyReleased
function stageOne:keyreleased(key, unicode)
end

--MousePressed
function stageOne:mousepressed(x, y, button)
end

--MouseReleased
function stageOne:mousereleased(x, y, button)
end

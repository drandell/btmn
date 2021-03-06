--[[
 -- Scene One state
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
  -- Set world meter size (in pixels)
love.physics.setMeter(64);
	
-- Prepare physics world with horizontal and vertical gravity
world = love.physics.newWorld(0, 0);

-- Load a map exported to Lua from Tiled
map = sti(sti.path .. "test.lua", { "bump" });
	
	-- Prepare collision objects
	map:bump_init(world);  
  
  -- Load Enemies
local redHoodImg = love.graphics.newImage("Content/Images/testEnemy.png");
local props = {}; 
  
  -- Are there enemies on this map?
  for k, object in pairs(map.objects) do
        if object.name == "Enemy" then
            props = map:getObjectProperties ("Enemies", "Enemy");
			
			enemies[k] = enemy(object.x, object.y, object.width, object.height, props.speedX, object.type, props.state, props.nextState, props.message, props.offsetX, props.offsetY);
        
			if (string.lower(enemies[k].typeOf) == "redhoodgang") then
				enemies[k].img = redHoodImg;
			end
        end
    end  
  
  --Load Images
  overlay = love.graphics.newImage("Content/Images/overlay.png");
end

-- Close
function sceneOne:close()
end

-- Enable
function sceneOne:enable()
  if (not isStateEnabled("UI")) then
    enableState("UI");
  end
end

-- Disable
function sceneOne:disable()
end

-- Update
function sceneOne:update( dt )
  -- Update BTMN
  btmn:update(dt, map, global.currentGameSpeed);
  
  -- Update Enemies
  for i, enemy in pairs( enemies ) do
      enemy:update(dt, map, global.currentGameSpeed);
      btmn:updateBatarangs(enemy, global.currentGameSpeed);
      btmn:checkCollisionWth(enemy);
      enemy:updateStatus(i);
    end
end

-- Draw
function sceneOne:draw()
    love.graphics.clear();
    
    -- Scale and translate the game screen for map drawing
   local ftx, fty = math.floor(global.tx), math.floor(global.ty)
    -- Draw the map
    map:draw(global.offsetX + ftx, global.offsetY + fty, global.scale, global.scale) 
    
    -- Draw Enemies
    for i, enemy in pairs( enemies ) do
      enemy:draw();
    end
    
    -- Draw BTMN
    btmn.draw();
    
    -- Draw overlay
    love.graphics.draw(overlay, 0, 0);
    
    -- Draw UI Border 
    -- TODO: Move to UI implementation
    love.graphics.setColor(white);
    love.graphics.setLineWidth(4);
    love.graphics.rectangle("line", global.offsetX, global.offsetY, global.gameWorldWidth, global.gameWorldHeight);  
    love.graphics.setLineWidth(1);
    love.graphics.reset();
end

-- KeyPressed
function sceneOne:keypressed( key, unicode )
  if (key == "f1") then map.layers["Collision Layer"].visible = not map.layers["Collision Layer"].visible; end
  if (key == "f2") then btmn.health = btmn.health - 20; btmn.takenDmg = true; end
  
  btmn:keypressed(key, unicode);
end

-- KeyReleased
function sceneOne:keyreleased( key, unicode )
end

-- MousePressed
function sceneOne:mousepressed( x, y, button )
end

-- MouseReleased
function sceneOne:mousereleased( x, y, button )
end

--[[
 -- Loading of Map Objects 
 -- Enemies, Obstacles etc.
 -- Made 12:59pm, 17th April 2014
 -- Dan
]]--

function loadEnemies(map)
  local redHoodImg = love.graphics.newImage("Content/Images/testEnemy.png");
  
  -- Are there enemies on this map?
  if (map("Enemies")) then
      -- Add Enemy
      for i, obj in pairs( map("Enemies").objects ) do
        enemies[i] = enemy(obj.x, obj.y, obj.width, obj.height, obj.properties.speedX, obj.type,
          obj.properties.state, obj.properties.nextState, obj.properties.message, obj.properties.offsetX, obj.properties.offsetY);
        
        if (string.lower(enemies[i].typeOf) == "redhoodgang") then
          enemies[i].img = redHoodImg;
        end
    end
  end
end
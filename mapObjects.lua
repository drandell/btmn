--[[
 -- Loading of Map Objects 
 -- Enemies, Obstacles etc.
 -- Made 12:59pm, 17th April 2014
 -- Dan
]]--

function loadEnemies(map)
  local x, y, width, height, speedX, direction, health, typeOf;
  local state, nextState, message;
  local redHoodImg = love.graphics.newImage("Content/Images/testEnemy.png");
  
  -- Are there enemies on this map?
  if (map("Enemies")) then
      for i, obj in pairs( map("Enemies").objects ) do
        enemies[#enemies + 1] = {
          -- Attributes
          x = obj.x;
          y = obj.y;
          width = obj.width;
          height = obj.height;
          speedX = obj.properties.speedX;
          direction = obj.properties.direction;
          health = obj.properties.health;
          typeOf = obj.type;
          img = nil;
          -- States
          state = obj.properties.state;
          nextState = obj.properties.state;
          message = obj.properties.message;
        
          -- Collision Rect
          offset = {x = obj.properties.offsetX, y = obj.properties.offsetY};
          collisionRect = {
            x = 0, 
            y = 0, 
            width = width,                    
            height = height 
          };
      };
      -- Set Collision Rect Start Pos
      enemies[i].collisionRect.x = (enemies[i].x + enemies[i].offset.x) - global.tx;
      enemies[i].collisionRect.y = (enemies[i].y + enemies[i].offset.y) - global.ty;
      
      -- Finally what enemy image shall we use?
      if (string.lower(enemies[i].typeOf) == "redhoodgang") then
        enemies[i].img = redHoodImg;
      end
    end
  end
end
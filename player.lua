--[[
 -- Player Base Class for Batman
 -- Handles all player actions, animations etc.
 -- Created 10th April 2014
 -- Dan
]]--

local LEFT = -1;
local RIGHT = 1;

player = {};

-- Attributes
player.img = love.graphics.newImage("Content/Images/test.png");
player.height = 32;
player.width = 32;
player.x = 20;
player.y = 60;
player.speedX = 2;
player.speedY = 0;
player.direction = RIGHT;
player.health = 100;
player.drawDebug = false;

-- Character Action Bools
player.canMove = true;
player.standingLeft = false;
player.standingRight = true;
player.movingLeft = false;
player.movingRight = false;
player.jumping = false;

-- Rope Bools
player.collidingWithRope = false;
player.onRope = false;

-- Conversation Bools & Vars
player.convoActive = false;
player.convoInput = false;
player.selectedConvoOption = 0;

offset = {x = 0, y = 0};
player.collisionRect = {x = (player.x + offset.x) - global.tx, y = (player.y - offset.y) - global.ty, width = player.width,                    height = player.height };

-- Rope Object
rope = {}

-- Collision Tile Variables
left = 0;
right = 0;
up = 0;
middleX = 0;
middleY = 0;
down = 0;

-- Animations
--[[
WalkImg = love.graphics.newImage("Content/Images/walkingAnimationSheet.png");

local walkGrid = anim8.newGrid(120, 120, WalkImg:getWidth(), WalkImg:getHeight())
player.walkRight = anim8.newAnimation(walkGrid('1-8',1), 0.1)
player.walkLeft = anim8.newAnimation(walkGrid('8-1',1), 0.1):flipH();
walkWidthOffset = 8; -- 8 pixel offset due to difference in anim frame width & player width
]]--

-- Simple Generic box collision function
function boxCollision(x, y, width, height)
	if (player.collisionRect.x + player.width > x) and (player.collisionRect.x < x + width) and (player.collisionRect.y + player.height + global.ty > y) and (player.collisionRect.y < y + height) then
		return true;
	else
		return false;
	end
end

function boxCollisionHalfWidth(x, y, width, height)
  if (player.direction == RIGHT) then
      if (player.collisionRect.x + (player.width / 2) > x) and (player.collisionRect.x < x + width) and (player.collisionRect.y +         player.height + global.ty > y) and (player.collisionRect.y < y + height) then
        return true;
      else
        return false;
      end
  elseif (player.direction == LEFT) then 
    if (player.collisionRect.x < x) and (player.collisionRect.x + player.width > x + width) and 
      (player.collisionRect.y + player.height + global.ty > y) and (player.collisionRect.y < y + height) then
      return true;
    else
      return false;
    end
  end  
end

function getPlayerCorners(x, y)
  down = math.floor(( (y - offset.y) + player.height - 1) / global.tSize);
	up = math.floor( (y - offset.y) / global.tSize); --+1
  
  middleY = math.floor((y - offset.y + (player.height / 2)) / global.tSize);
  middleX = math.ceil((x - offset.x + (player.width / 2)) / global.tSize);
	
  -- Hopefully sorted!
  left = math.floor( (x - offset.x) / global.tSize) + 1;
	right = math.ceil(( (x - offset.x) + player.width - 1) / global.tSize);
end

-- Jump function, makes our player jump
function jump(colMap, gSpeed, grav)
grav = 0.45 or grav;
collisionMap = colMap;
player.speedY = (player.speedY - grav * gSpeed);

	if (player.speedY < 0) then
		movePlayer(0, 1, collisionMap, gSpeed);
	elseif (player.speedY > 0) then
		movePlayer(0, -1, collisionMap, gSpeed);
	end
end

-- Fall function, to make the player "fall"
function fall(collisionMap, fallSpeed)
fallSpeed = -0.5 or fallSpeed;

  if not player.jumping and not player.onRope then
    getPlayerCorners(player.x, player.y + 1);
      if (collisionMap:get(left, down) == nil and collisionMap:get(right, down) == nil) 
         and collisionMap:get(middleX, down) == nil then
        player.speedY = fallSpeed;
        player.jumping = true;
      end
  end
end

function movePlayer(dirx, diry, collisionMap, gSpeed)
  --Update postition
  if not player.dead and player.x >= 0 and player.y >= 0 and player.y < global.gameWorldHeight then
    player.x = (player.x + (player.speedX * dirx) * gSpeed);
    if player.speedY > 0 then
      player.y = (player.y + (player.speedY * diry) * gSpeed); 
    elseif player.speedY < 0 then
      player.y = (player.y - (player.speedY * diry) * gSpeed); 
    end
    
    if (player.x < 0) then player.x = global.offsetX; end
    if (player.x + player.width + player.speedX > (map.width * map.tileWidth)) then 
      player.x = (map.width * map.tileWidth) - player.width - player.speedX;
    end
  
    -- Get Player Tile Corners
    getPlayerCorners(player.x, player.y);
  
    if (dirx == 1) then
        if (collisionMap:get(right, down) == nil 
            and collisionMap:get(right, up) == nil) then
            if (player.x + player.width) > ((love.graphics.getWidth() / 2)) and global.tx > -global.gameWorldWidth then
                global.tx = (global.tx - player.speedX * gSpeed);
            end
        else
          player.x = ((right-1) * global.tSize) - (player.width - offset.x);
        end
    end
    
    if (dirx == -1) then
        if (collisionMap:get(left, down) == nil and collisionMap:get(left, middleY) == nil 
            and collisionMap:get(left, up) == nil) then	
            if (player.x + global.tx) < ((love.graphics.getWidth() / 2)) and global.tx < 0 then
                global.tx = (global.tx + player.speedX * gSpeed);
                
                if (global.tx > 0) then global.tx = 0; end
            end
        else
          player.x = (left * global.tSize) + (offset.x - player.speedX);
        end
    end
    
    if (diry == 1) then
        if (collisionMap:get(left, down) == nil and collisionMap:get(right, down) == nil
          and collisionMap:get(middleX, down) == nil) then
        else
          player.y = (down * global.tSize) - (player.height - offset.y);
          player.jumping = false;
          player.speedY = 0;
        end
    end
    
    if (diry == -1) then
      if (collisionMap:get(left, up) == nil and collisionMap:get(right, up) == nil) then	   
      else
        global.currentGameSpeed = 1; -- Reset Game Speed If We have a collision
        player.y = (up * global.tSize);
        player.speedY = -1;
      end
    end 
    
  end
end

function checkCollisionWithRope(colmap)
  if (colmap("Ropes")) then
      for i, obj in pairs( colmap("Ropes").objects ) do
          if (boxCollisionHalfWidth(obj.drawInfo.left + global.tx, obj.drawInfo.top + global.ty, obj.width, obj.height)) then
            player.collidingWithRope = true;
            rope = obj;
            break;
          else
            player.collidingWithRope = false;
          end
      end
  end
end

function AtTopOfRope()
    if (player.collidingWithRope) then 
      if (player.collisionRect.y <= rope.drawInfo.top) then
        return true;
      else 
        return false;
      end
    else
      return false;
    end
end

function AtBottomOfRope()
    if (player.collidingWithRope) then 
      if (player.collisionRect.y + player.collisionRect.height >= rope.drawInfo.bottom) then
        return true;
      else 
        return false;
      end
    else
      return false;
    end
end

function canMoveUpRope()
  if (player.collisionRect.y <= rope.drawInfo.top) then
    return false;
  else
    return true;
  end
end

function canMoveDownRope()
  if (player.collisionRect.y + player.collisionRect.height >= rope.drawInfo.bottom) then
    return false;
  else
    return true;
  end
end

function player:update(dt, colmap, gameSpeed)
  gameSpeed = gameSpeed or 1;
  
  -- Update Anim
  --[[
  if (player.movingRight) then
    player.walkRight:update(dt);
  elseif (player.movingLeft) then
    player.walkRight:update(dt);
  end
  ]]--
  
  -- Check to see if the object should be falling
	fall(colmap("Collision Layer"));
  -- Check if the player is colliding with a rope obj
  checkCollisionWithRope(colmap);
  
  -- Player Movement Update
  if not player.onRope and player.canMove then
    if (love.keyboard.isDown("right")) then 
        player.direction = RIGHT;
        movePlayer(player.direction, 0, colmap("Collision Layer"), gameSpeed);  
        player.movingLeft = false;
        player.movingRight = true;
        player.standingRight = false;
        player.standingLeft = false;
    end
  
    if (love.keyboard.isDown("left")) then 
        player.direction = LEFT;
        movePlayer(player.direction, 0, colmap("Collision Layer"), gameSpeed); 
        player.movingRight = false;
        player.movingLeft = true;
        player.standingRight = false;
        player.standingLeft = false;
    end
    
    -- ADD Jumping check here for when jumping to-do anim
    if (not love.keyboard.isDown("left") and not love.keyboard.isDown("right")) then 
      player.movingLeft = false;
      player.movingRight = false;
      
      if (player.direction == RIGHT) then
        player.standingRight = true;
      else
        player.standingLeft = true;
      end
    end
 
    if (player.jumping) then
        jump(colmap("Collision Layer"), gameSpeed);
    end
  elseif player.onRope then
    -- Check to see if player can climb &
    -- Check to see if player can exit rope!
    if (love.keyboard.isDown("up") and canMoveUpRope()) then
      player.y = player.y - 2;
    elseif not canMoveUpRope() then
      if (love.keyboard.isDown("left") or love.keyboard.isDown("right")) then 
        player.onRope = false;
      end
    end
    
    if (love.keyboard.isDown("down") and canMoveDownRope()) then
      player.y = player.y + 2;
    elseif not canMoveDownRope() then
      if (love.keyboard.isDown("left") or love.keyboard.isDown("right")) then 
        player.onRope = false;
      end
    end
  end
  
  -- Player Collision Update
  if (colmap("Messages Layer")) then
      for i, obj in pairs( colmap("Messages Layer").objects ) do
          if (boxCollision(obj.drawInfo.left + global.tx, obj.drawInfo.top + global.ty, obj.width, obj.height)) then
            obj.properties.triggered = true;
          else
            obj.properties.triggered = false;
          end
      end
  end
  
  if (colmap("Npcs")) then
      for i, obj in pairs( colmap("Npcs").objects ) do
          if not obj.properties.convoActive and not obj.properties.convoFinished then  
            if (boxCollision(obj.drawInfo.left + global.tx, obj.drawInfo.top + global.ty, obj.width, obj.height)) then
              obj.properties.triggered = true;
            else
              obj.properties.triggered = false;
            end
            
            if (love.keyboard.isDown("return")) then
              obj.properties.convoActive = true;
              player.canMove = false;
              player.convoActive = true;
              break;
            end
          end
      end
  end
  
  -- Update Collision Rectangle
  player.collisionRect.x = (player.x + offset.x) + global.offsetX + global.tx;
  player.collisionRect.y = (player.y - offset.y) + global.offsetY + global.ty;
end

function player:draw()
  -- Draw Player  
  if (player.standingRight or player.movingRight) then
    love.graphics.draw(player.img, player.x + global.tx + 40, player.y + 40 + global.ty, 0, 1, 1);
  elseif (player.standingLeft or player.movingLeft) then
    love.graphics.draw(player.img, player.x + global.tx + 40, player.y + 40 + global.ty, 0, -1, 1, player.width + (offset.x * 2));
  end
  --[[
  if (player.movingRight) then
    player.walkRight:draw(WalkImg, player.x - walkWidthOffset + global.tx, player.y + global.ty);
  elseif (player.movingLeft) then
    player.walkRight:draw(WalkImg, player.x + walkWidthOffset + global.tx, player.y + global.ty, 0, -1, 1, player.width + (    offset.x * 2));
  end
  ]]--
  
  -- Temp Health Bar & Map Information 
  -- TODO: Move to a UI implementation
  for i = 0, player.health / 20 do
    love.graphics.setColor(255, 0, 0);
    love.graphics.rectangle("fill", global.offsetX + 6 + i*10 + (i*2), global.offsetY + 6, 10, 10); 
    love.graphics.reset();
  end
  
  -- UI Elements (seperate out)
  -- Add different font for scene name, to make it look comic like.
  love.graphics.rectangle("fill", 
    global.offsetX + global.gameWorldWidth - (love.graphics.getFont():getWidth(map.properties.scene) + 5), 
    global.offsetY + global.gameWorldHeight - (love.graphics.getFont():getHeight(map.properties.scene) + 5), 
    love.graphics.getFont():getWidth(map.properties.scene), 
    love.graphics.getFont():getHeight(map.properties.scene));
  --love.graphics.setFont(); -- TODO: Add comic font!
  love.graphics.setColor(0, 0, 0, 255); -- We want black text
  love.graphics.print("" .. map.properties.scene, 
    global.offsetX + global.gameWorldWidth - (love.graphics.getFont():getWidth(map.properties.scene) + 5),
    global.offsetY + global.gameWorldHeight - (love.graphics.getFont():getHeight(map.properties.scene) + 5));
  love.graphics.setColor(255, 255, 255, 255); -- Reset Color
end

function player:keypressed(key, unicode)
  if player.collidingWithRope and not player.convoActive then
    if (key == "up") and not AtTopOfRope() or (key == "down") and not AtBottomOfRope() then
        player.onRope = true;
    end
  end  
  
  if not player.collidingWithRope and player.convoActive then
    if (key == "up") then
      player.selectedConvoOption = player.selectedConvoOption + 1;
    elseif (key == "down") then
      player.selectedConvoOption = player.selectedConvoOption - 1;
    end
    
    if (player.selectedConvoOption < 0) then
      player.selectedConvoOption = 1;
    elseif (player.selectedConvoOption > 1) then
      player.selectedConvoOption = 0;
    end
    
    if (key == "return") then player.convoInput = true; end
  end
  
  if not player.onRope then
    if (key == " ") and not player.jumping then
        player.jumping = true;
        player.speedY = 8;
    end
  end
end


return player;

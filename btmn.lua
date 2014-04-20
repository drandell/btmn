--[[
 -- Btmn Base Class
 -- Handles all btmn actions, animations etc.
 -- Created 10th April 2014
 -- Dan
]]--

local LEFT = -1;
local RIGHT = 1;

btmn = {};

-- Attributes
btmn.img = love.graphics.newImage("Content/Images/test.png");
btmn.height = 32;
btmn.width = 32;
btmn.x = 20;
btmn.y = 60;
btmn.speedX = 2;
btmn.speedY = 0;
btmn.direction = RIGHT;
btmn.health = 100;
btmn.drawDebug = false;

-- Character Action Bools
btmn.canMove = true;
btmn.standingLeft = false;
btmn.standingRight = true;
btmn.movingLeft = false;
btmn.movingRight = false;
btmn.jumping = false;

-- Rope Bools
btmn.collidingWithRope = false;
btmn.onRope = false;

-- Conversation Bools & Vars
btmn.convoActive = false;
btmn.convoInput = false;
btmn.selectedConvoOption = 0;

offset = {x = 0, y = 0};
btmn.collisionRect = {x = (btmn.x + offset.x) - global.tx, y = (btmn.y - offset.y) - global.ty, width = btmn.width,                    height = btmn.height };

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
btmn.walkRight = anim8.newAnimation(walkGrid('1-8',1), 0.1)
btmn.walkLeft = anim8.newAnimation(walkGrid('8-1',1), 0.1):flipH();
walkWidthOffset = 8; -- 8 pixel offset due to difference in anim frame width & btmn width
]]--

-- Simple Generic box collision function
function boxCollision(x, y, width, height)
	if (btmn.collisionRect.x + btmn.width > x) and (btmn.collisionRect.x < x + width) and (btmn.collisionRect.y + btmn.height + global.ty > y) and (btmn.collisionRect.y < y + height) then
		return true;
	else
		return false;
	end
end

function boxCollisionHalfWidth(x, y, width, height)
  if (btmn.direction == RIGHT) then
      if (btmn.collisionRect.x + (btmn.width / 2) > x) and (btmn.collisionRect.x < x + width) and (btmn.collisionRect.y +         btmn.height + global.ty > y) and (btmn.collisionRect.y < y + height) then
        return true;
      else
        return false;
      end
  elseif (btmn.direction == LEFT) then 
    if (btmn.collisionRect.x < x) and (btmn.collisionRect.x + btmn.width > x + width) and 
      (btmn.collisionRect.y + btmn.height + global.ty > y) and (btmn.collisionRect.y < y + height) then
      return true;
    else
      return false;
    end
  end  
end

function getbtmnCorners(x, y)
  down = math.floor(( (y - offset.y) + btmn.height - 1) / global.tSize);
	up = math.floor( (y - offset.y) / global.tSize); --+1
  
  middleY = math.floor((y - offset.y + (btmn.height / 2)) / global.tSize);
  middleX = math.ceil((x - offset.x + (btmn.width / 2)) / global.tSize);
	
  -- Hopefully sorted!
  left = math.floor( (x - offset.x) / global.tSize) + 1;
	right = math.ceil(( (x - offset.x) + btmn.width - 1) / global.tSize);
end

-- Jump function, makes our btmn jump
function jump(colMap, gSpeed, grav)
grav = 0.45 or grav;
collisionMap = colMap;
btmn.speedY = (btmn.speedY - grav * gSpeed);

	if (btmn.speedY < 0) then
		movebtmn(0, 1, collisionMap, gSpeed);
	elseif (btmn.speedY > 0) then
		movebtmn(0, -1, collisionMap, gSpeed);
	end
end

-- Fall function, to make the btmn "fall"
function fall(collisionMap, fallSpeed)
fallSpeed = -0.5 or fallSpeed;

  if not btmn.jumping and not btmn.onRope then
    getbtmnCorners(btmn.x, btmn.y + 1);
      if (collisionMap:get(left, down) == nil and collisionMap:get(right, down) == nil) 
         and collisionMap:get(middleX, down) == nil then
        btmn.speedY = fallSpeed;
        btmn.jumping = true;
      end
  end
end

function movebtmn(dirx, diry, collisionMap, gSpeed)
  --Update postition
  if not btmn.dead and btmn.x >= 0 and btmn.y >= 0 and btmn.y < global.gameWorldHeight then
    btmn.x = (btmn.x + (btmn.speedX * dirx) * gSpeed);
    if btmn.speedY > 0 then
      btmn.y = (btmn.y + (btmn.speedY * diry) * gSpeed); 
    elseif btmn.speedY < 0 then
      btmn.y = (btmn.y - (btmn.speedY * diry) * gSpeed); 
    end
    
    if (btmn.x < 0) then btmn.x = global.offsetX; end
    if (btmn.x + btmn.width + btmn.speedX > (map.width * map.tileWidth)) then 
      btmn.x = (map.width * map.tileWidth) - btmn.width - btmn.speedX;
    end
  
    -- Get btmn Tile Corners
    getbtmnCorners(btmn.x, btmn.y);
  
    if (dirx == 1) then
        if (collisionMap:get(right, down) == nil 
            and collisionMap:get(right, up) == nil) then
            if (btmn.x + btmn.width) > ((love.graphics.getWidth() / 2)) and global.tx > -global.gameWorldWidth then
                global.tx = (global.tx - btmn.speedX * gSpeed);
            end
        else
          btmn.x = ((right-1) * global.tSize) - (btmn.width - offset.x);
        end
    end
    
    if (dirx == -1) then
        if (collisionMap:get(left, down) == nil and collisionMap:get(left, middleY) == nil 
            and collisionMap:get(left, up) == nil) then	
            if (btmn.x + global.tx) < ((love.graphics.getWidth() / 2)) and global.tx < 0 then
                global.tx = (global.tx + btmn.speedX * gSpeed);
                
                if (global.tx > 0) then global.tx = 0; end
            end
        else
          btmn.x = (left * global.tSize) + (offset.x - btmn.speedX);
        end
    end
    
    if (diry == 1) then
        if (collisionMap:get(left, down) == nil and collisionMap:get(right, down) == nil
          and collisionMap:get(middleX, down) == nil) then
        else
          btmn.y = (down * global.tSize) - (btmn.height - offset.y);
          btmn.jumping = false;
          btmn.speedY = 0;
        end
    end
    
    if (diry == -1) then
      if (collisionMap:get(left, up) == nil and collisionMap:get(right, up) == nil) then	   
      else
        global.currentGameSpeed = 1; -- Reset Game Speed If We have a collision
        btmn.y = (up * global.tSize);
        btmn.speedY = -1;
      end
    end 
    
  end
end

function checkCollisionWithRope(colmap)
  if (colmap("Ropes")) then
      for i, obj in pairs( colmap("Ropes").objects ) do
          if (boxCollisionHalfWidth(obj.drawInfo.left + global.tx, obj.drawInfo.top + global.ty, obj.width, obj.height)) then
            btmn.collidingWithRope = true;
            rope = obj;
            break;
          else
            btmn.collidingWithRope = false;
          end
      end
  end
end

function AtTopOfRope()
    if (btmn.collidingWithRope) then 
      if (btmn.collisionRect.y <= rope.drawInfo.top) then
        return true;
      else 
        return false;
      end
    else
      return false;
    end
end

function AtBottomOfRope()
    if (btmn.collidingWithRope) then 
      if (btmn.collisionRect.y + btmn.collisionRect.height >= rope.drawInfo.bottom) then
        return true;
      else 
        return false;
      end
    else
      return false;
    end
end

function canMoveUpRope()
  if (btmn.collisionRect.y <= rope.drawInfo.top) then
    return false;
  else
    return true;
  end
end

function canMoveDownRope()
  if (btmn.collisionRect.y + btmn.collisionRect.height >= rope.drawInfo.bottom) then
    return false;
  else
    return true;
  end
end

function btmn:update(dt, colmap, gameSpeed)
  gameSpeed = gameSpeed or 1;
  
  -- Update Anim
  --[[
  if (btmn.movingRight) then
    btmn.walkRight:update(dt);
  elseif (btmn.movingLeft) then
    btmn.walkRight:update(dt);
  end
  ]]--
  
  -- Check to see if the object should be falling
	fall(colmap("Collision Layer"));
  -- Check if the btmn is colliding with a rope obj
  checkCollisionWithRope(colmap);
  
  -- btmn Movement Update
  if not btmn.onRope and btmn.canMove then
    if (love.keyboard.isDown("right")) then 
        btmn.direction = RIGHT;
        movebtmn(btmn.direction, 0, colmap("Collision Layer"), gameSpeed);  
        btmn.movingLeft = false;
        btmn.movingRight = true;
        btmn.standingRight = false;
        btmn.standingLeft = false;
    end
  
    if (love.keyboard.isDown("left")) then 
        btmn.direction = LEFT;
        movebtmn(btmn.direction, 0, colmap("Collision Layer"), gameSpeed); 
        btmn.movingRight = false;
        btmn.movingLeft = true;
        btmn.standingRight = false;
        btmn.standingLeft = false;
    end
    
    -- ADD Jumping check here for when jumping to-do anim
    if (not love.keyboard.isDown("left") and not love.keyboard.isDown("right")) then 
      btmn.movingLeft = false;
      btmn.movingRight = false;
      
      if (btmn.direction == RIGHT) then
        btmn.standingRight = true;
      else
        btmn.standingLeft = true;
      end
    end
 
    if (btmn.jumping) then
        jump(colmap("Collision Layer"), gameSpeed);
    end
  elseif btmn.onRope then
    -- Check to see if btmn can climb &
    -- Check to see if btmn can exit rope!
    if (love.keyboard.isDown("up") and canMoveUpRope()) then
      btmn.y = btmn.y - 2;
    elseif not canMoveUpRope() then
      if (love.keyboard.isDown("left") or love.keyboard.isDown("right")) then 
        btmn.onRope = false;
      end
    end
    
    if (love.keyboard.isDown("down") and canMoveDownRope()) then
      btmn.y = btmn.y + 2;
    elseif not canMoveDownRope() then
      if (love.keyboard.isDown("left") or love.keyboard.isDown("right")) then 
        btmn.onRope = false;
      end
    end
  end
  
  -- btmn Collision Update
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
              btmn.canMove = false;
              btmn.convoActive = true;
              break;
            end
          end
      end
  end
  
  -- Update Collision Rectangle
  btmn.collisionRect.x = (btmn.x + offset.x) + global.offsetX + global.tx;
  btmn.collisionRect.y = (btmn.y - offset.y) + global.offsetY + global.ty;
end

function btmn:draw()
  -- Draw btmn  
  if (btmn.standingRight or btmn.movingRight) then
    love.graphics.draw(btmn.img, 
      btmn.x + global.tx + global.offsetX, 
      btmn.y + global.ty + global.offsetY, 0, 1, 1);
  elseif (btmn.standingLeft or btmn.movingLeft) then
    love.graphics.draw(btmn.img, 
      btmn.x + global.tx + global.offsetX, 
      btmn.y + global.ty + global.offsetY, 0, -1, 1, btmn.width + (offset.x * 2));
  end
  --[[
  if (btmn.movingRight) then
    btmn.walkRight:draw(WalkImg, btmn.x - walkWidthOffset + global.tx, btmn.y + global.ty);
  elseif (btmn.movingLeft) then
    btmn.walkRight:draw(WalkImg, btmn.x + walkWidthOffset + global.tx, btmn.y + global.ty, 0, -1, 1, btmn.width + (    offset.x * 2));
  end
  ]]--
  
  -- Temp Health Bar & Map Information 
  -- TODO: Move to a UI implementation
  for i = 0, btmn.health / 20 do
    love.graphics.setColor(red);
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
  love.graphics.setColor(black); -- We want black text
  love.graphics.print("" .. map.properties.scene, 
    global.offsetX + global.gameWorldWidth - (love.graphics.getFont():getWidth(map.properties.scene) + 5),
    global.offsetY + global.gameWorldHeight - (love.graphics.getFont():getHeight(map.properties.scene) + 5));
  love.graphics.setColor(white); -- Reset Color
end

function btmn:keypressed(key, unicode)
  if btmn.collidingWithRope and not btmn.convoActive then
    if (key == "up") and not AtTopOfRope() or (key == "down") and not AtBottomOfRope() then
        btmn.onRope = true;
    end
  end  
  
  if not btmn.collidingWithRope and btmn.convoActive then
    if (key == "up") then
      btmn.selectedConvoOption = btmn.selectedConvoOption + 1;
    elseif (key == "down") then
      btmn.selectedConvoOption = btmn.selectedConvoOption - 1;
    end
    
    if (btmn.selectedConvoOption < 0) then
      btmn.selectedConvoOption = 1;
    elseif (btmn.selectedConvoOption > 1) then
      btmn.selectedConvoOption = 0;
    end
    
    if (key == "return") then btmn.convoInput = true; end
  end
  
  if not btmn.onRope then
    if (key == " ") and not btmn.jumping then
        btmn.jumping = true;
        btmn.speedY = 8;
    end
  end
end


return btmn;

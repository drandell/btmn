--[[
 -- Btmn base class
 -- Handles all btmn actions, animations etc.
 -- Created 10th April 2014
 -- Dan
]]--

local LEFT = -1;
local RIGHT = 1;

btmn = {};

-- Attributes
btmn.height = 64;
btmn.width = 32;
btmn.x = 20;
btmn.y = 60;
btmn.speedX = 2;
btmn.speedY = 0;
btmn.oldDirection = RIGHT;
btmn.direction = RIGHT;
btmn.health = 100;
btmn.drawDebug = false;

-- Batarang
btmn.batarangs = {};
btmn.batarangImg = love.graphics.newImage("Content/Images/batarang.png");
btmn.activeBatarangs = 0;
btmn.maxNumberOfBatarangs = 1;

-- Character action bools
btmn.currentState = "standingRight";
btmn.currentAnim = nil;
btmn.canMove = true;
btmn.jumping = false;
btmn.ducking = false;
btmn.blocking = false;
btmn.throwingBatarang = false;

-- Rope bools
btmn.collidingWithRope = false;
btmn.onRope = false;

-- Conversation bools & vars
btmn.convoActive = false;
btmn.convoInput = false;
btmn.selectedConvoOption = 0;

offset = {x = 0, y = 0};
btmn.collisionRect = {x = (btmn.x + offset.x) - global.tx, y = (btmn.y - offset.y) - global.ty, width = btmn.width, height = btmn.height };

-- Collision tile variables
-- TODO: Make Local when not debugging!
left = 0;
right = 0;
up = 0;
middleX = 0;
middleY = 0;
down = 0;

-- Requires
require("rope");

-- Animation imgs
btmn.standImg = love.graphics.newImage("Content/Images/btmnStand.png");
btmn.duckImg = love.graphics.newImage("Content/Images/btmnDuck.png");
btmn.standUpImg = love.graphics.newImage("Content/Images/btmnStandUp.png");
btmn.walkImg = love.graphics.newImage("Content/Images/btmnWalk.png");
btmn.toStandImg = love.graphics.newImage("Content/Images/btmnToStand.png");
btmn.standJumpImg = love.graphics.newImage("Content/Images/btmnStandingJump.png");
btmn.landJumpImg = love.graphics.newImage("Content/Images/btmnLand.png");
btmn.lookUpImg = love.graphics.newImage("Content/Images/btmnLookup.png");
btmn.blockImg = love.graphics.newImage("Content/Images/btmnBlock.png");
btmn.throwBatarangImg = love.graphics.newImage("Content/Images/btmnBatarang.png");

-- Animations
local yRenderOffset = 12;
local standAndTurnRenderOffset = 10;
local standGrid = anim8.newGrid(50, 64, btmn.standImg:getWidth(), btmn.standImg:getHeight());
btmn.standRight = anim8.newAnimation(standGrid('1-5',1), {0.7, 0.1, 0.1, 0.1, 0.1}, 'pauseAtEnd');
btmn.standLeft = btmn.standRight:clone():flipH();

btmn.turnRight = anim8.newAnimation(standGrid('5-1',1), {0.08, 0.08, 0.08, 0.08, 0.08}, 'pauseAtEnd');
btmn.turnLeft = btmn.turnRight:clone():flipH();

local duckRenderOffset = 15;
local duckGrid = anim8.newGrid(60, 64, btmn.duckImg:getWidth(), btmn.duckImg:getHeight());
btmn.duckRight = anim8.newAnimation(duckGrid('1-7',1), 0.1, 'pauseAtEnd');
btmn.duckLeft = btmn.duckRight:clone():flipH();

local standUpRenderOffset = 15;
local standUpGrid = anim8.newGrid(60, 64, btmn.standUpImg:getWidth(), btmn.standUpImg:getHeight());
btmn.upRight = anim8.newAnimation(standUpGrid('1-3',1), 0.1, 'pauseAtEnd');
btmn.upLeft = btmn.upRight:clone():flipH();

local walkRenderOffsetRight = 25;
local walkRenderOffsetLeft = 15;
local walkQuads = {};

for i = 1, 18 do
  walkQuads[i] = love.graphics.newQuad(0 + ((i-1) * 70), 0, 70, 64, btmn.walkImg:getWidth(), btmn.walkImg:getHeight());
end
walkQuads[11] = love.graphics.newQuad(700, 0, 72, 64, btmn.walkImg:getWidth(), btmn.walkImg:getHeight());
for j = 1, 7 do
  walkQuads[11 + j] = love.graphics.newQuad(772 + ((j-1) * 70), 0, 70, 64, btmn.walkImg:getWidth(), btmn.walkImg:getHeight());
end

btmn.walkRight = anim8.newAnimation(walkQuads, 0.1, 'pauseAtEnd');
btmn.walkLeft = btmn.walkRight:clone():flipH();

local toStandGrid = anim8.newGrid(70, 64, btmn.toStandImg:getWidth(), btmn.toStandImg:getHeight());
btmn.toStandRight = anim8.newAnimation(toStandGrid('1-6',1), 0.08, 'pauseAtEnd');
btmn.toStandLeft = btmn.toStandRight:clone():flipH();

local standingJumpOffset = 20;
local standingJumpGrid = anim8.newGrid(60, 66, btmn.standJumpImg:getWidth(), btmn.standJumpImg:getHeight());
btmn.standJumpRight = anim8.newAnimation(standingJumpGrid('1-4',1), {0.1, 0.1, 0.1, 0.1}, 'pauseAtEnd');
btmn.standJumpLeft = btmn.standJumpRight:clone():flipH();

local landingOffset = 25;
local landingJumpGrid = anim8.newGrid(60, 64, btmn.landJumpImg:getWidth(), btmn.landJumpImg:getHeight());
btmn.landingRight = anim8.newAnimation(landingJumpGrid('1-3',1), 0.1, 'pauseAtEnd');
btmn.landingLeft = btmn.landingRight:clone():flipH();

local lookUpGrid = anim8.newGrid(50, 64, btmn.lookUpImg:getWidth(), btmn.lookUpImg:getHeight());
btmn.lookUpRight = anim8.newAnimation(lookUpGrid('1-3',1), 0.08, 'pauseAtEnd');
btmn.lookUpLeft = btmn.lookUpRight:clone():flipH();

local blockGrid = anim8.newGrid(50, 64, btmn.blockImg:getWidth(), btmn.blockImg:getHeight());
btmn.armsUpRight = anim8.newAnimation(standGrid('5-1',1), 0.04, 'pauseAtEnd');
btmn.armsUpLeft = btmn.armsUpRight:clone():flipH();
btmn.blockRight = anim8.newAnimation(blockGrid('1-4',1), {0.08, 0.08, 0.1, 0.1}, 'pauseAtEnd');
btmn.blockLeft = btmn.blockRight:clone():flipH();

local throwOffset = 15;
local throwBatarangGrid = anim8.newGrid(60, 64, btmn.throwBatarangImg:getWidth(), btmn.throwBatarangImg:getHeight());
btmn.throwRight = anim8.newAnimation(throwBatarangGrid('1-7',1), 0.09, 'pauseAtEnd');
btmn.throwLeft = btmn.throwRight:clone():flipH();

btmn.currentAnim = btmn.standRight;

--[[ Local Function ]]--
-- Bounding box collision
function boxCollision( x, y, width, height )
  if (btmn.collisionRect.x + btmn.width > x) and (btmn.collisionRect.x < x + width) and (btmn.collisionRect.y + btmn.height + global.ty > y) and (btmn.collisionRect.y < y + height) then
    return true;
  else
    return false;
  end
end
--[[ Local Function ]]--
-- Half width bounding box collision detection
function boxCollisionHalfWidth( x, y, width, height )
  if (btmn.direction == RIGHT) then
      if (btmn.collisionRect.x + (btmn.width / 2) > x) and (btmn.collisionRect.x < x + width) and (btmn.collisionRect.y + btmn.height + global.ty > y) and (btmn.collisionRect.y < y + height) then
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
--[[ Local Function ]]--
-- Get btmn corners on tilemap
function getBtmnCorners( x, y )
  down = math.floor(( (y - offset.y) + btmn.height - 1) / global.tSize);
  up = math.floor( (y - offset.y) / global.tSize); --+1
  
  middleY = math.floor((y - offset.y + (btmn.height / 2)) / global.tSize);
  middleX = math.ceil((x - offset.x + (btmn.width / 2)) / global.tSize);
	
  -- Hopefully sorted!
  left = math.floor( (x - offset.x) / global.tSize) + 1;
  right = math.ceil(( (x - offset.x) + btmn.width - 1) / global.tSize);
end
--[[ Local Function ]]--
-- Jump function, makes btmn jump
function jump( colMap, gSpeed, grav )
grav = 0.45 or grav;
collisionMap = colMap;
btmn.speedY = (btmn.speedY - grav * gSpeed);

	if (btmn.speedY < 0) then
		moveBtmn(0, 1, collisionMap, gSpeed);
	elseif (btmn.speedY > 0) then
		moveBtmn(0, -1, collisionMap, gSpeed);
	end
end
--[[ Local Function ]]--
-- Fall function, to make btmn "fall"
function fall( collisionMap, fallSpeed )
fallSpeed = -0.5 or fallSpeed;

  if not btmn.jumping and not btmn.onRope then
    getBtmnCorners(btmn.x, btmn.y + 1);
      if (collisionMap:get(left, down) == nil and collisionMap:get(right, down) == nil) 
         and collisionMap:get(middleX, down) == nil then
        btmn.speedY = fallSpeed;
        btmn.jumping = true;
      end
  end
end
--[[ Local Function ]]--
-- Move btmn
function moveBtmn( dirx, diry, collisionMap, gSpeed )
  --Update postition
  if not btmn.dead and btmn.x >= 0 and btmn.y >= 0 and btmn.y < global.gameWorldHeight then
    btmn.x = (btmn.x + (btmn.speedX * dirx) * gSpeed);
    if btmn.speedY > 0 then
      btmn.y = (btmn.y + (btmn.speedY * diry) * gSpeed); 
    elseif btmn.speedY < 0 then
      btmn.y = (btmn.y - (btmn.speedY * diry) * gSpeed); 
    end
    
    if (btmn.x < 12) then btmn.x = 12; end
    if (btmn.x + btmn.width + btmn.speedX > (map.width * map.tileWidth)) then 
      btmn.x = (map.width * map.tileWidth) - btmn.width - btmn.speedX;
    end
  
    -- Get btmn Tile Corners
    getBtmnCorners(btmn.x, btmn.y);
  
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
--[[ Function ]]--
-- Update
function btmn:update( dt, colmap, gameSpeed )
  gameSpeed = gameSpeed or 1;
  local collisionOffset = {x = 0, y = 12};
  btmn.collisionRect.width = btmn.width;
  btmn.collisionRect.height = btmn.height;
  
  -- Keep track of old direction
  btmn.oldDirection = btmn.direction;
  -- Update Anim
  btmn.currentAnim:update(dt);
  
  -- Check to see if the object should be falling
	fall(colmap("Collision Layer"));
  -- Check if the btmn is colliding with a rope obj
  checkCollisionWithRope(colmap);
  
  -- btmn Movement Update
  if not btmn.onRope and btmn.canMove then
    
    if not btmn.ducking and not btmn.blocking then
      offset.x = 0; -- No offset required!
      
      if (love.keyboard.isDown("up")) then      
        if (btmn.currentState == "standingRight" or btmn.currentState == "standingLeft") then
          if (btmn.direction == RIGHT) then
            -- Quickening Animation, we skip the long pause on the first frame
            if (btmn.currentAnim.position == 1) then 
              btmn.standRight:gotoFrame(2); 
            end 
          
            if (btmn.currentAnim.status == "paused") then
              btmn.standRight:pauseAtStart(); -- Reset standing animation
              btmn.currentState = "lookingUpRight";
              btmn.currentAnim = btmn.lookUpRight;
            end
          elseif (btmn.direction == LEFT) then
            -- Quickening Animation, we skip the long pause on the first frame
            if (btmn.currentAnim.position == 1) then 
              btmn.standLeft:gotoFrame(2); 
            end 
          
            if (btmn.currentAnim.status == "paused") then
              btmn.standLeft:pauseAtStart(); -- Reset standing animation
              btmn.currentState = "lookingUpLeft";
              btmn.currentAnim = btmn.lookUpLeft;
            end
          end
          
          btmn.currentAnim:resume();
        elseif (btmn.currentState == "lookingUpRight" or btmn.currentState == "lookingUpLeft") then
          -- We've reached look-up frame, stay on it
          if (btmn.currentAnim.position >= 2) then
            btmn.currentAnim:gotoFrame(2);
          end
        end
      elseif (not love.keyboard.isDown("up")) then  
        if (btmn.lookUpRight.position >= 3 and btmn.currentState == "lookingUpRight" and btmn.lookUpRight.status == "paused") then
          btmn.lookUpRight:pauseAtStart() -- Reset lookup animation
          btmn.currentState = "turningRight";
          btmn.currentAnim = btmn.armsUpRight;
          btmn.currentAnim:resume();
        elseif (btmn.lookUpLeft.position >= 3 and btmn.currentState == "lookingUpLeft" and btmn.lookUpLeft.status == "paused") then
          btmn.lookUpLeft:pauseAtStart() -- Reset lookup animation
          btmn.currentState = "turningLeft";
          btmn.currentAnim = btmn.armsUpLeft;
          btmn.currentAnim:resume();
        end
      end
      
      if (love.keyboard.isDown("right")) then 
          btmn.direction = RIGHT;
          collisionOffset.x = 12 * btmn.direction;
          
          if (btmn.currentAnim.status == "paused" and btmn.currentState == "walkingRight") then
            btmn.walkRight:gotoFrame(9); --Loop
          end
                 
          if (btmn.oldDirection == LEFT) then
            btmn.standRight:pauseAtStart(); -- Reset standing animation
            btmn.currentState = "turningRight";
            btmn.currentAnim = btmn.turnRight;
          elseif (btmn.turnRight.status == "paused" or btmn.turnRight.position >= 2 or btmn.currentState == "standingRight" or btmn.currentState == "lookingUpRight") then
            btmn.standRight:pauseAtStart(); -- Reset standing animation
            btmn.lookUpRight:pauseAtStart();
            btmn.turnRight:pauseAtStart(); 
            btmn.currentState = "walkingRight";
            btmn.currentAnim = btmn.walkRight;
          elseif (btmn.direction == RIGHT and btmn.turnLeft.status == "playing") then
            btmn.turnLeft:pauseAtStart(); 
            btmn.currentState = "walkingRight";
            btmn.currentAnim = btmn.walkRight;
          end
          
          if (btmn.currentState == "walkingRight") then
            moveBtmn(btmn.direction, 0, colmap("Collision Layer"), gameSpeed); 
          end
          btmn.currentAnim:resume();
      end
    
      if (love.keyboard.isDown("left")) then 
          btmn.direction = LEFT;
          collisionOffset.x = 12 * btmn.direction;
          
          if (btmn.currentAnim.status == "paused" and btmn.currentState == "walkingLeft") then
            btmn.walkLeft:gotoFrame(9); --Loop
          end
          
          if (btmn.oldDirection == RIGHT) then
            btmn.standLeft:pauseAtStart(); -- Reset standing animation
            btmn.currentState = "turningLeft";
            btmn.currentAnim = btmn.turnLeft;
          elseif (btmn.turnLeft.status == "paused" or btmn.turnLeft.position >= 2 or btmn.currentState == "standingLeft" or btmn.currentState == "lookingUpLeft") then
            btmn.standLeft:pauseAtStart(); -- Reset standing animation
            btmn.lookUpLeft:pauseAtStart();
            btmn.turnLeft:pauseAtStart(); 
            btmn.currentState = "walkingLeft";
            btmn.currentAnim = btmn.walkLeft;
          elseif (btmn.direction == LEFT and btmn.turnRight.status == "playing") then
            btmn.turnRight:pauseAtStart(); 
            btmn.currentState = "walkingLeft";
            btmn.currentAnim = btmn.walkLeft;
          end
          
          if (btmn.currentState == "walkingLeft") then
            moveBtmn(btmn.direction, 0, colmap("Collision Layer"), gameSpeed); 
          end
          btmn.currentAnim:resume();
      end
      
      if (not love.keyboard.isDown("left") and not love.keyboard.isDown("right")) then 
          if (btmn.currentState == "turningRight" and btmn.currentAnim.status == "paused") then
            btmn.turnRight:pauseAtStart(); -- Reset turning animation
            btmn.armsUpRight:pauseAtStart(); -- Reset faster turning animation
            btmn.currentState = "standingRight";
            btmn.currentAnim = btmn.standRight;   
            
          elseif (btmn.currentState == "turningLeft" and btmn.currentAnim.status == "paused") then
            btmn.turnLeft:pauseAtStart(); -- Reset turning animation
            btmn.armsUpLeft:pauseAtStart(); -- Reset faster turning animation
            btmn.currentState = "standingLeft";
            btmn.currentAnim = btmn.standLeft;
          
          elseif (btmn.currentState == "standingUpRight" and btmn.currentAnim.status == "paused") then
            btmn.upRight:pauseAtStart(); -- Reset standing up animation
            btmn.currentState = "standingRight";
            btmn.currentAnim = btmn.standRight;
            
          elseif (btmn.currentState == "standingUpLeft" and btmn.currentAnim.status == "paused") then
            btmn.upLeft:pauseAtStart(); -- Reset standing up animation
            btmn.currentState = "standingLeft";
            btmn.currentAnim = btmn.standLeft;
            
          elseif (btmn.currentState == "walkingRight" or btmn.currentState == "walkingLeft") then
            btmn.walkLeft:pauseAtStart(); -- Reset walking animations
            btmn.walkRight:pauseAtStart();
            
            if (btmn.direction == RIGHT) then
                btmn.currentState = "toStandRight";
                btmn.currentAnim = btmn.toStandRight;
              elseif (btmn.direction == LEFT) then
                btmn.currentState = "toStandLeft";
                btmn.currentAnim = btmn.toStandLeft;
              end
            
          elseif (btmn.currentState == "toStandRight" and btmn.currentAnim.status == "paused") then
            btmn.toStandRight:pauseAtStart(); -- Reset to stand animation
            btmn.currentState = "standingRight";
            btmn.currentAnim = btmn.standRight;
            
          elseif (btmn.currentState == "toStandLeft" and btmn.currentAnim.status == "paused") then
            btmn.toStandLeft:pauseAtStart(); -- Reset to stand animation
            btmn.currentState = "standingLeft";
            btmn.currentAnim = btmn.standLeft;
            
          elseif (btmn.currentState == "landingJumpRight" and btmn.currentAnim.status == "paused") then
            btmn.landingRight:pauseAtStart(); -- Reset landing animation
            btmn.currentState = "standingRight";
            btmn.currentAnim = btmn.standRight;
          
          elseif (btmn.currentState == "landingJumpRight" and btmn.currentAnim.status == "paused") then
            btmn.landingLeft:pauseAtStart(); -- Reset landing animation
            btmn.currentState = "standingLeft";
            btmn.currentAnim = btmn.standLeft;
          end
          
          btmn.currentAnim:resume();
      end
   
      if (btmn.jumping) then
          jump(colmap("Collision Layer"), gameSpeed);     
          
          if (btmn.currentState == "standingRight") then
            btmn.standRight:pauseAtStart(); -- Reset standing animation
            btmn.currentState = "standingJumpRight";
            btmn.currentAnim = btmn.standJumpRight;
          elseif (btmn.currentState == "standingLeft") then
            btmn.standLeft:pauseAtStart(); -- Reset standing animation
            btmn.currentState = "standingJumpLeft";
            btmn.currentAnim = btmn.standJumpLeft;
          end
          
      elseif (not btmn.jumping) then
        if (btmn.currentState == "standingJumpRight") then
          btmn.standJumpRight:pauseAtStart(); -- Reset standing jump animation
          btmn.currentState = "landingJumpRight";
          btmn.currentAnim = btmn.landingRight;
        elseif (btmn.currentState == "standingJumpLeft") then
          btmn.standJumpLeft:pauseAtStart(); -- Reset standing jump animation
          btmn.currentState = "landingJumpLeft";
          btmn.currentAnim = btmn.landingLeft;
        end
      end
    end  
    
    if (love.keyboard.isDown("down")) then
      if (not btmn.ducking) then
        btmn.currentAnim:pauseAtStart(); -- Reset Whatever animation is currently active
      end
      btmn.ducking = true;
      collisionOffset.x = 10 * btmn.direction;
      collisionOffset.y = 36;
      btmn.collisionRect.height = 32;
      
      if (btmn.direction == RIGHT) then
        btmn.currentState = "duckingRight";       
        btmn.currentAnim = btmn.duckRight;
      elseif (btmn.direction == LEFT) then
        btmn.currentState = "duckingLeft";       
        btmn.currentAnim = btmn.duckLeft;
      end
      
      btmn.currentAnim:resume();
    elseif (not love.keyboard.isDown("down") and btmn.ducking) then     
      if (btmn.currentAnim.status == "paused") then
        -- Fully ducked, stand up animation
        if (btmn.direction == RIGHT) then
          btmn.duckRight:pauseAtStart();
          btmn.currentState = "standingUpRight";       
          btmn.currentAnim = btmn.upRight;
        elseif (btmn.direction == LEFT) then
          btmn.duckLeft:pauseAtStart();
          btmn.currentState = "standingUpLeft";       
          btmn.currentAnim = btmn.upLeft;
        end
      else
        -- We have not fully ducked, just revert back to standing       
        if (btmn.direction == RIGHT) then
          btmn.duckRight:pauseAtStart();
          btmn.currentState = "standingRight";
          btmn.currentAnim = btmn.standRight;   
        elseif (btmn.direction == LEFT) then
          btmn.duckLeft:pauseAtStart();
          btmn.currentState = "standingLeft";
          btmn.currentAnim = btmn.standLeft;
        end
      end
      
      btmn.currentAnim:resume();
      btmn.ducking = false;      
    end
  elseif btmn.onRope and not btmn.ducking then
    -- Check to see if btmn can climb &
    -- Check to see if btmn can exit rope!
    --btmn.currentAnim = btmn.climb;
    
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
  
  if (love.keyboard.isDown("c") and not btmn.blocking) then
    btmn.blocking = true;
    
    if (btmn.currentState == "standingRight" or btmn.currentState == "standingLeft") then
      -- Quickening Animation, we skip the long pause on the first frame
      if (btmn.currentAnim.position == 1) then 
        btmn.standRight:gotoFrame(2); 
      end 
      
      if (btmn.direction == RIGHT) then
        btmn.standRight:pauseAtStart(); -- Reset standing animation
        btmn.currentState = "turningRight";
        btmn.currentAnim = btmn.armsUpRight;
      elseif (btmn.direction == LEFT) then
        btmn.standLeft:pauseAtStart(); -- Reset standing animation
        btmn.currentState = "turningLeft";
        btmn.currentAnim = btmn.armsUpLeft;
      end
    end    
    
    btmn.currentAnim:resume();
  elseif (love.keyboard.isDown("c") and btmn.blocking) then
    if (btmn.currentState == "turningRight" and btmn.currentAnim.status == "paused") then
      btmn.armsUpRight:pauseAtStart(); -- Reset turning animation
      btmn.currentState = "blockingRight";
      btmn.currentAnim = btmn.blockRight;
    elseif (btmn.currentState == "turningLeft" and btmn.currentAnim.status == "paused") then
      btmn.armsUpLeft:pauseAtStart(); -- Reset turning animation
      btmn.currentState = "blockingLeft";
      btmn.currentAnim = btmn.blockLeft;
    end
    
    if (btmn.currentState == "blockingRight" or btmn.currentState == "blockingLeft") then
      if (btmn.currentAnim.position >= 2) then
        btmn.currentAnim:gotoFrame(2);
      end
    end
    
    btmn.currentAnim:resume();
  end
  
  if (not love.keyboard.isDown("c")) then
    if (btmn.currentState == "blockingRight" or btmn.currentState == "blockingLeft") then
      if (btmn.currentAnim.position >= 4) then
        btmn.currentAnim:pauseAtStart(); -- Reset whatever blocking animation we have
          
        if (btmn.direction == RIGHT) then
          btmn.currentState = "standingRight";
          btmn.currentAnim = btmn.standRight;   
        elseif (btmn.direction == LEFT) then
          btmn.currentState = "standingLeft";
          btmn.currentAnim = btmn.standLeft;
        end
      end
    end
    
    btmn.blocking = false;
  end
  
  if (btmn.throwingBatarang) then   
    if (btmn.currentState ~= "throwingBatarangRight" and btmn.currentState ~= "throwingBatarangLeft") then
      btmn.currentAnim:pauseAtStart(); --Reset whatever animation is currently running
      
      if (btmn.direction == RIGHT) then
        btmn.currentState = "throwingBatarangRight";
        btmn.currentAnim = btmn.throwRight;
      elseif (btmn.direction == LEFT) then
        btmn.currentState = "throwingBatarangLeft";
        btmn.currentAnim = btmn.throwLeft;
      end
      btmn.currentAnim:resume();
    end
    
      if (btmn.currentAnim.position == 3 and btmn.activeBatarangs < btmn.maxNumberOfBatarangs) then
        if (btmn.currentState == "throwingBatarangRight") then
           btmn.batarangs[btmn.activeBatarangs+1] = {
             x = btmn.collisionRect.x + btmn.collisionRect.width - global.offsetX + (btmn.batarangImg:getWidth() / 2);
             y = btmn.collisionRect.y - global.offsetY + (btmn.batarangImg:getHeight() * 1.6), 
             width = btmn.batarangImg:getWidth(),
             height = btmn.batarangImg:getHeight(),
             active = true, 
             angle = 0,
             dir = "right"
           };
        elseif (btmn.currentState == "throwingBatarangLeft") then
           btmn.batarangs[btmn.activeBatarangs+1] = {
             x = btmn.collisionRect.x - global.offsetX - (btmn.batarangImg:getWidth() * 2), 
             y = btmn.collisionRect.y - global.offsetY + (btmn.batarangImg:getHeight() * 1.6), 
             width = btmn.batarangImg:getWidth(),
             height = btmn.batarangImg:getHeight(),
             active = true, 
             angle = 0,
             dir = "left"
           };
        end
        
        btmn.activeBatarangs = btmn.activeBatarangs + 1;
      end
    
    if (btmn.currentAnim.status == "paused") then
      if (btmn.currentState == "throwingBatarangRight") then
        btmn.throwRight:pauseAtStart(); -- Reset throwing animation
        btmn.currentState = "standingRight";
        btmn.currentAnim = btmn.standRight;   
      elseif (btmn.currentState == "throwingBatarangLeft") then
        btmn.throwLeft:pauseAtStart(); -- Reset throwing animation
        btmn.currentState = "standingLeft";
        btmn.currentAnim = btmn.standLeft;
      end
    
      btmn.canMove = true;
      btmn.throwingBatarang = false;
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
  btmn.collisionRect.x = (btmn.x + offset.x) + global.offsetX + global.tx + collisionOffset.x;
  btmn.collisionRect.y = (btmn.y - offset.y) + global.offsetY + global.ty + collisionOffset.y;
end
--[[ Function ]]--
-- Update batarangs
function btmn:updateBatarangs( enemy , gameSpeed )
  gameSpeed = gameSpeed or 1;
  local BATARANG_SPD = 6;
  local BATARANG_DMG = 20;
  
  for i, batarang in pairs( btmn.batarangs ) do
    if (batarang.active) then
      batarang.angle = batarang.angle + 5;
      
      if (batarang.angle > 360) then
        batarang.angle = 0;
      end

      if (batarang.dir == "left") then
          batarang.x = batarang.x - (BATARANG_SPD * gameSpeed);
      elseif (batarang.dir == "right") then
          batarang.x = batarang.x + (BATARANG_SPD * gameSpeed);
      end

      if (batarang.x > global.gameWorldWidth + btmn.batarangImg:getWidth()) then
        batarang.active = false;
        btmn.activeBatarangs = btmn.activeBatarangs - 1;
      elseif (batarang.x + btmn.batarangImg:getWidth() < 0) then
        batarang.active = false;
        btmn.activeBatarangs = btmn.activeBatarangs - 1;
      end
      
      -- Check Collision Against Enemies
      if (batarang.x - BATARANG_SPD + batarang.width + global.tx > enemy.x) 
        and (batarang.x  - BATARANG_SPD < enemy.x + enemy.width) 
        and (batarang.y + batarang.height + global.ty > enemy.y) 
        and (batarang.y < enemy.y + enemy.height and enemy.state ~= "knockout") then
          enemy.health = enemy.health - BATARANG_DMG;
          batarang.active = false;
          btmn.activeBatarangs = btmn.activeBatarangs - 1;
          global.targetedEnemy = enemy;
          -- If Player is too far away then here we should probably
          -- Have a check to see if the next state makes the enemy cautious 
          -- And not immediately go to the next state but for now it'll do.
          -- But he should defiantly be stunned for a bit
          if (enemy.nxtState == "speak") then
              enemy.state = enemy.nxtState;
              enemy.nxtState = "stunned"; 
          else
              -- TODO: Not yet implemented
              if (enemy.nxtState == "stunned") then
                enemy.state = "actioned";
              end
          end
      end
    end
  end
end
--[[ Function ]]--
-- Draw
function btmn:draw()
  -- Draw btmn  
  if (btmn.currentState == "standingRight" or btmn.currentState == "standingLeft" or 
    btmn.currentState == "turningRight" or btmn.currentState == "turningLeft") then
      btmn.currentAnim:draw(btmn.standImg, 
        btmn.x + global.tx + global.offsetX - standAndTurnRenderOffset, 
        btmn.y + global.ty + global.offsetY + yRenderOffset);
      
  elseif (btmn.currentState == "standingJumpRight" or btmn.currentState == "standingJumpLeft") then
    btmn.currentAnim:draw(btmn.standJumpImg, 
        btmn.x + global.tx + global.offsetX - standingJumpOffset, 
        btmn.y + global.ty + global.offsetY + yRenderOffset);
      
  elseif (btmn.currentState == "landingJumpRight"or btmn.currentState == "landingJumpLeft") then
    if (btmn.currentAnim.position == 3) then 
      landingOffset = 22;
    else
      landingOffset = 25;
    end
    
    btmn.currentAnim:draw(btmn.landJumpImg, 
        btmn.x + global.tx + global.offsetX - landingOffset, 
        btmn.y + global.ty + global.offsetY + yRenderOffset);
      
  elseif (btmn.currentState == "lookingUpRight" or btmn.currentState == "lookingUpLeft") then
    btmn.currentAnim:draw(btmn.lookUpImg, 
        btmn.x + global.tx + global.offsetX - standAndTurnRenderOffset, 
        btmn.y + global.ty + global.offsetY + yRenderOffset);
      
  elseif (btmn.currentState == "blockingRight" or btmn.currentState == "blockingLeft") then
    btmn.currentAnim:draw(btmn.blockImg, 
        btmn.x + global.tx + global.offsetX - standAndTurnRenderOffset, 
        btmn.y + global.ty + global.offsetY + yRenderOffset);
      
  elseif (btmn.currentState == "duckingRight" or btmn.currentState == "duckingLeft") then
    btmn.currentAnim:draw(btmn.duckImg, 
        btmn.x + global.tx + global.offsetX - duckRenderOffset, 
        btmn.y + global.ty + global.offsetY + yRenderOffset); 
      
  elseif (btmn.currentState == "standingUpRight" or btmn.currentState == "standingUpLeft") then
    btmn.currentAnim:draw(btmn.standUpImg, 
        btmn.x + global.tx + global.offsetX - standUpRenderOffset, 
        btmn.y + global.ty + global.offsetY + yRenderOffset);
      
  elseif (btmn.currentState == "throwingBatarangRight" or btmn.currentState == "throwingBatarangLeft") then
    btmn.currentAnim:draw(btmn.throwBatarangImg, 
        btmn.x + global.tx + global.offsetX - throwOffset, 
        btmn.y + global.ty + global.offsetY + yRenderOffset);
      
  elseif (btmn.currentState == "walkingRight") then
    btmn.currentAnim:draw(btmn.walkImg, 
        btmn.x + global.tx + global.offsetX - walkRenderOffsetRight, 
        btmn.y + global.ty + global.offsetY + yRenderOffset);
      
  elseif (btmn.currentState == "toStandRight") then
    btmn.currentAnim:draw(btmn.toStandImg, 
        btmn.x + global.tx + global.offsetX - walkRenderOffsetRight, 
        btmn.y + global.ty + global.offsetY + yRenderOffset);
      
  elseif (btmn.currentState == "toStandLeft") then
    btmn.currentAnim:draw(btmn.toStandImg, 
        btmn.x + global.tx + global.offsetX - walkRenderOffsetLeft, 
        btmn.y + global.ty + global.offsetY + yRenderOffset);
      
  elseif (btmn.currentState == "walkingLeft") then
    btmn.currentAnim:draw(btmn.walkImg, 
        btmn.x + global.tx + global.offsetX - walkRenderOffsetLeft, 
        btmn.y + global.ty + global.offsetY + yRenderOffset);
  end

  
  -- Draw Batarangs
  for i, batarang in pairs( btmn.batarangs ) do
    if (batarang.active) then
      local rotatePoint = 2;
        love.graphics.draw(btmn.batarangImg, 
          batarang.x + rotatePoint + global.tx + global.offsetX, 
          batarang.y + rotatePoint + global.ty + global.offsetY,
          math.rad(batarang.angle));
    end
  end
  
  
  -- Temp Health Bar & Map Information 
  -- TODO: Move to a UI implementation
  love.graphics.setColor(black);
  love.graphics.rectangle("fill", global.offsetX + 4, global.offsetY + 5, 74, 12); 
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

--[[ Function ]]--
-- Key pressed
function btmn:keypressed( key, unicode )
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
    
    -- Throw Batarang(s)!
    if (key == "q" and not btmn.jumping and not btmn.blocking and not btmn.ducking and not btmn.throwingBatarang and btmn.activeBatarangs < btmn.maxNumberOfBatarangs) then
        btmn.canMove = false;
        btmn.throwingBatarang = true;
      end
    end
end



return btmn;

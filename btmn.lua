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
btmn.dead = false;
btmn.jumping = false;
btmn.ducking = false;
btmn.blocking = false;
btmn.throwingBatarang = false;
btmn.punching = false;
btmn.takenDmg = false;

-- Locals
local canDraw = true;
local dmgTimer = 0;

-- Rope bools
--btmn.collidingWithRope = false;
--btmn.onRope = false;

-- Requires
--require("rope");

-- Conversation bools & vars
btmn.convoActive = false;
btmn.convoInput = false;
btmn.selectedConvoOption = 0;

renderOffset = {x = 0, y = -25};
offset = {x = 0, y = 0};
btmn.collisionRect = {x = (btmn.x + offset.x) - global.tx, y = (btmn.y - offset.y) - global.ty, width = btmn.width, height = btmn.height };

-- Collision tile variables
local left = 0;
local right = 0;
local up = 0;
local down = 0;
local middleX = 0;
local middleY = 0;

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
btmn.deathJumpImg = love.graphics.newImage("Content/Images/btmnDeathJump.png");
btmn.deathLandImg = love.graphics.newImage("Content/Images/btmnDeathLand.png");
btmn.punchImg = love.graphics.newImage("Content/Images/btmnPunch.png");

-- Animations
local standGrid = anim8.newGrid(50, 64, btmn.standImg:getWidth(), btmn.standImg:getHeight());
btmn.standRight = {anim8.newAnimation(standGrid('1-5',1), {0.7, 0.1, 0.1, 0.1, 0.1}, 'pauseAtEnd'), img = btmn.standImg};
btmn.standLeft = {btmn.standRight[1]:clone():flipH(), img = btmn.standImg};

btmn.turnRight = {anim8.newAnimation(standGrid('5-1',1), {0.08, 0.08, 0.08, 0.08, 0.08}, 'pauseAtEnd'), img = btmn.standImg};
btmn.turnLeft = {btmn.turnRight[1]:clone():flipH(), img = btmn.standImg};

local duckGrid = anim8.newGrid(60, 64, btmn.duckImg:getWidth(), btmn.duckImg:getHeight());
btmn.duckRight = {anim8.newAnimation(duckGrid('1-7',1), 0.07, 'pauseAtEnd'), img = btmn.duckImg};
btmn.duckLeft = {btmn.duckRight[1]:clone():flipH(), img = btmn.duckImg};

local standUpGrid = anim8.newGrid(60, 64, btmn.standUpImg:getWidth(), btmn.standUpImg:getHeight());
btmn.upRight = {anim8.newAnimation(standUpGrid('1-3',1), 0.06, 'pauseAtEnd'), img = btmn.standUpImg};
btmn.upLeft = {btmn.upRight[1]:clone():flipH(), img = btmn.standUpImg};

local walkQuads = {};

for i = 1, 18 do
  walkQuads[i] = love.graphics.newQuad(0 + ((i-1) * 70), 0, 70, 64, btmn.walkImg:getWidth(), btmn.walkImg:getHeight());
end
walkQuads[11] = love.graphics.newQuad(700, 0, 72, 64, btmn.walkImg:getWidth(), btmn.walkImg:getHeight());
for j = 1, 7 do
  walkQuads[11 + j] = love.graphics.newQuad(772 + ((j-1) * 70), 0, 70, 64, btmn.walkImg:getWidth(), btmn.walkImg:getHeight());
end

btmn.walkRight = {anim8.newAnimation(walkQuads, 0.1, 'pauseAtEnd'), img = btmn.walkImg};
btmn.walkLeft = {btmn.walkRight[1]:clone():flipH(), img = btmn.walkImg};

local toStandGrid = anim8.newGrid(70, 64, btmn.toStandImg:getWidth(), btmn.toStandImg:getHeight());
btmn.toStandRight = {anim8.newAnimation(toStandGrid('1-6',1), 0.075, 'pauseAtEnd'), img = btmn.toStandImg};
btmn.toStandLeft = {btmn.toStandRight[1]:clone():flipH(), img = btmn.toStandImg};

local standingJumpGrid = anim8.newGrid(60, 66, btmn.standJumpImg:getWidth(), btmn.standJumpImg:getHeight());
btmn.standJumpRight = {anim8.newAnimation(standingJumpGrid('1-4',1), 0.1, 'pauseAtEnd'), img = btmn.standJumpImg};
btmn.standJumpLeft = {btmn.standJumpRight[1]:clone():flipH(), img = btmn.standJumpImg};

local landingJumpGrid = anim8.newGrid(60, 64, btmn.landJumpImg:getWidth(), btmn.landJumpImg:getHeight());
btmn.landingRight = {anim8.newAnimation(landingJumpGrid('1-3',1), 0.1, 'pauseAtEnd'), img = btmn.landJumpImg};
btmn.landingLeft = {btmn.landingRight[1]:clone():flipH(), img = btmn.landJumpImg};

local lookUpGrid = anim8.newGrid(50, 64, btmn.lookUpImg:getWidth(), btmn.lookUpImg:getHeight());
btmn.lookUpRight = {anim8.newAnimation(lookUpGrid('1-3',1), 0.08, 'pauseAtEnd'), img = btmn.lookUpImg};
btmn.lookUpLeft = {btmn.lookUpRight[1]:clone():flipH(), img = btmn.lookUpImg};

local blockGrid = anim8.newGrid(50, 64, btmn.blockImg:getWidth(), btmn.blockImg:getHeight());
btmn.armsUpRight = {anim8.newAnimation(standGrid('5-1',1), 0.04, 'pauseAtEnd'), img = btmn.standImg};
btmn.armsUpLeft = {btmn.armsUpRight[1]:clone():flipH(), img = btmn.standImg};
btmn.blockRight = {anim8.newAnimation(blockGrid('1-4',1), {0.08, 0.08, 0.1, 0.1}, 'pauseAtEnd'), img = btmn.blockImg};
btmn.blockLeft = {btmn.blockRight[1]:clone():flipH(), img = btmn.blockImg};

local throwBatarangGrid = anim8.newGrid(60, 64, btmn.throwBatarangImg:getWidth(), btmn.throwBatarangImg:getHeight());
btmn.throwRight = {anim8.newAnimation(throwBatarangGrid('1-7',1), 0.09, 'pauseAtEnd'), img = btmn.throwBatarangImg};
btmn.throwLeft = {btmn.throwRight[1]:clone():flipH(), img = btmn.throwBatarangImg};

local deathJumpGrid = anim8.newGrid(70, 64, btmn.deathJumpImg:getWidth(), btmn.deathJumpImg:getHeight());
btmn.deathJumpRight = {anim8.newAnimation(deathJumpGrid('1-5',1), 0.15, 'pauseAtEnd'), img = btmn.deathJumpImg};
btmn.deathJumpLeft = {btmn.deathJumpRight[1]:clone():flipH(), img = btmn.deathJumpImg};

local deathLandQuads = {};

for i = 1, 5 do
  deathLandQuads[i] = love.graphics.newQuad(0 + ((i-1) * 70), 0, 70, 64, btmn.deathLandImg:getWidth(), btmn.deathLandImg:getHeight());
end
deathLandQuads[6] = love.graphics.newQuad(350, 0, 72, 64, btmn.deathLandImg:getWidth(), btmn.deathLandImg:getHeight());
deathLandQuads[7] = love.graphics.newQuad(422, 0, 72, 64, btmn.deathLandImg:getWidth(), btmn.deathLandImg:getHeight());
btmn.deathLandRight = {anim8.newAnimation(deathLandQuads, 0.15, 'pauseAtEnd'), img = btmn.deathLandImg};
btmn.deathLandLeft = {btmn.deathLandRight[1]:clone():flipH(), img = btmn.deathLandImg};

local punchGrid = anim8.newGrid(60, 64, btmn.punchImg:getWidth(), btmn.punchImg:getHeight());
btmn.punchRight = {anim8.newAnimation(punchGrid('1-5',1, '2-1',1), 0.08, 'pauseAtEnd'), img = btmn.punchImg};
btmn.punchLeft = {btmn.punchRight[1]:clone():flipH(), img = btmn.punchImg};

btmn.currentAnim = btmn.standRight;

--[[ Local Function ]]--
-- Bounding box collision
function boxCollision( x, y, width, height )
  if (btmn.collisionRect.x + btmn.width > x) and (btmn.collisionRect.x + global.tx < x + width) 
  and (btmn.collisionRect.y + btmn.height + global.ty > y) and (btmn.collisionRect.y < y + height) then
    return true;
  else
    return false;
  end
end
--[[ Local Function ]]--
-- Half width bounding box collision detection
function boxCollisionHalfWidth( x, y, width, height )
  if (btmn.direction == RIGHT) then
      if (btmn.collisionRect.x + (btmn.width / 2) > x) and (btmn.collisionRect.x + global.tx < x + width) 
      and (btmn.collisionRect.y + btmn.height + global.ty > y) and (btmn.collisionRect.y < y + height) then
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
grav = grav or 0.45;
btmn.speedY = (btmn.speedY - grav * gSpeed);

	if (btmn.speedY < 0) then
		moveBtmn(0, 1, colMap, gSpeed);
	elseif (btmn.speedY > 0) then
		moveBtmn(0, -1, colMap, gSpeed);
	end
end
--[[ Local Function ]]--
-- Fall function, to make btmn "fall"
function fall( collisionMap, fallSpeed )
fallSpeed = -0.5 or fallSpeed;

  if not btmn.jumping and not btmn.onRope then
    getBtmnCorners(btmn.x, btmn.y + 1);
      if collisionMap.data[down][left] == nil and collisionMap.data[down][right] == nil and collisionMap.data[down][middleX] == nil then
        btmn.speedY = fallSpeed;
        btmn.jumping = true;
      end
  end
end
--[[ Local Function ]]--
-- Move btmn
function moveBtmn( dirx, diry, collisionMap, gSpeed )
	local window_width = love.graphics.getWidth() ;
	
  --Update postition
	if not btmn.dead and btmn.x >= 0 and btmn.y >= 0 and btmn.y < global.gameWorldHeight then
		btmn.x = (btmn.x + (btmn.speedX * dirx) * gSpeed);
		
		if btmn.speedY > 0 then
			btmn.y = (btmn.y + (btmn.speedY * diry) * gSpeed); 
		elseif btmn.speedY < 0 then
			btmn.y = (btmn.y - (btmn.speedY * diry) * gSpeed); 
		end
    
    if (btmn.x < 12) then btmn.x = 12; end
    if (btmn.x + btmn.width + btmn.speedX > (map.width * map.tilewidth)) then 
      btmn.x = (map.width * map.tilewidth) - btmn.width - btmn.speedX;
    end
  
    -- Get btmn Tile Corners
    getBtmnCorners(btmn.x, btmn.y);
  
    if (dirx == 1) then
        if ( collisionMap.data[down][right] == nil and collisionMap.data[up][right] == nil and collisionMap.data[middleY][right] == nil) then
            if (btmn.x + btmn.width) > (window_width / 2) and global.tx > -global.gameWorldWidth then
                global.tx = (global.tx - btmn.speedX * gSpeed);
            end
        else
          btmn.x = ((right-1) * global.tSize) - (btmn.width - offset.x);
        end
    end
    
    if (dirx == -1) then
        if (collisionMap.data[down][left] == nil and collisionMap.data[up][left] == nil and collisionMap.data[middleY][left] == nil) then	
            if (btmn.x + global.tx) < (window_width / 2) and global.tx < 0 then
                global.tx = (global.tx + btmn.speedX * gSpeed);
                
                if (global.tx > 0) then global.tx = 0; end
            end
        else
          btmn.x = (left * global.tSize) + (offset.x - btmn.speedX);
        end
    end
    
    if (diry == 1) then
        if (collisionMap.data[down][left] == nil and collisionMap.data[down][right] == nil and collisionMap.data[down][middleX] == nil) then
        else
          btmn.y = (down * global.tSize) - (btmn.height - offset.y);
          btmn.jumping = false;
          btmn.speedY = 0;
        end
    end
    
    if (diry == -1) then
      if (collisionMap.data[up][left] == nil and collisionMap.data[up][right] == nil) then	   
      else
        global.currentGameSpeed = 1; -- Reset Game Speed If We have a collision
        btmn.y = (up * global.tSize);
        btmn.speedY = -1;
      end
    end 
  else
    if (btmn.dead) then
      if btmn.speedY > 0 then
        btmn.y = (btmn.y + (btmn.speedY * diry) * gSpeed); 
      elseif btmn.speedY < 0 then
        btmn.y = (btmn.y - (btmn.speedY * diry) * gSpeed); 
      end
      
      -- Get btmn Tile Corners
      getBtmnCorners(btmn.x, btmn.y);
      
      if (diry == 1) then
        if (collisionMap.data[down][left] == nil and collisionMap.data[down][right] == nil and collisionMap.data[down][middleX] == nil) then
        else
          btmn.y = (down * global.tSize) - (btmn.height - offset.y);
          btmn.jumping = false;
          btmn.speedY = 0;
        end
      end
      
    end --[[ btmn.dead ]]--
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
  btmn.currentAnim[1]:update(dt);
  
  -- Check to see if the object should be falling
	fall(colmap.layers["Collision Layer"]);
  -- Check if the btmn is colliding with a rope obj
  --checkCollisionWithRope(colmap);
  
  -- btmn Movement Update
  if not btmn.dead and btmn.canMove then
    if not btmn.ducking and not btmn.blocking then
      --[[ Look Up Animation ]]--
      if (love.keyboard.isDown("up")) then      
        if (btmn.currentState == "standingRight" or btmn.currentState == "standingLeft") then
          if (btmn.direction == RIGHT) then
            -- Quickening Animation, we skip the long pause on the first frame
            if (btmn.currentAnim[1].position == 1) then 
              btmn.standRight[1]:gotoFrame(2); 
            end 
          
            if (btmn.currentAnim[1].status == "paused") then
              btmn.standRight[1]:pauseAtStart(); -- Reset standing animation
              btmn.currentState = "lookingUpRight";
              btmn.currentAnim = btmn.lookUpRight;
            end
          elseif (btmn.direction == LEFT) then
            -- Quickening Animation, we skip the long pause on the first frame
            if (btmn.currentAnim[1].position == 1) then 
              btmn.standLeft[1]:gotoFrame(2); 
            end 
          
            if (btmn.currentAnim[1].status == "paused") then
              btmn.standLeft[1]:pauseAtStart(); -- Reset standing animation
              btmn.currentState = "lookingUpLeft";
              btmn.currentAnim = btmn.lookUpLeft;
            end
          end
          
          btmn.currentAnim[1]:resume();
        elseif (btmn.currentState == "lookingUpRight" or btmn.currentState == "lookingUpLeft") then
          -- We've reached look-up frame, stay on it
          if (btmn.currentAnim[1].position >= 2) then
            btmn.currentAnim[1]:gotoFrame(2);
          end
        end
      elseif (not love.keyboard.isDown("up")) then  
        if (btmn.lookUpRight[1].position >= 3 and btmn.currentState == "lookingUpRight" and btmn.lookUpRight[1].status == "paused") then
          btmn.lookUpRight[1]:pauseAtStart() -- Reset lookup animation
          btmn.currentState = "turningRight";
          btmn.currentAnim = btmn.armsUpRight;
          btmn.currentAnim[1]:resume();
        elseif (btmn.lookUpLeft[1].position >= 3 and btmn.currentState == "lookingUpLeft" and btmn.lookUpLeft[1].status == "paused") then
          btmn.lookUpLeft[1]:pauseAtStart() -- Reset lookup animation
          btmn.currentState = "turningLeft";
          btmn.currentAnim = btmn.armsUpLeft;
          btmn.currentAnim[1]:resume();
        end
      end --[[ love.keyboard.isDown("up") / not love.keyboard.isDown("up")) end ]]--
      
      if (love.keyboard.isDown("right")) then 
          btmn.direction = RIGHT;
          collisionOffset.x = 12 * btmn.direction;
          
          if (btmn.currentAnim[1].status == "paused" and btmn.currentState == "walkingRight") then
            btmn.walkRight[1]:gotoFrame(9); --Loop
          end
                 
          if (btmn.oldDirection == LEFT) then
            btmn.standRight[1]:pauseAtStart(); -- Reset standing animation
            btmn.currentState = "turningRight";
            btmn.currentAnim = btmn.turnRight;
          elseif (btmn.turnRight[1].status == "paused" or btmn.turnRight[1].position >= 2 or btmn.currentState == "standingRight" or btmn.currentState == "lookingUpRight") then
            btmn.standRight[1]:pauseAtStart(); -- Reset standing animation
            btmn.lookUpRight[1]:pauseAtStart();
            btmn.turnRight[1]:pauseAtStart(); 
            btmn.currentState = "walkingRight";
            btmn.currentAnim = btmn.walkRight;
          elseif (btmn.direction == RIGHT and btmn.turnLeft[1].status == "playing") then
            btmn.turnLeft[1]:pauseAtStart(); 
            btmn.currentState = "walkingRight";
            btmn.currentAnim = btmn.walkRight;
          end
          
          if (btmn.currentState == "walkingRight") then
            moveBtmn(btmn.direction, 0, colmap.layers["Collision Layer"], gameSpeed); 
          end
          btmn.currentAnim[1]:resume();
      end
    
      if (love.keyboard.isDown("left")) then 
          btmn.direction = LEFT;
          collisionOffset.x = 12 * btmn.direction;
          
          if (btmn.currentAnim[1].status == "paused" and btmn.currentState == "walkingLeft") then
            btmn.walkLeft[1]:gotoFrame(9); --Loop
          end
          
          if (btmn.oldDirection == RIGHT) then
            btmn.standLeft[1]:pauseAtStart(); -- Reset standing animation
            btmn.currentState = "turningLeft";
            btmn.currentAnim = btmn.turnLeft;
          elseif (btmn.turnLeft[1].status == "paused" or btmn.turnLeft[1].position >= 2 or btmn.currentState == "standingLeft" or btmn.currentState == "lookingUpLeft") then
            btmn.standLeft[1]:pauseAtStart(); -- Reset standing animation
            btmn.lookUpLeft[1]:pauseAtStart();
            btmn.turnLeft[1]:pauseAtStart(); 
            btmn.currentState = "walkingLeft";
            btmn.currentAnim = btmn.walkLeft;
          elseif (btmn.direction == LEFT and btmn.turnRight[1].status == "playing") then
            btmn.turnRight[1]:pauseAtStart(); 
            btmn.currentState = "walkingLeft";
            btmn.currentAnim = btmn.walkLeft;
          end
          
          if (btmn.currentState == "walkingLeft") then
            moveBtmn(btmn.direction, 0, colmap.layers["Collision Layer"], gameSpeed); 
          end
          btmn.currentAnim[1]:resume();
      end
      
      if (not love.keyboard.isDown("left") and not love.keyboard.isDown("right")) then 
          if (btmn.currentState == "turningRight" and btmn.currentAnim[1].status == "paused") then
            btmn.turnRight[1]:pauseAtStart(); -- Reset turning animation
            btmn.armsUpRight[1]:pauseAtStart(); -- Reset faster turning animation
            btmn.currentState = "standingRight";
            btmn.currentAnim = btmn.standRight;   
            
          elseif (btmn.currentState == "turningLeft" and btmn.currentAnim[1].status == "paused") then
            btmn.turnLeft[1]:pauseAtStart(); -- Reset turning animation
            btmn.armsUpLeft[1]:pauseAtStart(); -- Reset faster turning animation
            btmn.currentState = "standingLeft";
            btmn.currentAnim = btmn.standLeft;
          
          elseif (btmn.currentState == "standingUpRight" and btmn.currentAnim[1].status == "paused") then
            btmn.upRight[1]:pauseAtStart(); -- Reset standing up animation
            btmn.currentState = "standingRight";
            btmn.currentAnim = btmn.standRight;
            
          elseif (btmn.currentState == "standingUpLeft" and btmn.currentAnim[1].status == "paused") then
            btmn.upLeft[1]:pauseAtStart(); -- Reset standing up animation
            btmn.currentState = "standingLeft";
            btmn.currentAnim = btmn.standLeft;
            
          elseif (btmn.currentState == "walkingRight" or btmn.currentState == "walkingLeft") then
            btmn.walkLeft[1]:pauseAtStart(); -- Reset walking animations
            btmn.walkRight[1]:pauseAtStart();
            
            if (btmn.direction == RIGHT) then
                btmn.currentState = "toStandRight";
                btmn.currentAnim = btmn.toStandRight;
              elseif (btmn.direction == LEFT) then
                btmn.currentState = "toStandLeft";
                btmn.currentAnim = btmn.toStandLeft;
              end
            
          elseif (btmn.currentState == "toStandRight" and btmn.currentAnim[1].status == "paused") then
            btmn.toStandRight[1]:pauseAtStart(); -- Reset to stand animation
            btmn.currentState = "standingRight";
            btmn.currentAnim = btmn.standRight;
            
          elseif (btmn.currentState == "toStandLeft" and btmn.currentAnim[1].status == "paused") then
            btmn.toStandLeft[1]:pauseAtStart(); -- Reset to stand animation
            btmn.currentState = "standingLeft";
            btmn.currentAnim = btmn.standLeft;
            
          elseif (btmn.currentState == "landingJumpRight" and btmn.currentAnim[1].status == "paused") then
            btmn.landingRight[1]:pauseAtStart(); -- Reset landing animation
            btmn.currentState = "standingRight";
            btmn.currentAnim = btmn.standRight;
          
          elseif (btmn.currentState == "landingJumpRight" and btmn.currentAnim[1].status == "paused") then
            btmn.landingLeft[1]:pauseAtStart(); -- Reset landing animation
            btmn.currentState = "standingLeft";
            btmn.currentAnim = btmn.standLeft;
          end
          
          btmn.currentAnim[1]:resume();
      end --[[ not love.keyboard.isDown("left") and not love.keyboard.isDown("right") end ]]--
   
      if (btmn.jumping) then
          jump(colmap.layers["Collision Layer"], gameSpeed);     
          
          if (btmn.currentState == "standingRight") then
            btmn.standRight[1]:pauseAtStart(); -- Reset standing animation
            btmn.currentState = "standingJumpRight";
            btmn.currentAnim = btmn.standJumpRight;
          elseif (btmn.currentState == "standingLeft") then
            btmn.standLeft[1]:pauseAtStart(); -- Reset standing animation
            btmn.currentState = "standingJumpLeft";
            btmn.currentAnim = btmn.standJumpLeft;
          end
          
      elseif (not btmn.jumping) then
        if (btmn.currentState == "standingJumpRight") then
          btmn.standJumpRight[1]:pauseAtStart(); -- Reset standing jump animation
          btmn.currentState = "landingJumpRight";
          btmn.currentAnim = btmn.landingRight;
          btmn.currentAnim[1]:resume();
        elseif (btmn.currentState == "standingJumpLeft") then
          btmn.standJumpLeft[1]:pauseAtStart(); -- Reset standing jump animation
          btmn.currentState = "landingJumpLeft";
          btmn.currentAnim = btmn.landingLeft;
          btmn.currentAnim[1]:resume();
        end
      end --[[ btmn.jumping end ]]--
      
    end  --[[ not btmn.ducking and not btmn.blocking end ]]--
    
    if (love.keyboard.isDown("down")) then
      if (not btmn.ducking) then
        btmn.currentAnim[1]:pauseAtStart(); -- Reset Whatever animation is currently active
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
      
      btmn.currentAnim[1]:resume();
    elseif (not love.keyboard.isDown("down") and btmn.ducking) then     
      -- Fully ducked, stand up animation
      if (btmn.direction == RIGHT) then
        btmn.duckRight[1]:pauseAtStart();
        btmn.currentState = "standingUpRight";       
        btmn.currentAnim = btmn.upRight;
      elseif (btmn.direction == LEFT) then
        btmn.duckLeft[1]:pauseAtStart();
        btmn.currentState = "standingUpLeft";       
        btmn.currentAnim = btmn.upLeft;
      end

      btmn.currentAnim[1]:resume();
      btmn.ducking = false;      
    end
  
    if (love.keyboard.isDown("c") and not btmn.blocking) then
      btmn.blocking = true;
      
      if (btmn.currentState == "standingRight" or btmn.currentState == "standingLeft") then
        -- Quickening Animation, we skip the long pause on the first frame
        if (btmn.currentAnim[1].position <= 3) then 
          if (btmn.direction == RIGHT) then
            btmn.currentState = "blockingRight";
            btmn.currentAnim = btmn.blockRight;
          elseif (btmn.direction == LEFT) then
            btmn.currentState = "blockingLeft";
            btmn.currentAnim = btmn.blockLeft;
          end
        
        else
        
          if (btmn.direction == RIGHT) then
            btmn.standRight[1]:pauseAtStart(); -- Reset standing animation
            btmn.currentState = "turningRight";
            btmn.currentAnim = btmn.armsUpRight;
          elseif (btmn.direction == LEFT) then
            btmn.standLeft[1]:pauseAtStart(); -- Reset standing animation
            btmn.currentState = "turningLeft";
            btmn.currentAnim = btmn.armsUpLeft;
          end
        end
      end    
      
      btmn.currentAnim[1]:resume();
    elseif (love.keyboard.isDown("c") and btmn.blocking) then
      if (btmn.currentState == "turningRight" and btmn.currentAnim[1].status == "paused") then
        btmn.armsUpRight[1]:pauseAtStart(); -- Reset turning animation
        btmn.currentState = "blockingRight";
        btmn.currentAnim = btmn.blockRight;
      elseif (btmn.currentState == "turningLeft" and btmn.currentAnim[1].status == "paused") then
        btmn.armsUpLeft[1]:pauseAtStart(); -- Reset turning animation
        btmn.currentState = "blockingLeft";
        btmn.currentAnim = btmn.blockLeft;
      end
    
      if (btmn.currentState == "blockingRight" or btmn.currentState == "blockingLeft") then
        if (btmn.currentAnim[1].position >= 2) then
          btmn.currentAnim[1]:gotoFrame(2);
        end
      end
    
      btmn.currentAnim[1]:resume();
    end --[[ love.keyboard.isDown("c") and not btmn.blocking end ]]--
  
    if (not love.keyboard.isDown("c")) then
      if (btmn.currentState == "blockingRight" or btmn.currentState == "blockingLeft") then
        if (btmn.currentAnim[1].position >= 4) then
          btmn.currentAnim[1]:pauseAtStart(); -- Reset whatever blocking animation we have
            
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
    
    if (btmn.takenDmg) then
      dmgTimer = dmgTimer + dt;
    
      if (dmgTimer >= 0.1 and dmgTimer <= 0.15 or 
        dmgTimer >= 0.25 and dmgTimer <= 0.3 or
        dmgTimer >= 0.4 and dmgTimer < 0.45) then
        canDraw = true;
      elseif (dmgTimer > 0.5) then
        btmn.takenDmg = false;
        dmgTimer = 0;
        canDraw = true;
      else
        canDraw = false;
      end
    end
    
    if (btmn.health <= 0) then
      btmn.dead = true;
      btmn.speedY = 8;
      btmn.jumping = true;
      btmn.currentAnim[1]:pauseAtStart(); -- Reset current animation
      canDraw = true;
    end --[[ btmn.health < 0 ]]-- 
  end --[[ not btmn.dead and btmn.canMove ]]--
  
  if (btmn.punching) then
    btmn.collisionRect.width = 50;
    
    --Update collision box offset if facing left, right is fine as is
    if (btmn.direction == LEFT) then
      collisionOffset.x = -20;
    end
    
    if (btmn.currentState ~= "punchingRight" and btmn.currentState ~= "punchingLeft") then
      btmn.currentAnim[1]:pauseAtStart(); -- Reset current animation
      
      if (btmn.direction == RIGHT) then
        btmn.currentState = "punchingRight";
        btmn.currentAnim = btmn.punchRight;
      elseif (btmn.direction == LEFT) then
        btmn.currentState = "punchingLeft";
        btmn.currentAnim = btmn.punchLeft;
      end
      
      btmn.currentAnim[1]:resume();
    elseif (btmn.currentState == "punchingRight" or btmn.currentState == "punchingLeft") then
      if (btmn.currentAnim[1].status == "paused") then
        btmn.currentAnim[1]:pauseAtStart(); -- Reset current animation
      
        if (btmn.direction == RIGHT) then
          btmn.currentState = "standingRight";
          btmn.currentAnim = btmn.standRight;
        elseif (btmn.direction == LEFT) then
          btmn.currentState = "standingLeft";
          btmn.currentAnim = btmn.standLeft;
        end
        
        btmn.punching = false;
        btmn.canMove = true;
        btmn.currentAnim[1]:resume();
      end -- [[ btmn.currentAnim[1].status == "paused" ]]--
    end --[[ if/elseif btmn.currentState ~/= "punchingRight" and btmn.currentState ~/= "punchingLeft"  ]]--
  end --[[ btmn.punching ]]--

  if (btmn.throwingBatarang) then   
    if (btmn.currentState ~= "throwingBatarangRight" and btmn.currentState ~= "throwingBatarangLeft") then
      btmn.currentAnim[1]:pauseAtStart(); --Reset whatever animation is currently running
      
      if (btmn.direction == RIGHT) then
        btmn.currentState = "throwingBatarangRight";
        btmn.currentAnim = btmn.throwRight;
      elseif (btmn.direction == LEFT) then
        btmn.currentState = "throwingBatarangLeft";
        btmn.currentAnim = btmn.throwLeft;
      end
      btmn.currentAnim[1]:resume();
    end
    
    if (btmn.currentAnim[1].position == 3 and btmn.activeBatarangs < btmn.maxNumberOfBatarangs) then
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
    end --[[ btmn.currentAnim[1].position == 3 and btmn.activeBatarangs < btmn.maxNumberOfBatarangs end ]]--
  
    if (btmn.currentAnim[1].status == "paused") then
      if (btmn.currentState == "throwingBatarangRight") then
        btmn.throwRight[1]:pauseAtStart(); -- Reset throwing animation
        btmn.currentState = "standingRight";
        btmn.currentAnim = btmn.standRight;  
        
      elseif (btmn.currentState == "throwingBatarangLeft") then
        btmn.throwLeft[1]:pauseAtStart(); -- Reset throwing animation
        btmn.currentState = "standingLeft";
        btmn.currentAnim = btmn.standLeft;
      end  
      
      btmn.canMove = true;
      btmn.throwingBatarang = false;
    end --[[ btmn.currentAnim[1].status == "paused" ]]--
  
  end --[[ btmn.throwingBatarang ]]

  if (btmn.dead) then
    
    if (btmn.jumping) then
      local LEFT_BOUNDARY = 16;
      jump(colmap.layers["Collision Layer"], gameSpeed);  
      btmn.x = btmn.x - (btmn.speedX / 2) * btmn.direction; 
      
      if (btmn.x < LEFT_BOUNDARY) then btmn.x = LEFT_BOUNDARY; end --[[ btmn.x < LEFT_BOUNDARY end; stop player leaving game screen when dying]]--
    end
    
    if (btmn.direction == RIGHT and btmn.currentState ~= "deathJumpingRight" and btmn.currentState ~= "deathLandingRight") then
        btmn.currentState = "deathJumpingRight";
        btmn.currentAnim = btmn.deathJumpRight;   
      elseif (btmn.direction == LEFT and btmn.currentState ~= "deathJumpingLeft" and btmn.currentState ~= "deathLandingLeft") then
        btmn.currentState = "deathJumpingLeft";
        btmn.currentAnim = btmn.deathJumpLeft;
    end
    
    if (btmn.currentState == "deathJumpingRight" or btmn.currentState == "deathJumpingLeft") then
      if (btmn.direction == RIGHT and btmn.currentAnim[1].status == "paused") then
        btmn.currentState = "deathLandingRight";
        btmn.currentAnim = btmn.deathLandRight;
      elseif (btmn.direction == LEFT and btmn.currentAnim[1].status == "paused") then
        btmn.currentState = "deathLandingLeft";
        btmn.currentAnim = btmn.deathLandLeft;
      end
    end
  end --[[ btmn.dead end ]]--
  
  --  btmn Collision Update
--[[  
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
  ]]--
  
  -- Update Collision Rectangle
  btmn.collisionRect.x = (btmn.x + global.offsetX) + global.tx + collisionOffset.x + renderOffset.x;
  btmn.collisionRect.y = (btmn.y + global.offsetY) + global.ty + collisionOffset.y + renderOffset.y;
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
      if (batarang.x - BATARANG_SPD + batarang.width > enemy.x) 
        and (batarang.x  - BATARANG_SPD + global.tx < enemy.x + enemy.width) 
        and (batarang.y + batarang.height > enemy.y) 
        and (batarang.y + global.ty < enemy.y + enemy.height and enemy.state ~= "knockout") then
          enemy.health = enemy.health - BATARANG_DMG;
          enemy.takenDmg = true;
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
-- Check Collision
function btmn:checkCollisionWth( enemy )
  local PUNCH_DMG = 25;
  
  -- If punching
  if (btmn.punching) then
    if (boxCollision(enemy.x + global.tx, enemy.y + global.ty, enemy.width, enemy.height) 
      and enemy.state ~= "knockout" and not enemy.hit) then
          enemy.health = enemy.health - PUNCH_DMG;
          global.targetedEnemy = enemy;
          enemy.hit = true;
          enemy.takenDmg = true;
      end
  elseif (not btmn.punching) then
    if (enemy.hit) then
      enemy.hit = not enemy.hit; -- We've already hit the enemy, can't hit him twice.
    end
  end --[[ btmn.punching / not btmn.punching ]]--
  
end
--[[ Function ]]--
-- Draw
function btmn:draw()
  -- Default Offsets
  local currentXOffset = 10;
  local currentYOffset = 12;
  
  -- Decide if we should change them
  if (btmn.currentState == "walkingLeft" or btmn.currentState == "toStandLeft" or 
    btmn.currentState == "duckingRight" or btmn.currentState == "duckingLeft" or 
    btmn.currentState == "standingUpRight" or btmn.currentState == "standingUpLeft" or
    btmn.currentState == "throwingBatarangRight" or btmn.currentState == "throwingBatarangLeft" or
    btmn.currentState == "standingJumpRight" or btmn.currentState == "standingJumpLeft") then
    currentXOffset = 15;
  elseif (btmn.currentState == "walkingRight" or btmn.currentState == "toStandRight" or
    btmn.currentState == "deathJumpingRight" or btmn.currentState == "deathJumpingLeft" or
    btmn.currentState == "deathLandingRight" or btmn.currentState == "deathLandingLeft") then
    currentXOffset = 25;
  elseif (btmn.currentState == "landingJumpRight" or btmn.currentState == "landingJumpLeft") then
    if (btmn.currentAnim[1].position == 3) then 
      currentXOffset = 22;
    else
      currentXOffset = 25;
    end
  elseif (btmn.currentState == "punchingRight" or btmn.currentState == "punchingLeft") then
    if (btmn.currentAnim[1].position <=  3 or btmn.currentAnim[1].position >= 6) then
      currentXOffset = 15;
    else
      if (btmn.direction == RIGHT) then
        currentXOffset = 5;
      elseif (btmn.direction == LEFT) then
        currentXOffset = 25;
      end
    end
  end
  
	-- Draw btmn 
	local renderX = btmn.x + global.tx + global.offsetX - currentXOffset + renderOffset.x;
	local renderY = btmn.y + global.ty + global.offsetY + currentYOffset + renderOffset.y;
	
	if (canDraw) then
		btmn.currentAnim[1]:draw(btmn.currentAnim.img, 
			renderX, 
			renderY);
	end
  
	-- Draw Player Debug
	if (btmn.drawDebug) then 
		love.graphics.setColor(yellow);
		love.graphics.rectangle("line", btmn.collisionRect.x, btmn.collisionRect.y, btmn.collisionRect.width, btmn.collisionRect.height);  
		love.graphics.reset();
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
end

--[[ Function ]]--
-- Key pressed
function btmn:keypressed( key, unicode )
  if btmn.convoActive then
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
  
  if not btmn.dead then
    if (key == " ") and not btmn.jumping then
      btmn.jumping = true;
      btmn.speedY = 8;
    end
    
    -- Throw Batarang(s)!
    if (key == "q" and not btmn.jumping and not btmn.blocking and not btmn.ducking and not btmn.throwingBatarang and btmn.activeBatarangs < btmn.maxNumberOfBatarangs) then
      btmn.canMove = false;
      btmn.throwingBatarang = true;
    end
    
    -- PUNCH (POW)!
    if (key == "x" and not btmn.jumping and not btmn.blocking and not btmn.ducking and not btmn.throwingBatarang) then
      btmn.canMove = false;
      btmn.punching = true;
    end
  end
end

return btmn;

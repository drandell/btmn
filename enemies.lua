--[[
 -- Enemy base class
 -- Mainly for thugs & the like, generic enemies behaviour 
 -- Started at roughly 10pm, April 14th 2014
 -- Dan
]]--
require("./Libraries/class");
math.randomseed(os.time());

local LEFT = -1;
local RIGHT = 1;

-- Global table of enemies that will contain enemies per scene
enemies = {}

--[[ Function ]]--
-- Enemy base class
enemy = class( function( enemy,x,y,width,height,speedX, typeOf, state, nxtState, msg, offsetX, offsetY )
              enemy.x = x;
              enemy.y = y;
              enemy.width = width;
              enemy.height = height;
              enemy.speedX = speedX;
              enemy.direction = -1;
              enemy.health = 100;
              enemy.alive = true;
              enemy.hit = false;
              enemy.canDraw = true;
              enemy.takenDmg = false;
              enemy.dmgTimer = 0;
              enemy.typeOf = typeOf;
              enemy.img = nil;
              enemy.animations = {};
              enemy.currentAnimation = nil;
              enemy.state = state;
              enemy.nxtState = nxtState;
              enemy.message = msg;
              enemy.dly = 500;
              enemy.oldDly = 500;
              enemy.punchDly = math.random(500, 1050);
              enemy.alpha = 255;
              enemy.offset = {x = offsetX, y = offsetY};
              enemy.collisionRect = {
                x = (x + offsetX) - global.tx;
                y = (y + offsetY) - global.ty;
                width = width;
                height = height;
              };
           end);
         

--[[ Function ]]--
-- Enemy update
function enemy:update( dt, colmap, gameSpeed )
  gameSpeed = gameSpeed or 1;
  -- TODO: Each enemy should have an individual range, but generic thugs 
  -- Will probably all have the same 
  local RANGE = 250;
  local FIGHT_DISTANCE = 10;
  local PUNCH_DMG = 5;
  
  if (self.state == "idle") then
    -- Enemy is standing around
    if (self.x > btmn.x and btmn.x + btmn.width + RANGE > self.x or
        self.x < btmn.x and btmn.x - RANGE < self.x) then
      if (self.nxtState ~= nil) then
        self.state = self.nxtState;
        self.nxtState = "actioned";
      else
        self.state = "actioned";
      end
    end
  
  elseif (self.state == "speak") then
    -- Enemy has something to say
    --global.currentGameSpeed = 0; -- STOP THE PRESS!
    local delta = (love.timer.getAverageDelta() * 1000);
    self.dly = self.dly - delta;
    
    -- Either a) have a timer delay and then re-begin action automatically
    -- or b) let player press button to resume action.
    -- future; What if the enemy has a LOT to say?
    if (self.dly < 0) then
      --global.currentGameSpeed = 1;
      self.alpha = self.alpha - 10;
      
      if (self.alpha < 0) then
        self.state = "actioned";
        self.dly = self.oldDly;
      end
    end
    
  elseif (self.state == "patrol") then
    -- Patrol area
  elseif (self.state == "actioned") then
    -- Enemies is actioned, ready to fight
    if (self.x > btmn.x and btmn.x + btmn.width + FIGHT_DISTANCE < self.x) then
      self.x = self.x - self.speedX;
    elseif (self.x < btmn.x and btmn.x - FIGHT_DISTANCE > self.x + self.width) then
      self.x = self.x + self.speedX;
    else
      self.state = "punch"; 
      -- future; how do we decide what action to take in terms of attacking the player? 
    end
      
  elseif (self.state == "punch") then
    -- Fighting BTMN
    local delta = (love.timer.getAverageDelta() * 1000);
    self.punchDly = self.punchDly - delta;
	
	if (not btmn.takenDmg) then
		if (self.punchDly < 0 and self.x > btmn.x and btmn.x + btmn.width + FIGHT_DISTANCE <= self.x + (self.width / 2)) then
			btmn.health = btmn.health - PUNCH_DMG;
			self.punchDly = math.random(750, 1050);
			btmn.takenDmg = true;
		elseif (self.punchDly < 0 and self.x < btmn.x and btmn.x + btmn.width - FIGHT_DISTANCE >= self.x + (self.width / 2)) then
			btmn.health = btmn.health - PUNCH_DMG;
			self.punchDly = math.random(750, 1050);
			btmn.takenDmg = true;
		elseif (btmn.x + btmn.width + FIGHT_DISTANCE < self.x and btmn.direction ~= RIGHT) then
			-- BTMN has moved out of range, so re-chase him down!
			self.dly = self.dly - delta;
      
			if (self.dly < 0) then
				self.state = "actioned"
				self.punchDly = math.random(750, 1050);
				self.dly = self.oldDly;
			end
		elseif (self.x + self.width + FIGHT_DISTANCE < btmn.x and btmn.direction ~= LEFT) then
			-- BTMN has moved out of range, so re-chase him down!
			self.dly = self.dly - delta;
      
			if (self.dly < 0) then
				self.state = "actioned"
				self.punchDly = math.random(500, 1050);
				self.dly = self.oldDly;
			end
		end  
    end
    
  elseif (self.state == "kick") then
    -- Fighting BTMN
  elseif (self.state == "stunned") then
    --Enemy has been stunned
  elseif (self.state == "knockout") then
    -- Enemy has been defeated
  end
  
  if (self.takenDmg) then
      self.dmgTimer = self.dmgTimer + dt;
    
      if (self.dmgTimer >= 0.1 and self.dmgTimer <= 0.15 or 
        self.dmgTimer >= 0.25 and self.dmgTimer <= 0.3) then
        self.canDraw = true;
      elseif (self.dmgTimer > 0.3) then
        self.takenDmg = false;
        self.dmgTimer = 0;
        self.canDraw = true;
      else
        self.canDraw = false;
      end
  end
  
  -- Update Collision Rectangle
  self.collisionRect.x = (self.x + self.offset.x) + global.offsetX + global.tx;
  self.collisionRect.y = (self.y - self.offset.y) + global.offsetY + global.ty;
end
--[[ Function ]]--
-- Enemy status
function enemy:updateStatus(index)
  -- TODO: Add Death Animation finished
  if (self.health <= 0) then
    self.state = "knockout";
  end
end
--[[ Function ]]--
-- Enemy draw
function enemy:draw()
  if (self.state ~= "speak") then 
    if (self.x + self.width + global.tx > 0 and self.canDraw) then 
      love.graphics.draw(self.img, 
        self.x + global.tx + global.offsetX, 
        self.y + global.offsetY + global.ty, 
        0, 
        1, 
        1);
      
      -- Debug; Draw State Text
      love.graphics.setColor(255, 255, 255, 255); 
      love.graphics.print(
        "State: " .. self.state, 
        self.x - 16 + global.tx + global.offsetX, 
        self.y - 16 + global.offsetY +  global.ty
      );
    end
  else
    love.graphics.draw(self.img, 
        self.x + global.tx + global.offsetX, 
        self.y + global.offsetY + global.ty, 
        0, 
        1, 
        1);
    
    love.graphics.setColor(255, 255, 255, self.alpha); 
    -- TODO: Edit this properly later to show the message
    local numOfLines = (love.graphics.getFont():getWidth(self.message) / 100);
    local heightOffset = (love.graphics.getFont():getHeight(self.message) * (numOfLines + 1));
    love.graphics.print(
        "State: " .. self.state, 
        self.x - 18 + global.tx + global.offsetX, 
        self.y - 16 - heightOffset + global.offsetY +  global.ty
      );
    love.graphics.printf(
        "" .. self.message, 
        self.x - 18 + global.tx + global.offsetX, 
        self.y - heightOffset + global.offsetY +  global.ty, 100, "left"
    );
    love.graphics.reset();
  end
end
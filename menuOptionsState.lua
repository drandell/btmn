--[[
 -- Menu options state
 -- Handles game options available in main menu
 -- Made Afternoon, April 23rd 2014
 -- Dan
]]--

menuOptionsState = {}
menuOptionsState.logo = nil;
menuOptionsState.logoPos = { x = 0, y = 0 };
menuOptionsState.options = { 
  {text = "Master BG Volume:", xOffset = 60, implemented = true, gotoState = "nil"}, 
  {text = "Master Sound Effect Volume:", xOffset = 60, implemented = true, gotoState = "nil"},
  {text = "Back", xOffset = 0, implemented = true, gotoState = "menu"},
};
menuOptionsState.currentSelectedOption = 1;
menuOptionsState.numberOfOptions = #menuOptionsState.options;
menuOptionsState.canChoose = false;

-- New
function menuOptionsState:new()
   local gs = {}

   gs = setmetatable(gs, self)
   self.__index = self
   _gs = gs
   
   return gs
end

-- Load
function menuOptionsState:load()
  -- Load Logo
  menuOptionsState.logo = menuState.logo;
  menuOptionsState.logoPos = {x = (global.viewportWidth - menuOptionsState.logo:getWidth()) / 2, y = 30 };
end

-- Close
function menuOptionsState:close()
end

-- Enable
function menuOptionsState:enable()
end

-- Disable
function menuOptionsState:disable()
end

-- Update
function menuOptionsState:update( dt )
  -- Options Selection
  if (menuOptionsState.currentSelectedOption > menuOptionsState.numberOfOptions) then
    menuOptionsState.currentSelectedOption = 1;
  elseif (menuOptionsState.currentSelectedOption < 1) then
    menuOptionsState.currentSelectedOption = menuOptionsState.numberOfOptions;
  end
end

-- Draw
function menuOptionsState:draw()
  love.graphics.clear();
  
  love.graphics.setColor(yellow);
  love.graphics.draw(menuState.logo, menuState.logoPos.x, menuState.logoPos.y);
  love.graphics.setBackgroundColor(black);
  
  -- Locals, to justify Y coord of menu text
  local startY = 300;
  local yIncrement = 20;
  
  for i = 1, menuOptionsState.numberOfOptions do
 
    if (menuOptionsState.options[i].implemented) then 
      
      if (i ~= menuOptionsState.currentSelectedOption) then
        love.graphics.setColor(white); 
      else
        love.graphics.setColor(yellow); 
      end
      local textWidthInPixels = love.graphics.getFont():getWidth(menuOptionsState.options[i].text);
      love.graphics.print(
        menuOptionsState.options[i].text, 
        menuOptionsState.logoPos.x + (menuOptionsState.logo:getWidth() / 2) - (textWidthInPixels / 2) - menuOptionsState.options[i].xOffset, 
        startY + (i * yIncrement)
        );
    else 
      love.graphics.setColor(red); 
      local textWidthInPixels = love.graphics.getFont():getWidth(menuOptionsState.options[i].text .. " (Not Implemented)");
      love.graphics.print(
        menuOptionsState.options[i].text .. " (Not Implemented)", 
        menuOptionsState.logoPos.x + (menuOptionsState.logo:getWidth() / 2) - (textWidthInPixels / 2) - menuOptionsState.options[i].xOffset, 
        startY + (i * yIncrement)
        );
    end
  end
  
  for j = 0, 9 do
    if (menuOptionsState.currentSelectedOption == 1 and j < (global.bgVolume * 10)) then
      love.graphics.setColor(yellow);
    elseif (j < (global.bgVolume * 10)) then
      love.graphics.setColor(red);
    else
      love.graphics.setColor(white);
    end
    
    local textWidthInPixels = love.graphics.getFont():getWidth(menuOptionsState.options[1].text);
    love.graphics.rectangle("fill", 
      menuOptionsState.logoPos.x + (menuOptionsState.logo:getWidth() / 2) + (textWidthInPixels / 2) - menuOptionsState.options[1].xOffset + 6 + j*10 + (j*2), 
      startY + yIncrement + 3, 10, 10); 
  end
  
  for k = 0, 9 do
    if (menuOptionsState.currentSelectedOption == 2 and k < (global.sfxVolume * 10)) then
      love.graphics.setColor(yellow);
    elseif (k < (global.sfxVolume * 10)) then
      love.graphics.setColor(red);
    else
      love.graphics.setColor(white);
    end
    
    local textWidthInPixels = love.graphics.getFont():getWidth(menuOptionsState.options[2].text);
    love.graphics.rectangle("fill", 
      menuOptionsState.logoPos.x + (menuOptionsState.logo:getWidth() / 2) + (textWidthInPixels / 2) - menuOptionsState.options[2].xOffset + 6 + k*10 + (k*2), 
      startY + (yIncrement * 2) + 3, 10, 10); 
  end
end

-- KeyPressed
function menuOptionsState:keypressed( key, unicode )
  if (key == "up") then 
    if (menuOptionsState.options[menuOptionsState.currentSelectedOption-1] ~= nil) then
      if (menuOptionsState.options[menuOptionsState.currentSelectedOption-1].implemented) then
        menuOptionsState.currentSelectedOption = menuOptionsState.currentSelectedOption - 1; 
      end
    end
  elseif (key == "down") then
    if (menuOptionsState.options[menuOptionsState.currentSelectedOption+1] ~= nil) then
      if (menuOptionsState.options[menuOptionsState.currentSelectedOption+1].implemented) then
        menuOptionsState.currentSelectedOption = menuOptionsState.currentSelectedOption + 1; 
      end
    end
  end
  
  if (key == "return") and menuOptionsState.currentSelectedOption == #menuOptionsState.options and
    menuOptionsState.canChoose then
    if (menuOptionsState.options[menuOptionsState.currentSelectedOption].implemented) and
      menuOptionsState.options[menuOptionsState.currentSelectedOption].gotoState ~= "nil" then
      disableState("menuOptions");
      menuOptionsState.canChoose = false;
      enableState(menuOptionsState.options[menuOptionsState.currentSelectedOption].gotoState);
    end
  end
  
  -- Specific menu options
  if (menuOptionsState.currentSelectedOption == 1 and global.bgVolume >= 0 and global.bgVolume <= 1) then
      if (key == "left") then global.bgVolume = global.bgVolume - 0.1; 
      elseif (key == "right") then global.bgVolume = global.bgVolume + 0.1;
    end
    if (global.bgVolume < 0) then global.bgVolume = 0; end
    if (global.bgVolume > 1) then global.bgVolume = 1; end
    
  elseif (menuOptionsState.currentSelectedOption == 2 and global.sfxVolume >= 0 and global.sfxVolume <= 1) then
      if (key == "left") then global.sfxVolume = global.sfxVolume - 0.1; 
      elseif (key == "right") then global.sfxVolume = global.sfxVolume + 0.1;
    end
    if (global.sfxVolume < 0) then global.sfxVolume = 0; end
    if (global.sfxVolume > 1) then global.sfxVolume = 1; end
    
  end
end

-- KeyReleased
function menuOptionsState:keyreleased( key, unicode )
  if (key == "return") then
    menuOptionsState.canChoose = true;
  end
end

-- MousePressed
function menuOptionsState:mousepressed( x, y, button )
end

-- MouseReleased
function menuOptionsState:mousereleased( x, y, button )
end

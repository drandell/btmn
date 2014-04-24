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
  {text = "Master BG Volume", implemented = false, gotoState = "nil"}, 
  {text = "Master Sound Effect Volume:", implemented = false, gotoState = "nil"},
  {text = "Back", implemented = true, gotoState = "menu"},
};
menuOptionsState.currentSelectedOption = 3;
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
  
  love.graphics.setBackgroundColor(white);
  love.graphics.draw(menuOptionsState.logo, menuOptionsState.logoPos.x, menuOptionsState.logoPos.y);
  
  for i = 1, menuOptionsState.numberOfOptions do
    -- Locals, to justify Y coord of menu text
    local startY = 300;
    local yIncrement = 20;
    
    if (menuOptionsState.options[i].implemented) then 
      
      if (i ~= menuOptionsState.currentSelectedOption) then
        love.graphics.setColor(black); 
      else
        love.graphics.setColor(green); 
      end
      local textWidthInPixels = love.graphics.getFont():getWidth(menuOptionsState.options[i].text);
      love.graphics.print(
        menuOptionsState.options[i].text, 
        menuOptionsState.logoPos.x + (menuOptionsState.logo:getWidth() / 2) - (textWidthInPixels / 2), 
        startY + (i * yIncrement)
        );
    else 
      love.graphics.setColor(red); 
      local textWidthInPixels = love.graphics.getFont():getWidth(menuOptionsState.options[i].text .. " (Not Implemented)");
      love.graphics.print(
        menuOptionsState.options[i].text .. " (Not Implemented)", 
        menuOptionsState.logoPos.x + (menuOptionsState.logo:getWidth() / 2) - (textWidthInPixels / 2), 
        startY + (i * yIncrement)
        );
    end
  end

end

-- KeyPressed
function menuOptionsState:keypressed( key, unicode )
  if (key == "up") then 
    if (menuOptionsState.options[menuOptionsState.currentSelectedOption+1] ~= nil) then
      if (menuOptionsState.options[menuOptionsState.currentSelectedOption+1].implemented) then
        menuOptionsState.currentSelectedOption = menuOptionsState.currentSelectedOption + 1; 
      end
    end
  elseif (key == "down") then
    if (menuOptionsState.options[menuOptionsState.currentSelectedOption-1] ~= nil) then
      if (menuOptionsState.options[menuOptionsState.currentSelectedOption-1].implemented) then
        menuOptionsState.currentSelectedOption = menuOptionsState.currentSelectedOption - 1; 
      end
    end
  end
  
  if (key == "return") and menuOptionsState.currentSelectedOption == #menuOptionsState.options and
    menuOptionsState.canChoose then
    if (menuOptionsState.options[menuOptionsState.currentSelectedOption].implemented) then
      disableState("menuOptions");
      menuOptionsState.canChoose = false;
      enableState(menuOptionsState.options[menuOptionsState.currentSelectedOption].gotoState);
    end
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

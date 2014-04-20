menuState = {}
menuState.logo = nil;
menuState.logoPos = { x = 0, y = 0 };
menuState.options = { 
  {text = "Play Episode #1", implemented = true, gotoState = "sceneOne"}, 
  {text = "Options", implemented = false, gotoState = "options"} 
};
menuState.currentSelectedOption = 1;
menuState.numberOfOptions = 2;

-- New
function menuState:new()
   local gs = {}

   gs = setmetatable(gs, self)
   self.__index = self
   _gs = gs
   
   return gs
end

-- Load
function menuState:load()
  -- Load Logo
  menuState.logo = love.graphics.newImage("Content/Images/logo.png");
  menuState.logoPos = {x = (global.viewportWidth - menuState.logo:getWidth()) / 2, y = 30 };
end

-- Close
function menuState:close()
end

-- Enable
function menuState:enable()
end

-- Disable
function menuState:disable()
end

-- Update
function menuState:update(dt)
  -- Options Selection
  if (menuState.currentSelectedOption > menuState.numberOfOptions) then
    menuState.currentSelectedOption = 1;
  elseif (menuState.currentSelectedOption < 1) then
    menuState.currentSelectedOption = menuState.numberOfOptions;
  end
end

-- Draw
function menuState:draw()
  love.graphics.clear();
  
  love.graphics.setBackgroundColor(white);
  love.graphics.draw(menuState.logo, menuState.logoPos.x, menuState.logoPos.y);
  
  for i = 1, menuState.numberOfOptions do
    -- Locals, to justify Y coord of menu text
    local startY = 330;
    local yIncrement = 20;
    
    if (menuState.options[i].implemented) then 
      
      if (i ~= menuState.currentSelectedOption) then
        love.graphics.setColor(white); 
      else
        love.graphics.setColor(green); 
      end
      local textWidthInPixels = love.graphics.getFont():getWidth(menuState.options[i].text);
      love.graphics.print(
        menuState.options[i].text, 
        menuState.logoPos.x + (menuState.logo:getWidth() / 2) - (textWidthInPixels / 2), 
        startY + (i * yIncrement)
        );
    else 
      love.graphics.setColor(red); 
      local textWidthInPixels = love.graphics.getFont():getWidth(menuState.options[i].text .. " (Not Implemented)");
      love.graphics.print(
        menuState.options[i].text .. " (Not Implemented)", 
        menuState.logoPos.x + (menuState.logo:getWidth() / 2) - (textWidthInPixels / 2), 
        startY + (i * yIncrement)
        );
    end
  end

end

-- KeyPressed
function menuState:keypressed(key, unicode)
  if (key == "up") then 
    if (menuState.options[menuState.currentSelectedOption+1] ~= nil) then
      if (menuState.options[menuState.currentSelectedOption+1].implemented) then
        menuState.currentSelectedOption = menuState.currentSelectedOption + 1; 
      end
    end
  elseif (key == "down") then
    if (menuState.options[menuState.currentSelectedOption-1] ~= nil) then
      if (menuState.options[menuState.currentSelectedOption-1].implemented) then
        menuState.currentSelectedOption = menuState.currentSelectedOption - 1; 
      end
    end
  end
  
  if (key == "return") then
    if (menuState.options[menuState.currentSelectedOption].implemented) then
      disableState("menu");
      enableState(menuState.options[menuState.currentSelectedOption].gotoState);
    end
  end
end

-- KeyReleased
function menuState:keyreleased(key, unicode)
end

-- MousePressed
function menuState:mousepressed(x, y, button)
end

-- MouseReleased
function menuState:mousereleased(x, y, button)
end

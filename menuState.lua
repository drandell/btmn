menuState = {}
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
  
  for i = 1, menuState.numberOfOptions do
    if (menuState.options[i].implemented) then 
      
      if (i ~= menuState.currentSelectedOption) then
        love.graphics.setColor(255, 255, 255, 255); 
      else
        love.graphics.setColor(255, 255, 0, 255); 
      end
      love.graphics.printf(menuState.options[i].text, 310, 330 + (i * 20), 120, nil);
    else 
      love.graphics.setColor(255, 0, 0, 255); 
      love.graphics.printf(menuState.options[i].text .. " (Not Implemented)", 310, 330 + (i * 20), 400, nil);
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

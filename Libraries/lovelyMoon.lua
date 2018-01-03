--[[ 
 -- LövelyMoon stateManager - slight tweaks by myself purely for my own clarity. 
 -- Made by Davidobot
--]]
lovelyMoon = {}

function lovelyMoon.update(dt)
   for index, state in pairs(stateManager.states) do
      if state and state._enabled and state.update then
         local newState = state:update(dt)
         if newState then
            if state.close then
               state:close()
            end

            state = newState

            if state.load then
               state:load()
            end
         end
      end
   end
end

function lovelyMoon.draw()
   for index, state in pairs(stateManager.states) do
      if state and state._enabled and state.draw then
         state:draw()
      end
   end
end

function lovelyMoon.keypressed(key, unicode)
   for index, state in pairs(stateManager.states) do
      if state and state._enabled and state.keypressed then
         state:keypressed(key, unicode)
      end
   end
end

function lovelyMoon.keyreleased(key, unicode)
   for index, state in pairs(stateManager.states) do
      if state and state._enabled and state.keyreleased then
         state:keyreleased(key, unicode)
      end
   end
end

function lovelyMoon.mousepressed(x, y, button)
   for index, state in pairs(stateManager.states) do
      if state and state._enabled and state.mousepressed then
         state:mousepressed(x,y,button)
      end
   end
end

function lovelyMoon.mousereleased(x, y, button)
   for index, state in pairs(stateManager.states) do
      if state and state._enabled and state.mousereleased then
         state:mousereleased(x,y,button)
      end
   end
end

function lovelyMoon.mousemoved(x, y, dx, dy, istouch) 
   for index, state in pairs(stateManager.states) do
      if state and state._enabled and state.mousemoved then
         state:mousemoved(x, y, dx, dy, istouch) 
      end
   end
end

function lovelyMoon.wheelmoved(x, y)
   for index, state in pairs(stateManager.states) do
      if state and state._enabled and state.wheelmoved then
         state:wheelmoved(x,y)
      end
   end
end

function lovelyMoon.touchpressed(id, x, y, dx, dy, pressure)
	for index, state in pairs(stateManager.states) do
      if state and state._enabled and state.touchpressed then
         state:touchpressed(id,x,y,dx,dy,pressure)
      end
   end
end

function lovelyMoon.touchreleased(id, x, y, dx, dy, pressure)
	for index, state in pairs(stateManager.states) do
      if state and state._enabled and state.touchpressed then
         state:touchreleased(id,x,y,dx,dy,pressure)
      end
   end
end

function lovelyMoon.textinput(t)
	for index, state in pairs(stateManager.states) do
      if state and state._enabled and state.textinput then
         state:textinput(t)
      end
   end
end
menuState = {}

--New
function menuState:new()
   local gs = {}

   gs = setmetatable(gs, self)
   self.__index = self
   _gs = gs
   
   return gs
end

--Load
function menuState:load()
end

--Close
function menuState:close()
end

--Enable
function menuState:enable()
end

--Disable
function menuState:disable()
end

--Update
function menuState:update(dt)
end

--Draw
function menuState:draw()
end

--KeyPressed
function menuState:keypressed(key, unicode)
end

--KeyReleased
function menuState:keyreleased(key, unicode)
end

--MousePressed
function menuState:mousepressed(x, y, button)
end

--MouseReleased
function menuState:mousereleased(x, y, button)
end

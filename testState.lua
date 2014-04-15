testState = {}
storyBoardOne = storyFader;

--New
function testState:new()
   local gs = {}

   gs = setmetatable(gs, self)
   self.__index = self
   _gs = gs
   
   return gs
end

--Load
function testState:load()
  storyBoardOne:addImageEntry(love.graphics.newImage("/Content/Images/zelda.png"), 
    love.graphics.newQuad(0, 0, 100, 100, 502, 445), 2, 200, 200 );
  storyBoardOne:addTextEntry("A long, long time ago", 8, 180, 320, {255, 255, 255} );
end

--Close
function testState:close()
end

--Enable
function testState:enable()
end

--Disable
function testState:disable()
end

--Update
function testState:update(dt)
  storyBoardOne:update(dt);
end

--Draw
function testState:draw()
    storyBoardOne:draw();
end

--KeyPressed
function testState:keypressed(key, unicode)
end

--KeyReleased
function testState:keyreleased(key, unicode)
end

--MousePressed
function testState:mousepressed(x, y, button)
end

--MouseReleased
function testState:mousereleased(x, y, button)
end
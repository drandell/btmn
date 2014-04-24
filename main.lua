--[[
 -- Main lua file
 -- Created in a galaxy far, far away.. in 2014
 -- Dan
]]--

-- Libraries
require("./Libraries/stateManager");
require("./Libraries/lovelyMoon");
require("./Libraries/colors");
require("./storyFader");
require("./mapObjects");

-- Advanced Tiled Loader Library
loader = require("./Libraries/AdvTiledLoader/Loader");
loader.path = "Content/Maps/";

-- Anim 8 by Enrique García Cota
anim8 = require("./Libraries/anim8");

-- Global vars
global = {};
global.tx = 0;                   -- X translation of the screen
global.ty = 0;                   -- Y translation of the screen
global.scale = 1;                -- Scale of the screen
global.tSize = 32;               -- Tile Size
global.offsetX = 40;             -- Viewport Offset X
global.offsetY = 40;             -- Viewport Offset Y
global.viewportWidth = width;    -- Actual Window Width
global.viewportHeight = height;  -- Actual Window Height
global.gameWorldWidth = 640;     -- Game World Width Viewport
global.gameWorldHeight = 320;    -- Game World Height Viewport
global.currentGameSpeed = 1;     -- Game World Speed 

-- Btmn
btmn = require "btmn";

-- States
require("debugState");
--require("testState");
require("menuState");
require("menuOptionsState");
require("sceneOne");
require("jkr");

-- Testing creation of Jkr villain
--jkr = jkrVillian:create();

-- Load
function love.load( arg )
    -- ZeroBrane Debug requirement
    if arg[#arg] == "-debug" then require("mobdebug").start(); end
    
    -- Set Window Icon
    icon = love.graphics.newImage("Content/Images/icon.png");
    success = love.window.setIcon( icon:getData() );
  
    -- States
    addState(menuState, "menu");
    addState(menuOptionsState, "menuOptions");
    --addState(testState, "test");
    addState(sceneOne, "sceneOne");
    addState(debugState, "debug");
   
    -- Enable States
    enableState("menu");
    --enableState("sceneOne");
    --enableState("test");
    
    ----------------------------------------------
    -- Debug
    btmn.x = 0;
    btmn.y = 0;
    global.tx = 0;
   
    -- Load Global Resources such as Fonts
    gameFont = love.graphics.newFont("/Content/MunroSmall.ttf", 14);
end
-- Update
function love.update( dt )
   lovelyMoon.update(dt);
   
   if (love.keyboard.isDown("escape")) then os.exit(0); end
end
-- Draw
function love.draw()    
    lovelyMoon.draw();
end
-- Key pressed
function love.keypressed( key, unicode )
   lovelyMoon.keypressed(key, unicode);
   
   -- Enable Debug Drawing
   if (key == "f1") and getActiveStates()[1] == "sceneOne" then 
     toggleState("debug"); 
     btmn.drawDebug = not btmn.drawDebug; 
   end
end
-- Key released
function love.keyreleased( key, unicode )
   lovelyMoon.keyreleased(key, unicode);
end
-- Mouse pressed
function love.mousepressed( x, y, button )
   lovelyMoon.mousepressed(x, y, button);
end
-- Mouse released
function love.mousereleased( x, y, button )
   lovelyMoon.mousereleased(x, y, button);
end

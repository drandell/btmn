--[[
 -- Main File
 -- Dan
]]--

-- Libraries
require("stateManager");
require("lovelyMoon");
require("storyFader");

-- Advanced Tiled Loader Library
loader = require "./AdvTiledLoader/Loader";
loader.path = "Content/Maps/";

-- Anim 8 by Enrique García Cota
anim8 = require "anim8";

-- Global Scroll Position & Scale of Map Rendering
global = {};
global.tx = 0;                   -- X translation of the screen
global.ty = 0;                   -- Y translation of the screen
global.scale = 1;                -- Scale of the screen
global.tSize = 32;               -- Tile Size
global.offsetX = 40;
global.offsetY = 40;
global.gameWorldWidth = 640;
global.gameWorldHeight = 320;
global.currentGameSpeed = 1;     -- Game World Speed (For Slow-mo!)

-- Player
playerObj = require "player";

-- States
require("debugState");
--require("testState");
require("menuState");
require("stageOne");
require("joker");

joker = jokerVillian:create();

function love.load( arg )
    if arg[#arg] == "-debug" then require("mobdebug").start(); end
  
    --States
    addState(menuState, "menu");
    --addState(testState, "test");
    addState(stageOne, "stageOne");
    addState(debugState, "debug");
   
    -- Enable States
    --enableState("menu");
    enableState("stageOne");
    --enableState("test");
    
    ----------------------------------------------
    -- Debug
    playerObj.x = 0;
    playerObj.y = 0;
    global.tx = 0;
   
    -- Load Global Resources such as Fonts
    gameFont = love.graphics.newFont("/Content/MunroSmall.ttf", 14);
    --testFont = love.graphics.newFont("/Content/AlmendraSC-Regular.otf", 14);
end

function love.update(dt)
   lovelyMoon.update(dt);
   
   if (love.keyboard.isDown("escape")) then os.exit(0); end
   
   --[[ Debug
   if (love.keyboard.isDown("left")) then global.tx = global.tx + 2; end
   if (love.keyboard.isDown("right")) then global.tx = global.tx - 2; end
   if (love.keyboard.isDown("up")) then global.ty = global.ty + 2; end
   if (love.keyboard.isDown("down")) then global.ty = global.ty - 2; end
   ]]--
end

function love.draw()
    --[[
    love.graphics.setColor(255, 0, 0, 125);
    love.graphics.rectangle("line", map:getDrawRange())
    love.graphics.reset();
    ]]--
    
    lovelyMoon.draw();
end

function love.keypressed(key, unicode)
   lovelyMoon.keypressed(key, unicode);
   
   if (key == "f1") then toggleState("debug"); playerObj.drawDebug = not playerObj.drawDebug; end
end

function love.keyreleased(key, unicode)
   lovelyMoon.keyreleased(key, unicode);
end

function love.mousepressed(x, y, button)
   lovelyMoon.mousepressed(x, y, button);
end

function love.mousereleased(x, y, button)
   lovelyMoon.mousereleased(x, y, button);
end

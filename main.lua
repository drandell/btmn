--[[
 -- Main Lua File
 -- Created in a galaxy far, far away.. in 2014
 -- Dan
]]--

-- Libraries
require("stateManager");
require("lovelyMoon");
require("storyFader");
require("mapObjects");

-- Advanced Tiled Loader Library
loader = require "./AdvTiledLoader/Loader";
loader.path = "Content/Maps/";

-- Anim 8 by Enrique García Cota
anim8 = require "anim8";

-- Global Vars
global = {};
global.tx = 0;                   -- X translation of the screen
global.ty = 0;                   -- Y translation of the screen
global.scale = 1;                -- Scale of the screen
global.tSize = 32;               -- Tile Size
global.offsetX = 40;             -- Viewport Offset X
global.offsetY = 40;             -- Viewport Offset Y
global.gameWorldWidth = 640;     -- Game World Width Viewport
global.gameWorldHeight = 320;    -- Game World Height Viewport
global.currentGameSpeed = 1;     -- Game World Speed 

-- Player
playerObj = require "player";

-- States
require("debugState");
--require("testState");
require("menuState");
require("sceneOne");
require("joker");

-- Testing Creation of Joker Villain
--joker = jokerVillian:create();

function love.load( arg )
    -- ZeroBrane Debug requirement
    if arg[#arg] == "-debug" then require("mobdebug").start(); end
    
    -- Set Window Icon
    icon = love.graphics.newImage("Content/Images/icon.png");
    success = love.window.setIcon( icon:getData() );
  
    -- States
    addState(menuState, "menu");
    --addState(testState, "test");
    addState(sceneOne, "sceneOne");
    addState(debugState, "debug");
   
    -- Enable States
    enableState("menu");
    --enableState("sceneOne");
    --enableState("test");
    
    ----------------------------------------------
    -- Debug
    playerObj.x = 0;
    playerObj.y = 0;
    global.tx = 0;
   
    -- Load Global Resources such as Fonts
    gameFont = love.graphics.newFont("/Content/MunroSmall.ttf", 14);
end

function love.update(dt)
   lovelyMoon.update(dt);
   
   if (love.keyboard.isDown("escape")) then os.exit(0); end
end

function love.draw()    
    lovelyMoon.draw();
end

function love.keypressed(key, unicode)
   lovelyMoon.keypressed(key, unicode);
   
   -- Enable Debug Drawing
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

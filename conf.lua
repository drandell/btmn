--[[
 -- Love Configuration File
 -- Created In a different project, a long time ago...
 -- Dan
]]--

-- Some helpful globals
version = "0.9.1";
width = 720;
height = 400;
-- Locals
local title = "BTMN";
local author = "Wizardry Games";
local url = "www.wizardrygames.com";
local iconPath = "Content/Images/icon.png";

-- Love configuration
function love.conf(t)
    t.identity = nil                   -- The name of the save directory (string)
    t.author = author;                 -- The author of the game (string)
    t.url = url;                       -- The website of the game (string)
    t.release = false;                 -- Enable release mode (boolean)
    t.version = version;               -- The LÖVE version this game was made for (string)
    t.console = true;                  -- Attach a console (boolean, Windows only)

    t.window.title = title;            -- The window title (string)
    t.window.icon = iconPath;          -- Filepath to an image to use as the window's icon (string)
    t.window.width = width;            -- The window width (number)
    t.window.height = height;          -- The window height (number)
    t.window.borderless = false;       -- Remove all border visuals from the window (boolean)
    t.window.resizable = false;        -- Let the window be user-resizable (boolean)
    t.window.fullscreen = false        -- Enable fullscreen (boolean)
    t.window.fullscreentype = "normal" -- Standard fullscreen or desktop fullscreen mode (string)
    t.window.vsync = true;             -- Enable vertical sync (boolean)
    t.window.fsaa = 0                  -- The number of samples to use with multi-sampled antialiasing (number)
    t.window.display = 1               -- Index of the monitor to show the window in (number)

    t.modules.audio = true             -- Enable the audio module (boolean)
    t.modules.event = true             -- Enable the event module (boolean)
    t.modules.graphics = true          -- Enable the graphics module (boolean)
    t.modules.image = true             -- Enable the image module (boolean)
    t.modules.joystick = true          -- Enable the joystick module (boolean)
    t.modules.keyboard = true          -- Enable the keyboard module (boolean)
    t.modules.math = true              -- Enable the math module (boolean)
    t.modules.mouse = true             -- Enable the mouse module (boolean)
    t.modules.physics = true           -- Enable the physics module (boolean)
    t.modules.sound = true             -- Enable the sound module (boolean)
    t.modules.system = true            -- Enable the system module (boolean)
    t.modules.timer = true             -- Enable the timer module (boolean)
    t.modules.window = true            -- Enable the window module (boolean)
end

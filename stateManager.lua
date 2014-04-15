--[[ 
 --LövelyMoon stateManager - slight tweaks by myself purely for my own clarity. 
 --Made by Davidobot
--]]
stateManager = { states = {} }

function addState( class, id )
   class._enabled = false;
   class._id = id;
   class:load();
   table.insert(stateManager.states, class);
   return state;
end

function isStateEnabled( id )
   for index, state in pairs (stateManager.states) do
      if state._id == id then
         return state._enabled;
      end   
   end
end

function getState( id )
   for index, state in pairs (stateManager.states) do
      if state._id == id then
         return state;
      end
   end
end

function enableState( id )
   for index, state in pairs (stateManager.states) do
      if state._id == id then
         state:enable();
         state._enabled = true;
      end
   end
end

function disableState( id )
   for index, state in pairs (stateManager.states) do
      if state._id == id then
         state:disable();
         state._enabled = false;
      end
   end
end

function toggleState( id )
   for index, state in pairs (stateManager.states) do
      if state._id == id then
         state._enabled = not state._enabled;
         if state._enabled then
            state:enable();
         else
            state:disable();
         end
      end
   end
end

function destroyState( id )
   for index, state in pairs (stateManager.states) do
      if state._id == id then
         state:close();
         table.remove(stateManager.states, index);
      end
   end
end
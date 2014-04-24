--[[
 -- Rope objects class
 -- Functions dealing with ropes & btmn
 -- Created 7:48pm, 24th April 2014
 -- Dan
]]--

-- Rope object
rope = {}

--[[ Local Function ]]--
-- Is btmn at the top of a rope?
function AtTopOfRope()
    if (btmn.collidingWithRope) then 
      if (btmn.collisionRect.y <= rope.drawInfo.top) then
        return true;
      else 
        return false;
      end
    else
      return false;
    end
end
--[[ Local Function ]]--
-- Is btmn at the bottom of a rope?
function AtBottomOfRope()
    if (btmn.collidingWithRope) then 
      if (btmn.collisionRect.y + btmn.collisionRect.height >= rope.drawInfo.bottom) then
        return true;
      else 
        return false;
      end
    else
      return false;
    end
end
--[[ Function ]]--
-- Can btmn move up rope?
function canMoveUpRope()
  if (btmn.collisionRect.y <= rope.drawInfo.top) then
    return false;
  else
    return true;
  end
end
--[[ Local Function ]]--
-- Can btmn move down rope?
function canMoveDownRope()
  if (btmn.collisionRect.y + btmn.collisionRect.height >= rope.drawInfo.bottom) then
    return false;
  else
    return true;
  end
end
--[[ Local Function ]]--
-- Is btmn colliding with a rope?
function checkCollisionWithRope( colmap )
  if (colmap("Ropes")) then
      for i, obj in pairs( colmap("Ropes").objects ) do
          if (boxCollisionHalfWidth(obj.drawInfo.left + global.tx, obj.drawInfo.top + global.ty, obj.width, obj.height)) then
            btmn.collidingWithRope = true;
            rope = obj;
            break;
          else
            btmn.collidingWithRope = false;
          end
      end
  end
end
storyFader = {
  entry = {},
  currentEntry = 1,
  currentDelayTime = 0,
  displayedAllEntries = false,
  finished = false
};

function storyFader:addTextEntry(line, dly, x1, y1, clr)
  table.insert(storyFader.entry, {text = line, x = x1, y = y1, delay = dly, color = clr, alpha = 0, typ = "text"});
end

function storyFader:addIamgeEntry(image, dly, x1, y1)
  table.insert(storyFader.entry, {img = image, x = x1, y = y1, delay = dly, alpha = 0, typ = "image", hasQuad = false});
end

function storyFader:addImageEntry(image, q, dly, x1, y1)
  table.insert(storyFader.entry, {img = image, x = x1, y = y1, quad = q, delay = dly, alpha = 0, typ = "image", hasQuad = true})
end

function storyFader:update(dt)
  -- Increment alpha
  if not storyFader.displayedAllEntries then 
      if (storyFader.entry[storyFader.currentEntry].alpha ~= 255) then
        storyFader.entry[storyFader.currentEntry].alpha = storyFader.entry[storyFader.currentEntry].alpha + 1;
      end
      
      if (storyFader.entry[storyFader.currentEntry].alpha >= 255) then
        storyFader.currentDelayTime = storyFader.currentDelayTime + dt;
        storyFader.entry[storyFader.currentEntry].alpha = 255;
      end
      
      if (storyFader.currentDelayTime > storyFader.entry[storyFader.currentEntry].delay) then
          storyFader.currentEntry = storyFader.currentEntry + 1;
          storyFader.currentDelayTime = 0;
          
          if (storyFader.currentEntry > #storyFader.entry) then
              storyFader.displayedAllEntries = true;
              storyFader.currentEntry = #storyFader.entry;
          end
      end
  end
end

function storyFader:draw()
    if not storyFader.finished then
        for i = 1, storyFader.currentEntry do
            if (storyFader.entry[i].typ == "text") then
                love.graphics.setColor(storyFader.entry[i].color[1], storyFader.entry[i].color[2], storyFader.entry[i].color[3],   storyFader.entry[i].alpha);
                love.graphics.print(storyFader.entry[i].text, storyFader.entry[i].x, storyFader.entry[i].y);
            elseif (storyFader.entry[i].typ == "image") then
                love.graphics.setColor(255, 255, 255, storyFader.entry[i].alpha);
                
                if not storyFader.entry[i].hasQuad then
                  love.graphics.draw(storyFader.entry[i].img, storyFader.entry[i].x, storyFader.entry[i].y);
                else
                  love.graphics.draw(storyFader.entry[i].img, storyFader.entry[i].quad, storyFader.entry[i].x, storyFader.entry[i].y);
                end
            end
            
            love.graphics.reset();
        end
    end
    
    love.graphics.print("Delay Time: " .. storyFader.currentDelayTime, 0, 0);
    love.graphics.print("Current Entry: " .. storyFader.currentEntry, 0, 20);
end

return storyFader;
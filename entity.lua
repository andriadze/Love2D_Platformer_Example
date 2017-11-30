Entity = Object:extend();

function Entity:new(x, y, width, height, image, world, ent_name)
  self.x = x or 0;
  self.y = y or 0;
  self.w = width or 32;
  self.h = height or 32;
  self.image = image;
  self.name = ent_name or "base_entity";
  
  if world ~= nil then
    world:add(self, self.x, self.y, self.w, self.h)
  end
end




function Entity:draw()
  if self.image ~= nil then
    love.graphics.draw(self.image, self.x, self.y)
  end
end
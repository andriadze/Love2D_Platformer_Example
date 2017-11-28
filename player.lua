require "dynamic_entity"

Player = DynamicEntity:extend();

function Player:new(x, y, width, height, image, world, maxVelX, maxVelY, speed)
  Player.super.new(self, x, y, width, height, image, world, maxVelX, maxVelY, "ent_player", 2)
  self.origX = x;
  self.origY = 15;
  self.speed = speed
  self.image = image;
  self.isGripping = false;
  self.grippedEntity = nil;
  self.origMaxVel = maxVelX;
  
  self.tempDistance = ""
  
  local g = anim8.newGrid(28, 49, image:getWidth(), image:getHeight())
  self.animation = anim8.newAnimation(g('1-9',1), 0.1)
  self.animationFliped = anim8.newAnimation(g('1-9',1), 0.1):flipH()
end

function Player:update(dt)
  if self.xVel == 0 then
    self.animation:gotoFrame(3)
    self.animationFliped:gotoFrame(3)
  end
  
  if self.grounded == false then
    self.isGripping = false;
    self.grippedEntity = nil;
  end
  if self.isGripping then
    self.maxVelX = self.origMaxVel/1.7
  else 
    self.maxVelX = self.origMaxVel
  end
  
  
end

function Player:draw()
  if self.direction == 1 then
    self.animation:draw(self.image, self.x, self.y)
  elseif self.direction == -1 then
    self.animationFliped:draw(self.image, self.x, self.y)
  end
end

function Player:checkCols(cols)
  Player.super:checkCols(cols)
  self.grounded = false
	for i,v in ipairs (cols) do
    local otherName = cols[i].other.name 
    if otherName == "ent_crate" and cols[i].normal.y ~= -1 then
      cols[i].other.direction = self.direction
      cols[i].other.xVel = (self.xVel);
    end
    
		if cols[i].normal.y == -1 then
			self.yVel = 0
			self.grounded = true
		elseif cols[i].normal.y == 1 then
			self.yVel = -self.yVel/4
		end
		if cols[i].normal.x ~= 0 and cols[i].other.xVel == nil then
			self.xVel = 0
		end
	end
end

function Player:isEntityGrippable(entity)
  local yReq = math.abs(entity.h - self.h) + 3
  local xReq = math.abs(entity.w / 2 + self.w / 2) + 5
  local xDiff = entity.x - self.x;
  local yDiff = entity.y - self.y;
  
  if entity.name == "ent_crate" then  
    if ((self.direction > 0 and xDiff < 0) or (self.direction < 0 and xDiff > 0)) then
      return false
    end
  end
  
  if entity.name == "ent_crate" and math.abs(yDiff) <= yReq and math.abs(xDiff) <= xReq and self.grounded then
    return true;
  end
end

function Player:moveRight(dt)
  self.xVel = self.xVel + self.speed
  self.animationFliped:update(dt)
  self.animation:update(dt)  
  self.direction = 1
  if self.direction == -1 then
    self.xVel = 0
  end
end

function Player:moveLeft(dt)
  self.xVel = self.xVel + self.speed
  self.direction = -1
  self.animationFliped:update(dt)
  self.animation:update(dt)
  if self.direction == 1 then
    self.xVel = 0
  end
end

function Player:jump(dt)
  if self.grounded == true then
    self.yVel = self.yVel - 400;
    self.isGripping = false;
    self.grippedEntity = nil;
  end
end
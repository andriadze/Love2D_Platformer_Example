Game = Object:extend();

local GRAVITY = 14.8;


function Game:new()
  self.level = "maps/test_map.lua";
  self.entities = {}
  self.debug = {}
  self.player = {};
  
  self:loadAssets();
  self:loadLevel();
  
end

function Game:loadAssets()
  self.charImage = love.graphics.newImage('sprites/main_char.png')
  self.crate = love.graphics.newImage("sprites/crate.png")
end

function Game:setupPhysics()
  self.world = bump.newWorld()
  self.world.gravity = GRAVITY
end

function Game:loadLevel()
  self.entities = {}
  self:setupPhysics();
  self.map = sti(self.level, { "bump" })
	self.map:bump_init(self.world)
  
  for k, object in pairs(self.map.objects) do
    if object.name == "player_spawn" then
      self.player = Player(object.x, object.y, 28, 49, self.charImage, self.world, 200, 64, 100)
      table.insert(self.entities, self.player)      
    elseif object.name == "box" then
      local box = DynamicEntity(object.x, object.y, 32, 32, self.crate, self.world, 200, 64, "ent_crate", 10);
      table.insert(self.entities, box)
    elseif object.name == "spike" then
      local spike = Entity(object.x, object.y, object.width, object.height, nil, self.world, "ent_spike")
      table.insert(self.entities, spike)
    elseif object.name == "level_end" then
      local level_end = Entity(object.x, object.y, 35, 50, nil, self.world, "ent_level_end")
      level_end.nextMap = object.properties.next_map;
      table.insert(self.entities, level_end)
    end
  end
  
  self.map:removeLayer("Objects")
end


function Game:checkCols(entity, cols)
  local thisName = entity.name;
  
  
  entity.grounded = false
	for i,v in ipairs (cols) do
    local otherName = cols[i].other.name;
    
    if (thisName == "ent_player" or thisName == "ent_crate") and otherName == "ent_crate" and cols[i].normal.y ~= -1 then
      cols[i].other.direction = entity.direction
      cols[i].other.xVel = (entity.xVel);
      --self.player.grippedEntity = cols[i].other      
      
    elseif thisName == "ent_player" and otherName == "ent_level_end" then
      self.level = cols[i].other.nextMap
      self:loadLevel();
    elseif thisName == "ent_player" and otherName == "ent_spike" then
      self:loadLevel();
    end
    
		if cols[i].normal.y == -1 then
			entity.yVel = 0
			entity.grounded = true
		elseif cols[i].normal.y == 1 then
			entity.yVel = -entity.yVel/4
		end
		if cols[i].normal.x ~= 0 and otherName == nil then
			entity.xVel = 0
		end
	end
end


function Game:update(dt)
  self.map:update(dt)
  self:manageKeyboard(dt);
  
  if self.player.grippedEntity ~= nil and self.player.isGripping then
    self.player.grippedEntity.direction = self.player.direction
    self.player.grippedEntity.maxVelX = self.player.maxVelX
    self.player.grippedEntity.xVel = self.player.xVel
  end
  
  for i=1,#self.entities do
    if self.entities[i]:is(DynamicEntity) then
      self.entities[i]:updatePhysics(dt)
    end
    self.entities[i].x, self.entities[i].y, cols = self.world:move( self.entities[i], self.entities[i].x, self.entities[i].y )
    self:checkCols(self.entities[i], cols)
  end
  
  
  
  self.player:update(dt)
end

function Game:manageKeyboard(dt)
  if love.keyboard.isDown( "d" ) then
		self.player:moveRight(dt)
	elseif love.keyboard.isDown("a") then
		self.player:moveLeft(dt);
	end
  
  if love.keyboard.isDown("w") then
    self.player:jump(dt)
  end
  
  if love.keyboard.isDown("s") then
    if self.player.isGripping == false then
      for i=1,#self.entities do
        if self.player:isEntityGrippable(self.entities[i]) then
          self.player.isGripping = true;
          self.player.grippedEntity = self.entities[i];
          break
        end
      end
    end
  else
    self.player.isGripping = false;
    self.player.grippedEntity = nil
  end
  
  
end



function Game:draw()

  love.graphics.setColor( 255,255,255,255 )
	--map:setDrawRange(0, 0, 800, 600)
	self.map:draw()
  love.graphics.setColor( 255, 93, 0,255 )
	--love.graphics.rectangle( "fill",player.x,player.y,player.w,player.h )
	love.graphics.setColor(255, 255, 0, 255)
	--self.map:bump_draw(self.world)
	--love.graphics.print(self.player.yVel..self.debug..tostring(self.player.grounded))
	love.graphics.print(self.player.x,0,12)
	love.graphics.print(self.player.y,0,24)
    love.graphics.print(self.player.direction .. tostring(self.player.isGripping), 0, 36)
  
	debug = " "
  
  for i=1,#self.entities do
    self.entities[i]:draw()
  end
end
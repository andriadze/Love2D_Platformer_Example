bump = require "libs/bump"
sti = require "libs/sti"
Object = require "libs/classic"
require "player"

anim8 = require 'libs/anim8'

local cols,player,GRAVITY,map,world
local debug = " "
local entities = {}

function love.load()
  love.window.setMode(1280, 736)
  love.graphics.setBackgroundColor(90, 230, 252)
  GRAVITY = 14.8

	-- Set Physics Meter
	world = bump.newWorld()
  world.gravity = GRAVITY
	-- Load map
	map = sti("maps/test_map.lua", { "bump" })
	
	map:bump_init(world)
  
  charImage = love.graphics.newImage('sprites/main_char.png')
  crate = love.graphics.newImage("sprites/crate.png")
  

  
  for k, object in pairs(map.objects) do
    if object.name == "player_spawn" then
      player_obj = object
      player = Player(player_obj.x, player_obj.y, 28, 49, charImage, world, 200, 64, 100)
      table.insert(entities, player)      
    elseif object.name == "box" then
      box = DynamicEntity(object.x, object.y, 32, 32, crate, world, 200, 64);
      table.insert(entities, box)      
    end
  end
  
  map:removeLayer("Objects")

	GRAVITY = 14.8
  --world:add(player, player.x, player.y, player.w, player.h)
  
  
end

function love.update(dt)
	map:update(dt)
  manageKeyboard(dt);
  
  for i=1,#entities do
    if entities[i]:is(DynamicEntity) then
      entities[i]:updatePhysics(dt)
      entities[i].x, entities[i].y, cols = world:move( entities[i], entities[i].x, entities[i].y )
      entities[i]:checkCols(cols)
    end
  end
  
  player:update(dt)
end

function manageKeyboard(dt)
  if love.keyboard.isDown( "d" ) then
		player:moveRight(dt)
	elseif love.keyboard.isDown("a") then
		player:moveLeft(dt);
	end
  
  if love.keyboard.isDown("w") then
    player:jump(dt)
  end
end

function love.draw()
	
	love.graphics.setColor( 255,255,255,255 )
	--map:setDrawRange(0, 0, 800, 600)
	map:draw()
  love.graphics.setColor( 255, 93, 0,255 )
	--love.graphics.rectangle( "fill",player.x,player.y,player.w,player.h )
	love.graphics.setColor(255, 255, 0, 255)
	--map:bump_draw(world)
	love.graphics.print(player.yVel..debug..tostring(player.grounded))
	love.graphics.print(player.x,0,12)
	love.graphics.print(player.y,0,24)
	debug = " "
  
  for i=1,#entities do
    entities[i]:draw()
  end

end

function love.mousepressed( x,y,button )
	if button == 'l' and player.grounded then
		player.yVel = player.yVel - 180 --this is your jump juice
		player.grounded = false
		debug = debug.." Jumped "
	end
end
function love.resize(w, h)
	map:resize(w, h)
end
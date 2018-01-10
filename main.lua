bump = require "libs/bump"
sti = require "libs/sti"
Object = require "libs/classic"
require "player"
require "game"

anim8 = require 'libs/anim8'

local cols,GRAVITY,map,world
local entities = {}

local game;

function love.load()
  love.window.setMode(1280, 736)
  love.graphics.setBackgroundColor(90, 230, 252)
  
  game = Game()
  
end

function love.update(dt)
  game:update(dt);
end


function love.draw()
  game:draw(dt);
end

function love.mousepressed( x,y,button )
		game:loadLevel();
end

function love.resize(w, h)
	--map:resize(w, h)
end

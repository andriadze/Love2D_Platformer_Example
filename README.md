# Löve2d Platformer Game
2D Platformer written in Lua using Löve2D, STI and bump

# Basic flow
game.lua - is where all game logic is. It checks collisions and such implements game logic and stuff.
entity.lua - is base entity class. Base entity has no physics it is static.
dynamicentity.lua - well is a dynamic entity, it can be moved by other dynamic entities.
player.lua - player is a bit modified game dynamic entity

# Map

Tmx has 3 layers:
Base layer: Where all the tiles are. (collidble property on this layer is true)
Background layer: this is where graphics for spikes and level switcher are.
Objects: Spike locations, player_spawn, level_end and box locations.


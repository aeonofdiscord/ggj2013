require 'argon'
require 'cursor'
require 'map'
require 'mapstate'
require 'text'

sliders = {
	paranoid = 0,
	aggressive = 0,
	curious = 0,
	empathic = 0,
	pragmatic = 0,
}

function love.load()
	local f = io.open('data/map.argon')
	local mapdata = argon.load(f:read('*all'))
	local map = Map(0, 0, mapdata)
	
	local e = io.open('data/events.argon')
	local events = argon.load(e:read("*all"))
	
	state = MapState(mapdata, events)
	
	love.mouse.setVisible(false)
end

function love.draw()
	state:draw()
end

function love.mousepressed(mx, my, button)
	state:click(mx, my, button)
end

function love.update(dtime)
	state:update(dtime)
end
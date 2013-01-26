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

function generateMap()
	local mapdata = {}
	
	function tileAt(x, y)
		for _,t in ipairs(mapdata) do
			if t[1] == x and t[2] == y then return true end
		end
		return false
	end
	
	local count = 0
	local px = 0
	local py = 0
	local dir = math.random(4)
	local w = 20
	local h = 20
	while count < 128 do
		if math.random() > 0.5 then
			dir = dir+1
			if dir > 4 then dir = 1 end
		else
			dir = dir-1
			if dir < 1 then dir = 4 end 
		end
		
		if dir == UP then
			py = py-1
		elseif dir == RIGHT then
			px = px+1
		elseif dir == DOWN then
			py = py+1
		elseif dir == LEFT then
			px = px-1
		end
		
		if px < -w then px = px+1 end
		if px > w then px = px-1 end
		if py < -h then py = py+1 end
		if py > h then py = py-1 end
		if not tileAt(px, py) then
			table.insert(mapdata, {px, py})
			count = count+1
		end
	end
	
	return mapdata
end

function love.load()
	--local f = io.open('data/map.argon')
	--local mapdata = argon.load(f:read('*all'))
	
	local mapdata = generateMap()
	local map = Map(0, 0, mapdata)
	
	local e = io.open('data/events.argon')
	local events = argon.load(e:read("*all"))
	
   state = {}
	state[1] = MapState(mapdata, events)
	
	love.mouse.setVisible(false)
end

function love.draw()
	state[#state]:draw()
end

function love.mousepressed(mx, my, button)
	state[#state]:click(mx, my, button)
end

function love.update(dtime)
	state[#state]:update(dtime)
end

function pushState(new_state)
   table.insert(state, new_state)
end

function popState()
   table.remove(state)
end
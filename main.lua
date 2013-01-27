require 'argon'
require 'cursor'
require 'map'
require 'mapstate'
require 'text'

sliders = {
	paranoia = 0,
	aggression = 0,
	curiosity = 0,
	empathy = 0,
	pragmatism = 0,
}

flags = {
   PARANOIA_ENDING = false,
   AGGRESSION_ENDING = false,
   CURIOUS_ENDING = false,
   EMPATHIC_ENDING = false,
   PRAGMATIC_ENDING = true,
}

biomonitor = {
	pulse = 0.15,
	o2 = 1.0,
}

loaded = false

function generateMap()
	local mapdata = {}
	
	function tileAt(x, y)
		for _,t in ipairs(mapdata) do
			if t.x == x and t.y == y then return t.tile end
		end
		return nil
	end
	
	print('generating terrain')
	local count = 0
	local px = 0
	local py = 0
	local dir = math.random(4)
	local w = 40
	local h = 40
	while count < 256 do
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
			table.insert(mapdata, {x=px, y=py, tile=1})
			count = count+1
		end
	end
	
	for py = -h,h do
		for px = -w,w do
			if not tileAt(px, py) then
				local n = tileAt(px,py-1) == 1
				local e = tileAt(px+1,py) == 1
				local s = tileAt(px,py+1) == 1
				local w = tileAt(px-1,py) == 1
				if n or e or s or w then
					table.insert(mapdata, {x=px, y=py, tile=3})
				end
			end
		end
	end
	
	return mapdata
end

function TitleScreen()
	local title = {
		image = love.graphics.newImage('graphics/title.png')
	}
	
	function title:click(mx, my, button)
		self:newGame()
	end
	
	function title:declick()
	end
	
	function title:draw()
		love.graphics.draw(self.image)
	end
	
	function title:newGame()
		local mapdata = generateMap()
		local map = Map(0, 0, mapdata)
		
		local e = io.open('data/events.argon')
		local events = argon.load(e:read("*all"))
		
		pushState(MapState(mapdata, events))
	end
	
	function title:update(dtime)
	end

	return title
end

function love.load()
	--local f = io.open('data/map.argon')
	--local mapdata = argon.load(f:read('*all'))
	
	local mapdata = generateMap()
	local map = Map(0, 0, mapdata)
	
	local e = io.open('data/events.argon')
	local events = argon.load(e:read("*all"))
	
	state = {}
	state[1] = TitleScreen()
	
	love.mouse.setVisible(false)	
end

function love.draw()
	state[#state]:draw()
end

function love.keypressed(key)
	love.event.push('quit')
end

function love.mousepressed(mx, my, button)
	state[#state]:click(mx, my, button)
end

function love.mousereleased(mx, my, button)
	state[#state]:declick(mx, my, button)
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
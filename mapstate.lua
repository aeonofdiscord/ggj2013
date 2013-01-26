require 'eventstate'

function MapState(mapdata, events)
	local mapstate = {
		x = x,
		y = y,
		squares = {},
		blips = {},
		blipTimer = 0,
		player = {x = 0, y = 0},
		events = {},
		camera = {x = 0, y = 0},
		mapdata = mapdata
	}
	
	function mapstate:addEvents(events)
		for _,e in ipairs(events) do
			local g = {0,0}
			local done = false
			while not done do
				g = mapdata[math.random(#mapdata)]
				if not self:eventAt(g[1], g[2]) then
					done = true
					e.x = g[1]
					e.y = g[2]
				end
			end
			local blip = Blip(g[1], g[2], self)
			self.scene:add(blip)
			
			table.insert(self.blips, blip)
			table.insert(self.events, e)
		end
	end
	
	function mapstate:init()
		self.scene = Scene()
		self.ui = Scene()
		self.map = Map(0, 0, mapdata)
		self.scene:add(self.map)
		self:addEvents(events.events)
		self.camera.x = -love.graphics.getWidth()/2  + (self.player.x*TW) + TW/2
		self.camera.y = -love.graphics.getHeight()/2 + (self.player.y*TH) + TH/2
		
		self.cursor = MoveCursor()
		self.ui:add(self.cursor)
	end
	
	function mapstate:click(mx, my, button)
		local direction = self.cursor.direction
		local player = self.player
		
		local px = player.x
		local py = player.y
		if direction == LEFT then
			px = px-1
		elseif direction == RIGHT then
			px = px+1
		elseif direction == UP then
			py = py-1
		elseif direction == DOWN then
			py = py+1
		end
		
		if self:tileAt(px, py) then
			player.x = px
			player.y = py
		
			local event = self:eventAt(player.x, player.y)
			if event then
				self:doEvent(event)
			end
		end
	end
	
	function mapstate:doEvent(event)
		state = EventState(event)
	end
	
	function mapstate:draw()
		love.graphics.push()
		love.graphics.translate(-self.camera.x, -self.camera.y)
		
		self.scene:draw()
		
		love.graphics.circle('fill', self.player.x*TW + TW/2, self.player.y*TH + TH/2, TW/4)
		love.graphics.pop()
		self.ui:draw()
	end
	
	function mapstate:eventAt(x, y)
		for _,e in ipairs(self.events) do
			if e.x == x and e.y == y then
				return e
			end
		end
		return nil
	end
	
	function mapstate:tileAt(x, y)
		for _,e in ipairs(self.mapdata) do
			if e[1] == x and e[2] == y then
				return e
			end
		end
		return nil
	end
	
	function mapstate:update(dtime)
		self.blipTimer = self.blipTimer - dtime
		if self.blipTimer <= -2 then
			self.blipTimer = 1
		end
		self.scene:update(dtime)
		self.ui:update(dtime)
		
		self.camera.x = -love.graphics.getWidth()/2  + (TW*self.player.x) + TW/2
		self.camera.y = -love.graphics.getHeight()/2 + (TH*self.player.y) + TH/2
	end
	
	mapstate:init()
	return mapstate
end
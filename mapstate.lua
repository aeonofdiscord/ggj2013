require 'eventstate'

local playerImage = love.graphics.newImage('graphics/spaceguy.png')

function MapState(mapdata, events)
	local mapstate = {
		x = x,
		y = y,
		blips = {},
		blipTimer = 0,
		player = {x = 0, y = 0},
		events = {},
		camera = {x = 0, y = 0},
		mapdata = mapdata,
      move_direction = -1,
      move_timer = 0
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
		
		local s = self.map.squares[1]
		while s.tile ~= 1 do
			s = self.map.squares[math.random(#self.map.squares)]
		end
		
		self.cursor = MoveCursor()
		self.ui:add(self.cursor)
	end
	
	function mapstate:click(mx, my, button)
		local direction = self.cursor.direction
      self:movePlayer(direction)
	end
	
	function mapstate:declick(mx, my, button)
      self.move_direction = -1
   end
   
   function mapstate:movePlayer(direction)
      local player = self.player
		
		local px = player.x
		local py = player.y
      
		if direction == LEFT then
         self.move_direction = LEFT
			px = px-1
		elseif direction == RIGHT then
         self.move_direction = RIGHT
			px = px+1
		elseif direction == UP then
         self.move_direction = UP
			py = py-1
		elseif direction == DOWN then
         self.move_direction = DOWN
			py = py+1
      elseif direction == UP_LEFT then
         self.move_direction = UP_LEFT
         px = px-1
			py = py-1
      elseif direction == UP_RIGHT then
         self.move_direction = UP_RIGHT
         px = px+1
			py = py-1
      elseif direction == DOWN_LEFT then
         self.move_direction = DOWN_LEFT
         px = px-1
			py = py+1
      elseif direction == DOWN_RIGHT then
         self.move_direction = DOWN_RIGHT
         px = px+1
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
		pushState(EventState(event))
	end
	
	function mapstate:draw()
		love.graphics.push()
		love.graphics.translate(-self.camera.x, -self.camera.y)
		
		self.scene:draw()
		
		love.graphics.draw(playerImage, self.player.x*TW, self.player.y*TH)
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
      
      if self.move_direction ~= -1 then
         self.move_timer = self.move_timer + dtime
      else
         self.move_timer = 0
      end
      
      if self.move_timer > 0.3 then
         if self.move_timer > 0.5 then
            self:movePlayer(self.cursor.direction)
            self.move_timer = 0.3
         end
      end
		
		self.camera.x = -love.graphics.getWidth()/2  + (TW*self.player.x) + TW/2
		self.camera.y = -love.graphics.getHeight()/2 + (TH*self.player.y) + TH/2
      
	end
   
	
	mapstate:init()
	return mapstate
end
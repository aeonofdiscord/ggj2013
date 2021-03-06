require 'eventstate'
require 'pulse'
require 'oxygen'

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
				if not self:eventAt(g.x, g.y) then
					done = true
					e.x = g.x
					e.y = g.y
				end
			end
			local blip = Blip(g.x, g.y, self, e.biome, e.slider, e.flag)
			blip.event = e
			blip:testConditions()
			e.blip = blip
			
			self.scene:add(blip)
         
			 if e.biome then
				self.map:overwrite(g.x, g.y, e.biome)
			 end
			
			table.insert(self.blips, blip)
			table.insert(self.events, e)
		end
	end
	
	function mapstate:load()
		self.ui:clear()
		self.map = Map(0, 0, mapdata)
		self.scene:add(self.map)
		print('adding events')
		self:addEvents(events.events)
		
		self.camera.x = -love.graphics.getWidth()/2  + (self.player.x*TW)
		self.camera.y = -love.graphics.getHeight()/2 + (self.player.y*TH)
		
		print('placing avatar')
		local s = self.map.squares[1]
		while s.tile ~= 1 do
			s = self.map.squares[math.random(#self.map.squares)]
		end
		self.player.x = s.x
		self.player.y = s.y
		
		self.cursor = MoveCursor()
		self.ui:add(self.cursor)
		
		self.ui:add(PulseMonitor())
		self.ui:add(OxygenMonitor())
	end
	
	function mapstate:init()
		self.scene = Scene()
		self.ui = Scene()
		
		self.ui:add(Text(0, 0, 'Loading'))
	end
	
	function mapstate:click(mx, my, button)
		local direction = self.cursor.direction
		self:movePlayer(direction)
		print(mx, my)
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
      
      for _,e in ipairs(self.blips) do
         print(e.active)
      end
		
		
		local tile = self:tileAt(px, py)
		if tile and tile ~= 2 then
			player.x = px
			player.y = py
		
			local event = self:eventAt(player.x, player.y)
			local event_key = 0
         
			if event then
            if event.blip.active then
               self:doEvent(event)
               local blip_no = self:blipIdAt(player.x, player.y)
               local blip = self:blipAt(player.x, player.y)
               local event_no = self:eventIdAt(player.x, player.y)
               table.remove(self.blips, blip_no)
               table.remove(self.events, event_no)
               self.scene:remove(blip)
            end
			end
         
         table.remove(self.blips, event_key)
         table.remove(self.events, event_key)
		end
      
		for _,e in ipairs(self.blips) do
         e:testConditions()
      end
   end
   
	function mapstate:doEvent(event)
		pushState(EventState(event))
	end
	
	function mapstate:draw()	
		love.graphics.setBackgroundColor(0xcc, 0xb3, 0x8d)
		
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
   
	function mapstate:eventIdAt(x, y)
		for k,e in ipairs(self.events) do
			if e.x == x and e.y == y then
				return k
			end
		end
		return nil
	end	
   
   function mapstate:blipIdAt(x, y)
		for k,e in ipairs(self.blips) do
			if e.x == x and e.y == y then
				return k
			end
		end
		return nil
	end
   
   function mapstate:blipAt(x, y)
		for _,e in ipairs(self.blips) do
			if e.x == x and e.y == y then
				return e
			end
		end
		return nil
	end	
   
	function mapstate:tileAt(x, y)
		for _,e in ipairs(self.mapdata) do
			if e.x == x and e.y == y then
				return e
			end
		end
		return nil
	end
	
	function mapstate:update(dtime)
		if not self.loaded then
			self:load()
			self.loaded = true
		end
		
		self.blipTimer = self.blipTimer - dtime/2
		if self.blipTimer <= -0.1 then
			self.blipTimer = 1
		end
		self.scene:update(dtime)
		self.ui:update(dtime)
      
		if self.move_direction ~= -1 then
			self.move_timer = self.move_timer + dtime
		else
			self.move_timer = 0
		end
      
		if self.move_timer > 0.2 then
			self:movePlayer(self.cursor.direction)
			self.move_timer = 0.0
		end
		
		self.camera.x = -love.graphics.getWidth()/2  + (TW*self.player.x) + TW/2
		self.camera.y = -love.graphics.getHeight()/2 + (TH*self.player.y) + TH/2
	end
	
	mapstate:init()
	return mapstate
end
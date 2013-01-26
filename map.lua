require 'blip'
require 'scene'

tileImage = love.graphics.newImage('graphics/tiles.png')

function drawRect(x, y, w, h)
	love.graphics.rectangle('fill', x, y, w, 1)
	love.graphics.rectangle('fill', x, y, 1, h)
	love.graphics.rectangle('fill', x+w, y, 1, h)
	love.graphics.rectangle('fill', x, y+h, w, 1)
end

function Map(x, y, mapdata)
	local map = {
		x = x,
		y = y,
		squares = {},
	}
	
   function map:tileAt(x,y)
      for _,s in ipairs(mapdata) do
         if s.x == x and s.y == y then return s.tile end
      end
      return nil
   end
   
	function map:build()
		print('building map')
		self.tiles = {}
		for i=0, tileImage:getWidth()/64 do
			table.insert(self.tiles, love.graphics.newQuad(i*64,0, 64, 64, tileImage:getWidth(), tileImage:getHeight()))
		end
	
		local minX = nil
		local maxX = nil
		local minY = nil
		local maxY = nil
		for _,s in ipairs(mapdata) do
			if minX == nil or s.x < minX then
				minX = s.x
			end
			if maxX == nil or s.x > maxX then
				maxX = s.x
			end
			if minY == nil or s.y < minY then
				minY = s.y
			end
			if maxY == nil or s.y > maxY then
				maxY = s.y
			end
		end
		self.w = (maxX - minX) * TW
		self.h = (maxY - minY) * TH
		
		for py = minY-1, maxY+1 do
			for px = minX-1, maxX+1 do
				local tile = self:tileAt(px, py)
				if tile then
					table.insert(self.squares, {x = px, y = py, tile = tile})
				else
					table.insert(self.squares, {x = px, y = py, tile = 2})
				end
			end
		end
	end
   
   function map:overwrite(px, py, biome)
      local tile = nil
      if biome == "desert" then
         tile = 3
      elseif biome == "jungle" then
         tile = 4
      elseif biome == "canyon" then
         tile = 2
      else
         return
      end
      
		for _,s in ipairs(self.squares) do
         if s.x == px and s.y == py then s.tile = tile end
      end
   end
	
	function map:draw()
		for _,s in ipairs(self.squares) do
			love.graphics.drawq(tileImage, self.tiles[s.tile], s.x * TW, s.y * TH)
			if s.tile == 1 then
				--drawRect(s.x * TW, s.y * TH, TW, TH)
			end
		end
	end
	
	map:build()
	return map
end


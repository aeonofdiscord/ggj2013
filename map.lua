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
	
	function map:build()
		self.tiles = {}
		for i=0, tileImage:getWidth()/64 do
			table.insert(self.tiles, love.graphics.newQuad(i*64, 0, 64, 64, tileImage:getWidth(), tileImage:getHeight()))
		end
	
		local minX = nil
		local maxX = nil
		local minY = nil
		local maxY = nil
		for _,s in ipairs(mapdata) do
			if minX == nil or s[1] < minX then
				minX = s[1]
			end
			if maxX == nil or s[1] > maxX then
				maxX = s[1]
			end
			if minY == nil or s[2] < minY then
				minY = s[2]
			end
			if maxY == nil or s[2] > maxY then
				maxY = s[2]
			end
		end
		self.w = (maxX - minX) * TW
		self.h = (maxY - minY) * TH
		
		function tileAt(x,y)
			for _,s in ipairs(mapdata) do
				if s[1] == x and s[2] == y then return true end
			end
		end
		
		for py = minY-1, maxY+1 do
			for px = minX-1, maxX+1 do
				if tileAt(px, py) then
					table.insert(self.squares, {x = px, y = py, tile = 1})
				else
					table.insert(self.squares, {x = px, y = py, tile = 2})
				end
			end
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


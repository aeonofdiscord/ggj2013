require 'blip'
require 'scene'

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
		local minX = nil
		local maxX = nil
		local minY = nil
		local maxY = nil
		for _,s in ipairs(mapdata.grid) do
			table.insert(self.squares, {x = s[1], y = s[2]})
			
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
	end
	
	function map:draw()
		for _,s in ipairs(self.squares) do
			drawRect(s.x * TW, s.y * TH, TW, TH)
		end
	end
	
	map:build()
	return map
end


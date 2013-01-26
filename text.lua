function Text(x, y, text)
	local t = {
		x = x,
		y = y,
		text = text,
		font = love.graphics.newFont(18)
	}
	t.h = t.font:getHeight()
	t.w = t.font:getWidth(text)
	
	function t:draw()
		love.graphics.setFont(self.font)
		love.graphics.print(self.text, self.x, self.y)
	end
	
	return t 
end
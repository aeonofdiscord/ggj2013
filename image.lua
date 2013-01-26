function Image(x, y, path)
	local img = love.graphics.newImage(path)
	
	local image = {
		x = x,
		y = y,
		image = img,
		w = img:getWidth(),
		h = img:getHeight(),
	}
	
	function image:draw()
		love.graphics.draw(self.image, self.x, self.y)
	end
	
	return image
end
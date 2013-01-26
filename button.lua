function Rect(x, y, w, h)
	local rect = {
		x = x,
		y = y,
		w = w,
		h = h,
	}
	
	function rect:contains(mx, my)
		return mx >= self.x and mx < self.x + self.w and my >= self.y and my < self.y + self.h 
	end
	
	return rect
end

function Button(x, y, w, h, text, action)
	if not action then action = function() end end
	
	local button = {
		x = x,	
		y = y,
		w = w,
		h = h,
		text = Text(x, y, text),
		action = action
	}
	if button.w < button.text.w + 10 then button.w = button.text.w + 10 end
	button.text.x = button.x + button.w/2 - button.text.w/2
	button.text.y = button.y + button.h/2 - button.text.h/2
	
	
	function button:click(mx, my, mbutton)
		if self.highlighted and self:rect():contains(mx, my) then
			self.action()
		end
	end
	
	function button:draw()
		if self.highlighted then
			love.graphics.setColor(0x80, 0x80, 0x80)
		else
			love.graphics.setColor(0x40, 0x40, 0x40)
		end
		love.graphics.rectangle('fill', self.x, self.y, self.w, self.h)
		love.graphics.setColor(0xff, 0xff, 0xff)
		self.text:draw()
	end
	
	function button:rect()
		return Rect(self.x, self.y, self.w, self.h)
	end
	
	function button:update(dtime)
		local mx = love.mouse.getX()
		local my = love.mouse.getY()
		
		if self:rect():contains(mx, my) then
			self.highlighted = true
		else
			self.highlighted = false
		end
	end
	
	return button
end
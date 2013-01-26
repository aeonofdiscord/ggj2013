require 'directions'

local CURSOR_RIGHT = love.graphics.newImage('graphics/cursor_right.png')
local CURSOR_LEFT = love.graphics.newImage('graphics/cursor_left.png')
local CURSOR_UP = love.graphics.newImage('graphics/cursor_up.png')
local CURSOR_DOWN = love.graphics.newImage('graphics/cursor_down.png')
local CURSOR_SELECT = love.graphics.newImage('graphics/cursor_select.png')

function MoveCursor()
	local cursor = {
		x = x,
		y = y,
		image = CURSOR_RIGHT,
		layer = 16,
	}
	
	function cursor:draw()
		love.graphics.draw(self.image, self.x, self.y)
	end
	
	function cursor:update(dtime)
		self.x = love.mouse.getX()
		self.y = love.mouse.getY()
		
		if self.x < love.graphics.getWidth()/4 then
			self.image = CURSOR_LEFT
			self.direction = LEFT
		elseif self.x > love.graphics.getWidth()/4 * 3 then
			self.image = CURSOR_RIGHT
			self.direction = RIGHT
		elseif self.y < love.graphics.getHeight() / 4 then
			self.image = CURSOR_UP
			self.direction = UP
		elseif self.y > love.graphics.getHeight()/4 * 3 then
			self.image = CURSOR_DOWN
			self.direction = DOWN
		else
			self.image = CURSOR_SELECT
			self.direction = nil
		end
	end
	
	return cursor
end

function SelectCursor()
	local cursor = {
		x = x,
		y = y,
		image = CURSOR_SELECT,
		layer = 16,
	}
	
	function cursor:draw()
		love.graphics.draw(self.image, self.x, self.y)
	end
	
	function cursor:update(dtime)
		self.x = love.mouse.getX()
		self.y = love.mouse.getY()
	end
	
	return cursor
end
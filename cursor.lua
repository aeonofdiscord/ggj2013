require 'directions'

local CURSOR_RIGHT = love.graphics.newImage('graphics/cursor_right.png')
local CURSOR_LEFT = love.graphics.newImage('graphics/cursor_left.png')
local CURSOR_UP = love.graphics.newImage('graphics/cursor_up.png')
local CURSOR_DOWN = love.graphics.newImage('graphics/cursor_down.png')
local CURSOR_DOWN_RIGHT = love.graphics.newImage('graphics/cursor_down_right.png')
local CURSOR_DOWN_LEFT = love.graphics.newImage('graphics/cursor_down_left.png')
local CURSOR_UP_RIGHT = love.graphics.newImage('graphics/cursor_up_right.png')
local CURSOR_UP_LEFT = love.graphics.newImage('graphics/cursor_up_left.png')
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
      
      local dz_low = 0.45
      local dz_high = 0.55
		
      if self.x < love.graphics.getWidth() * dz_low - 32 and self.y < love.graphics.getHeight() * dz_low - 32 then
         self.image = CURSOR_UP_LEFT
         self.direction = UP_LEFT
      elseif self.x < love.graphics.getWidth() * dz_low - 32 and self.y > love.graphics.getHeight() * dz_high - 16 + 32 then
         self.image = CURSOR_DOWN_LEFT
         self.direction = DOWN_LEFT
      elseif self.x > love.graphics.getWidth() * dz_high - 16 + 32 and self.y < love.graphics.getHeight() * dz_low - 32 then
         self.image = CURSOR_UP_RIGHT
         self.direction = UP_RIGHT
      elseif self.x > love.graphics.getWidth() * dz_high  - 16 + 32 and self.y > love.graphics.getHeight() * dz_high - 16 + 32 then
         self.image = CURSOR_DOWN_RIGHT
         self.direction = DOWN_RIGHT
		elseif self.x < love.graphics.getWidth() * dz_low then
			self.image = CURSOR_LEFT
			self.direction = LEFT
		elseif self.x > love.graphics.getWidth() * dz_high - 16 then
			self.image = CURSOR_RIGHT
			self.direction = RIGHT
		elseif self.y < love.graphics.getHeight() * dz_low then
			self.image = CURSOR_UP
			self.direction = UP
		elseif self.y > love.graphics.getHeight() * dz_high - 16 then
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
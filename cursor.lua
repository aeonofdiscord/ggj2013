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
      
      local angle = math.deg(math.atan2(self.y - love.graphics.getHeight()/2, self.x - love.graphics.getWidth()/2)) + 90
      if angle < 0 then angle = angle + 360 end
      
      if angle >= 337.5 or angle < 22.5 then
			self.image = CURSOR_UP
			self.direction = UP
      elseif angle >= 22.5 and angle < 67.5 then
         self.image = CURSOR_UP_RIGHT
         self.direction = UP_RIGHT
      elseif angle >= 67.5 and angle < 112.5 then
			self.image = CURSOR_RIGHT
			self.direction = RIGHT   
      elseif angle >= 112.5 and angle < 157.5 then
         self.image = CURSOR_DOWN_RIGHT
         self.direction = DOWN_RIGHT
      elseif angle >= 157.5 and angle < 202.5 then
			self.image = CURSOR_DOWN
			self.direction = DOWN
      elseif angle >= 202.5 and angle < 247.5 then
         self.image = CURSOR_DOWN_LEFT
         self.direction = DOWN_LEFT
      elseif angle >= 247.5 and angle < 292.5 then
			self.image = CURSOR_LEFT
			self.direction = LEFT
      elseif angle >= 292.5 and angle < 337.5 then
         self.image = CURSOR_UP_LEFT
         self.direction = UP_LEFT
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
local frames = {}

for _,f in ipairs({'heart1', 'heart2', 'heart3', 'heart4', 'heart5', 'heart6', 'heart7'}) do
	table.insert(frames, love.graphics.newImage('ui/' .. f .. '.png'))
end

function PulseMonitor()
	local w = 256
	local h = 64
	local pulse = {
		x = 0,
		y = love.graphics.getHeight()-h,
		w = w,
		h = h,
		frameTime = 0.09,
		time = 0,
		frame = 1,
		pulseTime = 0.01,
	}
	
	function pulse:draw()
		love.graphics.draw(frames[self.frame], self.x, self.y)
	end
	
	function pulse:update(dtime)
		self.time = self.time + dtime
		if not pulsing and self.time > self.pulseTime then
			pulsing = true
			self.time = 0
		end
		if pulsing and self.time >= self.frameTime then
			self.time = self.time - self.frameTime
			self.frame = self.frame+1
			if self.frame > #frames then
				self.frame = 1
				pulsing = false
			end
		end
	end

	return pulse
end
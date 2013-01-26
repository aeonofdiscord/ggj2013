require 'constants'

function Blip(x, y, state)
	local blip = {
		x = x,
		y = y,
		state = state,
	}
	
	function blip:draw()
		local alpha = 0xff * state.blipTimer
		if alpha < 0 then alpha = 0  end
		love.graphics.setColor({0, 0xff, 0, alpha})
		love.graphics.circle('line', self.x*TW + TW/2, self.y*TH + TH/2, TW/4)
		love.graphics.setColor({0xff, 0xff, 0xff, 0xff})
	end
	
	return blip
end
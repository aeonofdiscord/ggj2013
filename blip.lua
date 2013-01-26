require 'constants'

function Blip(x, y, state, biome)
	local blip = {
		x = x,
		y = y,
      biome = biome,
		state = state
	}
	
	function blip:draw()
      
		love.graphics.setLineWidth(3)
		love.graphics.setBlendMode('additive')
		local alpha = 0xff * state.blipTimer
		if alpha < 0 then alpha = 0  end
		love.graphics.setColor({0, 0xff, 0, alpha/2})
		love.graphics.circle('line', self.x*TW + TW/2, self.y*TH + TH/2, TW/4)
		love.graphics.setColor({0, 0xff, 0, alpha})
		love.graphics.circle('line', self.x*TW + TW/2, self.y*TH + TH/2, TW/8)
		love.graphics.setColor({0xff, 0xff, 0xff, 0xff})
		love.graphics.setBlendMode('alpha')
	end
	
	return blip
end
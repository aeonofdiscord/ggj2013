require 'constants'

function Blip(x, y, state, biome, slider, flag)
	local blip = {
		x = x,
		y = y,
      biome = biome,
		state = state,
      condition_slider = slider,
      condition_flag = flag,
      active = false
	}
	
	function blip:draw()
      if active == false then 
         return
      end
      
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
   
   function blip:testConditions()
      if self.condition_slider then
         if(sliders[self.condition_slider.type] < self.condition_slider.amount) then
            self.active = false
            return
         end
      end
      
      if self.condition_flag then
         if self.condition_flag == "PRAGMATIC_ENDING" then
            if(flags[self.condition_flag] == true) then
               print("JA")
            end
         end
         if(flags[self.condition_flag] == false) then
            self.active = false
            return
         end
      end
      
      self.active = true
   end
	
	return blip
end
function OxygenMonitor()
	local w = 128
	local h = 32
   local oxygen = {
      x = 0,
      y = love.graphics.getHeight() - 64 - h,
      w = w,
      h = h,
      max_level = 100,
      min_level = 10,
      current_level = max_level,
      timer = 0
   }
   
   function oxygen:draw()
      local oxygen_level = (self.current_level/self.max_level)*self.w
      love.graphics.setColor(0,255,255,220)
      love.graphics.rectangle("fill", self.x, self.y, oxygen_level, self.h )
      love.graphics.setColor(0,200,200,220)
      love.graphics.rectangle("fill", self.x, self.y+14, oxygen_level, self.h+14 )
      love.graphics.setColor(0,145,145,220)
      love.graphics.rectangle("fill", self.x, self.y+22, oxygen_level, self.h+22 )
      love.graphics.setColor(0,0,255,220)
      love.graphics.print("O2",self.x + self.w/2 - 8, self.y + self.h/2 - 8)
      
      love.graphics.setColor(0,0,0,220)
      --love.graphics.rectangle("line", self.x, self.y, self.x + self.w, self.h )
      love.graphics.line(self.x, self.y, self.x + self.w, self.y)
      love.graphics.line(self.x, self.y + self.h - 1, self.x + self.w, self.y + self.h - 1)
      
      love.graphics.setColor(255,255,255,220)
      love.graphics.line(self.x+2, self.y+6, self.x + self.w-2, self.y+6)
      
      love.graphics.setColor(255,255,255,255)
   end
   
   function oxygen:update(dtime)
      self.timer = self.timer + dtime
      
      if self.timer > 0.5 then
         self.timer = self.timer - 0.5
      end
   
      self.current_level = self.max_level - (sliders["paranoia"]*10) - (10 * (self.timer/0.5))
      if self.current_level > self.max_level then self.current_level = self.max_level end
      if self.current_level < 0 then self.current_level = 10 end
   end
   
   return oxygen
end



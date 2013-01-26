function Scene()
	local scene = {
		entities = {}
	}
	
	function scene:add(e)
		table.insert(self.entities, e)
	end
	
	function scene:click(mx, my, button)
		for _,e in ipairs(self.entities) do
			if e.click then e:click(mx, my, button) end
		end
	end
	
	function scene:draw()
		for _,e in ipairs(self.entities) do
			if e.draw then e:draw() end
		end
	end
	
	function scene:remove(e)
		e.removed = true
	end
	
	function scene:update(dtime)
		local ents = {}
		for _,e in ipairs(self.entities) do
			if e.update then e:update(dtime) end
			if not e.removed then
				table.insert(ents, e)
			end
		end
		self.entities = ents
		
		table.sort(self.entities, function(l, r) 
			if not l.layer then l.layer = 0 end
			if not r.layer then r.layer = 0 end
			return l.layer < r.layer
		end)
	end
	
	return scene
end
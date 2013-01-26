require 'button'
require 'image'

function EventState(event)
	local eventstate = {
		options = {}
	}
	
	function eventstate:clearText()
		self.scene:remove(self.text)
		self.text = nil
	end
	
	function eventstate:click(mx, my, button)
		self.scene:click(mx, my, button)
	end
	
	function eventstate:init()
		self.scene = Scene()
		self.scene:add(SelectCursor())

		local image = Image(0, 0, 'graphics/' .. event.image)
		self.scene:add(image)
		
		local py = image.h
		
		self.text = Text(0, py, event.text)
		self.scene:add(self.text)
		
		py = py + 30
		for _,o in ipairs(event.options) do
			local action = function()
				eventstate:clearOptions()		
				eventstate:clearText()
				self.text = Text(0, image.h, o.result)
				self.scene:add(self.text)
				if o.modify then
					sliders[o.modify[1]] = sliders[o.modify[1]] + o.modify[2]
					print(o.modify[1], sliders[o.modify[1]])
				end
			end
			local option = Button(0, py, o.text, action)
			table.insert(self.options, option)
			self.scene:add(option)
			py = py + 30
		end
	end
	
	function eventstate:clearOptions()
		for _,o in ipairs(self.options) do
			self.scene:remove(o)
		end
		self.options = {}
	end
	
	function eventstate:draw()
		self.scene:draw()
	end
	
	function eventstate:update(dtime)
		self.scene:update(dtime)
	end
	
	eventstate:init()
	return eventstate
end
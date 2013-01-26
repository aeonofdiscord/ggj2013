require 'button'
require 'image'
require 'textbox'

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
   
   function eventstate:addDoneOption()
      local action = function()
         popState()
      end
      
		local option = Button(40, self.image.h+10+self.text.h+10, 100, 30, "Done", action)
		table.insert(self.options, option)
		self.scene:add(option)
   end
	
	function eventstate:init()
		self.scene = Scene()
		self.scene:add(SelectCursor())

		local image = Image(0, 0, 'graphics/' .. event.image)
		self.image = image
		self.scene:add(image)
		
		local py = image.h + 10
		
		self.text = TextBox(10, py, event.text)
		self.scene:add(self.text)
		
		py = py + self.text.h + 10
		
		for _,o in ipairs(event.options) do
			local action = function()
				eventstate:clearOptions()		
				eventstate:clearText()
				if o.modify then
					sliders[o.modify[1]] = sliders[o.modify[1]] + o.modify[2]
				end
				if o.result then
					self.text = TextBox(10, image.h + 10, o.result)
					self.scene:add(self.text)
					eventstate:addDoneOption()
				else
					popState()
				end
			end
			local option = Button(40, py, 100, 30, o.text, action)
			table.insert(self.options, option)
			self.scene:add(option)
			py = py + 40
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
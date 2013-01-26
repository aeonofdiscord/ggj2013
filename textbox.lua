function TextBox(x, y, text)
	local textbox = {
		x = x,
		y = y,
		text = text,
		lines = {}	
	}

	function textbox:init()
		local line = ''
	end
	
	function textbox:draw()
		for _,l in ipairs(self.lines) do
			l:draw()
		end
	end
	
	return textbox
end
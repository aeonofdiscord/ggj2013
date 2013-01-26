local LINE_MAX = 110

function TextBox(x, y, text)
	local textbox = {
		x = x,
		y = y,
		w = 0,
		h = 0,
		text = text,
		lines = {}	
	}

	function textbox:init()
		local lines = {}
		local line = ''
		local text = self.text
		local word = ''
		while text:len() > 0 do
			local c = text:sub(1, 1)
			text = text:sub(2)
			word = word .. c
			if c == ' ' or text:len() == 0 then
				if line:len() + word:len() + 1 > LINE_MAX then
					table.insert(lines, line)
					line = word
				else
					if line:len() > 0 then
						line = line .. word
					else
						line = word
					end
				end
				word = ''
			end
			
		end
		table.insert(lines, line)
		
		local py = self.y
		for _,l in ipairs(lines) do
			local t = Text(self.x, py, l)
			table.insert(self.lines, t)
			py = py + t.h
			self.h = self.h + t.h
		end
	end
	
	function textbox:draw()
		for _,l in ipairs(self.lines) do
			l:draw()
		end
	end
	
	textbox:init()
	return textbox
end
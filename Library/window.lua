os.loadAPI("ic_os/graphics.lua")
os.loadAPI("ic_os/format.lua")

Direction = {
	Up = "up",
	Down = "down",
	Forward = "forward",
	Back = "back",
	Right = "right",
	Left = "left"
}

UItype = {
	Panel = 1,
	Button = 2,
	Label = 3,
	Image = 4,
	Checkbox = 5,
	Dropdown = 6,
	Slider = 7,
	Textbox = 8
}

ButtonMode = {
	Disabled = 0,
	Pulse = 1,
	Toggle = 2
}

Window = {}
Window.new = function(monitor, active)
	local _obj = {}
	_obj.monitor = monitor
	_obj.ui = {}

	_obj.active = active
	if active == nil then
		_obj.active = true
	end

	if _obj.monitor==nil then
		_obj.monitor=term
	end

	_obj.setPanel = function(self, x, y, w, h, color,event)
		table.insert(self.ui, Panel.new(x,y,w,h,color,self.monitor,event))
		return #self.ui
	end
	_obj.setButton = function(self,x,y,w,h,text,color,textColor,pressedColor,event)
		table.insert(self.ui, Button.new(x,y,w,h,color,self.monitor,text,textColor,pressedColor,event))
		return #self.ui
	end
	_obj.setLabel = function(self,x,y,text,textColor,bgColor,event)
		table.insert(self.ui, Label.new(x,y,self.monitor,text,textColor,bgColor,event))
		return #self.ui
	end
	_obj.setImage = function(self,x,y,pixel,event)
		table.insert(self.ui, Image.new(x,y,self.monitor,pixel,event))
		return #self.ui
	end

	_obj.setCheckbox = function(self,x,y,off_char_color,on_char_color,off_char,on_char,off_color,on_color,value,event)
		table.insert(self.ui, Checkbox.new(x,y,self.monitor,off_char_color,on_char_color,off_char,on_char,off_color,on_color,value,event))
		return #self.ui
	end

	_obj.setDropdown =  function(self,x,y,w,h,content,color,pressedColor,text,textColor,contentColor1,contentColor2,contentTextColor,contentHeight,dropDirection,event,eventTable)
		table.insert(self.ui,Dropdown.new(x,y,w,h,color,pressedColor,self.monitor,text,textColor,contentColor1,contentColor2,contentTextColor,content,contentHeight,dropDirection,event,eventTable))
		return #self.ui
	end

	_obj.setSlider = function(self,x,y,w,h,value,color,fillAreaColor,handleColor,enableHandle,direction,event)
		table.insert(self.ui, Slider.new(x,y,w,h,self.monitor,color,fillAreaColor,handleColor,enableHandle,direction,value,event))
		return #self.ui
	end

	_obj.setTextbox = function(self,x,y,w,h,color,selectedColor,value,displayText,textLengthLimit,textColor,displayTextColor,enableBlink,event)
		table.insert(self.ui, Textbox.new(x,y,w,h,self.monitor,color,selectedColor,value,displayText,textLengthLimit,extColor,displayTextColor,enableBlink,event))
		return #self.ui
	end



	_obj.draw = function(self)
		if _obj.active==false then
			return
		end

		if #_obj.ui == nil then
			return
		end

		for i=1 , #_obj.ui do
			_obj.ui[i]:draw()
		end
	end

	_obj.trigger = function(self, x, y, button, id, reflesh)
		if self.active==false or x==nil or y==nil then
			return
		end
		if button==nil then
			button=1
		end

		if reflesh == nil then
			reflesh=true
		end

		IDs = nil
		ret = false

		for i=1 , #_obj.ui do
			ret = _obj.ui[i]:checkInside(x,y)
			if ret==true then
				IDs = i
				ret = false
			end
		end

		if IDs~=nil then
			if id~= nil then
				if IDs == id then
					_obj.ui[IDs]:OnClicked(button)
					os.queueEvent("window_activated", IDs)
				end
			else
				_obj.ui[IDs]:OnClicked(button)
				os.queueEvent("window_activated", IDs)
			end
		end

		if reflesh then
			_obj.draw(self)
		end
	end

	Panel = {}
	Panel.new = function(x, y, w, h, color, monitor, event)
		local obj = {}
		obj.type = UItype.Panel
		obj.x, obj.y, obj.width, obj.height, obj.color, obj.monitor, obj.event = x, y ,w, h, color, monitor, event
		if obj.event == nil then
			obj.event = function() end
		end
		if obj.color == nil then
			obj.color=colors.white
		end

		obj.draw = function(self)
			graphics.drawFilledBox(obj.x, obj.y, obj.width, obj.height, obj.color, obj.monitor, 2)
		end

		obj.OnClicked = function(self, button)
			self.event()
		end

		obj.getValue = function(self)
			return
		end

		obj.checkInside = function(self,x,y)
			x1,y1,x2,y2 = obj.x, obj.y, obj.x + obj.width-1, obj.y + obj.height - 1
			if x1>x2 then
				temp = x1
				x1=x2
				x2=temp
			end
			if y1>y2 then
				temp = y1
				y1=y2
				y2=temp
			end

			if (x1<=x and x<=x2 and y1<=y and y<=y2) then
				return true
			else
				return false
			end
		end

		return obj
	end

	Button = {}
	Button.new = function(x,y,w,h,color,monitor,text,textColor,pressedColor,event)
		local obj = {}
		obj.type = UItype.Button
		obj.x, obj.y, obj.width, obj.height, obj.color, obj.monitor, obj.event, obj.text, obj.textColor, obj.pressedColor = x,y,w,h,color,monitor,event,text,textColor,pressedColor
		obj.buttonMode = ButtonMode.Pulse
		obj.value = false

		if obj.event == nil then
			obj.event = function() end
		end
		if obj.color==nil then
			obj.color=colors.lightGray
		end
		if obj.textColor==nil then
			obj.textColor = colors.black
		end
		if obj.pressedColor==nil then
			obj.pressedColor = colors.gray
		end

		obj.draw = function(self)
			local col = obj.color
			if obj.value==true then
				col = obj.pressedColor
			end

			graphics.drawFilledBox(obj.x, obj.y, obj.width, obj.height, col, obj.monitor, 2)
			obj.monitor.setBackgroundColor(col)
			obj.monitor.setTextColor(obj.textColor)
			mx, my, ml = format.round((obj.x * 2 + obj.width) / 2), format.round((obj.y * 2 + obj.height - 0.5) / 2), format.round(string.len(obj.text)/ 2)

			sx,sy = mx - ml,my
			for i=1,string.len(obj.text) do
				t=string.sub(obj.text, i,i)
				if obj.checkInside(obj,sx+i-1,sy) then
					obj.monitor.setCursorPos(sx+i-1,sy)
					obj.monitor.write(t)
				end
			end
		end

		obj.OnClicked = function(self, button)
			if obj.value~=true and obj.value~=false then
				obj.value = false
			end

			if obj.buttonMode==ButtonMode.Pulse then
				obj.value = true
				obj.draw(self)

				local flag = false
				repeat
					event, m, x, y = os.pullEvent("mouse_up")

					inside = obj.checkInside(self, x, y)
					if m==button and inside then
						flag = true
					elseif m==button and inside==false then
						flag = true
						obj.value = false

					end
				until flag

				if obj.value then
					self.event()
					obj.value = false
				end
				obj.draw(self)

			elseif obj.buttonMode==ButtonMode.Disabled then
				self.event()

			elseif obj.buttonMode==ButtonMode.Toggle then
				obj.value = not(obj.value)
				obj.draw(self)

				local flag,inside = false, false
				repeat
					event, m, x, y = os.pullEvent("mouse_up")

					 inside = obj.checkInside(self, x, y)
					if m==button and inside then
						flag = true
					elseif m==button and inside==false then
						flag = true
						obj.value = not(obj.value)
					end
				until flag

				if inside then
					self.event()
				end
				obj.draw(self)
			end
		end

		obj.getValue = function(self)
			return obj.value
		end

		obj.checkInside = function(self,x,y)
			x1,y1,x2,y2 = self.x, self.y, self.x + self.width-1, self.y + self.height - 1
			if x1>x2 then
				temp = x1
				x1=x2
				x2=temp
			end
			if y1>y2 then
				temp = y1
				y1=y2
				y2=temp
			end

			if (x1<=x and x<=x2 and y1<=y and y<=y2) then
				return true
			else
				return false
			end
		end

		return obj
	end

	Label = {}
	Label.new = function(x,y,monitor,text,color,bgColor,event)
		local obj={}
		obj.type = UItype.Label
		obj.x, obj.y, obj.text, obj.color, obj.bgColor,obj.monitor, obj.event = x,y,text,color,bgColor,monitor,event
		if obj.event == nil then
			obj.event = function() end
		end
		if obj.bgColor==nil then
			obj.bgColor=colors.black
		end
		if obj.color==nil then
			obj.color = colors.white
		end

		obj.draw = function(self)
			obj.monitor.setBackgroundColor(self.bgColor)
			obj.monitor.setTextColor(self.color)
			obj.monitor.setCursorPos(self.x,self.y)
			obj.monitor.write(self.text)
		end

		obj.update = function(self, string)
			self.text = string
			self.draw(self)
		end

		obj.OnClicked = function(self, button)
			obj.event()
		end

		obj.getValue = function(self)
			return obj.text
		end

		obj.checkInside = function(self,x,y)
			if obj.text==nil then
				return
			end

			l = string.len(obj.text)
			x1,y1,x2,y2 = self.x, self.y, self.x + l-1, self.y
			if x1>x2 then
				temp = x1
				x1=x2
				x2=temp
			end
			if y1>y2 then
				temp = y1
				y1=y2
				y2=temp
			end

			if (x1<=x and x<=x2 and y1<=y and y<=y2) then
				return true
			else
				return false
			end
		end

		return obj
	end

	Image = {}
	Image.new = function(x,y,monitor,pixel,event)
		local obj={}
		type = UItype.Image
		obj.x, obj.y, obj.monitor, obj.event, obj.pixel = x,y,monitor,event,pixel
		if obj.event == nil then
			obj.event = function() end
		end
		if dir==nil then
			bgColor=colors.black
		end

		obj.draw = function(self)
			graphics.drawImage(graphics.parseImage(obj.pixel), obj.x, obj.y)
		end

		obj.loadImage = function(self, dir)
			obj.pixel = graphics.loadRawImage(dir)
		end

		obj.OnClicked = function(self, button)
			obj.event()
		end

		obj.getValue = function(self)
			return obj.pixel
		end

		obj.checkInside = function(self,x,y)
			local iw, ih, div = graphics.getImageSize(self.pixel)
			if iw==nil or ih==nil then
				return false
			end

			x1,y1,x2,y2 = self.x, self.y, self.x + iw-1, self.y+ih-1
			if x1>x2 then
				temp = x1
				x1=x2
				x2=temp
			end
			if y1>y2 then
				temp = y1
				y1=y2
				y2=temp
			end

			if (x1<=x and x<=x2 and y1<=y and y<=y2) then
				s = div[y-(y1-1)]
				if string.sub(s, x-(x1-1), x-(x1-1))==" " then
					return false
				end

				return true
			else
				return false
			end
		end

		return obj
	end

	Checkbox = {}
	Checkbox.new = function(x,y,monitor,off_char_color,on_char_color,off_char,on_char,off_color,on_color,value,event)
		local obj = {}
		obj.type = UItype.Checkbox
		obj.x, obj.y, obj.monitor, obj.off_char_color, obj.on_char_color, obj.off_char, obj.on_char, obj.off_color, obj.on_color,obj.value,  obj.event = x,y,monitor,off_char_color,on_char_color,off_char,on_char,off_color,on_color,value,event
		obj.buttonMode = ButtonMode.Toggle

		if obj.event == nil then
			obj.event = function() end
		end
		if obj.off_char_color==nil then
			obj.off_char_color=colors.white
		end
		if obj.on_char_color==nil then
			obj.on_char_color=colors.white
		end
		if obj.off_char==nil then
			obj.off_char=" "
		end
		if obj.on_char==nil then
			obj.on_char="x"
		end

		if obj.off_color==nil then
			obj.off_color=colors.lightGray
		end
		if obj.on_color==nil then
			obj.on_color=colors.lightGray
		end
		if obj.value==nil then
			obj.value=false
		end

		obj.draw = function(self)
			if string.len(obj.off_char)>1 then
				obj.off_char=string.sub(obj.off_char,1,1)
			elseif string.len(obj.off_char)<1 then
				obj.off_char=" "
			end
			if string.len(obj.on_char)>1 then
				obj.on_char=string.sub(obj.on_char,1,1)
			elseif string.len(obj.on_char)<1 then
				obj.on_char=" "
			end

			if obj.value==false then
				obj.monitor.setCursorPos(x,y)
				obj.monitor.setTextColor(obj.off_char_color)
				obj.monitor.setBackgroundColor(obj.off_color)
				obj.monitor.write(obj.off_char)
			elseif obj.value==true then
				obj.monitor.setCursorPos(x,y)
				obj.monitor.setTextColor(obj.on_char_color)
				obj.monitor.setBackgroundColor(obj.on_color)
				obj.monitor.write(obj.on_char)
			end
		end

		obj.OnClicked = function(self, button)
			if obj.buttonMode==ButtonMode.Toggle then
				obj.value = not(obj.value)
				obj.draw()
				obj.event()
			elseif obj.buttonMode==ButtonMode.Disabled then
				obj.event()
			elseif obj.buttonMode==ButtonMode.Pulse then
				obj.value = not(obj.value)
				obj.draw()
				obj.event()
				obj.value = not(obj.value)
				obj.draw()
			end
		end

		obj.getValue = function(self)
			return obj.value
		end

		obj.checkInside = function(self,x,y)
			if (self.x==x and self.y==y) then
				return true
			else
				return false
			end
		end

		return obj
	end

	Dropdown = {}
	Dropdown.new = function(x,y,w,h,color,pressedColor,monitor,text,textColor,contentColor1,contentColor2,contentTextColor,content,contentHeight,dropDirection,event,eventTable)
		local obj = {}
		obj.type = UItype.Dropdown
		obj.x,obj.y,obj.width,obj.height,obj.color,obj.pressedColor,obj.monitor,obj.text,obj.textColor,obj.contentColor1,obj.contentColor2,obj.contentTextColor,obj.contentHeight,obj.content,obj.dropDirection,obj.event,obj.eventTable = x,y,w,h,color,pressedColor,monitor,text,textColor,contentColor1,contentColor2,contentTextColor,contentHeight,content,dropDirection,event,eventTable
		obj.open = false
		obj.value = nil

		obj.buttonMode = ButtonMode.Toggle
		obj.writeValueOnSelected = false
		obj.resetValueWhenOutsideWasClicked = false

		if obj.event == nil then
			obj.event = function() end
		end
		if obj.height==nil then
			obj.height = 1
		end
		if obj.dropDirection~="up" and obj.dropDirection~="down" then
			obj.dropDirection = "down"
		end
		if obj.contentHeight==nil or obj.contentHeight<1 then
			obj.contentHeight = obj.height
		end
		if obj.textColor==nil then
			obj.textColor = colors.black
		end
		if obj.contentTextColor==nil then
			obj.contentTextColor = colors.black
		end
		if obj.color==nil then
			obj.color=colors.lightGray
		end
		if obj.pressedColor==nil then
			obj.pressedColor = colors.gray
		end
		if obj.contentColor1==nil then
			obj.contentColor1=colors.lightGray
		end
		if obj.contentColor2==nil then
			obj.contentColor2=colors.white
		end

		obj.draw = function(self)
			if obj.open==true then
				obj.monitor.setBackgroundColor(obj.pressedColor)
				graphics.drawFilledBox(obj.x, obj.y, obj.width, obj.height, obj.pressedColor, obj.monitor, 2)
			else
				obj.monitor.setBackgroundColor(obj.color)
				graphics.drawFilledBox(obj.x, obj.y, obj.width, obj.height, obj.color, obj.monitor, 2)
			end
			obj.monitor.setTextColor(obj.textColor)
			local text = obj.text
			if obj.value~=nil then
				if obj.content[obj.value]~=nil and obj.writeValueOnSelected then
					text = obj.content[obj.value]
				end
			end

			mx, my, ml = format.round((obj.x * 2 + obj.width) / 2), format.round((obj.y * 2 + obj.height - 0.5) / 2), format.round(string.len(text)/ 2)

			sx,sy = mx - ml,my
			for i=1,string.len(text) do
				t=string.sub(text, i,i)
				if obj.checkInside(obj,sx+i-1,sy) then
					obj.monitor.setCursorPos(sx+i-1,sy)
					obj.monitor.write(t)
				end
			end

			if obj.open==true and obj.content~=nil then
				if #obj.content>=1 then
					for i = 1, #obj.content do
						if obj.dropDirection=="down" then
							if i%2==1 then --奇数番
								graphics.drawFilledBox(obj.x, obj.y + obj.height + (i-1) * obj.contentHeight, obj.width, obj.contentHeight, obj.contentColor1, obj.monitor, 2)
							elseif i%2==0 then --偶数番
								graphics.drawFilledBox(obj.x, obj.y + obj.height + (i-1) * obj.contentHeight, obj.width, obj.contentHeight, obj.contentColor2, obj.monitor, 2)
							end

							mx,my,ml = format.round((obj.x * 2 + obj.width) / 2), format.round(((obj.y+obj.height)+(i-1)*obj.contentHeight + (obj.y+obj.height)+(i-1)*obj.contentHeight+obj.contentHeight-1) / 2), format.round(string.len(obj.content[i])/ 2)
							sx, sy = mx - ml, my
							for j=1,string.len(content[i]) do
								t=string.sub(content[i], j,j)
								if obj.checkInside(obj,sx+j-1,obj.y) then
									obj.monitor.setTextColor(obj.contentTextColor)
									obj.monitor.setCursorPos(sx+j-1,sy)
									obj.monitor.write(t)
								end
							end

						elseif obj.dropDirection == "up" then
							if i%2==1 then --奇数番
								graphics.drawFilledBox(obj.x, obj.y - i*obj.contentHeight, obj.width, obj.contentHeight, obj.contentColor1, obj.monitor, 2)
							elseif i%2==0 then --偶数番
								graphics.drawFilledBox(obj.x, obj.y - i*obj.contentHeight, obj.width, obj.contentHeight, obj.contentColor2, obj.monitor, 2)
							end

							mx,my,ml = format.round((obj.x * 2 + obj.width) / 2), format.round((obj.y-i*obj.contentHeight + obj.y-i*obj.contentHeight+obj.contentHeight -0.5) / 2), format.round(string.len(obj.content[i])/ 2)
							sx, sy = mx - ml,my
							for j=1,string.len(content[i]) do
								t=string.sub(content[i], j,j)
								if obj.checkInside(obj,sx+j-1,obj.y) then
									obj.monitor.setTextColor(obj.contentTextColor)
									obj.monitor.setCursorPos(sx+j-1,sy)
									obj.monitor.write(t)
								end
							end
						end
					end
				end
			end
		end

		obj.OnClicked = function(self, button)
			if obj.buttonMode==ButtonMode.Toggle then
				self.event()
				self.open = true
				self.draw()
				repeat
					event, m, x, y = os.pullEvent()
					if event=="mouse_click" then
						if m==1 or m==2 then
							ret, val = self.checkInside(self, x, y)

							if ret==true and val~=0 then
								self.value = val
								if self.eventTable[val]~=nil then
									self.eventTable[val]()
								end
							elseif ret==false and resetValueWhenOutsideWasClicked then
								self.value = nil
							end
						end
					end
				until m==1 or m==2
				self.open = false

			elseif obj.buttonMode==ButtonMode.Disabled then
				obj.event()
			elseif obj.buttonMode==ButtonMode.Pulse then
				obj.event()
			end
		end

		obj.getValue = function(self)
			return obj.value
		end

		obj.checkInside = function(self,x,y)
			x1,y1,x2,y2 = self.x, self.y, self.x + self.width-1, self.y + self.height - 1
			if x1>x2 then
				temp = x1
				x1=x2
				x2=temp
			end
			if y1>y2 then
				temp = y1
				y1=y2
				y2=temp
			end

			if self.open==true and self.content~=nil then
				if #self.content>=1 then
					local c,i = self.contentHeight, #self.content
					local ax1,ay1,ax2,ay2 = nil,nil,nil,nil
					if self.dropDirection == "down" then
						ax1,ay1,ax2,ay2 = x1,y2+1, x2,y2+(i*c)
					elseif self.dropDirection == "up" then
						ax1,ay1,ax2,ay2 = x1,y1-(i*c), x2,y1-1
					end

					if (ax1<=x and x<=ax2 and ay1<=y and y<=ay2) then
						if self.dropDirection == "down" then
							local ry = y-y2
							local v = math.ceil(ry/c)
							return true, v
						elseif self.dropDirection == "up" then
							local ry = y-ay1+1
							local v = i - math.ceil(ry/c) + 1
							return true, v
						end
					end
				end
			end

			if (x1<=x and x<=x2 and y1<=y and y<=y2) then
				if self.open==true then
					return true, 0
				elseif self.open==false then
					return true, nil
				end
			else
				return false
			end

		end

		return obj
	end

	Slider = {}
	Slider.new = function(x,y,w,h,monitor,color,fillAreaColor,handleColor,enableHandle,direction,value,event)
		local obj = {}
		obj.type = UItype.Slider
		obj.x,obj.y,obj.width,obj.height,obj.monitor,obj.color,obj.fillAreaColor,obj.handleColor,obj.enableHandle,obj.textHandle,obj.direction,obj.value,obj.event = x,y,w,h,monitor,color,fillAreaColor,handleColor,enableHandle,textHandle,direction,value,event
		obj.handlePos = nil

		if obj.event == nil then
			obj.event = function() end
		end
		if obj.color==nil then
			obj.color=colors.lightGray
		end
		if obj.fillAreaColor==nil then
			obj.fillAreaColor=colors.green
		end
		if obj.handleColor==nil then
			obj.handleColor=colors.gray
		end
		if obj.enableHandle==nil then
			obj.enableHandle=true
		end
		if obj.direction==nil then
			obj.direction = "right"
		end
		if obj.textHandle==nil then
			obj.textHandle = " "
		end
		if obj.value==nil then
			obj.value=0
		end

		obj.draw = function(self)
			if obj.value == nil then
				obj.value = 0
			end
			if obj.value<0 then
				obj.value = 0
			elseif  obj.value>1 then
				obj.value = 1
			end

			graphics.drawFilledBox(obj.x, obj.y, obj.width, obj.height, obj.color, obj.monitor, 2)

			if obj.direction=="right" then
				graphics.drawFilledBox(obj.x, obj.y, format.round(obj.width * obj.value), obj.height, obj.fillAreaColor, obj.monitor, 2)
				if obj.enableHandle then
					p = obj.x + format.limit(format.round(obj.width * obj.value), obj.width, 1) - 1
					obj.handlePos = p
					graphics.drawFilledBox(p, obj.y, 1, obj.height, obj.handleColor, obj.monitor, 2)
				end

			elseif obj.direction=="left" then
					p = format.limit(obj.x + format.round(obj.width * (1-obj.value)),  obj.x+obj.width-1,obj.x)

					graphics.drawFilledBox(p, obj.y, obj.x + obj.width - p, obj.height, obj.fillAreaColor, obj.monitor, 2)
					system.debug_log(obj.x + obj.width * (1-obj.value))
				if obj.enableHandle then
					obj.handlePos = p
					graphics.drawFilledBox(p, obj.y, 1, obj.height, obj.handleColor, obj.monitor, 2)
				end

			elseif obj.direction=="up" then
				p = format.limit(obj.y + format.round(obj.height * (1-obj.value)),  obj.y+obj.height-1,obj.y)
				graphics.drawFilledBox(obj.x, p, obj.x + obj.width - 1, obj.y + obj.height - 1, obj.fillAreaColor, obj.monitor, 1)
				if obj.enableHandle then
					obj.handlePos = p
					graphics.drawFilledBox(obj.x, p, obj.width, 1, obj.handleColor, obj.monitor, 2)
				end

			elseif obj.direction=="down" then
				graphics.drawFilledBox(obj.x, obj.y, obj.width, format.round(obj.height*obj.value), obj.fillAreaColor, obj.monitor, 2)
				if obj.enableHandle then
					p = obj.y + format.limit(format.round(obj.height * obj.value), obj.height, 1) - 1
					obj.handlePos = p
					graphics.drawFilledBox(obj.x, p, obj.width, 1, obj.handleColor, obj.monitor, 2)
				end

			end
		end

		obj.OnClicked = function(self, button)
			local flag = false
			repeat
				event, m, x, y = os.pullEvent()
				if event=="mouse_drag" then
					if obj.direction=="down" then
						local p = format.limit(y+1, obj.y + obj.height, obj.y) - obj.y
						obj.value = p/obj.height
					elseif obj.direction=="up" then
						local p = format.limit(y, obj.y + obj.height, obj.y) - obj.y
						obj.value = 1 - p/obj.height
					elseif obj.direction=="left" then
						local p = format.limit(x, obj.x + obj.width, obj.x) - obj.x
						obj.value = 1 - p/obj.width
					elseif obj.direction=="right" then
						local p = format.limit(x, obj.x + obj.width - 1, obj.x - 1) - obj.x + 1
						obj.value = p/obj.width
					end


				elseif event=="mouse_up" then
					flag=true
				end
				self.draw(self)
				sleep(0)
			until flag

			system.debug_log(self.value)
			self.event()
		end

		obj.getValue = function(self)
			return obj.value
		end

		obj.update = function(self,value)
			obj.value = tonumber(value)
			obj.draw(self)
		end

		obj.checkInside = function(self,x,y)
			x1,y1,x2,y2 = self.x, self.y, self.x + self.width-1, self.y + self.height - 1
			if x1>x2 then
				temp = x1
				x1=x2
				x2=temp
			end
			if y1>y2 then
				temp = y1
				y1=y2
				y2=temp
			end
			if (x1<=x and x<=x2 and y1<=y and y<=y2) then
				return true
			else
				return false
			end
		end

		return obj
	end

	Textbox = {}
	Textbox.new = function(x,y,w,h,monitor,color,selectedColor,value,displayText,textLengthLimit,textColor,displayTextColor,enableBlink,event)
		local obj = {}
		obj.type = UItype.Checkbox
		obj.x, obj.y, obj.width, obj.height, obj.monitor, obj.color, obj.selectedColor, obj.value, obj.displayText, obj.textLengthLimit, obj.textColor, obj.displayTextColor, obj.enableBlink, obj.event = x,y,w,h,monitor,color,selectedColor,value,displayText,textLengthLimit,textColor,displayTextColor,enableBlink,event
		obj.buttonStats = false
		obj.blink = {false, 1, 1}

		if obj.event == nil then
			obj.event = function() end
		end
		if obj.color==nil then
			obj.color=colors.white
		end
		if obj.selectedColor==nil then
			obj.selectedColor=colors.lightGray
		end
		if obj.cursorColor==nil then
			obj.cursorColor=colors.blue
		end
		if obj.textColor==nil then
			obj.textColor=colors.black
		end
		if obj.displayTextColor==nil then
			obj.displayTextColor=colors.gray
		end
		if obj.enableBlink==nil then
			obj.enableBlink=true
		end
		if obj.textLengthLimit==nil or obj.textLengthLimit>(obj.width*obj.height) or obj.textLengthLimit<0 then
			obj.textLengthLimit = obj.width*obj.height
		end

		obj.draw = function(self)
			local color = nil
			if obj.buttonStats == true then
				color = obj.selectedColor
			else
				color = obj.color
			end

			graphics.drawFilledBox(obj.x, obj.y, obj.width, obj.height, color, obj.monitor, 2)

			local text = nil
			if obj.displayText==nil or obj.displayText=="" then
				if obj.value==nil or obj.value=="" then
					return
				else
					obj.monitor.setTextColor(obj.textColor)
					text = obj.value
				end
			else
				if (obj.value==nil or obj.value=="") then
					obj.monitor.setTextColor(obj.displayTextColor)
					text = obj.displayText
				else
					obj.monitor.setTextColor(obj.textColor)
					text = obj.value
				end
			end

			local x,y = obj.x, obj.y
			for i = 1, string.len(text) do
				local c = string.sub(text, i, i)
				repeat
					ret = self.checkInside(self,x,y)
					obj.monitor.setCursorPos(x,y)
					if ret==false then
						x=obj.x
						y=y+1
						if self.checkInside(self,x,y) then
							obj.monitor.setCursorPos(x,y)
							ret = true
						else
							return
						end
					end

					if x==(obj.blink[2]+obj.x-1) and y==(obj.blink[3]+obj.y-1) and obj.blink[1] then
						obj.monitor.setBackgroundColor(obj.cursorColor)
					else
						if obj.buttonStats == true then
							color = obj.selectedColor
						else
							color = obj.color
						end
						obj.monitor.setBackgroundColor(color)
					end

				until ret
				obj.monitor.write(c)

				x=x+1
			end
		end

		obj.OnClicked = function(self, button)
			local flag = false
			obj.buttonStats = true
			local t,text = obj.value, {}
			if t==nil then
				t=""
			end
			t=string.sub(t,1,obj.textLengthLimit)
			text = format.divideCnt(t, obj.width)

			cx, cy = string.len(text[#text]), #text
			local bl = true
			repeat
				event, m, x, y = os.pullEvent()
				if event=="key_up" thenas
					if m == keys.up then
						cy = format.limit_overflow(cy-1, #text, 1)
					elseif m == keys.down then
						cy = format.limit_overflow(cy+1, #text, 1)
					elseif m == keys.left then
						cx = format.limit_overflow(cx-1, string.len(text[cy]), 1)
					elseif m == keys.right then
						cx = format.limit_overflow(cx+1, string.len(text[cy]), 1)
					elseif m == keys.backspace then

					elseif m == keys.delete then

					end
				elseif event=="char" then
					if (string.len(t)+string.len(m))<=obj.textLengthLimit then
						t=string.sub(format.insert(t,obj.width*(cy-1)+cx,m),1,obj.textLengthLimit)
						text = format.divideCnt(t, obj.width)
						cx = cx + 1
						if cx>obj.width then
							cy=system.limit_overflow(cy+1,obj.height,1)
						end
					end

				elseif event=="mouse_click" then
					if obj.checkInside(self,x,y)==true then
						cx = obj.width - x + 1
						cy = obj.height - y + 1
					else
						flag=true
					end

				elseif event=="timer" then
					--bl = not(bl)
				end

				obj.blink = {bl, cx, cy}
				obj.value = t

				obj.draw(self)
			until flag

			obj.event()
			obj.buttonStats = false
		end

		obj.getValue = function(self)
			return obj.value
		end

		obj.checkInside = function(self,x,y)
			x1,y1,x2,y2 = self.x, self.y, self.x + self.width-1, self.y + self.height - 1
			if x1>x2 then
				temp = x1
				x1=x2
				x2=temp
			end
			if y1>y2 then
				temp = y1
				y1=y2
				y2=temp
			end

			if (x1<=x and x<=x2 and y1<=y and y<=y2) then
				return true
			else
				return false
			end
		end

		return obj
	end


	return _obj
end

function GetClicked(button, mode)
	if button==nil then
		button = 1
	end
	if mode==nil then
		mode = false
	end

	if mode==true then
		repeat
			event, m, x, y = os.pullEvent("mouse_click")
		until m==button

		return x,y
	else
		event, m, x, y = os.pullEvent()
		if event == "mouse_click" and m==button then
			return x,y
		end
		return
	end
end

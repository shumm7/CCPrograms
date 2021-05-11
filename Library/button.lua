os.loadAPI("ic_os/graphics.lua")


Panel = {}
Panel.new = function(nx, ny, width, height, color, nz, monitor, func)
	  local obj = {}
	  obj.nx, obj.ny, obj.width, obj.height, obj.color, obj.nz, obj.func, obj.mon = nx, ny, width, height, color, nz, func, monitor
		obj.text = {}
		if(obj.mon == nil) then
			obj.mon=term
		end
		if(obj.nz==nil) then
			obj.nz=1
		end

		z_cnt = obj.nz + 1

		local Text = {}
		Text.new = function(x, y, z,text, color, bgColor)
			local obj = {}
			obj.x, obj.y,obj.z,obj.text, obj.color, obj.bgColor = x,y,z,text,color,bgColor
			return obj
		end

	  obj.draw = function(self)
			graphics.drawFilledBox(self.nx, self.ny, self.width, self.height, self.color, self.mon, 2)
		end

		obj.addText = function(self, name, label, rx, ry, z color, bgColor)
			self.text[name] = Text.new(rx - 1, ry - 1, z, label, color, bgColor)
		end

		obj.drawText = function(self, name)
			for i = 0, string.len(self.text[name].text) do
				t = string.sub(self.text[name].text, i, i)

				self.mon.setCursorPos(self.nx + self.text[name].x+i-1, self.ny+self.text[name].y)
				if self.checkInside(self, self.nx+self.text[name].x+i-1, self.ny+self.text[name].y)==true then
					if self.text[name].color~=nil then
						self.mon.setTextColor(self.text[name].color)
					end
					if self.text[name].bgColor~=nil then
						self.mon.setBackgroundColor(self.text[name].bgColor)
					end

					self.mon.write(t)
				end
			end
		end

		obj.setActive = function(self, bool)
			self.available = bool
		end

		obj.OnClicked = function(self, func)
			self.func = func
		end

		obj.RunEvent = function(self)
			self.func()
		end

		obj.checkInside = function(self,x,y)
			x1,y1,x2,y2 = self.nx, self.ny, self.nx + self.width-1, self.ny + self.height - 1
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

os.loadAPI("ic_os/format.lua")

draw_mode = {
	none = nil,
	left_top = 1,
	left_top_strech = 2,
	center_middle_strech = 3
}

local tColourLookup = {}
for n=1,16 do
    tColourLookup[ string.byte( "0123456789abcdef",n,n ) ] = 2^(n-1)
end

function clear(color,monitor,drawmode)
	if color==nil then
		color = colors.black
	end
	if monitor == nil then
		monitor = term
	end
	mx, my = monitor.getSize()

	for x = 1, mx do
		for y = 1, my do
			drawDot(x,y,color,monitor,drawmode)
		end
	end

	monitor.setCursorPos(1,1)
end

function drawDot(_x, _y, color, monitor, drawmode)
	_x = math.floor(_x)
	_y = math.floor(_y)

	if monitor == nil then
		monitor = term
	end

	if color == nil then
		color = colors.white
	end

	monitor.setCursorPos(_x, _y)

	if monitor.isColor() == false then
		if color ~= colors.black and color ~= colors.white then
			color = colors.white
		end
	end

	monitor.setBackgroundColor(color)
	monitor.write(" ")
	return
end

function drawLine(_x1, _y1, _x2, _y2, color, monitor, drawmode)
	if monitor == nil then
		monitor = term
	end

	if color == nil then
		color = colors.white
	end

	if monitor.isColor() == false then
		if color ~= colors.black and color ~= colors.white then
			color = colors.white
		end
	end

	if drawmode == 2 then
		_x1 = math.floor(_x1)
		_y1 = math.floor(_y1)
		local angle = -_x2
		local length = math.floor(_y2)
		_x2, _y2 = length * math.cos(math.rad(angle)) + _x1, length * math.sin(math.rad(angle)) + _y1
		drawmode = nil
	end

	if drawmode == 3 then
		_x1 = math.floor(_x1)
		_y1 = math.floor(_y1)
		local angle = -_x2

		if _y2%2==1 then
			length = _y2 / 2
			if length < 0 then
				length = -length
			end
			length = length - 0.5
			_x2, _y2 = length * math.cos(math.rad(angle)) + _x1, length * math.sin(math.rad(angle)) + _y1
			_x1, _y1 = length * math.cos(math.rad(angle+180)) + _x1, length * math.sin(math.rad(angle+180)) + _y1

		else
			length = _y2 / 2
			if length < 0 then
				length = -length
			end
			length = length - 0.5
			_x2, _y2 = length * math.cos(math.rad(angle)) + _x1, length * math.sin(math.rad(angle)) + _y1
			_x1, _y1 = length * math.cos(math.rad(angle+180)) + _x1, length * math.sin(math.rad(angle+180)) + _y1
		end
		drawmode = nil
	end

	if drawmode == nil or drawmode == 1 then
		_x1 = math.floor(_x1)
		_y1 = math.floor(_y1)
		_x2 = math.floor(_x2)
		_y2 = math.floor(_y2)

		if _x1 == _x2 and _y1==_y2 then
				drawDot(_x1, _y1, color, monitor)
				return
		end

		local minX = math.min( _x1, _x2 )
		local maxX, minY, maxY
		if minX == _x1 then
				minY = _y1
				maxX = _x2
				maxY = _y2
		else
				minY = _y2
				maxX = _x1
				maxY = _y1
		end

		local xDiff = maxX - minX
		local yDiff = maxY - minY

		if xDiff > math.abs(yDiff) then
				local y = minY
				local dy = yDiff / xDiff
				for x=minX,maxX do
						drawDot( x, math.floor( y + 0.5 ) , color, monitor)
						y = y + dy
				end
		else
				local x = minX
				local dx = xDiff / yDiff
				if maxY >= minY then
						for y=minY,maxY do
								drawDot( math.floor( x + 0.5 ), y , color, monitor)
								x = x + dx
						end
				else
						for y=minY,maxY,-1 do
								drawDot( math.floor( x + 0.5 ), y , color, monitor)
								x = x - dx
						end
				end
		end
	end
end

function drawFilledBox(_x1, _y1, _x2, _y2, color, monitor, drawmode)
	_x1 = math.floor(_x1)
	_y1 = math.floor(_y1)
	_x2 = math.floor(_x2)
	_y2 = math.floor(_y2)

	if monitor == nil then
		monitor = term
	end

	if color == nil then
		color = colors.white
	end

	if monitor.isColor() == false then
		if color ~= colors.black and color ~= colors.white then
			color = colors.white
		end
	end

	if drawmode == 2 then
		width = _x2
		height = _y2

		if width * height == 0 then
			return
		end

		_x2 = _x1 + width - 1
		_y2 = _y1 + height - 1
		drawmode = nil
	end

	if drawmode == 3 then
		cx = _x1
		cy = _y1

		if _x2%2==1 then
			width = _x2 / 2
			if width<0 then
				width = -width
			end
			width = width - 0.5

			_x1 = cx - width
			_x2 = cx + width
		else
			width = _x2 / 2
			_x1 = cx - width + 0.5
			_x2 = cx + width - 0.5
		end

		if _y2%2==1 then
			height = _y2 / 2
			if height<0 then
				height=-height
			end

			height = height - 0.5
			_y1 = cy - height
			_y2 = cy + height
		else
			height = _y2 / 2
			_y1 = cy - height + 0.5
			_y2 = cy + height - 0.5
		end

		drawmode = nil
	end

	if drawmode==nil or drawmode==1 then
		if _x1 == _x2 and _y1==_y2 then
				drawDot(_x1, _y1, color, monitor)
				return
		end

		if _x2<_x1 then
			local temp = _x1
			_x1 = _x2
			_x2 = temp
		end

		for x = _x1, _x2 do
			drawLine(x,_y1,x,_y2,color,monitor)
		end
	end
end

function drawBox(_x1, _y1, _x2, _y2, color, monitor, drawmode)
	_x1 = math.floor(_x1)
	_y1 = math.floor(_y1)
	_x2 = math.floor(_x2)
	_y2 = math.floor(_y2)

	if monitor == nil then
		monitor = term
	end

	if color == nil then
		color = colors.white
	end

	if monitor.isColor() == false then
		if color ~= colors.black and color ~= colors.white then
			color = colors.white
		end
	end

	if drawmode == 2 then
		width = _x2
		height = _y2

		if width * height == 0 then
			return
		end

		_x2 = _x1 + width - 1
		_y2 = _y1 + height - 1
		drawmode = nil
	end

	if drawmode == 3 then
		cx = _x1
		cy = _y1

		if _x2%2==1 then
			width = _x2 / 2
			if width<0 then
				width = -width
			end
			width = width - 0.5

			_x1 = cx - width
			_x2 = cx + width
		else
			width = _x2 / 2
			_x1 = cx - width + 0.5
			_x2 = cx + width - 0.5
		end

		if _y2%2==1 then
			height = _y2 / 2
			if height<0 then
				height=-height
			end

			height = height - 0.5
			_y1 = cy - height
			_y2 = cy + height
		else
			height = _y2 / 2
			_y1 = cy - height + 0.5
			_y2 = cy + height - 0.5
		end

		drawmode = nil
	end

	if drawmode==nil or drawmode==1 then
		if _x1 == _x2 and _y1==_y2 then
				drawDot(_x1, _y1, color, monitor)
				return
		end

		drawLine(_x1,_y1,_x1,_y2,color,monitor)
		drawLine(_x1,_y1,_x2,_y1,color,monitor)
		drawLine(_x2,_y2,_x1,_y2,color,monitor)
		drawLine(_x2,_y2,_x2,_y1,color,monitor)

	end
end

function drawEllipse(_x1, _y1, _x2, _y2, color, monitor, drawmode)
	_x1 = math.floor(_x1)
	_y1 = math.floor(_y1)
	_x2 = math.floor(_x2)
	_y2 = math.floor(_y2)

	if monitor == nil then
		monitor = term
	end

	if color == nil then
		color = colors.white
	end

	if monitor.isColor() == false then
		if color ~= colors.black and color ~= colors.white then
			color = colors.white
		end
	end

	if drawmode == 2 then
		width = _x2
		height = _y2

		if width * height == 0 then
			return
		end

		_x2 = _x1 + width - 1
		_y2 = _y1 + height - 1
		drawmode = nil
	end

	if drawmode == 3 then
		cx = _x1
		cy = _y1

		if _x2%2==1 then
			width = _x2 / 2
			if width<0 then
				width = -width
			end
			width = width - 0.5

			_x1 = cx - width
			_x2 = cx + width
		else
			width = _x2 / 2
			_x1 = cx - width + 0.5
			_x2 = cx + width - 0.5
		end

		if _y2%2==1 then
			height = _y2 / 2
			if height<0 then
				height=-height
			end

			height = height - 0.5
			_y1 = cy - height
			_y2 = cy + height
		else
			height = _y2 / 2
			_y1 = cy - height + 0.5
			_y2 = cy + height - 0.5
		end

		drawmode = nil
	end

	if drawmode==nil or drawmode==1 then
		_x1 = _x1 + 1
		_y1 = _y1 + 1


		if _x2<_x1 then
			temp = _x1
			_x1 = _x2
			_x2 = temp
		end
		if _y2<_y1 then
			temp = _y1
			_y1 = _y2
			_y2 = temp
		end

		cx, cy = (_x2 + _x1)/2, (_y2 + _y1)/2
		width, height = _x2 - _x1 + 1, _y2 - _y1 + 1
		local a = (width / 2)^2
		local b = (height / 2)^2

		for i = 1, 360 do
			dx=math.sqrt(a) * math.cos(math.rad(i)) + math.floor(cx)
			dy=math.sqrt(b) * math.sin(math.rad(i)) + math.floor(cy)
			drawDot(dx,dy,color,monitor)
		end
	end
end

function drawFilledEllipse(_x1, _y1, _x2, _y2, color, monitor, drawmode)
	_x1 = math.floor(_x1)
	_y1 = math.floor(_y1)
	_x2 = math.floor(_x2)
	_y2 = math.floor(_y2)

	if monitor == nil then
		monitor = term
	end

	if color == nil then
		color = colors.white
	end

	if monitor.isColor() == false then
		if color ~= colors.black and color ~= colors.white then
			color = colors.white
		end
	end

	if drawmode == 2 then
		width = _x2
		height = _y2

		if width * height == 0 then
			return
		end

		_x2 = _x1 + width - 1
		_y2 = _y1 + height - 1
		drawmode = nil
	end

	if drawmode == 3 then
		cx = _x1
		cy = _y1

		if _x2%2==1 then
			width = _x2 / 2
			if width<0 then
				width = -width
			end
			width = width - 0.5

			_x1 = cx - width
			_x2 = cx + width
		else
			width = _x2 / 2
			_x1 = cx - width + 0.5
			_x2 = cx + width - 0.5
		end

		if _y2%2==1 then
			height = _y2 / 2
			if height<0 then
				height=-height
			end

			height = height - 0.5
			_y1 = cy - height
			_y2 = cy + height
		else
			height = _y2 / 2
			_y1 = cy - height + 0.5
			_y2 = cy + height - 0.5
		end

		drawmode = nil
	end

	if drawmode==nil or drawmode==1 then
		_x1 = _x1 + 1
		_y1 = _y1 + 1


		if _x2<_x1 then
			temp = _x1
			_x1 = _x2
			_x2 = temp
		end
		if _y2<_y1 then
			temp = _y1
			_y1 = _y2
			_y2 = temp
		end

		cx, cy = (_x2 + _x1)/2, (_y2 + _y1)/2
		width, height = _x2 - _x1 + 1, _y2 - _y1 + 1
		local a = (width / 2)^2
		local b = (height / 2)^2

		for i = 1, 360 do
			dx=math.sqrt(a) * math.cos(math.rad(i)) + math.floor(cx)
			dy=math.sqrt(b) * math.sin(math.rad(i)) + math.floor(cy)
			drawLine(cx,cy,dx,dy,color,monitor,nil)
		end
	end
end

function drawText(text, x, y, width, height, textColor, bgColor, monitor, vertical, horizontal, overflow_vertical, overflow_horizontal)
	if monitor == nil then
		monitor = term
	end
	if text == nil then
		return
	end
	if string.len(text)<1 then
		return
	end
	if textColor~= nil then
		monitor.setTextColor(textColor)
	end
	if bgColor~= nil then
		monitor.setBackgroundColor(bgColor)
	end
	if vertical~="top" and vertical~="center" and vertical~="bottom" then
		vertical = "top"
	end
	if horizontal~="left" and horizontal~="center" and horizontal~="right" then
		horizontal="left"
	end
	if overflow_vertical~=true and overflow_vertical~=false then
		overflow_vertical=false
	end
	if overflow_horizontal~=true and overflow_horizontal~=false then
		overflow_horizontal=true
	end

	t = format.divide(text, "\n")

	local sx, sy = 0,0
	
	if overflow_horizontal == false then
		for i=1, #t do
			if string.len(t[i])>width then
				if horizontal=="left" then
					temp = string.sub(t[i], width+1)
					t[i] = string.sub(t[i], 1, width)
					if t[i+1]~=nil then
						t = format.table_insert(t, i+1, temp)
					else
						table.insert(t, temp)
					end
				elseif horizontal=="center" then
					local o1 = format.round((string.len(t[i]) - width) / 2 )
					local o2 = string.len(t[i]) - width - o1
					temp1 = string.sub(t[i], 1, o1)
					temp2 = string.sub(t[i], string.len(t[i]) - o2 + 1)
					t[i] = string.sub(t[i], o1+1, string.len(t[i]) - o2)
					if t[i+1]~=nil then
						t = format.table_insert(t, i+1, temp2)
					else
						table.insert(t, temp)
					end
					t = format.table_insert(t, i, temp1)
				elseif horizontal=="right" then
					temp = string.sub(t[i], 1, string.len(t[i]) - width)
					t[i] = string.sub(t[i], )
					if t[i+1]~=nil then
						t = format.table_insert(t, i+1, temp)
					else
						table.insert(t, temp)
					end
				end
			end
		end
	elseif overflow_horizontal == true then
		for i=1, #t do
			if string.len(t[i])>width then
				if horizontal=="left" then

				elseif horizontal=="center" then

				elseif horizontal=="right" then

				end
			end
		end
	end

	if overflow_vertical == false then

	end

	if vertical=="top" then
		sy = y
	elseif vertical=="center" then
		if 1<#t then
			sy=format.round((y + (y + height - 1)) / 2 - #t / 2)
		else
			sy=format.round((y + (y + height - 1)) / 2)
		end
	elseif vertical=="bottom" then
		sy = y + height - 1
	end


	for iy = 1, #t do
		if horizontal=="left" then
			sx = x
		elseif horizontal=="center" then
			sx = format.round(  (x + (x + width - 1)) / 2 - (string.len(t[iy]) / 2)  )
		elseif horizontal=="right" then

			sx =
		end

		for ix = 1, string.len(#t[iy]) do
			char = string.sub(#t[iy], iy, iy)

		end

		if vertical=="bottom" then
			sy = sy - 1
		elseif vertical=="top" or vertical=="center" then
			sy = sy + 1
		end
	end
end

local function isInside(x,y, _posX, _posY, _width, _height)
	x1,y1,x2,y2 = _posX, _posY, _posX + _width - 1, _posY + _height - 1
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

function getImageSize(image)
	width, height = 0, 0
	n = format.divide(image, "\n")

	if n==nil then
		return
	end

	height = #n
	for i = 1, height do
		if width<string.len(n[i]) then
			width = string.len(n[i])
		end
	end

	return width, height, n
end

local function drawPixelInternal( xPos, yPos )
    term.setCursorPos( xPos, yPos )
    term.write(" ")
end

local function parseLine( tImageArg, sLine )
    local tLine = {}
    for x=1,sLine:len() do
        tLine[x] = tColourLookup[ string.byte(sLine,x,x) ] or 0
    end
    table.insert( tImageArg, tLine )
end

function parseImage( raw )
    local tImage = {}
    for sLine in ( raw .. "\n" ):gmatch( "(.-)\n" ) do -- read each line like original file handling did
        parseLine( tImage, sLine )
    end
    return tImage
end

function loadImage( path )
    if fs.exists( path ) then
        local file = io.open( path, "r" )
        local sContent = file:read("*a")
        file:close()
        return graphics.parseImage( sContent )
    end
    return nil
end

function loadRawImage( path )
    if fs.exists( path ) then
        local file = io.open( path, "r" )
        local sContent = file:read("*a")
        file:close()
        return sContent
    end
    return nil
end

function drawImage( tImage, xPos, yPos )
    for y=1,#tImage do
        local tLine = tImage[y]
        for x=1,#tLine do
            if tLine[x] > 0 then
                term.setBackgroundColor( tLine[x] )
                drawPixelInternal( x + xPos - 1, y + yPos - 1 )
            end
        end
    end
end

function drawGrid(monitor)
	if monitor==nil then
		monitor = term
	end

	mx, my = monitor.getSize()
	for x = 1, mx do
		for y = 1, my do
			if (x+y)%2==1 then
				monitor.setBackgroundColor(colors.black)
			else
				if monitor.isColor()==true then
					monitor.setBackgroundColor(colors.gray)
				else
					monitor.setBackgroundColor(colors.black)
				end
			end

			monitor.setCursorPos(x,y)
			if x==1 then
				monitor.write(y%10)
			elseif y==1 then
				monitor.write(x%10)
			else
				monitor.write(" ")
			end
		end
	end
end

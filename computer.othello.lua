value = {...}
side = value[1]

-------------------------------------------------------------------------------
--                                 Function                                  --
-------------------------------------------------------------------------------
--COMMON
function terminate()
  os.queueEvent("terminate")
end

function termCls()
   term.clear()
   term.setCursorPos(1,1)
end

function monCls()
	mon.clear()
	mon.setCursorPos(1,1)
end

function cls()
	monCls()
end

function acls()
	monCls()
	termCls()
end

function range(num, max, min)
	if num>max then
		return min
	elseif num<min then
		return max
	else
		return num
	end
end

function oppos(bin)
	if bin==1 then
		return 0
	elseif bin==0 then
		return 1
	else
		return nil
	end
end

-------------------------------------------------------------------------------
TURN_CURRENT = math.random(2)-1
TURN_OPPOS = oppos(TURN_CURRENT)
NONE = -1
WHITE = 0
BLACK = 1
PASSFLAG = 0

board = {}
direction = {}

mon = peripheral.wrap(side)
-------------------------------------------------------------------------------
--BOARD SETUP
function boardReset()
	for x=1,8 do
		board[x] = {}

		for y=1,8 do
			board[x][y] = NONE
		end
	end

	--board[4][4] = WHITE
	--board[5][4] = BLACK
	--board[4][5] = BLACK
	--board[5][5] = WHITE
	board[4][8] = BLACK
	board[4][7] = BLACK
	board[4][6] = WHITE
	board[4][5] = BLACK
end

function boardCount()
	local amountWhite, amountBlack = 0, 0
	for x=1,8 do
		for y=1,8 do
			if board[x][y] == WHITE then
				amountWhite = amountWhite+1
			elseif board[x][y] == BLACK then
				amountBlack = amountBlack+1
			end
		end
	end

	return amountWhite, amountBlack
end

function setDirectionTable()
	for i=1,8 do
		direction[i]={}
		for j=1,2 do
			direction[i][j] = nil
		end
	end

	--UP
	direction[1][1] = 0
	direction[1][2] = -1
	--UP RIGHT
	direction[2][1] = 1
	direction[2][2] = -1
	--RIGHT
	direction[3][1] = 1
	direction[3][2] = 0
	--DOWN RIGHT
	direction[4][1] = 1
	direction[4][2] = 1
	--DOWN
	direction[5][1] = 0
	direction[5][2] = 1
	--DOWN LEFT
	direction[6][1] = -1
	direction[6][2] = 1
	--LEFT
	direction[7][1] = -1
	direction[7][2] = 0
	--UP LEFT
	direction[8][1] = -1
	direction[8][2] = -1
end


function canPlace(_x, _y, _turn)
	local oppos = oppos(_turn)
	setDirectionTable()
	local fl=0

	for i=1, 8 do
		vx, vy = _x + direction[i][1], _y + direction[i][2]

		if vx>0 and vx<9 and vy>0 and vy<9 then
			if board[vx][vy] == oppos then
				while 1 do
					vx, vy = vx + direction[i][1], vy + direction[i][2]
					if vx<1 or vx>8 or vy<1 or vy>8 then
						break
					end

					if board[vx][vy]==_turn then
						fl=1
					elseif board[vx][vy]==NONE then
						break
					end
				end
			end

		end
	end

	if _x>0 and _x<9 and _y>0 and _y<9 then
		if board[_x][_y]~=NONE then
			fl=0
		end
	else
		fl=0
	end


	if fl==1 then
		return true
	else
		return false
	end
end

function boardPlace(_x, _y, _turn)
	local oppos = oppos(_turn)
	setDirectionTable()

	if canPlace(_x,_y,_turn)==true then
		for i=1, 8 do
			vx, vy = _x + direction[i][1], _y + direction[i][2]

			if vx>0 and vx<9 and vy>0 and vy<9 then
				if board[vx][vy] == oppos then
					while 1 do
						vx, vy = vx + direction[i][1], vy + direction[i][2]
						if vx<1 or vx>8 or vy<1 or vy>8 then
							break
						end

						if board[vx][vy]==_turn then
							vvx, vvy = _x + direction[i][1], _y + direction[i][2]
							board[_x][_y] = _turn
							while 1 do
								if vvx<1 or vvx>8 or vvy<1 or vvy>8 then
									break
								end

								if board[vvx][vvy]==oppos then
									board[vvx][vvy]=_turn
								else
									break
								end
								vvx, vvy = vvx + direction[i][1], vvy + direction[i][2]
							end

						elseif board[vx][vy]==NONE then
							break
						end
					end
				end

			end
		end

	end
end

function placableCnt(_turn)
	local cnt=0

	for x=1,8 do
		for y=1,8 do
			if canPlace(x,y,_turn)==true then
				cnt = cnt + 1
			end
		end
	end

	return cnt
end
-------------------------------------------------------------------------------
--DISPLAY
function monChk()
	local x, y = mon.getSize()
	if x~=12 or y~=8 then
		print("The monitor must be 2x2")
		sleep(2)
		terminate()
	end
	if mon.isColor()==false then
		print("The monitor is not an advanced")
		sleep(2)
		terminate()
	end
end

function boardDraw(turn)
	--Board Number
	for i=1,8 do
		mon.setCursorPos(1,i)
		mon.setBackgroundColor(colors.gray)
		mon.setTextColor(colors.white)
		mon.write(i.."           ")
	end

	--Board Stone
	for x=1,8 do
		for y=1,8 do
			mon.setCursorPos(x+1,y)

			if board[x][y] == NONE and (x+y)%2 == 0 then
				mon.setBackgroundColor(colors.green)
			else
				mon.setBackgroundColor(colors.lime)
			end

			if canPlace(x,y,TURN_CURRENT)==true then
				mon.setBackgroundColor(colors.red)
			end

			if board[x][y] == WHITE then
				mon.setBackgroundColor(colors.white)
			elseif board[x][y] == BLACK then
				mon.setBackgroundColor(colors.black)
			end

			mon.write(" ")
		end
	end

	--Cursor
	mon.setBackgroundColor(colors.gray)
	mon.setTextColor(colors.white)
	if turn==WHITE then
		mon.setCursorPos(10,1)
		mon.write(">")
	elseif turn==BLACK then
		mon.setCursorPos(10,2)
		mon.write(">")
	end

	--Count
	local amountWhite, amountBlack = boardCount()
	local stwhite, stblack = tostring(amountWhite), tostring(amountBlack)

	mon.setBackgroundColor(colors.lightGray)

	mon.setTextColor(colors.white)
	mon.setCursorPos(11,1)
	if amountWhite<10 then
		stwhite = string.sub(stwhite,1,1)
		mon.write(" "..stwhite)
	elseif amountWhite>9 then
		stwhite = string.sub(stwhite,1,2)
		mon.write(stwhite)
	end

	mon.setTextColor(colors.black)
	mon.setCursorPos(11,2)
	if amountBlack<10 then
		stblack = string.sub(stblack,1,1)
		mon.write(" "..stblack)
	elseif amountBlack>9 then
		stblack = string.sub(stblack,1,2)
		mon.write(stblack)
	end

	mon.setBackgroundColor(colors.gray)
	mon.setTextColor(colors.white)
	mon.setCursorPos(10,8)
	mon.write("RES")
	if PASSFLAG > 0 then
		mon.setCursorPos(11,3)
		mon.write("P")
		mon.setCursorPos(11,4)
		mon.write("A")
		mon.setCursorPos(11,5)
		mon.write("S")
		mon.setCursorPos(11,6)
		mon.write("S")
	else
		mon.setCursorPos(11,3)
		mon.write(" ")
		mon.setCursorPos(11,4)
		mon.write(" ")
		mon.setCursorPos(11,5)
		mon.write(" ")
		mon.setCursorPos(11,6)
		mon.write(" ")
	end



	mon.setCursorPos(1,1)
end

function getTouchPos()
	local void, nm, x, y = os.pullEvent("monitor_touch")
	if x>1 and x<10 and y>0 and y<9 then
		--BOARD
		return x-1, y
	elseif x>9 and x<13 and y==8 then
		--RES
		return -1,-1
	else
		return 0, 0
	end
end

function getColorName(_color)
	if _color==WHITE then
		return "WHITE"
	elseif _color==BLACK then
		return "BLACK"
	elseif _color==NONE then
		return "NONE"
	else
		return nil
	end
end
-------------------------------------------------------------------------------


acls()
mon.setTextScale(1.5)

boardReset()
monChk()
boardDraw(TURN_CURRENT)

while 1 do
	local tx, ty = getTouchPos()
	print(tx..":"..ty.."("..placableCnt(TURN_CURRENT)..")"..PASSFLAG)

	if tx==-1 or ty==-1 then
		acls()
		sleep(1)
		boardReset()
		TURN_CURRENT = math.random(2)-1
		TURN_OPPOS = oppos(TURN_CURRENT)
		boardDraw(TURN_CURRENT)
		PASSFLAG = 0
	else
		if canPlace(tx,ty,TURN_CURRENT)==true then
			boardPlace(tx,ty,TURN_CURRENT)
			TURN_CURRENT = oppos(TURN_CURRENT)
			TURN_OPPOS = oppos(TURN_CURRENT)
			PASSFLAG = 0
			boardDraw(TURN_CURRENT)
			sleep(0.2)
		end
	end

	if placableCnt(TURN_CURRENT)==0 and placableCnt(oppos(TURN_CURRENT))~=0 then
		PASSFLAG = PASSFLAG + 1
		TURN_CURRENT = oppos(TURN_CURRENT)
		sleep(0.2)
		boardDraw(TURN_CURRENT)
	elseif placableCnt(TURN_CURRENT)==0 and placableCnt(oppos(TURN_CURRENT))==0 then
		PASSFLAG = 2
		sleep(0.2)
	else
		PASSFLAG = 0
	end

	if PASSFLAG >= 2 then
		sleep(1)
		mon.setBackgroundColor(colors.gray)
		acls()
		mon.setCursorPos(1,2)

		local awhite, ablack = boardCount()

		if awhite>ablack	then
			mon.setTextColor(colors.white)
			mon.write(" WHITE WON")
		elseif awhite<ablack then
			mon.setTextColor(colors.black)
			mon.write(" BLACK WON")
		else
			mon.write(" DRAW")
		end

		PASSFLAG = 0
		sleep(2)
		acls()
		sleep(1)
		boardReset()
		TURN_CURRENT = math.random(2)-1
		TURN_OPPOS = oppos(TURN_CURRENT)
		boardDraw(TURN_CURRENT)
	end
end

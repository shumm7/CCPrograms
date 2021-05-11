function getInGameTime(raw)
	local time = os.time()

	if raw==true then
		return time
	end

	local t = textutils.formatTime(time, true)

	if string.len(t)<5 then
		return " "..t
	end

  return t
end

function debug_log(...)
	args = {...}
	str = ""
	if args~=nil then
		for i=1, #args do
			str=str..args[i].." "
		end
	else
		str="nil"
	end

	rednet.open("left")
	rednet.broadcast(str)
	rednet.close("left")
end

function getAppIcon(name)
	if name=="option" then
		s="      7777      \n   7  7887  7   \n  787 7887 787  \n 78887788778887 \n  788878878887  \n   7888888887   \n7777788778877777\n7888887  7888887\n7888887  7888887\n7777788778877777\n   7888888887   \n  788878878887  \n 78887788778887 \n  787 7887 787  \n   7  7887  7   \n      7777      "
	end
	return s
end

local function printUsage()
    print( "Usages:" )
    print( "download get <url> <filename>" )
		print( "download update <url> <filename>" )
    print( "download run <url> <arguments>" )
end

local tArgs = { ... }
if #tArgs < 2 then
    printUsage()
    return
end

if not http then
  printError( "Pastebin requires http API" )
  printError( "Set http_enable to true in ComputerCraft.cfg" )
  return
end

-------------------------
function getString(url)
	local response = http.get( url )

	if response then
		local str = response.readAll()
		response.close()
		return str
	else
		return
	end
end

function checkExists(path)
	if fs.exists( path ) then
		return true
	else
		return false
	end
end

function saveString(str, path)
	if str then
		local file = fs.open( path, "w" )
		file.write( str )
		file.close()
		return true
	end
	return false
end

function download(url, path, mode)
	if mode~="a" and mode~="w" then
		mode="a"
	end

	local str = getString(url)
	if str==nil then
		return false
	end

	if mode=="a" and checkExists(path)==true then
		return false
	end

	if saveString(str, path)==true then
		return true
	else
		return false
	end
end

function run(...)
	local args = {...}
	local url = args[1]

	local str = getString(url)
	if str then
		local func, err = load(str, "ccdlfunction", "t", _ENV)
		if not func then
			return err
		end

		local success, msg = pcall(func, table.unpack(args, 2))
		if not success then
			return msg
		end
	end

	return
end
--------------
if tArgs[1]=="get" then
	print( "Connecting to "..tArgs[2].."... " )
	if download(tArgs[2], tArgs[3], "a")==false then
		printError("Failed")
		return
	else
		print("Downloaded as "..tArgs[3])
		return
	end
elseif tArgs[1]=="update" then
		print( "Connecting to "..tArgs[2].."... " )
		if download(tArgs[2], tArgs[3], "w")==false then
			printError("Failed")
			return
		else
			print("Downloaded as "..tArgs[3])
			return
		end
elseif tArgs[1]=="run" then
	local url = tArgs[2]

	local str = getString(url)
	if str then
		local func, err = load(str, "ccdlpfunction", "t", _ENV)
		if not func then
			printError( err )
			return
		end

		local success, msg = pcall(func, table.unpack(tArgs, 3))
		if not success then
			printError( msg )
		end
	end

else
	if tArgs[1]==nil then
		return
	end
	printUsage()
	return
end

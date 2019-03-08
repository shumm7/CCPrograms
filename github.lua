local function printUsage()
	print( "Usages:" )
	print( "github get <repository> <branch> <directory> <filename>" )
	print( "github run <repository> <branch> <directory> <arguments>" )
end

local function getRepositoryDetail(repository)
	local val = {}
	local temp
	local url = repository
	temp = string.find(url, "https://github.com/")
	if temp~=1 then
		return
	end

	url = string.sub(url, 20)
	temp = string.find(url, "/")
	if temp==1 or temp==nil then
		return
	end
	val["username"]=string.sub(url, 1, temp-1)

	url = string.sub(url, temp+1)
	temp = string.find(url, ".git")
	if temp==1 then
		return
	elseif temp==nil then
		val["repository"]=string.sub(url, 1)
	else
		val["repository"]=string.sub(url, 1, temp-1)
	end

	return val
end

local function getString(username, repository, branch, directory)
	local response = http.get(
		"https://raw.githubusercontent.com/"..textutils.urlEncode( username ).."/"..textutils.urlEncode( repository ).."/"..textutils.urlEncode( branch ).."/"..textutils.urlEncode( directory )
	)

	if response then
		local string = response.readAll()
		response.close()
		return string
	else
		return
	end
end

function get(repository, branch, directory, filename)
	local val = getRepositoryDetail(repository)

	if val==nil then
			return false
	end
	local username = val["username"]
	local repname = val["repository"]


	if fs.exists( filename ) then
			return false
	end

	local string = getString(username, repname, branch, directory)
	if val==string then
			return false
	end

	local file = fs.open(filename, "w")
	file.write(string)
	file.close()

	return true
end

function run(...)
	local rArgs = {...}

	local val = getRepositoryDetail(rArgs[1])
	if val==nil then
			return
	end
	local username = val["username"]
	local repname = val["repository"]
	local branch = rArgs[2]
	local directory = rArgs[3]

	local string = getString(username, repname, branch, directory)
	if val==string then
			return
	end

	local n = username.."_"..repname.."_"..directory
	local func, err = load(string, n, "t", _ENV)
		if not func then
			return err
		end
	local success, msg = pcall(func, table.unpack(rArgs, 5))
	if not success then
		return msg
	end

	return
end



-----------------------------
local tArgs = { ... }

if not http then
	printError( "CCGetGithub requires http API" )
	printError( "Set http_enable to true in ComputerCraft.cfg" )
	return
end

local val = {}
if tArgs[1]=="get" then
	if #tArgs < 5 then
			printUsage()
			return
	end

	local success = get(tArgs[2], tArgs[3], tArgs[4], tArgs[5])
	if success then
		print( "Downloaded as "..tArgs[5])
	else
		print("Failed")
	end

elseif tArgs[1]=="run" then
	if #tArgs < 5 then
			printUsage()
			return
	end

	local val = getRepositoryDetail(tArgs[2])
	if val==nil then
			return
	end
	local username = val["username"]
	local repname = val["repository"]
	local branch = tArgs[3]
	local directory = tArgs[4]

	local string = getString(username, repname, branch, directory)
	if val==string then
			return
	end

	local n = username.."_"..repname.."_"..directory
	local func, err = load(string, n, "t", _ENV)
		if not func then
			printError(err)
			return
		end
	local success, msg = pcall(func, table.unpack(tArgs, 5))
	if not success then
		printError(msg)
	end

	return
else
	if tArgs[1]==nil then
		return
	else
		printUsage()
		return
	end
end

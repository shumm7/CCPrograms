--Json API
--http://www.computercraft.info/forums2/index.php?/topic/5854-json-api-v201-for-computercraft/
--Weather API
--https://openweathermap.org/

local API_DIR = "ccweather"
local JSON_API_CODE = "4nRg9CHU"
local API_KEY = ""
local MYCITY = ""
local TEMP_MODE = "metric"

--usage
local function printUsage(args)
	if args=="get" then
		print("Usages:")
		print(" weather get cityid <city name> <country code>")
		print(" weather get")
		print("   cityinfo, location, cityname,")
		print("   weather, pressure, temperature,")
		print("   humidity, visibility, wind,")
		print("   clouds, rain, snow")
		print("   sun")
		print(" <city id>")
	elseif args=="set" then
		print("Usages:")
		print(" weather set apikey <apikey>")
		print(" weather set mycity <cityid>")
		print(" weather set temp <K/C/F>")
	else
		print("Usages:")
		print(" weather set <argument>...")
		print(" weather get <argument>...")
	end
end

--Pastebin
local function getPastebin(code)
    local response = http.get( "http://pastebin.com/raw.php?i="..textutils.urlEncode( code ) )

  if response then
		local sResponse = response.readAll()
    response.close()
    return sResponse
  else
    return
  end
end

--openweathermap
local function getWeatherJson(cityid, mode)
	if API_KEY == nil or API_KEY=="" then
		print("You must sign up on https://openweathermap.org/ and get the API key")
		return nil
	end

	local url
	if mode == nil then
		url = "http://api.openweathermap.org/data/2.5/weather?id="..textutils.urlEncode( tostring(cityid) ).."&units="..textutils.urlEncode( TEMP_MODE ).."&appid="..textutils.urlEncode( API_KEY )
	elseif mode == "getid" then
		url = "http://api.openweathermap.org/data/2.5/weather?q="..textutils.urlEncode( tostring(cityid) ).."&units="..textutils.urlEncode( TEMP_MODE ).."&appid="..textutils.urlEncode( API_KEY )
	end
    local response = http.get( url )

  if response then
	else
    return false
  end

	local sResponse = response.readAll()
	response.close()


	local path = API_DIR.."/weather-temp.json"
	if sResponse then
		local file = fs.open( path, "w" )
		file.write( sResponse )
		file.close()
	end

	return true
end

--Config load
local function getConfig()
	local MAX_INDEX = 3
	local line = {}
	local val = {}
	local i, temp

	local path = API_DIR.."/ccweather"
	if fs.exists( path )==true then
		local file = fs.open( path, "r" )

		for i=0, MAX_INDEX-1 do
			line[i] = file.readLine()
		end
		file.close()
		for i=0, MAX_INDEX-1 do
			temp = string.find(line[i], ":")
			val[i+1] = string.sub(line[i], temp+1)

			if val[i+1] == nil then
				val[i+1] = ""
			end
		end
		return val

	else
		return {"", "", "", "", ""}
	end
end

local function setConfig()
	local path = API_DIR.."/ccweather"
	if fs.exists( path )==true then
		local file = fs.open( path, "w" )
		file.writeLine("apikey:"..API_KEY)
		file.writeLine("mycity:"..MYCITY)
		file.writeLine("tempmode:"..TEMP_MODE)
		file.close()
	else
		return
	end
end


------------------------------
local function l_getCityid(city, country)
	if city==nil then
		city = MYCITY
	end

	if country == nil then
		getWeatherJson(city, "getid")
	else
		getWeatherJson(city..","..country, "getid")
	end

	local data
	local res = {}
	local path = API_DIR.."/weather-temp.json"
	if fs.exists( path )==true then
		data = json.decodeFromFile(path)
		return data["id"]
	else
		return "0"
	end
end


local function l_get(mode, city)
	if city==nil then
		city = MYCITY
	end

	getWeatherJson(city)

	local data
	local res = {}
	local path = API_DIR.."/weather-temp.json"
	if fs.exists( path )==true then
		data = json.decodeFromFile(path)
	else
		return {"", "", "", "", ""}
	end

	if mode=="cityinfo" then
		res[1] = data["id"]
		res[2] = data["name"]
		res[3] = data["sys"]["country"]

	elseif mode=="location" then
		res[1] = data["coord"]["lon"]
		res[2] = data["coord"]["lat"]

	elseif mode=="cityname" then
		res[1] = data["name"]

	elseif mode=="weather" then
		res[1] = data["weather"][1]["main"]
		res[2] = data["weather"][1]["description"]

	elseif mode=="pressure" then
		res[1] = data["main"]["pressure"]
		res[2] = data["main"]["sea_level"]
		res[3] = data["main"]["grnd_level"]

	elseif mode=="temperature" then
		res[1] = data["main"]["temp"]
		res[2] = data["main"]["temp_min"]
		res[3] = data["main"]["temp_max"]

	elseif mode=="humidity" then
		res[1] = data["main"]["humidity"]

	elseif mode=="visibility" then
		res[1] = data["visibility"]

	elseif mode=="wind" then
		res[1] = data["wind"]["speed"]
		res[2] = data["wind"]["deg"]
		res[3] = data["wind"]["gust"]

	elseif mode=="clouds" then
		res[1] = data["clouds"]["all"]

	elseif mode=="rain" then
		res[1] = data["rain"]["1h"]
		res[2] = data["rain"]["3h"]

	elseif mode=="snow" then
		res[1] = data["snow"]["1h"]
		res[2] = data["snow"]["3h"]

	elseif mode=="sun" then
		res[1] = data["sys"]["sunrise"]
		res[2] = data["sys"]["sunset"]

	else
		return {"", "", "", "", ""}
	end

	for i=1, 5 do
		if res[i]==nil then
			res[i]=""
		end
	end
	return res

end


function set(mode, val)
	if mode=="apikey" then
		API_KEY=val
		setConfig()
		return true

	elseif mode=="mycity" then
		MYCITY=val
		setConfig()
		return true

	elseif mode=="temp" then
		if val=="c" or val=="C" then
			TEMP_MODE = "imperial"
		elseif val=="f" or val=="F" then
			TEMP_MODE = "metric"
		elseif val=="k" or val=="K" then
			TEMP_MODE = "default"
		else
			TEMP_MODE = "default"
		end

		setConfig()
		return true

	else
		return false
	end
end
------------------------------
function getCityid(city, country)
	if city==nil then
		city = MYCITY
	end

	if country == nil then
		getWeatherJson(city, "getid")
	else
		getWeatherJson(city..","..country, "getid")
	end

	local data
	local res = {}
	local path =API_DIR.."/weather-temp.json"
	if fs.exists( path )==true then
		data = json.decodeFromFile(path)
		return data["id"]
	else
		return
	end
end


function get(mode, city)
	if city==nil then
		city = MYCITY
	end

	getWeatherJson(city)

	local data
	local res = {}
	local path = API_DIR.."/weather-temp.json"
	if fs.exists( path )==true then
		data = json.decodeFromFile(path)
	else
		return
	end

	if mode=="cityinfo" then
		res[1] = data["id"]
		res[2] = data["name"]
		res[3] = data["sys"]["country"]

	elseif mode=="location" then
		res[1] = data["coord"]["lon"]
		res[2] = data["coord"]["lat"]

	elseif mode=="cityname" then
		res[1] = data["name"]

	elseif mode=="weather" then
		res[1] = data["weather"][1]["main"]
		res[2] = data["weather"][1]["description"]

	elseif mode=="pressure" then
		res[1] = data["main"]["pressure"]
		res[2] = data["main"]["sea_level"]
		res[3] = data["main"]["grnd_level"]

	elseif mode=="temperature" then
		res[1] = data["main"]["temp"]
		res[2] = data["main"]["temp_min"]
		res[3] = data["main"]["temp_max"]

	elseif mode=="humidity" then
		res[1] = data["main"]["humidity"]

	elseif mode=="visibility" then
		res[1] = data["visibility"]

	elseif mode=="wind" then
		res[1] = data["wind"]["speed"]
		res[2] = data["wind"]["deg"]
		res[3] = data["wind"]["gust"]

	elseif mode=="clouds" then
		res[1] = data["clouds"]["all"]

	elseif mode=="rain" then
		res[1] = data["rain"]["1h"]
		res[2] = data["rain"]["3h"]

	elseif mode=="snow" then
		res[1] = data["snow"]["1h"]
		res[2] = data["snow"]["3h"]

	elseif mode=="sun" then
		res[1] = data["sys"]["sunrise"]
		res[2] = data["sys"]["sunset"]

	else
		return
	end

	return res

end
--------------------------------

--args
local tArgs = { ... }

if #tArgs < 2 and not(tArgs[1]==nil) then
  printUsage(tArgs[1])
  return
end

if not http then
  printError( "CCWeather requires http API" )
  printError( "Set http_enable to true in ComputerCraft.cfg" )
  return
end

--api
if fs.exists( API_DIR )==false then
	fs.makeDir(API_DIR)
end

local path = API_DIR.."/json"
if fs.exists( path )==false then

	local temp = getPastebin(JSON_API_CODE)
	if temp then
		local file = fs.open( path, "w" )
		file.write( temp )
		file.close()
	end
end

local success = os.loadAPI(API_DIR.."/json")
if success==false then
	return
end

--config
local path = API_DIR.."/ccweather"
if fs.exists( path )==false then
	local file = fs.open( path, "w" )
	file.writeLine("apikey:")
	file.writeLine("mycity:")
	file.writeLine("tempmode:metric")
	file.close()
end
local cfg = getConfig()
API_KEY = cfg[1]
MYCITY = cfg[2]
TEMP_MODE = cfg[3]

local city
if tArgs[3]==nil then
	city = MYCITY
else
	city = tArgs[3]
end

--set city
if tArgs[1]=="get" then
	local disp = {}
	if tArgs[2]=="cityinfo" then
		disp = l_get(tArgs[2], city)
		print("City Information:")
		print(" City ID: "..disp[1])
		print(" City Name: "..disp[2])
		print(" Country Code: "..disp[3])

	elseif tArgs[2]=="location" then
		disp = l_get(tArgs[2], city)
		print("Location:")
		print(" Longitude: "..disp[1])
		print(" Latitude: "..disp[2])

	elseif tArgs[2]=="cityname" then
		disp = l_get(tArgs[2], city)
		print("City Name:")
		print(" City Name: "..disp[1])

	elseif tArgs[2]=="weather" then
		disp = l_get(tArgs[2], city)
		print("Weather:")
		print(" Weather: "..disp[1])
		print(" Desctiption: "..disp[2])

	elseif tArgs[2]=="pressure" then
		disp = l_get(tArgs[2], city)
		print("Atomospheric Pressure:")
		print(" Pressure (Sea Level): "..disp[1].." hPa")
		print(" Sea Level: "..disp[2].." hPa")
		print(" Ground Level: "..disp[3].." hPa")

	elseif tArgs[2]=="temperature" then
		local tempdisp = ""
		if TEMP_MODE == "default" then
			tempdisp = " Kelvin"
		elseif TEMP_MODE == "imperial" then
			tempdisp = " deg Fahrenheit"
		elseif TEMP_MODE == "metric" then
			tempdisp = " deg Celsius"
		end

		disp = l_get(tArgs[2], city)
		print("Temperature:")
		print(" Temperature: "..disp[1]..tempdisp)
		print(" Minimum Temp: "..disp[2]..tempdisp)
		print(" Maximum Temp: "..disp[3]..tempdisp)

	elseif tArgs[2]=="humidity" then
		disp = l_get(tArgs[2], city)
		print("Humidity:")
		print(" Humidity: "..disp[1].." %")

	elseif tArgs[2]=="visibility" then
		disp = l_get(tArgs[2], city)
		print("Visibility:")
		print(" Visibility: "..disp[1].." m")

	elseif tArgs[2]=="wind" then
		disp = l_get(tArgs[2], city)
		print("Wind:")
		print(" Speed: "..disp[1].." m/s")
		print(" Direction: "..disp[2].." deg")
		print(" Peak Gust: "..disp[3].." m/s")

	elseif tArgs[2]=="clouds" then
		disp = l_get(tArgs[2], city)
		print("Clouds:")
		print(" Cloudiness: "..disp[1].." %")

	elseif tArgs[2]=="rain" then
		disp = l_get(tArgs[2], city)
		print("Rain:")
		print(" Last 1h: "..disp[1].." mm")
		print(" Last 3h: "..disp[2].." mm")

	elseif tArgs[2]=="snow" then
		disp = l_get(tArgs[2], city)
		print("Snow:")
		print(" Last 1h: "..disp[1].." mm")
		print(" Last 3h: "..disp[2].." mm")

	elseif tArgs[2]=="sun" then
		disp = l_get(tArgs[2], city)
		print("Sun:")
		print( " Sunrise (UTC/Unix): "..disp[1])
		print( " Sunset (UTC/Unix): "..disp[2])

	elseif tArgs[2]=="cityid" then
		local id = l_getCityid(tArgs[3], tArgs[4])
		disp = l_get("cityinfo", id)
		print("City ID:")
		print(" City ID: "..id.." ("..disp[2]..", "..disp[3]..")")
	else
		printUsage(tArgs[1])
	end

elseif tArgs[1]=="set" then
	if tArgs[2]=="apikey" then
		set("apikey", tArgs[3])
		print("API Key has been changed: "..tArgs[3])

	elseif tArgs[2]=="mycity" then
		set("mycity", tArgs[3])
		print("My City has been changed: "..tArgs[3])

	else
		printUsage(tArgs[1])
	end
elseif tArgs[1]==nil then
	return
else
	printUsage(tArgs[1])
end

local path = API_DIR.."/weather-temp.json"
	if fs.exists(path) then
		local file = fs.open( path, "w" )
		file.write()
		file.close()
	end

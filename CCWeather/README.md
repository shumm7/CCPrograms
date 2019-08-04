# CCWeather
CCWeatherは、MinecraftのMODである「ComputerCraft」のプログラムです。
マインクラフト内から現実の気象情報を取得し、APIとして提供します。


---
## 利用方法
1. <https://openweathermap.org/> から「Sign Up」をクリックし、会員登録をする。
2. <https://home.openweathermap.org/api_keys> からKeyをコピー、もしくは、新しいKeyをGenerateする。
3. Minecraft内のComputerなどの端末に、CCWeatherを導入する。
4. ターミナル画面に「`weather set apikey <API key>`」を入力し、Keyを登録する。

## My Cityとは
My Cityを登録しておくと、API使用時に都市名情報が抜けていた場合に自動的に都市名情報を補完することができます。
登録は、ターミナルから「`weather set mycity <city id>`」を入力するか、関数「`weather.set("mycity", "<city id>")`」を呼び出すことで設定できます。


---
## プログラム
`weather get cityid <city name> <country code>` 都市名と国名コードから`city id`を取得します。  
`weather get <mode> <city id>` modeで指定した情報が表示されます。`city id`を省略した場合は、My Cityの情報が表示されます。  
`weather set <mode> <valiable>` modeで指定した情報を設定します。設定はファイルに保存されるため、プログラムを終了しても保持されます。  

### get mode一覧
`cityinfo, location, cityname, weather, pressure, temperature, humidity, visibility, wind, clouds, rain, snow, sun`

### set mode一覧
`apikey, mycity, temp`


## 関数
`get("<mode>", "<city id>")` modeで指定した情報を取得します。値はTableで返されます。  
`set("<mode>", "<valiable>")` modeで指定した情報を取得します。成功した場合trueを返します。  
`getCityid("<city id>", "<country code>")` `city id`を取得して返します。見つからない場合は`nil`を返します。  

### get関数の値一覧
| mode | 要素1 | 要素2 | 要素3 |
|:-----------|:-----------|:-----------|:-----------|
| `cityinfo` | City ID | City Name | Country Code |
| `location` | Longitude | Latitude | `nil` |
| `cityname` | City Name | `nil` | `nil` |
| `weather` | Weather | Description | `nil` |
| `pressure` | Atomospheric Pressure [hPa] | Pressure (Sea Level) [hPa] | Pressure (Ground Level) [hPa] |
| `temperature` | Temperature [K/°C/°F] | Minimum Temperature [K/°C/°F] | Maximum Temperature [K/°C/°F] |
| `humidity` | Humidity [%] | `nil` | `nil` |
| `visibility` | Visibility [m] | `nil` | `nil` |
| `wind` | Speed [m/s] | Direction [deg] | Peak Gust [m/s] |
| `clouds` | Cloudiness [%] | `nil` | `nil` |
| `rain` | Last 1h [mm] | Last 3h [mm] | `nil` |
| `snow` | Last 1h [mm] | Last 3h [mm] | `nil` |
| `sun` | Sunrise [unix/UTC] | Sunset [unix/UTC] | `nil` |

### set関数の値一覧
| mode | 引数 |
|:-----------|:-----------|
| `apikey` | API Key |
| `mycity` | My City (string/city id) |
| `temp` | Temperature Unit (K/C/F) |

---

## 謝辞
JSON API for ComputerCraft 
http://www.computercraft.info/forums2/index.php?/topic/5854-json-api-v201-for-computercraft/

OpenWeatherMap
https://openweathermap.org/

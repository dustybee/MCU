-- file : config.lua
local module = {}

module.SSID = {}
module.SSID["ssid"] = "password"

module.HOST = "10.20.0.80"
module.PORT = 1883
module.ID = node.chipid()
module.UNAME = "username"
module.PASSWD = "password"

return module

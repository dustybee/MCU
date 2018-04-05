-- file : application.lua
local module = {}
m = nil
pubPin = "1"
gpio.mode(pubPin, gpio.INPUT, gpio.PULLUP)

local function register_myself()

    m:subscribe("mcu3/r1",0, function(conn) print("subscribe success on mcu3/r1") end)
    m:subscribe("mcu2/r1",0, function(conn) print("subscribe success mcu2/r1") end)
    m:subscribe("mcu1/door",0, function(conn) print("subscribe successmcu1/door") end)
end

local function mqtt_start()
    m = mqtt.Client(config.ID, 120, config.UNAME, config.PASSWD)
    m:on("message", function(conn, topic, data)
        print(topic .. ": " .. data)
        if (topic == "mcu3/r1" and data == "false") then
            gpio.write(pubPin, 0)
            m:publish("mcu/message","Desk light has been turned off.",0,0, function(conn)end)
        elseif (topic == "mcu3/r1" and data == "true") then
            gpio.write(pubPin, 1)
            m:publish("mcu/message","Desk light has been turned on.",0,0, function(conn)end)
        end
    end)
    m:connect(config.HOST, config.PORT, 0, 1, function(con)
        register_myself()
        m:publish("mcu/message","Main MCU is online.",0,0, function(conn)end)
    end)
end
function module.start()
  mqtt_start()
end

return module

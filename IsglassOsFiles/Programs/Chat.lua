---@diagnostic disable: need-check-nil
term.clear()
term.setCursorPos(1,1)
print("Until we have our own Chat software, a version of the TomtarSkogar chat software will be used")
sleep(1)
local monitor = peripheral.find("monitor")
if monitor ~= nil then
    monitor.clear()
    monitor.setCursorPos(1,1)
end
local modem = peripheral.find("modem") or error("No modem attached", 0)
modem.open(420)

local test
local test = peripheral.find("speaker")
print("Välj namn: ")
local namn = read()

local msgRecv = function()
    local event, side, channel, replyChannel, message, distance
    repeat
        event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")    
    until channel == 420
    
    --local x,y = term.getCursorPos()
    --term.setCursorPos(x, y + 1)
    print(tostring(message))
    if monitor ~= nil then
        monitor.write(tostring(message))
        local x, y = monitor.getCursorPos()
        monitor.setCursorPos(1, y+1)
    end
    if test ~= nil then
        test.playNote("harp", 3.0, 12)
    end
end
--coroutine.resume(msgRecv)

local msgSend = function()
    local msg = read()
    modem.transmit(420, 421, namn..": "..msg)
end

while true do
    parallel.waitForAny(msgRecv, msgSend)
end

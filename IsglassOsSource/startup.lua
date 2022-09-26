package.path = package.path..";/IsglassOsAPI/?.lua"
local util = require("util")

--Setup system information

sleep(1)

local middle = math.floor(util.H(term)/2) + 1
term.clear()

util.LeftWrite(term, util.W(term), util.H(term), "V"..util.VersionString(util.ReadData("IsglassOsData/version.txt")))

util.CenterWrite(term, middle-1," IsglassOS ")
util.CenterWrite(term, middle+0,"[         ]")
util.CenterWrite(term, middle+1,"Preparing start")

local speaker = util.Speaker()
if speaker then
    speaker.playSound("entity.experience_orb.pickup", 3)
end

sleep(2)


middle = math.floor(util.H(term)/2) + 1
term.clear()

util.LeftWrite(term, util.W(term), util.H(term), "V"..util.VersionString(util.ReadData("IsglassOsData/version.txt")))

util.CenterWrite(term, middle-1," IsglassOS ")
util.CenterWrite(term, middle+0,"[         ]")

util.SetTextColor(term, colors.yellow)
util.CenterWrite(term, middle, "###      ")
util.SetTextColor(term, colors.white)

util.CenterWrite(term, middle+1, "Updating")

if speaker then
    speaker.playSound("entity.experience_orb.pickup", 3)
end


--Check for update
shell.switchTab(shell.openTab("IsglassOsSource/update.lua"))
os.pullEvent("OSupdate")


middle = math.floor(util.H(term)/2) + 1
term.clear()

util.LeftWrite(term, util.W(term), util.H(term), "V"..util.VersionString(util.ReadData("IsglassOsData/version.txt")))

util.CenterWrite(term, middle-1," IsglassOS ")
util.CenterWrite(term, middle+0,"[         ]")

util.SetTextColor(term, colors.yellow)
util.CenterWrite(term, middle, "######   ")
util.SetTextColor(term, colors.white)

util.CenterWrite(term, middle+1, "Starting!")

if speaker then
    speaker.playSound("entity.experience_orb.pickup", 3)
end

sleep(2)


middle = math.floor(util.H(term)/2) + 1
term.clear()

util.LeftWrite(term, util.W(term), util.H(term), "V"..util.VersionString(util.ReadData("IsglassOsData/version.txt")))

util.CenterWrite(term, middle-1," IsglassOS ")
util.CenterWrite(term, middle+0,"[         ]")

util.SetTextColor(term, colors.yellow)
util.CenterWrite(term, middle, "#########")
util.SetTextColor(term, colors.white)

util.CenterWrite(term, middle+1, "Starting!")

if speaker then
    speaker.playSound("entity.experience_orb.pickup", 3)
end

sleep(2)


--StartOS
shell.run("IsglassOsSource/main.lua")
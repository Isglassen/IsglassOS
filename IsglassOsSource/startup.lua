--Setup system information

sleep(1)

os.loadAPI("IsglassOsAPI/util.lua")
os.loadAPI("IsglassOsAPI/settingsUtil.lua")
util.W, util.H = term.getSize()
util.Color = term.isColor()
util.Speaker = peripheral.find("speaker")


local middle = math.floor(util.H/2) + 1
term.clear()

util.LeftWrite(term, util.W, util.H, "V"..util.VersionString(util.ReadData("IsglassOsData/version.txt")))

util.CenterWrite(term, middle-1," IsglassOS ")
util.CenterWrite(term, middle+0,"[         ]")
util.CenterWrite(term, middle+1,"Preparing start")

if util.Speaker then
    util.Speaker.playSound("entity.experience_orb.pickup", 3)
end

sleep(2)


middle = math.floor(util.H/2) + 1
term.clear()

util.LeftWrite(term, util.W, util.H, "V"..util.VersionString(util.ReadData("IsglassOsData/version.txt")))

util.CenterWrite(term, middle-1," IsglassOS ")
util.CenterWrite(term, middle+0,"[         ]")

util.SetTextColor(term, colors.yellow)
util.CenterWrite(term, middle, "###      ")
util.SetTextColor(term, colors.white)

util.CenterWrite(term, middle+1, "Updating")

if util.Speaker then
    util.Speaker.playSound("entity.experience_orb.pickup", 3)
end


--Check for update
shell.switchTab(shell.openTab("IsglassOsSource/update.lua"))
os.pullEvent("OSupdate")


middle = math.floor(util.H/2) + 1
term.clear()

util.LeftWrite(term, util.W, util.H, "V"..util.VersionString(util.ReadData("IsglassOsData/version.txt")))

util.CenterWrite(term, middle-1," IsglassOS ")
util.CenterWrite(term, middle+0,"[         ]")

util.SetTextColor(term, colors.yellow)
util.CenterWrite(term, middle, "######   ")
util.SetTextColor(term, colors.white)

util.CenterWrite(term, middle+1, "Starting!")

if util.Speaker then
    util.Speaker.playSound("entity.experience_orb.pickup", 3)
end

sleep(2)


middle = math.floor(util.H/2) + 1
term.clear()

util.LeftWrite(term, util.W, util.H, "V"..util.VersionString(util.ReadData("IsglassOsData/version.txt")))

util.CenterWrite(term, middle-1," IsglassOS ")
util.CenterWrite(term, middle+0,"[         ]")

util.SetTextColor(term, colors.yellow)
util.CenterWrite(term, middle, "#########")
util.SetTextColor(term, colors.white)

util.CenterWrite(term, middle+1, "Starting!")

if util.Speaker then
    util.Speaker.playSound("entity.experience_orb.pickup", 3)
end

sleep(2)


--StartOS
shell.run("IsglassOsSource/main.lua")
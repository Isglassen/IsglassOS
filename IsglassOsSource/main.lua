local options = {
    {
        name = "Files",
        path = "IsglassOsData/Programs/FileSystem.lua"
    },
    {
        name = "Console",
        path = "IsglassOsData/Programs/Console.lua"
    },
    {
        name = "Help",
        path = "IsglassOsData/Programs/Help.lua"
    },
    {
        name = "Settings",
        path = "IsglassOsData/Programs/Settings.lua"
    },
    {
        name = "Power off",
        path = "IsglassOsSource/shutdown.lua"
    }
}
local osVersion = util.ReadData("IsglassOsData/version.txt").major
local option = 1
term.clear()


local function updateTime()
    --Update time
    util.LeftWrite(term, util.W, util.H-1, "Day "..os.day())
    util.LeftWrite(term, util.W, util.H, textutils.formatTime(os.time(), util.ReadData("IsglassOsData/Settings/General/time24.txt").value))

    --Set new timer
    return os.startTimer(0.8333)
end


local function updateMenu()
    local menuTop = math.floor((util.H/2) - ((#options+2)/2)) + 1
    util.CenterWrite(term, menuTop, "IsglassOS "..osVersion)
    for k, v in pairs(options) do
        term.setCursorPos(1, menuTop+1+k)
        term.clearLine()
        if option == k then
            util.SetTextColor(term, colors.yellow)
        else
            util.SetTextColor(term, colors.white)
        end
        util.CenterWrite(term, menuTop+1+k, (option == k) and "> "..v.name.." <" or v.name)
    end
    util.SetTextColor(term, colors.white)
end


if util.Color then
    local image = paintutils.loadImage("IsglassOsData/splash.img")
    local osNameY = math.floor((util.H/2) - ((#image+2)/2))+2+#image
    local osName = "IsglassOS "..util.ReadData("IsglassOsData/version.txt").major
    paintutils.drawImage(image, math.floor((util.W/2) - (#(image[1])/2)), math.floor((util.H/2) - ((#image+2)/2))+1)
    term.setCursorPos(math.floor((util.W/2) - (osName:len()/2)), osNameY)
    term.write(osName)
end

if util.Speaker then
    util.Speaker.playSound("entity.player.levelup", 3)
end
sleep(2)

term.clear()

local function runProgram(program)
    shell.switchTab(shell.openTab(program.path))
end


local timer = updateTime()
updateMenu()


while true do
    local type, p1, p2 = os.pullEventRaw()
    if type == "key" then
        if not p2 then
            if p1 == keys.down or p1 == keys.s then
                option = option + 1
                if option > #options then option = 1 end
                updateMenu()
            elseif p1 == keys.up or p1 == keys.w then
                option = option - 1
                if option < 1 then option = #options end
                updateMenu()
            elseif p1 == keys.enter then
                runProgram(options[option])
                updateMenu()
            end
        end
    elseif type == "timer" then
        if p1 == timer then
            timer = updateTime()
        end
    elseif type == "terminate" then
        shell.run("IsglassOsSource/shutdown.lua")
    elseif type == "exitOS" then
        term.clear()
        return
    elseif type == "term_resize" then
        util.W, util.H = term.getSize()
        term.clear()
        updateMenu()
        updateTime()
    end
end

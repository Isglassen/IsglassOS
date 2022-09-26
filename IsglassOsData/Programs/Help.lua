package.path = package.path..";/IsglassOsAPI/?.lua"
local util = require("util")

local pages = {
    {
        number = "1",
        data = util.ReadFile("IsglassOsData/Help/page1.txt")
    },
    {
        number = "2",
        data = util.ReadFile("IsglassOsData/Help/page2.txt")
    },
    {
        number = "3",
        data = util.ReadFile("IsglassOsData/Help/page3.txt")
    },
    {
        number = "4",
        data = util.ReadFile("IsglassOsData/Help/page4.txt")
    }
}

local function displayPage(page)
    term.clear()
    term.setCursorPos(1,1)
    util.SetTextColor(term, colors.yellow)
    print("When making a program for IsglassOS, there are a few good things to remember:")
    util.SetTextColor(term, colors.white)
    print("")
    print(page.data)
    print("")
    util.SetTextColor(term, colors.yellow)
    print("Page "..page.number.."/"..#pages..". Press [Enter] to exit")
    util.SetTextColor(term, colors.white)
end

local currentPage = 1

displayPage(pages[currentPage])

while true do
    local type, key = os.pullEvent("key")
    if key == keys.left or key == keys.a then
        if currentPage > 1 then
            currentPage = currentPage - 1
            displayPage(pages[currentPage])
        end
    elseif key == keys.right or key == keys.d then
        if currentPage < #pages then
            currentPage = currentPage + 1
            displayPage(pages[currentPage])
        end
    elseif key == keys.enter then
        break
    end
end
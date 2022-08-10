--[[
Functions:
X - Cut
C - Copy
V - Paste
D - Delete
E - Edit
O - Run
N - New File
Backspace - Quit

Enter - Open Dir (List ../ as a dir)

Bottom Display:
X[Cut] C[Copy] E[Edit] R[Run]
V[Paste] Q[Quit] D[Delete]
]]

local clipboard = ""
local cutting = false
local copying = false

local path = "IsglassOsFiles"
local dirs = {}
local files = {}
local index = 1
local fileScroll = 1

local function cut(path)
    clipboard = path
    cutting = true
    copying = false
    return true
end

local function copy(path)
    clipboard = path
    cutting = false
    copying = true
    return true
end

local function delete(path)
    if fs.isReadOnly(path) then
        return false, "Can't delete read-only file", colors.red
    end
    if clipboard == path then clipboard = "" end
    fs.delete(path)
    return true
end

local function getSelected()
    if index > #dirs then
        return files[index-#dirs]
    else
        return dirs[index].."/"
    end
end

local function paste(path)
    if copying then
        local result = shell.run("copy", clipboard, path)
        return result, "Couldn't copy all files", colors.red
    end
    if cutting then
        local result1 = shell.run("copy", clipboard, path)
        local result2 = delete(clipboard)
        cutting = false
        if result2 then
            clipboard = ""
            if not result1 then
                return false, "Couldn't copy all files", colors.red
            end
            return true
        end
        copying = true
        if not result1 then
            return false, "Couldn't copy all files", colors.red
        end
        return false, "Can't cut read-only file, changed to copying", colors.yellow
    end
    return false, "Nothing in clipboard", colors.red
end

local function run(path)
    if fs.isDir(fs.combine(path, getSelected())) then
        return false, "Can't run a directory", colors.red
    else
        shell.switchTab(shell.openTab(path))
        return true
    end
end

local function edit(path)
    if fs.isDir(fs.combine(path, getSelected())) then
        return false, "Can't edit a directory", colors.red
    else
        shell.switchTab(shell.openTab("edit "..path))
        return true
    end
end

local function listRoot()
    local list = {"IsglassOsFiles"}
    local tempFiles = fs.list(".")
    for _, file in pairs(tempFiles) do
        if fs.isDriveRoot(file) then
            table.insert(list, file)
        end
    end
    return list
end

local function listPath(path)
    if fs.isDriveRoot(path) then
        if fs.getDrive(path) == "hdd" then
            return listRoot(), {}
        end
    end
    local tempDirs = {".."}
    local tempFiles = {}
    local fileList = fs.list(path)
    for _, file in pairs(fileList) do
        if fs.isDir(fs.combine(path, file)) then
            table.insert(tempDirs, file)
        else
            table.insert(tempFiles, file)
        end
    end
    return tempDirs, tempFiles
end

local function drawInfo(message, color)
    --Display message the row under top
    util.SetTextColor(term, color)
    term.setCursorPos(1,2)
    term.write(message)
end

local function drawMain()
    term.clear()
    util.SetTextColor(term, colors.white)

    --Display Path at top
    term.setCursorPos(1,1)
    term.write(path.."/")
    term.setCursorPos(1,3)
    for i = 1, util.W, 1 do
        term.write("-")
    end

    --Display files to the left
    local highlight = getSelected()

    for i = 4, util.H-3, 1 do
        term.setCursorPos(1,i)
        local fileName = ""
        local readIndex = fileScroll + i - 4
        if readIndex > #dirs then
            fileName = files[readIndex-#dirs]
        else
            fileName = dirs[readIndex].."/"
        end
        if fileName == nil then
            break
        end
        if highlight == fileName then
            util.SetTextColor(term, colors.lightBlue)
            term.write("["..fileName.."]")
        else
            util.SetTextColor(term, colors.white)
            term.write(fileName)
        end
    end

    --Display tutorial to the right
    util.SetTextColor(term, colors.lime)
    util.LeftWrite(term, util.W, 4, "Up/W - Select File above")
    util.LeftWrite(term, util.W, 5, "Down/S - Select File below")
    util.LeftWrite(term, util.W, 6, "Enter - Open Directory")
    util.LeftWrite(term, util.W, 7, "X - Cut")
    util.LeftWrite(term, util.W, 8, "C - Copy")
    util.LeftWrite(term, util.W, 9, "V - Paste")
    util.LeftWrite(term, util.W, 10, "D - Delete")
    util.LeftWrite(term, util.W, 11, "E - Edit")
    util.LeftWrite(term, util.W, 12, "O - Run as lua")
    util.LeftWrite(term, util.W, 13, "N - New file or dir")
    util.LeftWrite(term, util.W, 14, "Backspace - Quit")
    util.LeftWrite(term, util.W, 15, "../ is the previous directory")

    --Display actions to the bottomLeft
    util.SetTextColor(term, colors.white)
    term.setCursorPos(1,util.H-2)
    for i = 1, util.W, 1 do
        term.write("-")
    end

    term.setCursorPos(1,util.H-1)
    util.SetTextColor(term, colors.yellow)
    if copying then
        term.write("Copying '"..clipboard.."'")
    elseif cutting then
        term.write("Cutting '"..clipboard.."'")
    end

    term.setCursorPos(1,util.H)
    util.SetTextColor(term, colors.red)
    
    if fs.isReadOnly(path) then
        term.write("[Read-Only]")
    end

    --DisplayMemory to the bottomRight
    util.SetTextColor(term, colors.white)
    if fs.getFreeSpace(path) ~= nil and fs.getCapacity(path) ~= nil then
        util.LeftWrite(term, util.W, util.H-1, "Remaining Space")
        util.LeftWrite(term, util.W, util.H, fs.getFreeSpace(path).."/"..fs.getCapacity(path))
    end
end



dirs, files = listPath(path)

term.setCursorPos(1,1)
print("Loading..")
sleep(0.5)

drawMain()

--Main Loop
while true do
    local type, key = os.pullEvent("key")
    local valid, message, col
    if key == keys.up or key == keys.w then
        --File above
        valid = true
        if index > 1 then
            index = index - 1
            if ((index - fileScroll) < 2) and (fileScroll > 1) then
                fileScroll = fileScroll - 1
            end
        end
    elseif key == keys.down or key == keys.s then
        --File below
        valid = true
        if index < (#dirs + #files) then
            index = index + 1
            local fileAreaSize = util.H-6
            if ((index - fileScroll) > fileAreaSize - 3) and (fileScroll < (#dirs + #files - fileAreaSize + 1)) then
                fileScroll = fileScroll + 1
            end
        end
    elseif key == keys.enter then
        --Enter directory
        if fs.isDir(fs.combine(path, getSelected())) then
            valid = true
            path = fs.combine(path, getSelected())
            index, fileScroll = 1, 1
        else
            valid, message, col = false, "That is not a directory", colors.yellow
        end
    elseif key == keys.x then
        --Cut file
        valid, message, col = cut(fs.combine(path, getSelected()))
    elseif key == keys.c then
        --Copy file
        valid, message, col = copy(fs.combine(path, getSelected()))
    elseif key == keys.v then
        --Paste file
        valid, message, col = paste(path)
    elseif key == keys.o then
        --Run file
        valid, message, col = run(fs.combine(path, getSelected()))
    elseif key == keys.d then
        --Delete file
        valid, message, col = delete(fs.combine(path, getSelected()))
    elseif key == keys.e then
        --Edit file
        valid, message, col = edit(fs.combine(path, getSelected()))
    elseif key == keys.backspace then
        --Quit
        break
    elseif key == keys.n then
        --New File
        term.clear()
        term.setCursorPos(1,1)
        print("Enter the new file name")
        print("If you want to add the file in a different directory you can use 'directory/' as many times as you want in the file name")
        print("You can ../ to refer to the previous directory")
        print("Example:")
        print("  Current path: IsglassOsFiles/Test/")
        print("  File name: ../Test2/newFile.txt")
        print("  New file location: IsglassOsFiles/Test2/newFile.txt")
        print("")
        term.write(path.."/")
        local newLocation = read()
        local newPath = fs.combine(path, newLocation)
        if not fs.exists(newPath) then
            valid, message, col = edit(newPath)
        else
            valid, message, col = false, "That file already exists", colors.red
        end
    else
        valid = true
    end
    dirs, files = listPath(path)
    drawMain()
    if not valid then
        drawInfo(message, col)
    end
end
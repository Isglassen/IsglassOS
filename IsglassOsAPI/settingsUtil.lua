local ccexpect = dofile("rom/modules/main/cc/expect.lua")
local expect, field, range = ccexpect.expect, ccexpect.field, ccexpect.range

local function contains(list, value)
    for _, v in pairs(list) do
        if v == value then return true end
    end
    return false
end

local function resolveSettingPath(path, debug)
    if debug == nil then debug = false end
    expect(1, path, "string")
    local truePath = "IsglassOsData/Settings"
    local found = false
    for dir in path:gmatch("[^/]+") do
        if debug then print("Finding "..dir) end
        if found then
            error("Already found setting, but path keeps going")
        end
        local paths = fs.list(truePath)
        for _, v in pairs(paths) do
            local tempPath = fs.combine(truePath, v)
            if debug then print("Looking at "..tempPath) end
            if fs.isDir(tempPath) then
                if debug then print(tempPath.." is a directory") end
                if util.ReadData(fs.combine(tempPath, "index.txt")).name == dir then
                    if debug then print(tempPath.." matches") end
                    truePath = tempPath
                    break
                end
            else
                if debug then print(tempPath.." is a file") end
                if util.ReadData(tempPath).name == dir then
                    if debug then print(tempPath.." matches") end
                    truePath = tempPath
                    found = true
                    break
                end
            end
        end
    end
    if not found then
        error("Didn't find a setting at specified path")
    end
    return truePath
end

function FixSettings(settingsList)
    expect(1, settingsList, "table")
    for settingURI, settingInfo in pairs(settingsList) do
        local ok, settingPath = pcall(resolveSettingPath, settingURI, true)
        if ok then
            local setting = util.ReadData(settingPath)
            local okContain, containResult = pcall(contains, setting.valid, type(setting.value))
            if not okContain then
                print("Invalid setting "..settingURI..". Set to "..tostring(settingInfo.value))
                util.WriteData(settingPath, settingInfo)
            elseif not containResult then
                print("Invalid setting "..settingURI..". Set to "..tostring(settingInfo.value))
                settingsUtil.Setting(settingPath, setting.default)
            end
        else
            print("Invalid setting "..settingURI..". Set to "..tostring(settingInfo.value))
            util.WriteData(settingPath, settingInfo)
        end
    end
end

function List(path)
    expect(1, path, "string")
    local truePath = resolveSettingPath(path)
    local files = fs.list(truePath)
    local settings = {}
    local categories = {}
    for _, settingFile in pairs(files) do
        local tempPath = fs.combine(truePath, settingFile)
        if fs.isDir(tempPath) then
            table.insert(categories, util.ReadData(fs.combine(tempPath, "index.txt")).name)
        else
            table.insert(settings, util.ReadData(tempPath).name)
        end
    end
    return categories, settings
end

function Setting(path, value)
    expect(1, path, "string")
    local settingPath = resolveSettingPath(path)
    local setting = util.ReadData(settingPath)
    expect(2, value, "nil", unpack(setting.valid))
    if type(value) == "number" then
        range(value)
    end
    if value == nil then
        return setting.value
    end
    setting.value = value
    util.WriteData(settingPath, setting)
end
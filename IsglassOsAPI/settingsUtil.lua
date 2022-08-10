local ccexpect = dofile("rom/modules/main/cc/expect.lua")
local expect, field, range = ccexpect.expect, ccexpect.field, ccexpect.range

local function contains(list, value)
    for _, v in pairs(list) do
        if v == value then return true end
    end
    return false
end

local function resolveSettingPath(path)
    expect(1, path, "string")
    local truePath = "IsglassOsData/Settings"
    local found = false
    for dir in path:gmatch("[^/]+") do
        if found then
            error("Already found setting, but path keeps going")
        end
        local paths = fs.list(truePath)
        for _, v in pairs(paths) do
            local tempPath = fs.combine(truePath, v)
            if fs.isDir(tempPath) then
                if util.ReadData(fs.combine(tempPath, "index.txt")).name == dir then
                    truePath = tempPath
                    break
                end
            else
                if util.ReadData(tempPath).name == dir then
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
        local ok, settingPath = pcall(resolveSettingPath, settingURI)
        if ok then
            local setting = util.ReadData(settingPath)
            if not contains(setting.valid, type(setting.value)) then
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
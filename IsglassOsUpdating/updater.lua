package.path = package.path..";/IsglassOsAPI/?.lua"
local util = require("util")
local settingsUtil = require("settingsUtil")

local tArgs = {...}
local oldVersion = tArgs[1]
local ownPath = tArgs[2]

local function deleteCopy(path)
    if fs.exists(path) then
        fs.delete(path)
    end
    fs.copy(ownPath.."/"..path, path)
end

local function tryCopy(path)
    if not fs.exists(path) then
        fs.copy(ownPath.."/"..path, path)
    end
end

--IsglassOsAPI
deleteCopy("IsglassOsAPI")

--IsglassOsData
deleteCopy("IsglassOsData/Programs")
tryCopy("IsglassOsData/Settings")
deleteCopy("IsglassOsData/Settings/backup.txt")
deleteCopy("IsglassOsData/changelog.txt")
tryCopy("IsglassOsData/quick.txt")
deleteCopy("IsglassOsData/splash.img")
deleteCopy("IsglassOsData/version.txt")

--Fix Broken Settings
local settingUtil = require("settingsUtil")
local util = require("util")
settingsUtil.FixSettings(util.ReadData("IsglassOsData/Settings/backup.txt"))

--IsglassOsFiles
tryCopy("IsglassOsFiles/Programs/Chat.lua")
tryCopy("IsglassOsFiles/Programs/diskSong.lua")

--IsglassOsSource
deleteCopy("IsglassOsSource")

--IsglassOsUpdating
deleteCopy("IsglassOsUpdating")

--startup.lua
deleteCopy("startup.lua")
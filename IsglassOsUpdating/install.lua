local tArgs = {...}
local ownPath = tArgs[1]
local branch = tArgs[2]

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

deleteCopy("IsglassOsAPI")
deleteCopy("IsglassOsData")
tryCopy("IsglassOsFiles")
deleteCopy("IsglassOsSource")
deleteCopy("IsglassOsUpdating")
deleteCopy("startup.lua")
deleteCopy("github.lua")

if branch ~= nil then
    local versionFile = fs.open("IsglassOsData/version.txt", "r")
    local version = textutils.unserialize(versionFile.readAll())
    versionFile.close()
    version.branch = branch
    versionFile = fs.open("IsglassOsData/version.txt", "w")
    versionFile.write(textutils.serialize(version))
    versionFile.close()
end
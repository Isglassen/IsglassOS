local tArgs = {...}
local oldVersion = tArgs[1]
if util.VersionCompare({ major = 0, update = 1, patch = 0, branch = "" }, oldVersion) then
    return false
end
return true
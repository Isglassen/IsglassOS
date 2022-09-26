package.path = package.path..";/IsglassOsAPI/?.lua"
local util = require("util")

local versionS = util.VersionString(util.ReadData("IsglassOsData/version.txt"))
print("Type the version number "..versionS.." to uninstall IsglassOS")
print("You will still keep all files inside IsglassOsFiles and the standard files of a computer")
local inputed = read()
if inputed == versionS then
    fs.delete("IsglassOsAPI")
    fs.delete("IsglassOsData")
    fs.delete("IsglassOsSource")
    fs.delete("IsglassOsUpdating")
    fs.delete("startup.lua")
    fs.delete("github.lua")
    os.reboot()
end
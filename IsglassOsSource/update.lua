package.path = package.path..";/IsglassOsAPI/?.lua"
local util = require("util")

--Check current IsglassOS version
local version = util.ReadData("IsglassOsData/version.txt")

local function checkAny(path, displayPath)
    if fs.exists(fs.combine(path,"/IsglassOsSource/checks.lua")) then
        local valid = assert(loadfile(fs.combine(path,"/IsglassOsSource/checks.lua")))()
        if valid then
            local diskVersion = util.ReadData(fs.combine(path, "/IsglassOsData/version.txt"))
            if util.VersionCompare(version, diskVersion) then
                if assert(loadfile(fs.combine(path, "/IsglassOsUpdating/canUpdate.lua")))(version) then
                    if diskVersion.branch == version.branch or diskVersion.branch == "" then
                        print("Installing new version "..util.VersionString(diskVersion))
                        assert(loadfile(fs.combine(path, "/IsglassOsUpdating/updater.lua")))(version, path)
                        return true
                    else
                        print("Found new version "..util.VersionString(diskVersion).." on "..displayPath..". Write the version number to update: ")
                        if read() == util.VersionString(diskVersion) then
                            assert(loadfile(fs.combine(path,"/IsglassOsUpdating/updater.lua")))(version, path)
                            return true
                        end
                    end
                else
                    print("Found version"..util.VersionString(diskVersion).." on "..displayPath..", but updating directly to this version is not supported")
                    print("")
                    print("Valid versions to update from:")
                    local validFile = fs.open(fs.combine(path, "/IsglassOsUpdating/valid.txt"), "r")
                    print(validFile.readAll())
                    validFile.close()
                end
            end
        end
    end
    return false
end

--Check for update online

local function checkRemote(branch, auth)
    shell.run("github Isglassen IsglassOS "..auth.." temp/ . "..branch)
    term.clear()
    local output = checkAny("temp/IsglassOS", "remote:"..branch)
    fs.delete("temp")
    return output
end

local done = false

print("If you want to download updates from online you need to enter your github authentication. This will not be saved by your program")
print("This is done to avoid rate limits, unauthorized requests have a limit of 60 request/hour/ip adress, and every computer on the server uses the server ip adress")
print("You can generate a token at https://github.com/settings/tokens")
print("Enter it in the format GithubName:Token, or leave blank if you don't want to download updates from online")
local auth = read()

if auth ~= "" and auth ~= nil then

    --Check current branch
    if version.branch ~= "" then
        done = checkRemote(version.branch, auth)
    end

    --Check main branch
    if not done then
        done = checkRemote("main", auth)
    end

end

--Check for os in disk drive
if not done then
    local drives = { peripheral.find("drive") }
    for k, drive in pairs(drives) do
        if drive.hasData() then
            done = checkAny(drive.getMountPath().."/IsglassOS", drive.getMountPath())
        end
    end
end

util.SetTextColor(term, colors.lime)
term.write("Updater has finished!")
util.SetTextColor(term, colors.white)

sleep(1)

if done then
    os.reboot()
end

os.queueEvent("OSupdate")
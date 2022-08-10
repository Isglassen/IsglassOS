--Check current IsglassOS version
local version = util.ReadData("IsglassOsData/version.txt")

--Check for os online
--NOT DONE

--Check for os in disk drive
local drives = { peripheral.find("drive") }
for k, drive in pairs(drives) do
    if drive.hasData() then
        local diskPath = drive.getMountPath().."/IsglassOS"
        if fs.exists(diskPath.."/IsglassOsSource/checks.lua") then
            local valid = assert(loadfile(diskPath.."/IsglassOsSource/checks.lua"))()
            if valid then
                local diskVersion = util.ReadData(diskPath.."/IsglassOsData/version.txt")
                if util.VersionCompare(version, diskVersion) then
                    if assert(loadfile(diskPath.."/IsglassOsUpdating/canUpdate.lua"))(version) then
                        if diskVersion.branch == version.branch or diskVersion.branch == "" then
                            print("Installing new version "..util.VersionString(diskVersion))
                            assert(loadfile(diskPath.."/IsglassOsUpdating/updater.lua"))(version, diskPath)
                        else
                            print("Found new version "..util.VersionString(diskVersion).." on "..diskPath..". Write the version number to update: ")
                            if read() == util.VersionString(diskVersion) then
                                assert(loadfile(diskPath.."/IsglassOsUpdating/updater.lua"))(version, diskPath)
                            end
                        end
                    else
                        print("Found version"..util.VersionString(diskVersion).." on "..diskPath..", but updating directly to this version is not supported")
                        print("")
                        print("Valid versions to update from:")
                        local validFile = fs.open(diskPath.."/IsglassOsUpdating/valid.txt", "r")
                        print(validFile.readAll())
                        validFile.close()
                    end
                end
            end
        end
    end
end

term.write("Updater has finished! Press any key to continue")
os.pullEvent("key")

os.queueEvent("OSupdate")
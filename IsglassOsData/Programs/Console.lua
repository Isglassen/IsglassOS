local debug = util.ReadData("IsglassOsData/Settings/System/Console/debugMode.txt").value

local OScommands = {
    commands = {
        exitOS = {
            name = "exitOS",
            use = "exitOS <password>",
            short = "Exit IsglassOS",
            help = "Exit IsglassOS and open the computer console.\nThis requires the developer password so that you can't modify the OS\ndev versions don't need a password",
            code = function (OScommands, args)
                if args[1] == "SuperSecretPassword022843" or util.ReadData("IsglassOsData/version.txt").branch == "dev" then
                    os.queueEvent("exitOS")
                    return true
                end
            end
        },
        uninstall = {
            name = "uninstall",
            use = "uninstall",
            short = "Uninstall all IsglassOS files.",
            help = "Uninstall all IsglassOS files.\nFiles from the IsglassOS file system will remain, but you will lose all settings",
            code = function (OScommands, args)
                shell.switchTab(shell.openTab("IsglassOsSource/uninstall.lua"))
            end
        },
        help = {
            name = "help",
            use = "help [commandPath]",
            short = "Get help for other commands",
            help = "No help here (yet?)",
            code = function (OScommands, args)
                if #args == 0 then
                    for k, v in pairs(OScommands.commands) do
                        util.SetTextColor(term, colors.lightBlue)
                        term.write(v.use)
                        util.SetTextColor(term, colors.white)
                        print(" - "..v.short)
                    end
                else
                    local result, err = pcall(function()
                        local command = OScommands
                        for k, v in pairs(args) do
                            command = command.commands[v]
                        end
                        if command.code then
                            util.SetTextColor(term, colors.lightBlue)
                            print(command.use)
                            util.SetTextColor(term, colors.white)
                            print(command.help)
                        else
                            for k, v in pairs(command.commands) do
                                util.SetTextColor(term, colors.lightBlue)
                                term.write(v.use)
                                util.SetTextColor(term, colors.white)
                                print(" - "..v.short)
                            end
                        end
                    end)
                    if result == false then
                        print("Couldn't get help, make sure you are wrote a valid command path")
                        if debug then print(err) end
                    end
                end
            end
        },
        close = {
            name = "close",
            use = "close",
            short = "Close the console",
            help = "Close the console",
            code = function (OScommands, args)
                return true
            end
        },
        info = {
            name = "info",
            use = "info",
            short = "Get information about the computer",
            help = "Get the computer's IsglassOS version, CraftOS version, name, and ID",
            code = function (OScommands, args)
                print("IsglassOS: "..util.VersionString(util.ReadData("IsglassOsData/version.txt")))
                print("ComputerOS: "..os.version())
                if os.getComputerLabel() then
                    print("Label: "..os.getComputerLabel())
                end
                print("ID: "..tostring(os.getComputerID()))
            end
        },
        changes = {
            name = "changes",
            use = "changes",
            short = "List the latest changes",
            help = "List the latest changes and future plans for IsglassOS",
            code = function (OScommands, args)
                local changes = fs.open("IsglassOsData/changelog.txt", "r")
                print(changes.readAll())
                changes.close()
            end
        },
        rename = {
            name = "rename",
            use = "rename [name...]",
            short = "Rename the computer",
            help = "Rename the computer to name, which can include spaces. If no name is provided the computer name is removed",
            code = function (OScommands, args)
                if #args == 0 then
                    os.setComputerLabel()
                    return
                end
                local name = table.concat(args, " ")
                os.setComputerLabel(name)
            end
        }
    }
}

term.setCursorPos(1,1)
term.clear()
print("use help for a list of commands")

while true do
    util.SetTextColor(term, colors.yellow)
    local posX, posY = term.getCursorPos()
    term.write("> ")
    local commandString = read()
    util.SetTextColor(term, colors.white)
    local commandTable = {}
    local command = OScommands
    local args = {}
    for word in commandString:gmatch("%S+") do
        table.insert(commandTable, word)
    end
    local commandDone = false
    for k, arg in pairs(commandTable) do
        if not commandDone then
            command = command.commands[arg]
            if command.code then
                commandDone = true
            end
        else
            table.insert(args, arg)
        end
    end
    local exit = command.code(OScommands, args)
    if exit then
        break
    end
end
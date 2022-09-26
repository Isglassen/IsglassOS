--Check for IsglassOS

package.path = package.path..";/IsglassOsAPI/?.lua;/IsglassOsAPI/?;/IsglassOsAPI/?/init.lua"

if not fs.exists("IsglassOsSource/checks.lua") then
    error("Din IsglassOS installation är felaktig")
end
local valid = assert(loadfile("IsglassOsSource/checks.lua"))()
if not valid then
    error("Din IsglassOS installation är felaktig")
end

--Run IsglassOS

term.clear()
shell.run("IsglassOsSource/startup")
local ccexpect = dofile("rom/modules/main/cc/expect.lua")
local expect, field, range = ccexpect.expect, ccexpect.field, ccexpect.range

W = 0
H = 0
Color = false
Speaker = nil
function ReadData(path)
    expect(1, path, "string")
    local file = fs.open(path, "r")
    local data = textutils.unserialize(file.readAll())
    file.close()
    return data
end
function ReadFile(path)
    expect(1, path, "string")
    local file = fs.open(path, "r")
    local data = file.readAll()
    file.close()
    return data
end
function WriteData(path, data)
    expect(1, path, "string")
    local file = fs.open(path, "w")
    file.write(textutils.serialize(data))
    file.close()
end
function WriteFile(path, data)
    expect(1, path, "string")
    expect(2, data, "string")
    local file = fs.open(path, "w")
    file.write(data)
    file.close()
end
function SetTextColor(terminal, color)
    expect(1, terminal, "table")
    expect(2, color, "number")
    if terminal.isColor() then
        terminal.setTextColor(color)
    end
end
function SetBackgroundColor(terminal, color)
    expect(1, terminal, "table")
    expect(2, color, "number")
    if terminal.isColor() then
        terminal.setBackgroundColor(color)
    end
end
function VersionCompare(oldVersion, newVersion)
    expect(1, oldVersion, "table")
    field(oldVersion, "major", "number")
    field(oldVersion, "update", "number")
    field(oldVersion, "patch", "number")
    field(oldVersion, "branch", "string")
    expect(2, newVersion, "table")
    field(newVersion, "major", "number")
    field(newVersion, "update", "number")
    field(newVersion, "patch", "number")
    field(newVersion, "branch", "string")
    if oldVersion.major > newVersion.major then
        return false
    elseif oldVersion.major == newVersion.major then
        if oldVersion.update > newVersion.update then
            return false
        elseif oldVersion.update == newVersion.update then
            if oldVersion.patch < newVersion.patch then
                return true
            else
                return false
            end
        else
            return true
        end
    else
        return true
    end
end
function VersionString(version)
    expect(1, version, "table")
    field(version, "major", "number")
    field(version, "update", "number")
    field(version, "patch", "number")
    field(version, "branch", "string")
    return tostring(version.major).."."..tostring(version.update).."."..tostring(version.patch)..version.branch
end
function CenterWrite(terminal, y, s)
    expect(1, terminal, "table")
    expect(2, y, "number")
    expect(3, s, "string")
    local w, h = terminal.getSize()
    terminal.setCursorPos(math.floor((w/2) - (s:len()/2)), y)
    terminal.write(s)
end
function LeftWrite(terminal, x, y, s)
    expect(1, terminal, "table")
    expect(2, x, "number")
    expect(3, y, "number")
    expect(4, s, "string")
    terminal.setCursorPos(x+1-s:len(), y)
    terminal.write(s)
end
local dfpwm = require("cc.audio.dfpwm")
local speaker = peripheral.find("speaker")

local tArgs = {...}

if speaker == nil then
    print("No speaker connected")
    return
end

local decoder = dfpwm.make_decoder()
for chunk in io.lines(tArgs[1], 16 * 1024) do
    local buffer = decoder(chunk)

    while not speaker.playAudio(buffer) do
        os.pullEvent("speaker_audio_empty")
    end
end
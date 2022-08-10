local drive = peripheral.find("drive")
if drive.hasAudio() then
    print("Started Playing "..drive.getAudioTitle())
    drive.playAudio()
    return
end
print("No disc in drive")

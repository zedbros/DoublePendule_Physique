using FFMPEG, Plots

begin

    imagesdirectory = r"./frames/frame\d.png"
    framerate = 30
    gifname = "gray_animation.gif"
    FFMPEG.ffmpeg_exe(`-framerate $(framerate) -f image2 -i $(imagesdirectory) -y $(gifname)`)

end

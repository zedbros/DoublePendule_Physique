using Images, VideoIO, FileIO

begin
    local img_path = "./img/base.png"
    local counter = 0

    local vid_path = "vids/First_Video_2s.mp4"
    local frames = openvideo(vid_path)

    function get_filtered_image(rgb_img)

        # local rgb_img = load(img_path)
        local hsv_img = HSV.(rgb_img)
        local channels = channelview(float.(hsv_img))
        local hue_img = channels[1,:,:]
        local value_img = channels[3,:,:]
        local saturation_img = channels[2,:,:]

        local mask = zeros(size(hue_img))
        local h, s, v = 360, 260, 150
        for ind in eachindex(hue_img)
            if hue_img[ind] <= h && saturation_img[ind] <= s/255 && value_img[ind] <= v/255
                mask[ind] = 1
            end
        end
        local binary_img = colorview(Gray, mask)
        counter += 1
        return binary_img
    end

    for frame in frames
        save("./frames/frame$counter.png", get_filtered_image(frame))
    end
    # close(frames)
    # img = load(img_path)
end
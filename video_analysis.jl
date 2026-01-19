using Images, VideoIO, FileIO

begin
    local img_path = "./img/base.png"
    local counter = 1

    local vid_path = "vids/First_Video_2s.mp4"
    local frames = openvideo(vid_path)


    function get_filtered_image(rgb_img)

        local hsv_img = HSV.(rgb_img)
        local channels = channelview(float.(hsv_img))
        local hue_img = channels[1,:,:]
        local value_img = channels[3,:,:]
        local saturation_img = channels[2,:,:]

        local mask = ones(size(hue_img))
        local h_min, h_max, s_min, s_max, v_min, v_max = 0, 360, 0.2, 1, 0.5, 1
        for ind in eachindex(hue_img)
            if (h_min <= hue_img[ind] && hue_img[ind] <= h_max && 
                s_min <= saturation_img[ind] && saturation_img[ind] <= s_max && 
                v_min <= value_img[ind] && value_img[ind] <= v_max)
                
                mask[ind] = 0
            end
        end
        local binary_img = colorview(Gray, mask)
        counter += 1
        return binary_img
    end

    for frame in frames
        save("./frames/frame$counter.png", get_filtered_image(frame))
    end

    close(frames)
    
end
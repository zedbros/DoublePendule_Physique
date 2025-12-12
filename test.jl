
posy = [l, 0.67]   # [m]

y = posy[end]

println(y)

push!(posy, 6)

new_y = posy[end]

println(new_y)


# if x > 0
#     new_vx = vx - sin(theta)*an*t
# elseif x < 0
#     new_vx = vx + sin(theta)*an*t
# else
#     new_vx = vx
# end

# if y > 0
#     new_vy = vy + (-cos(theta)*an  - g)*t
# elseif y < 0
#     new_vy = vy + (cos(theta)*an  - g)*t
# else
#     new_vy = vy - g*t
# end

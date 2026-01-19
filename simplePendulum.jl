using GLMakie # animation packages
using Images #, BlobTracking, VideoIO # Video analysis packages

#//////////////////////Video analysis//////////////////////


#//////////////////////Global variables//////////////////////
begin
    global gStep = 0.01
    global gLimitStep = 2
    global fps = 100
    # The step and the fps must be the same.. meaning that step = 1/fps

    global g = 9.81                     # [m/s^2]
    
    #////////////L1 section////////////
    global m1 = 0.0024                     # [kg]
    global L1 = 0.09174                 # [m]
    global theta1 = [3.15066]            # [rad]
    global angularVelocity1 = [0.3]     # [rad/s]

    global posx1 = [L1*sin(theta1[1])]
    global posy1 = [-L1*cos(theta1[1])]

    #////////////L2 section////////////
    global m2 = 0.003                     # [kg]
    global L2 = 0.06933                 # [m]
    global theta2 = [3.23707]               # [rad]
    global angularVelocity2 = [0.6]     # [rad/s]

    global posx2 = [L1*sin(theta1[1]) + L2*sin(theta2[1])]
    global posy2 = [-L1*cos(theta1[1]) - L2*cos(theta2[1])]
end

#//////////////////////Physics//////////////////////
begin
    function eulerStep(t)
        # correct_angle_for_Ft2 = 0
        # if sin(theta2[end]) < 0
        #     correct_angle_for_Ft2 = -(abs(theta2[end]) - abs(theta1[end]))
        # else
        #     correct_angle_for_Ft2 = abs(theta2[end]) - abs(theta1[end])
        # end

        angularAcceleration1 = -((sin(theta1[end])*m1*g + sin(theta2[end] - theta1[end])*cos(theta2[end])*m2*g))/(m1*L1)
        new_angularVelocity1 = angularVelocity1[end] + angularAcceleration1*t
        new_theta1 = theta1[end] + new_angularVelocity1*t

        push!(theta1, new_theta1)
        push!(angularVelocity1, new_angularVelocity1)
        push!(posx1, L1*sin(new_theta1))
        push!(posy1, -L1*cos(new_theta1))

        
        angularAcceleration2 = -(g/L2)*sin(theta2[end])
        new_angularVelocity2 = angularVelocity2[end] + angularAcceleration2*t
        new_theta2 = theta2[end] + new_angularVelocity2*t

        push!(theta2, new_theta2)
        push!(angularVelocity2, new_angularVelocity2)
        push!(posx2, (L1*sin(new_theta1) + L2*sin(new_theta2)))
        push!(posy2, (-L1*cos(new_theta1) - L2*cos(new_theta2)))
    end
end

#//////////////////////Simulation//////////////////////
begin
    function simulate(step, limitStep)
        x1 = Observable(posx1[end])
        y1 = Observable(posy1[end])

        x2 = Observable(posx2[end])
        y2 = Observable(posy2[end])

        global fig = Figure(resolution = (800, 800))
        ax = GLMakie.Axis(
            fig[1, 1],
            aspect = DataAspect(),
            limits = (-L1 - L2 - 0.1, L1 + L2 + 0.1, -L1 - L2 - 0.1, L1 + L2 + 0.1) #spaced because posy2 = L1 -L2 somehow causes an error !
        )

        #//////Rod build//////
        rod1_points = lift(x1, y1) do xb1, yb1
            Point2f[(0, 0), (xb1, yb1)]
        end
        lines!(ax, rod1_points, linewidth = 1)
        # arrows2d!(ax, rod1_points, color="red")

        rod2_points = lift(x2, y2) do xb2, yb2
            Point2f[(posx1[end], posy1[end]), (xb2, yb2)] # There may be an error caused by the starting point since I'm not sure which staged it is at (previous or current).
        end
        lines!(ax, rod2_points, linewidth = 1)
        

        #//////Bob build//////
        scatter!(ax, lift(x1, y1) do xb1, yb1
            Point2f(xb1, yb1)
        end, markersize = 17)

        scatter!(ax, lift(x2, y2) do xb2, yb2
            Point2f(xb2, yb2)
        end, markersize = 15)

        timestamps = range(0, limitStep, step = step)

        #//////Animation loop//////
        record(fig, "Double_pendulum_testing.mp4", timestamps; fps) do t
            x1[] = posx1[end]
            y1[] = posy1[end]

            x2[] = posx2[end]
            y2[] = posy2[end]

            eulerStep(step)

            # display(fig)
        end
    end
end


#//////////////////////Main//////////////////////
begin
    simulate(gStep, gLimitStep)
end

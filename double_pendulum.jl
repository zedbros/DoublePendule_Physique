using GLMakie # animation package

#//////////////////////Global variables//////////////////////
begin
    global gStep = 0.01
    global gLimitStep = 2.0
    global fps = 100                    # The step and the fps must be the same.. meaning that step = 1/fps

    global g = 9.81                     # [m/s^2]
    
    #////////////L1 section////////////
    global m1 = 0.0024                  # [kg]
    global L1 = 0.09174                 # [m]
    global theta1 = [3.15066]           # [rad]
    global angularVelocity1 = [0.3]     # [rad/s]

    global posx1 = [L1*sin(theta1[1])]
    global posy1 = [-L1*cos(theta1[1])]

    #////////////L2 section////////////
    global m2 = 0.003                   # [kg]
    global L2 = 0.06933                 # [m]
    global theta2 = [3.23707]           # [rad]
    global angularVelocity2 = [0.6]     # [rad/s]

    global posx2 = [L1*sin(theta1[1]) + L2*sin(theta2[1])]
    global posy2 = [-L1*cos(theta1[1]) - L2*cos(theta2[1])]
end

#//////////////////////Physics//////////////////////
begin
    function iterate(t)
        t1 = theta1[end]
        t2 = theta2[end]
        w1 = angularVelocity1[end]
        w2 = angularVelocity2[end]

        
        delta = t1 - t2
        den = 2.0*m1+m2-m2*cos(2.0*delta)

        angularAcceleration1 = (-g*(2.0*m1 + m2)*sin(t1) - m2*g*sin(t1 - 2.0*t2) - 2.0*m2*sin(delta)*(w2^2 * L2 + w1^2 * L1*cos(delta))) / (den * L1)
        angularAcceleration2 = (2.0*sin(delta)*(w1^2 * L1*(m1 + m2) + g*(m1 + m2)*cos(t1) + w2^2 * L2*m2*cos(delta))) / (den * L2)


        new_angularVelocity1 = w1 + angularAcceleration1*t
        new_angularVelocity2 = w2 + angularAcceleration2*t

        new_theta1 = t1 + new_angularVelocity1*t
        new_theta2 = t2 + new_angularVelocity2*t


        push!(angularVelocity1, new_angularVelocity1)
        push!(angularVelocity2, new_angularVelocity2)
        push!(theta1, new_theta1)
        push!(theta2, new_theta2)

        push!(posx1, L1*sin(new_theta1))
        push!(posy1, -L1*cos(new_theta1))
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
        rod2_points = lift(x1, y1, x2, y2) do xb1, yb1, xb2, yb2
            Point2f[(xb1, yb1), (xb2, yb2)] # Fixed.
        end
        lines!(ax, rod2_points, linewidth = 1)
        
        #//////Bob build//////
        scatter!(ax, lift(x1, y1) do xb1, yb1
            Point2f(xb1, yb1)
        end, markersize = 17)

        scatter!(ax, lift(x2, y2) do xb2, yb2
            Point2f(xb2, yb2)
        end, markersize = 15)

        #//////Animation loop//////
        timestamps = range(0.0, limitStep, step = step)
        record(fig, "new_dbl_pen.mp4", timestamps; fps) do t
            x1[] = posx1[end]
            y1[] = posy1[end]

            x2[] = posx2[end]
            y2[] = posy2[end]

            iterate(step)
            # display(fig)
        end
    end
end


#//////////////////////Main//////////////////////
begin
    simulate(gStep, gLimitStep)
end

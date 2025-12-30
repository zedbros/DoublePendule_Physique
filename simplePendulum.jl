using GLMakie

#//////////////////////Global variables//////////////////////
begin
    global gStep = 0.01
    global gLimitStep = 10

    global g = 9.81                     # [m/s^2]
    global m = 0.1                      # [kg]
    
    #////////////L1 section////////////
    global L1 = 0.5                     # [m]
    global theta1 = [3.0]               # [rad]
    global angularVelocity1 = [0.0]     # [rad/s]

    global posx1 = [L1*sin(theta1[1])]
    global posy1 = [-L1*cos(theta1[1])]

    #////////////L2 section////////////
    global L2 = 0.3                     # [m]
    global theta2 = [3.0]               # [rad]
    global angularVelocity2 = [0.0]     # [rad/s]

    global posx2 = [L2*sin(theta2[1])]
    global posy2 = [-L2*cos(theta2[1])]
end

#//////////////////////Physics//////////////////////
begin
    function eulerStep(t)
        angularAcceleration1 = -(g/L1)*sin(theta1[end])
        new_angularVelocity1 = angularVelocity1[end] + angularAcceleration1*t
        new_theta1 = theta1[end] + new_angularVelocity1*t

        push!(theta1, new_theta1)
        push!(angularVelocity1, new_angularVelocity1)
        push!(posx1, L1*sin(new_theta1))
        push!(posy1, -L1*cos(new_theta1))
    end
end

#//////////////////////Simulation//////////////////////
begin
    function simulate(step, limitStep)
        x = Observable(posx1[end])
        y = Observable(posy1[end])

        global fig = Figure(resolution = (800, 800))
        ax = Axis(
            fig[1, 1],
            aspect = DataAspect(),
            limits = (-L1-0.1, L1+0.1, -L1-0.1, L1+0.1)
        )

        #//////Rod build//////
        rod_points = lift(x, y) do xb, yb
            Point2f[(0, 0), (xb, yb)]
        end
        lines!(ax, rod_points, linewidth = 3)

        #//////Bob build//////
        scatter!(ax, lift(x, y) do xb, yb
            Point2f(xb, yb)
        end, markersize = 20)

        #//////Animation loop//////
        for i in 1:step:limitStep
            x[] = posx1[end]
            y[] = posy1[end]

            eulerStep(step)

            sleep(0.01)
            display(fig)
        end
    end
end


#//////////////////////Main//////////////////////
begin
    simulate(gStep, gLimitStep)
end

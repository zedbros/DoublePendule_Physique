using GLMakie

#//////////////////////Global variables//////////////////////
begin
    global gStep = 0.01
    global gLimitStep = 10

    global g = 9.81                # [m/s^2]
    global m = 0.5                 # [kg]
    global L = 0.5                 # [m]
    global theta = [3.0]          # [rad]
    global angularVelocity = [0.0] # [rad/s]

    global posx = [L*sin(theta[1])]
    global posy = [-L*cos(theta[1])]
end

#//////////////////////Physics//////////////////////
begin
    function eulerStep(t)
        angularAcceleration = -(g/L)*sin(theta[end])
        new_angularVelocity = angularVelocity[end] + angularAcceleration*t
        new_theta = theta[end] + new_angularVelocity*t

        push!(theta, new_theta)
        push!(angularVelocity, new_angularVelocity)
        push!(posx, L*sin(new_theta))
        push!(posy, -L*cos(new_theta))
    end
end

#//////////////////////Simulation//////////////////////
begin
    function simulate(step, limitStep)
        x = Observable(posx[end])
        y = Observable(posy[end])

        global fig = Figure(resolution = (800, 800))
        ax = Axis(
            fig[1, 1],
            aspect = DataAspect(),
            limits = (-L-0.1, L+0.1, -L-0.1, L+0.1)
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
            eulerStep(step)

            x[] = posx[end]
            y[] = posy[end]

            sleep(0.01)
            display(fig)
        end
    end
end


#//////////////////////Main//////////////////////
begin
    simulate(gStep, gLimitStep)
end

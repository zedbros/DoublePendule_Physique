using Plots

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
        # Animation
        @gif for i in 1:step:limitStep
            Plots.plot(posx, posy, label=false, title="Yes", xlims=[-0.5, 0.5], ylims=[-0.5, 0.5])
            # Incrementation
            eulerStep(step)
        end every 5
    end
end


#//////////////////////Main//////////////////////
begin
    simulate(gStep, gLimitStep)
end

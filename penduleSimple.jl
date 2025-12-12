using Plots, HypertextLiteral

#//////////////////////Global variables//////////////////////
begin
    # x is pointing [->]
    # y is pointing [down]

    global gStep = 0.1
    global gLimitStep = 10

    global g = 9.81     # [m/s^2]
    global m = 0.05     # [kg]
    global l = 0.5      # [m]
    global alpha = 0.0  # [rad]

    global posx = [0.0] # [m]
    global posy = [l]   # [m]

    global vitx = [1.2] # [m/s]
    global vity = [0.0] # [m/s]

end

#//////////////////////Physics//////////////////////
begin
    function eulerStep(t)
        x = posx[end]
        y = posy[end]
        vx = vitx[end]
        vy = vity[end]

        # my theta is the problem
        theta = tan(x/y)
        v = sqrt(vx^2 + vy^2)
        an = v^2/l


        new_x = x + vx*t
        new_y = y + vy*t

        new_vx = vx + sin(theta)*an*t
        new_vy = vy + (cos(theta)*an  - g)*t


        push!(posx, new_x)
        push!(posy, new_y)
        push!(vitx, new_vx)
        push!(vity, new_vy)
    end
end

#//////////////////////Simulation//////////////////////
begin
    function simulate(step, limitStep)
        # Animation
        @gif for i in 1:step:limitStep
            Plots.plot(posx, posy, label=false)
            Plots.plot!(title="Yes", xlims=[-10, 10])
            # Incrementation
            eulerStep(step)
        end
        
        
    end
end


#//////////////////////Main//////////////////////
begin
    simulate(gStep, gLimitStep)
end
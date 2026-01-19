using GLMakie # animation package

#//////////////////////Global variables//////////////////////
begin
    global gStep = 0.00001              # affects the precision of the iteration => lower improves accuracy
    global gLimitStep = 5               # How long the animation goes for.
    global fps = 60                     # Frames per second of the animation

    global g = 9.81                     # [m/s^2]
    
    #/////////////L1 section/////////////
    global m1 = 0.0024                  # [kg]
    global L1 = 0.09174                 # [m]
    global theta1 = [3.15066]           # [rad]
    global angularVelocity1 = [0.3]     # [rad/s]

    global posx1 = [L1*sin(theta1[1])]  # Cartesian coordination system for plotting the animation
    global posy1 = [-L1*cos(theta1[1])] # Cartesian coordination system for plotting the animation

    #/////////////L2 section/////////////
    global m2 = 0.003                   # [kg]
    global L2 = 0.06933                 # [m]
    global theta2 = [3.23707]           # [rad]
    global angularVelocity2 = [0.6]     # [rad/s]

    global posx2 = [L1*sin(theta1[1]) + L2*sin(theta2[1])]  # Cartesian coordination system for plotting the animation
    global posy2 = [-L1*cos(theta1[1]) - L2*cos(theta2[1])] # Cartesian coordination system for plotting the animation

    #///////////Tests section///////////
    global E = []
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

        # Final movement equations
        angularAcceleration1 = (-g*(2.0*m1 + m2)*sin(t1) - m2*g*sin(t1 - 2.0*t2) - 2.0*m2*sin(delta)*(w2^2 * L2 + w1^2 * L1*cos(delta))) / (den*L1)
        angularAcceleration2 = (2.0*sin(delta)*(w1^2 * L1*(m1 + m2) + g*(m1 + m2)*cos(t1) + w2^2 * L2*m2*cos(delta))) / (den*L2)

        # Velocity and angle update
        new_angularVelocity1 = w1 + angularAcceleration1*t
        new_angularVelocity2 = w2 + angularAcceleration2*t

        new_theta1 = t1 + new_angularVelocity1*t
        new_theta2 = t2 + new_angularVelocity2*t


        # Insertion into arrays for plotting
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

#//////////////////////Tests//////////////////////
function cin() # Kinetic energy of the system
    t1 = theta1[end]
    t2 = theta2[end]
    w1 = angularVelocity1[end]
    w2 = angularVelocity2[end]

    delta = t1-t2

    T1 = 0.5*m1 * (L1*w1)^2
    T2 = 0.5*m2 * (L1*w1)^2 + (L2*w2)^2 + 2*L1*L2*w1*w2*cos(delta)

    c = T1 + T2
    return c
end
function pot() # Potential energy of the system
    t1 = theta1[end]
    t2 = theta2[end]

    y1 = -L1*cos(t1)
    y2 = y1 - L2*cos(t2)

    p = m1*g*y1 + m2*g*y2
    return p
end
function energy() # Total energy of the system when called
    return cin() + pot()
end

#//////////////////////Simulation//////////////////////
begin
    function simulate()
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

        #///////////Rod build///////////
        rod1_points = lift(x1, y1) do xb1, yb1
            Point2f[(0, 0), (xb1, yb1)]
        end
        lines!(ax, rod1_points, linewidth = 1)
        rod2_points = lift(x1, y1, x2, y2) do xb1, yb1, xb2, yb2
            Point2f[(xb1, yb1), (xb2, yb2)] # Fixed.
        end
        lines!(ax, rod2_points, linewidth = 1)
        
        #///////////Bob build///////////
        scatter!(ax, lift(x1, y1) do xb1, yb1
            Point2f(xb1, yb1)
        end, markersize = 17)

        scatter!(ax, lift(x2, y2) do xb2, yb2
            Point2f(xb2, yb2)
        end, markersize = 15)

        #///////////Animation loop///////////
        function middle_steps(mid_steps) # Serves as the background calculator called proportionally in between each frame
            for i in 0:gStep:mid_steps   # so that the accuracy of the animation does not depend on the amount of chosen
                iterate(gStep)           # frames. (animates the pendulum correctly while still being very precise with the calculations)
            end
        end
        #///////////Animation loop///////////
        timestamps = range(0, gLimitStep, step = 1/fps)
        record(fig, "new_dbl_pen.mp4", timestamps; fps) do t # Handles the entire logic, whilst recording and saving the final animation.
            # Positions
            x1[] = posx1[end]
            y1[] = posy1[end]

            x2[] = posx2[end]
            y2[] = posy2[end]

            # Tests
            push!(E, energy())

            # Iterate
            middle_steps(1/fps)
        end
    end
end


#//////////////////////Main//////////////////////
begin
    simulate() # Run main (the whole double pendulum system)
    print("The variation of energy, throughout this simulation is 
    start_energy $(E[1]) - end_energy $(E[end]) = $(E[1] - E[end]). 
    It should be equal to 0, since the double pendulum follows the laws of conservation of energy.")
end

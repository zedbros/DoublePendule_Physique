using Plots, HypertextLiteral


#//////////////////////Physics//////////////////////
begin
    function x(t)
        return 2*t
    end
end

#//////////////////////Simulation//////////////////////
begin
    function simulate()
        Plots.plot([1,2,3,4,5,6,7,8,9,], [4,5,4,5,4,5,4,5,4], label="test")
        Plots.plot!(title="Simulation")
    end
end


#//////////////////////Main//////////////////////
begin
    new_x = x(5)
    print(new_x)

    simulate()
end
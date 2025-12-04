using Plots, HypertextLiteral

#//////////////////////Global variables//////////////////////
begin
    g = 9.81    #m/s^2
    m1 = 0.05   #kg
    m2 = 0.02   #kg

    x1 = []     #m
    x2 = []     #m

    v1 = []     #m/s
    v2 = []     #m/s

    
end

#//////////////////////Physics//////////////////////
begin
    function x(t)
        return 2*t
    end
end

#//////////////////////Simulation//////////////////////
begin
    function simulate()
        
    end
end


#//////////////////////Main//////////////////////
begin
    new_x = x(5)
    print(new_x)

    simulate()
end
######## The 2 plots in B.2 ########
######B2_(b)#######

# Define the parameters
σ = 0.8   #observe that σ<1
θ = 0.15  #observe that θ<1 
κ = 0.8   
c = 0.1   
η₀ = 1  
η₁ = 3  #observe that η₀ < η₁ 
r = 0.7 #high r for better visual interpretation 
γ = 0.6  # Adjust to separate curves



# Calculate v_sat and v_s based on the given formulas
v_sat = 2 * κ / (σ * θ)
v_s = (sqrt(κ * σ) + sqrt(κ * σ + ((1 - θ)^2 * κ^2) / (r * c)))^2 / 2
println("v_sat = $v_sat, v_s = $v_s")
if v_sat < v_s
    println("v_s and v_sat correctly specified")
else
    println("Warning! v_s and v_sat are not correctly specified")
end

# Set v to a value that satisfies v_s < v
v = 1.2*v_s  

# Define π_min and π_max
π_max = v - sqrt(2 * σ * κ * v * θ)


function curve1(π, r)
    return r * π 
end

function y_0_p(π, v, σ, θ, κ, c, β=0)
    return γ*((v - π)^2 / (2 * σ * v) - κ * θ )^2 / (2 * c) #changing incline for better visual representationm and fitting to (0,0)

end

function y_0_f(π, v, σ, θ, κ, c, η₀, γ=1, β=0)
    term1 = ((v - π)^2 / (2 * σ * v) - κ * θ )^2 / (2 * c)
    term2 = η₀ * ((v - π)^2 / (2 * σ * v) - κ * θ)
    term3 = η₀ * (1 - θ) * κ
    return (term1 + term2 - term3) 
end


function y_1_f(π, v, σ, θ, κ, c, η₁)
    term1 = ((v - π)^2 / (2 * σ * v) - κ * θ)^2 / (2 * c)
    term2 = η₁ * ((v - π)^2 / (2 * σ * v) - κ * θ)
    return term1 + term2 + 0.03 #for better visual - it is still the highest curve without 
end

# Adjust range of π for prettier plot
π_min=0             #########x_min will be changed again here is a holder value 
x_max = π_max 
π_values = range(π_min, stop=x_max, length=100)

# Find the intersection point where y₀ᵖ(π) and r * π intersect
curve1_values = [curve1(π, r) for π in π_values]
y_0_p_values = [y_0_p(π, v, σ, θ, κ, c) for π in π_values]
π_0_p_index = argmin(abs.(y_0_p_values .- curve1_values))
π_0_p = π_values[π_0_p_index]  # π value at the intersection
println("Intersection at π_0_p = $π_0_p")

################Adjusting for readability of the graphs######################
# Update π_values range starting from the intersection point
π_min = π_0_p-0.5  # Set the lower bound to the intersection point
π_values = range(π_min, stop=x_max, length=100)


# Recompute the curve values with the updated π_values
curve1_values = [curve1(π, r) - r*π_min for π in π_values] ## forcing through point of origin for better visual representation
y_0_p_values = [y_0_p(π, v, σ, θ, κ, c) for π in π_values]
y_0_f_values = [y_0_f(π, v, σ, θ, κ, c, η₀) for π in π_values]
y_1_f_values = [y_1_f(π, v, σ, θ, κ, c, η₁) for π in π_values]



# Plot and save the first plot
plot(π_values, 
    curve1_values, 
    xlabel="",  
    ylabel="", 
    title="",
    xticks=false, yticks=false,
    legend=false,
    top_margin=30Plots.pt, bottom_margin=30Plots.pt,
    left_margin=45Plots.pt, right_margin=30Plots.pt,
    label="", 
    lw=1.5, 
    color=:red)
plot!(π_values, y_0_p_values, label="y₀ᵖ(π)", lw=1.5, color=:black)
plot!(π_values, y_0_f_values, label="y₀ᶠ(π)", lw=1.5, color=:black)
plot!(π_values, y_1_f_values, label="y₁^f(π)", lw=1.5, color=:black)

##########scaling the axis###############
x_min = π_min #making all graphs touch the vertical axis 
x_max = π_max+0.1
xlims!(x_min,x_max)
y_min=0
y_max=y_1_f(π_min, v, σ, θ, κ, c, η₁)+0.2
ylims!(y_min,y_max)

# Note: the plot does not start at 0 on the x-axis! With the same variable values but a higher v, 
# we can achieve the same theoretical crossing points 
# but it is hard to see visually.Hence the graph has been adjusted 
# x_min_rounded = ceil(Int, x_min)

###### Annotations ##########

# Annotate axes
annotate!(x_min - 0.05, 0.1, text(L"$0$", 7))  # x-axis label
annotate!(x_min - 0.05, y_max, text(L"y", 7))  # y-axis label
annotate!(x_max + 0.05, y_min+0.12, text(L"\pi", 7))  # pi axis label


# Define the target function y₀ᵖ(π) to solve for π where y₀ᵖ(π) = 0
π_root = v - sqrt(2 * v * σ * θ * κ)
y_π_root = y_0_p(π_root, v, σ, θ, κ, c)
plot!([π_root, π_root], [y_min, y_π_root], label="", color=:grey, linestyle=:dot, lw=1)
annotate!(π_root, y_min - 0.4, text(L"v - \sqrt{2\theta \sigma \kappa v}", 7))

###### Intersections ##########
# Find the intersection between y₀ᵖ(π) and r * π
π_0_p_index = argmin(abs.(y_0_p_values .- curve1_values))
π_0_p = π_values[π_0_p_index]  # π value at the intersection
y_π_0_p = y_0_p_values[π_0_p_index]  # Corresponding y value

# Vertical dotted line for the intersection point
plot!([π_0_p, π_0_p], [y_min, y_π_0_p], label="", color=:grey, lw=1, linestyle=:dot)
annotate!(π_0_p, y_min - 0.4, text(L"\pi_0^p", 7))

# Intersection between y₀ᶠ(π) and r * π
π_0_f_index = argmin(abs.(y_0_f_values .- curve1_values))
π_0_f = π_values[π_0_f_index]
y_π_0_f = y_0_f_values[π_0_f_index]

plot!([π_0_f, π_0_f], [y_min, y_π_0_f], label="", color=:grey, lw=1, linestyle=:dot)
annotate!(π_0_f, y_min - 0.4, text(L"\pi_0^f", 7))

# Intersection between y₁^f(π) and r * π
π_1_f_index = argmin(abs.(y_1_f_values .- curve1_values))
π_1_f = π_values[π_1_f_index]
y_π_1_f = y_1_f_values[π_1_f_index]

plot!([π_1_f, π_1_f], [y_min, y_π_1_f], label="", color=:grey, lw=1, linestyle=:dot)
annotate!(π_1_f, y_min - 0.4, text(L"\pi_1^f", 7))

# y₀ᵖ(π) and y₀ᶠ(π) intercept
interception_index = argmin(abs.(y_0_p_values .- y_0_f_values))
π_interception = π_values[interception_index]
y_interception = y_0_p_values[interception_index]

plot!([π_interception, π_interception], [y_min, y_interception], label="", color=:grey, lw=1, linestyle=:dot)

# Horizontal line from (π_min, y_interception) to (π_interception, y_interception)
plot!([x_min, π_interception], [y_interception, y_interception], label="", color=:grey, lw=1, linestyle=:dot)
annotate!(x_min - 0.2, y_interception + 0.2 , text(L"\frac{(1-\theta)^2 \kappa^2}{2c}", 7))
annotate!(π_interception, y_min - 0.4, text(L"v - \sqrt{2\sigma \kappa v}", 7))

######## Curve Name Labels ##########

y_1_f_name = y_1_f(π_1_f, v, σ, θ, κ, c, η₁) + 2.1
annotate!(π_1_f-0.5, y_1_f_name, text(L"y_1^f(\pi)", 7))

y_0_f_name = y_0_f(π_0_f, v, σ, θ, κ, c, η₀) + 1.7
annotate!(π_0_f-0.35, y_0_f_name, text(L"y_0^f(\pi)", 7))

y_0_p_name = y_0_p(π_0_p, v, σ, θ, κ, c)+0.8
π_name = π_0_p-0.6
annotate!(π_name, y_0_p_name, text(L"y_0^p(\pi)", 7))

y_rpi = r*(x_max-x_min)+0.2
annotate!(π_max-0.1, y_rpi, text(L"r\pi", 7, color=:red))

######## F Labels ##########removed according to instruction
#x_f_low = 0.5 * (x_min + π_0_p)
#annotate!(x_f_low, y_min - 1.2, text(L"$F_{low}$", 7))
#x_f_med = 0.5 * (π_0_p + π_1_f)
#annotate!(x_f_med, y_min - 1.2, text(L"$F_{med}$", 7))
#x_f_high = 0.5 * (π_1_f + π_root)
#annotate!(x_f_high, y_min - 1.2, text(L"$F_{high}$", 7))

##### Plot Name Label ######
name_label = y_0_f(π_min, v, σ, θ, κ, c, η₀)
annotate!(π_max-0.5, name_label, text(L"$v>v_s$", 8))

display(plot!)

savefig(joinpath(output_dir, "B2_(b)_high_v.pdf"))
savefig(joinpath(output_dir, "B2_(b)_high_v.png"))

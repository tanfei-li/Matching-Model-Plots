######## The 2 plots in B.2 ########
######B2_(a)#######


# Parameters
σ = 0.8   # Moderate σ for sharper curves
θ = 0.15   # Adjusted θ
κ = 0.8   # Keep κ constant for simplicity
c = 0.1   # Lower c for sharper intersections
η₀ = 1.5  # Lower η₀ to ensure y₀ᶠ is not always above y₀ᵖ
η₁ = 3  # Keep η₁ constant
r = 0.2  # Reduce r for a flatter rπ curve


# Calculate v_sat and v_s based on the given formulas
v_sat = 2 * κ / (σ * θ)
v_s = (sqrt(κ * σ) + sqrt(κ * σ + ((1 - θ)^2 * κ^2) / (r * c)))^2 / 2
println("v_sat = $v_sat, v_s = $v_s")
if v_sat < v_s
    println("v_s and v_sat correctly specified")
else
    println("Warning! v_s and v_sat are not correctly specified")
end

# Set v to a value that satisfies v_sat < v < v_s
v = 1.2*v_sat  # A value between v_s and v_sat - chosen to be relatively small for a prettier plot

# Check that v is between v_s and v_sat
if v_sat < v < v_s
    println("v is correctly set between v_sat and v_s.")
else
    println("Warning: v is not between v_sat and v_s. Adjust the value of v.")
end

# Define π_min and π_max
π_min = v - sqrt(2 * σ * κ * v)
π_max = v - sqrt(2 * σ * κ * v * θ)

# Check that π_min is positive
if π_min > 0
    println("π_min is positive: π_min = $π_min.")
else
    println("Warning: π_min is not positive. Adjust parameters to ensure π_min > 0.")
end

# Adjust range of π for prettier plot
x_min=π_min-0.3
x_max=π_max+0.2
π_values = range(x_min, stop=x_max, length=100)

function curve1(π, r)
    return r * π - x_min*r  #fitting through (0,0) visually
end

function y_0_p(π, v, σ, θ, κ, c) 
    return ((v - π)^2 / (2 * σ * v) - κ * θ )^2 / (2 * c)   # +1 for better visual effect
end

function y_0_f(π, v, σ, θ, κ, c, η₀)
    term1 = ((v - π)^2 / (2 * σ * v) - κ * θ )^2 / (2 * c)
    term2 = η₀ * ((v - π)^2 / (2 * σ * v) - κ * θ)
    term3 = η₀ * (1 - θ) * κ
    return term1 + term2 - term3  # +1 for better visual effect
end

function y_1_f(π, v, σ, θ, κ, c, η₁)
    term1 = ((v - π)^2 / (2 * σ * v) - κ * θ)^2 / (2 * c)
    term2 = η₁ * ((v - π)^2 / (2 * σ * v) - κ * θ)
    return term1 + term2  # +1 for better visual effect
end

# Calculate values for each curve
curve1_values = [curve1(π, r) for π in π_values]
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
    top_margin=30Plots.pt, bottom_margin=25Plots.pt,
    left_margin=45Plots.pt, right_margin=30Plots.pt,
    label="", 
    lw=1.5, 
    color=:red)
plot!(π_values, y_0_p_values, label="y₀ᵖ(π)", lw=1.5, color=:black)
plot!(π_values, y_0_f_values, label="y₀ᶠ(π)", lw=1.5, color=:black)
plot!(π_values, y_1_f_values, label="y₁^f(π)", lw=1.5, color=:black)

#####selecting the scale of the axis: also used in positioning of labels#########
xlims!(x_min,x_max+0.3)
y_min=y_0_f(x_max, v, σ, θ, κ, c, η₀)
y_max=y_1_f(x_min, v, σ, θ, κ, c, η₁)+0.2
ylims!(y_min,y_max)

######annotations##########

hline!([0], lw=1, linestyle=:dash, color=:gray, label="") 
annotate!(x_min-0.1,0, text(L"$0$", 7))
annotate!(x_min - 0.1, y_max, text(L"y", 7))
annotate!(x_max+0.3, y_min-0.17, text(L"\pi", 7))

# Define the target function y₀ᵖ(π) to solve for π where y₀ᵖ(π) = 0
π_root = v - sqrt(2 * v * σ * θ * κ)
y_π_root = y_0_p(π_root, v, σ, θ, κ, c)
plot!([π_root, π_root], [y_min, y_π_root], label="", color=:grey, linestyle=:dash, lw=1)
annotate!(π_root, y_min-0.15, text(L"v - \sqrt{2\theta \sigma \kappa v}", 7))

######intersections##########
# Find the index where y₀ᵖ(π) and r * π intersect
π_0_p_index = argmin(abs.(y_0_p_values .- curve1_values))
π_0_p = π_values[π_0_p_index]  # π value at the intersection
y_π_0_p = y_0_p_values[π_0_p_index]  # Corresponding y value

# Vertical dotted line for the intersection point
plot!([π_0_p, π_0_p], [y_min, y_π_0_p],  # Adjust lower limit if needed (was -1.8)
    label="", 
    color=:grey, 
    lw=1, 
    linestyle=:dash)
annotate!(π_0_p, y_min-0.17, text(L"\pi_0^p", 7))  # Adjust y-position to make annotation visible

# Find the interception point between y₀ᶠ(π) and r*pi
π_0_f_index = argmin(abs.(y_0_f_values .- curve1_values))
π_0_f = π_values[π_0_f_index]  # π value at the intersection
y_π_0_f = y_0_f_values[π_0_f_index]  # Corresponding y value
# dotted lines for the interception point
# Vertical line from (π_interception, 0) to (π_interception, y_interception)
plot!([π_0_f, π_0_f], [y_min, y_π_0_f], 
    label="", 
    color=:grey, 
    lw=1, 
    linestyle=:dash)
annotate!(π_0_f, y_min-0.17, text(L"\pi_0^f", 7)) 

# Find the interception point between y₁^f(π) and r*pi
π_1_f_index = argmin(abs.(y_1_f_values .- curve1_values))
π_1_f = π_values[π_1_f_index]  # π value at the intersection
y_π_1_f = y_1_f_values[π_1_f_index]  # Corresponding y value
# dotted lines for the interception point
# Vertical line from (π_interception, 0) to (π_interception, y_interception)
plot!([π_1_f, π_1_f], [y_min, y_π_1_f], 
    label="", 
    color=:grey, 
    lw=1, 
    linestyle=:dash)
annotate!(π_1_f, y_min-0.17, text(L"\pi_1^f", 7))


#y₀ᵖ(π) and y₀ᶠ(π) intercept
interception_index = argmin(abs.(y_0_p_values .- y_0_f_values))
π_interception = π_values[interception_index]
y_interception = y_0_p_values[interception_index]  # Same as y₀ᶠ(π) at the intersection
# Vertical line from (π_interception, 0) to (π_interception, y_interception)
plot!([π_interception, π_interception], [y_min, y_interception], 
    label="", 
    color=:grey, 
    lw=1, 
    linestyle=:dash)

# Horizontal line from (π_min, y_interception) to (π_interception, y_interception)
plot!([x_min, π_interception], [y_interception, y_interception], 
    label="", 
    color=:grey, 
    lw=1, 
    linestyle=:dash)
#Annotation
annotate!(x_min-0.2, y_interception, text(L"\frac{(1-\theta)^2 \kappa^2}{2c}", 7))
annotate!(π_interception, y_min-0.17, text(L"v - \sqrt{2\sigma \kappa v}", 7))

########curve name labels#######
x_curve_name = π_0_f - 0.4
y_0_f_name = y_0_f(x_curve_name, v, σ, θ, κ, c, η₀)-0.3
annotate!(x_curve_name,y_0_f_name, text(L"y_0^f(\pi)", 7))
x_curve_name = π_0_f - 0.2
y_0_p_name = y_0_p(x_curve_name, v, σ, θ, κ, c)+0.24
annotate!(x_curve_name,y_0_p_name, text(L"y_0^p(\pi)", 7))
y_1_f_name = y_1_f(x_curve_name, v, σ, θ, κ, c, η₁)+0.3
annotate!(x_curve_name+0.05,y_1_f_name, text(L"y_1^f(\pi)", 7))
y_rpi=r*π_root-r*x_min+0.1
annotate!(π_root,y_rpi,text(L"r\pi",7, color=:red))

########F Labels#######
x_f_low = 0.5*(π_0_f+π_0_p)
annotate!(x_f_low,y_min-0.5, text(L"$F_{low}$", 7))
x_f_med = 0.5*(π_0_p+π_1_f)
annotate!(x_f_med,y_min-0.5, text(L"$F_{medium}$", 7))
x_f_high = 0.5*(π_1_f+π_root)
annotate!(x_f_high,y_min-0.5, text(L"$F_{high}$", 7))

#####plot name label##
y_plot_name = y_1_f(π_min, v, σ, θ, κ, c, η₁)
annotate!(π_1_f,y_plot_name, text(L"$v<v_s$", 8))

savefig(joinpath(output_dir, "B2_(a)_high_v.png"))
savefig(joinpath(output_dir, "B2_(a)_high_v.pdf"))
display(plot!)








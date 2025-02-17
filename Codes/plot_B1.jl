
#Plot B1#
# Parameters
σ = 0.8   # Moderate σ for sharper curves
θ = 0.15   # Adjusted θ
κ = 0.8   # Keep κ constant for simplicity
c = 0.1   # Lower c for sharper intersections
r = 0.2  # Reduce r for a flatter rπ curve
v = 3(2 * κ / (σ * θ))

# Define threshold and π_max
threshold = (1-σ * θ)*v # when pi > threshold, the function changes from the non-sat setup to the sat setup
π_max = v - sqrt(2 * σ * κ * v * θ) # this is where non-sat curve reaches y = 0

# Adjust range of π for prettier plot
x_min= threshold - 0.5 ###here the x-axis is adjusted to make the graph easier to read. 
x_max=π_max ###adjusting x_axis range for better representation
π_sat = range(x_min, stop=threshold, length=100)
π_nonsat = range(threshold, stop=x_max, length=100) ### 
π_values = range(x_min, stop=x_max, length=100)

function yp_sat(π, v, σ, θ, κ, c)
    return (θ * v * (1 - θ * σ / 2) - θ * π - κ * θ)^2 / (2c)
end

function yp_nonsat(π, v, σ, θ, κ, c) 
    return ((v - π)^2 / (2 * σ * v) - κ * θ )^2 / (2 * c)  
end
yp_sat_values = [yp_sat(π, v, σ, θ, κ, c) for π in π_sat]
yp_nonsat_values = [yp_nonsat(π, v, σ, θ, κ, c) for π in π_nonsat]


function curve1(π, r)
    return r * π - r*x_min #fitting through (0,0) visually - to be rigorous, we can set x_min to 0 and choose a higher v value to make sure that r*pi crosses the non_sat curve 
end
# Calculate values for each curve

yp_sat_values = [yp_sat(π, v, σ, θ, κ, c) for π in π_sat]
yp_nonsat_annotation = [yp_nonsat(π, v, σ, θ, κ, c) for π in π_values] #this is needed to locate the right π_0_p
yp_nonsat_values = [yp_nonsat(π, v, σ, θ, κ, c) for π in π_nonsat]
curve1_values = [curve1(π, r) for π in π_values]

##################
# Plot and save the first plot
custom_grey = RGB(0.6, 0.6, 0.6)
plot(π_values, 
    curve1_values, 
    xlabel="",  
    ylabel="", 
    title="",
    xticks=false, yticks=false,
    legend=false,
    top_margin=30Plots.pt, bottom_margin=25Plots.pt,
    left_margin=65Plots.pt, right_margin=30Plots.pt,
    label="", 
    lw=1.5, 
    color=:red)
plot!(π_sat, yp_sat_values, label="yp_high(π)", linestyle=:solid, color=custom_grey, linewidth=1.5)
plot!(π_nonsat, yp_nonsat_values, label="yp_low(π)", linestyle=:solid, color=:black, linewidth=1.5)

#to show kink#
#yp_sat_values_further = [yp_sat(π, v, σ, θ, κ, c) for π in π_nonsat]
#plot!(π_nonsat, yp_sat_values_further, label="yp_high(π)", linestyle=:dash, color=:lightgrey, linewidth=1.5)

#scaling the axes
xlims!(x_min,x_max+0.2)
y_max = maximum(yp_sat_values)+0.01
y_min = minimum(curve1_values)
ylims!(y_min, y_max)

###annotations###
kink = yp_sat(threshold, v, σ, θ, κ, c)
plot!([x_min, threshold], [kink, kink],  label="", color=:grey, linestyle=:dot, lw=1) #horizontal 
annotate!(x_min-0.25, kink, text(L"\frac{\theta^2 \left( \frac{v \theta \sigma}{2} - \kappa \right)^2}{2c}", 7))

plot!([threshold, threshold], [y_min, kink],label="", linestyle=:dot, color=:grey) #vertical
annotate!(threshold, y_min-0.014, text(L"(1 - \sigma\theta)v", 7))

rpi = curve1(threshold,r)
plot!([x_min, threshold], [rpi,rpi],  label="", color=:grey, linestyle=:dot, lw=1) #horizontal 
annotate!(x_min-0.2, rpi, text(L"r(1 - \sigma\theta)v", 7))


# Find the intersection index only for π values greater than threshold
valid_indices = findall(π -> π > threshold, π_values)  # Get indices where π > threshold

# Find the index where the difference is minimized within the valid range
π_0_p_index = valid_indices[argmin(abs.(yp_nonsat_annotation[valid_indices] .- curve1_values[valid_indices]))]

# Get the corresponding π and y values
π_0_p = π_values[π_0_p_index]
y_π_0_p = yp_nonsat_annotation[π_0_p_index]

plot!([π_0_p, π_0_p], [y_min, y_π_0_p], 
    label="", 
    color=:grey, 
    lw=1, 
    linestyle=:dot)
annotate!(π_0_p, y_min-0.014, text(L"\pi_0^p", 7)) 

##other annotations##
annotate!(x_max, y_min-0.014, text(L"v - \sqrt{2\theta\kappa\sigma v}", 7))

annotate!(x_max+0.25, y_min, text(L"\pi", 7))
annotate!(x_max-0.1, maximum(curve1_values),text(L"r\pi", 8))

label = (x_min + threshold)/2
curve_label = yp_sat(label, v, σ, θ, κ, c)
annotate!(label, curve_label+0.05, text(L"y^p(\pi)",8))
#########################3

savefig(joinpath(output_dir, "B1.pdf"))
savefig(joinpath(output_dir, "B1.png"))
display(plot!)

#to show kink#
yp_sat_values_further = [yp_sat(π, v, σ, θ, κ, c) for π in π_nonsat]
plot!(π_nonsat, yp_sat_values_further, label="yp_high(π)", linestyle=:dash, color=:lightgrey, linewidth=1.5)
savefig(joinpath(output_dir, "B1_kink.pdf"))
savefig(joinpath(output_dir, "B1_kink.png"))
display(plot!)
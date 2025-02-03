######## Figure 7: Effect of the program on the decision to create a vacancy ########

σ = 0.8   
θ = 0.15   
κ = 0.8   
c = 0.1
η₀ = 5 ##scaled up for kink between pi_p and pi_f
η₁ = 5.5 ##scaled up for a clearer plot  
r = 0.2  

# Calculate v_sat and v_s with adjusted parameters
v_sat = 2 * κ / (σ * θ)
v_s = (sqrt(κ * σ) + sqrt(κ * σ + ((1 - θ)^2 * κ^2) / (r * c)))^2 / 2

# Define ranges of v
v_max = v_s + 1.5
v_values_0_p = range(v_sat, stop=v_s, length=200)
v_values_0_f = range(v_s, stop=v_max, length=200)
v_values_all = range(v_sat, stop=v_max, length=200)

# Define functions for each equation
function π_0_p_eq(π, v, σ, θ, κ, c)
    left_side = ((v - π)^2 / (2 * σ * v - κ * θ))^2 * (1 / (2 * r * c))
    return left_side - π
end

function π_0_f_eq(π, v, σ, θ, κ, c, η₀)
    term1 = ((v - π)^2 / (2 * σ * v - κ * θ))^2 * (1 / (2 * r * c))
    term2 = η₀ / r * ((v - π)^2 / (2 * σ * v - κ * θ))
    term3 = η₀ / r * (1 - θ) * κ
    return term1 + term2 - term3 - π
end

function π_1_f_eq(π, v, σ, θ, κ, c, η₁)
    term1 = ((v - π)^2 / (2 * σ * v - κ * θ))^2 * (1 / (2 * r * c))
    term2 = η₁ / r * ((v - π)^2 / (2 * σ * v - κ * θ))
    return term1 + term2 - π
end
# Solve for π_0^p(v) for v in v_values_0_p
π_0_p_values = Float64[]
for v in v_values_0_p
    sol = nlsolve(x -> π_0_p_eq(x[1], v, σ, θ, κ, c), [0.5 * v])
    push!(π_0_p_values, sol.zero[1])
end

# Solve for π_0_p(v_s) at conituity point 
sol_π_0_p_v_s = nlsolve(x -> π_0_p_eq(x[1], v_s, σ, θ, κ, c), [0.5 * v_s])
π_0_p_v_s = sol_π_0_p_v_s.zero[1]

# Define modified π_0_f function to enforce continuity at v_s
function π_0_f_continuous(v)
    if v == v_s
        return π_0_p_v_s
    else
        sol = nlsolve(x -> π_0_f_eq(x[1], v, σ, θ, κ, c, η₀), [0.5 * v])
        return sol.zero[1]
    end
end

# Solve for π_0^f(v) for v in v_values_0_f using the modified function
π_0_f_values = [π_0_f_continuous(v) for v in v_values_0_f]

# Solve for π_1^f(v) for v in v_values_all
π_1_f_values = Float64[]
for v in v_values_all
    sol = nlsolve(x ->π_1_f_eq(x[1], v, σ, θ, κ, c, η₁), [0.5 * v])
    push!(π_1_f_values, sol.zero[1])
end


# Plotting##########
custom_grey = RGB(0.6, 0.6, 0.6)
plot(
    v_values_0_p, π_0_p_values, lw=1.5,
    label=L"",
    xlabel="",  
    ylabel="", 
    title="",
    xticks=false, yticks=false,
    legend=false,
    top_margin=30Plots.pt, bottom_margin=25Plots.pt,
    left_margin=30Plots.pt, right_margin=30Plots.pt,
    linecolor=custom_grey
)

plot!(v_values_0_f, π_0_f_values, lw=1.5, label=L"", linecolor=:black)
plot!(v_values_all, π_1_f_values, lw=1.5, label=L"", linecolor=:black)
### horizontal and vertical axis limits ### 
x_min = v_sat + 0.1
x_max = maximum(v_values_all)
xlims!(x_min,x_max )
sol_π_1_f_v_max = nlsolve(x -> π_1_f_eq(x[1], v_max, σ, θ, κ, c, η₁), [0.5 * v_max])
y_max = sol_π_1_f_v_max.zero[1]
y_min = minimum(vcat(π_0_p_values, π_0_f_values, π_1_f_values)) - 0.5
ylims!(y_min, y_max)

##### Add vertical and horizontal lines
# F low 
# Calculate π_0^p at v = (3v_s + v_sat) / 4 to be F value chosen
v_F = (3v_s + v_sat) / 4
sol_π_0_p_v_F = nlsolve(x -> π_0_p_eq(x[1], v_F, σ, θ, κ, c), [0.5 * v_F])
π_F = sol_π_0_p_v_F.zero[1]
hline!([π_F], lw=1, linestyle=:solid, linecolor=:blue, label="") #F low 

#F high
# Calculate π_0_f at v = (v_s + v_max)/2 to be high F value chosen
v_F_h = (v_s + v_max)/2
sol_π_0_f_v_F_h = nlsolve(x -> π_0_f_eq(x[1], v_F_h, σ, θ, κ, c,η₀), [0.5 * v_F_h])
π_F_h = sol_π_0_f_v_F_h.zero[1]
hline!([π_F_h], lw=1, linestyle=:dot, linecolor=:blue, label="") #F high 

#vertical line at v_s
plot!([v_s, v_s], [π_0_p_v_s, y_min], linestyle=:dashdotdot, linecolor=:grey, label="")

# Labelling the curves
v_label = v_s - 0.4
sol_π_0_p_label = nlsolve(x -> π_0_p_eq(x[1], v_label, σ, θ, κ, c), [0.5 * v_label])
π_0_p_label_value = sol_π_0_p_label.zero[1]
annotate!(v_label, π_0_p_label_value + 0.35, text(L"\pi_0^p(v)", 8, :left))
annotate!(maximum(v_values_all)-0.4, π_0_f_values[end], text(L"\pi_0^f(v)", 8, :left))
annotate!(maximum(v_values_all)-0.4, π_1_f_values[end], text(L"\pi_1^f(v)", 8, :left))

# Annotations
#v_s and v_sat
annotate!(x_min, y_min - 0.2, text(L"v_{sat}", 8))
annotate!(v_s, y_min - 0.2, text(L"v_s", 8))
##labels to F and F'
annotate!(x_min - 0.15, π_F, text(L"F", 8, :left)) #F
annotate!(x_min - 0.15, π_F_h, text(L"F\,'", 8, :left)) #F' - high F 


# Annotate axis labels at the end of the axes at chosen points
annotate!(x_max, y_min - 0.2, text(L"v", 8))
annotate!(x_min - 0.1, y_max, text(L"\pi(v)", 8))

############labeling all the effects along F and F high #########
# A # 
function find_v_for_pi_1_f(π_F, σ, θ, κ, c, η₁, x_min, x_max)
    sol = nlsolve(v -> π_1_f_eq(π_F, v[1], σ, θ, κ, c, η₁), [0.5 * (x_min + x_max)])
    return sol.zero[1]
end

# Call the function to find v_value
v_A_value = find_v_for_pi_1_f(π_F, σ, θ, κ, c, η₁, x_min, x_max)

# Find the midpoint between v_value and x_min
v_A = (v_A_value + x_min) / 2
annotate!(v_A, π_F - 0.12, text(L"A", 8, color=:blue))

# B #
function find_v_for_pi_0_p(π_F, σ, θ, κ, c, x_min, x_max)
    sol = nlsolve(v -> π_0_p_eq(π_F, v[1], σ, θ, κ, c), [0.5 * (x_min + x_max)])
    return sol.zero[1]
end
# Call the function to find v_value
v_B_value = find_v_for_pi_0_p(π_F, σ, θ, κ, c, x_min, x_max)
v_B = (v_B_value + x_min) / 2
annotate!(v_B, π_F - 0.12, text(L"B", 8, color=:blue))

# C #
v_C = (v_B_value + v_s) / 2
annotate!(v_C, π_F - 0.12, text(L"C", 8, color=:blue))

# D #
v_D = (v_s + x_max) / 2
annotate!(v_D, π_F - 0.12, text(L"D", 8, color=:blue))

###align F high###
#A\,'#
function find_v_for_pi_1_f(π_F_h, σ, θ, κ, c, η₁, x_min, x_max)
    sol = nlsolve(v -> π_1_f_eq(π_F_h, v[1], σ, θ, κ, c, η₁), [0.5 * (x_min + x_max)])
    return sol.zero[1]
end
# Call the function to find v_value
v_A_value = find_v_for_pi_1_f(π_F_h, σ, θ, κ, c, η₁, x_min, x_max)
# Find the midpoint between v_value and x_min
v_A = (v_A_value + x_min) / 2
annotate!(v_A, π_F_h - 0.12, text(L"A\,'", 8, color=:blue))

#B\,'#
function find_v_for_pi_0_f(π_F_h, σ, θ, κ, c, η₀, x_min, x_max)
    sol = nlsolve(v -> π_0_f_eq(π_F_h, v[1], σ, θ, κ, c, η₀), [0.5 * (x_min + x_max)])
    return sol.zero[1]
end
# Call the function to find v_value
v_B_value = find_v_for_pi_0_f(π_F_h, σ, θ, κ, c, η₀, x_min, x_max)
v_B = (v_B_value + v_A_value) / 2
annotate!(v_B, π_F_h - 0.12, text(L"B\,'", 8, color=:blue))

#C\,'#
v_C = (v_B_value + x_max) / 2
annotate!(v_C, π_F_h - 0.12, text(L"C\,'", 8, color=:blue))

# Save and display plot
savefig(joinpath(output_dir, "Fig_7.pdf"))
savefig(joinpath(output_dir, "Fig_7.png"))
display(plot!)


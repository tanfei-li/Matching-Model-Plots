######## Figure 8: Effect of the program on the decision to create a vacancy: slack and dynamic markets ########
σ = 0.8   
θ = 0.15   
κ = 0.8 
q_h = 0.35 
c_unscaled = 0.01225
c = c_unscaled/(q_h)^2  ##arbitrary choice of unscaled cost for a fitting c value 
η₀ = 5 
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

# Solve for π_0^p(v_s)
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


# Adjust c to c_lowq ###########
q_l = 0.346  ## < q_h = 0.35, tighter market
c_unscaled = 0.01225
c_lowq = c_unscaled/(q_l)^2

# Recalculate v_s with adjusted c_lowq
v_s_lowq = (sqrt(κ * σ) + sqrt(κ * σ + ((1 - θ)^2 * κ^2) / (r * c_lowq)))^2 / 2

# Define new ranges of v
v_values_0_p_lowq = range(v_sat, stop=v_s_lowq, length=200)
v_values_0_f_lowq = range(v_s_lowq, stop=v_max, length=200)
v_values_all_lowq = range(v_sat, stop=v_max, length=200)

# Solve for π_0_p(v) for v in v_values_0_p_lowq
π_0_p_values_lowq = Float64[]
for v in v_values_0_p_lowq
    sol = nlsolve(x -> π_0_p_eq(x[1], v, σ, θ, κ, c_lowq), [0.5 * v])
    push!(π_0_p_values_lowq, sol.zero[1])
end

# Solve for π_0_p(v_s_lowq)
sol_π_0_p_v_s_lowq = nlsolve(x -> π_0_p_eq(x[1], v_s_lowq, σ, θ, κ, c_lowq), [0.5 * v_s_lowq])
π_0_p_v_s_lowq = sol_π_0_p_v_s_lowq.zero[1]

# Define modified π_0_f function to enforce continuity at v_s_lowq
function π_0_f_continuous_lowq(v)
    if v == v_s_lowq
        return π_0_p_v_s_lowq
    else
        sol = nlsolve(x -> π_0_f_eq(x[1], v, σ, θ, κ, c_lowq, η₀), [0.5 * v])
        return sol.zero[1]
    end
end

# Solve for π_0^f(v) for v in v_values_0_f_lowq using the modified function
π_0_f_values_lowq = [π_0_f_continuous_lowq(v) for v in v_values_0_f_lowq]

# Solve for π_1^f(v) for v in v_values_all_lowq
π_1_f_values_lowq = Float64[]
for v in v_values_all_lowq
    sol = nlsolve(x ->π_1_f_eq(x[1], v, σ, θ, κ, c_lowq, η₁), [0.5 * v])
    push!(π_1_f_values_lowq, sol.zero[1])
end


custom_grey = RGB(0.6, 0.6, 0.6)
# Plot the results
plot(
    v_values_0_p, π_0_p_values, lw=1.5, label=L"", xlabel="", ylabel="", title="",
    xticks=false, yticks=false, legend=false,
    top_margin=30Plots.pt, bottom_margin=25Plots.pt,
    left_margin=30Plots.pt, right_margin=30Plots.pt, linecolor=custom_grey
)
plot!(v_values_0_f, π_0_f_values, lw=1.5, linecolor=:black, label=L"")
plot!(v_values_all, π_1_f_values, lw=1.5, linecolor=:black, label=L"")

##offsetting the low_q results for better visualisation
offset_value = 0.4
π_0_p_values_offset = [π - offset_value for π in π_0_p_values_lowq]
π_0_f_values_offset = [π - offset_value for π in π_0_f_values_lowq]
π_1_f_values_offset = [π - offset_value for π in π_1_f_values_lowq]

plot!(v_values_0_p_lowq, π_0_p_values_offset, lw=1.5, linecolor=custom_grey, linestyle=:dash, label=L"")
plot!(v_values_0_f_lowq, π_0_f_values_offset, lw=1.5, linecolor=:black, linestyle=:dash, label=L"")
plot!(v_values_all_lowq, π_1_f_values_offset, lw=1.5, linecolor=:black, linestyle=:dash, label=L"")

xlims!(v_sat + 0.1, v_max)

########################################Annotations########################################
### horizontal and vertical axis limits ### 
x_min = v_sat + 0.1
x_max = maximum(v_values_all)
xlims!(x_min,x_max )
sol_π_1_f_v_max = nlsolve(x -> π_1_f_eq(x[1], v_max, σ, θ, κ, c, η₁), [0.5 * v_max])
y_max = sol_π_1_f_v_max.zero[1]
y_min = minimum(vcat(π_0_p_values, π_0_f_values, π_1_f_values)) - 0.5
ylims!(y_min, y_max)




##### Add vertical and horizontal lines
# F line
# Calculate π_0^p at v = (1.5 v_s + v_sat) / 2.5 to be F value chosen
v_F = (1.5*v_s + v_sat) / 2.5
sol_π_0_p_v_F = nlsolve(x -> π_0_p_eq(x[1], v_F, σ, θ, κ, c), [0.5 * v_F])
π_F = sol_π_0_p_v_F.zero[1]
hline!([π_F], lw=1, linestyle=:solid, linecolor=:blue, label="") #F low 


#vertical line at v_s and v_s_lowq
plot!([v_s, v_s], [π_0_p_v_s, y_min], linestyle=:dashdotdot, linecolor=:grey, label="")
plot!([v_s_lowq, v_s_lowq], [π_0_p_v_s_lowq-offset_value, y_min], linestyle=:dot, linecolor=:grey, label="")

# Labelling the curves
v_label = (v_s_lowq + x_min)/2
sol_π_0_p_label = nlsolve(x -> π_0_p_eq(x[1], v_label, σ, θ, κ, c), [0.5 * v_label])
π_0_p_label_value = sol_π_0_p_label.zero[1]
annotate!(v_label, π_0_p_label_value - 0.13, text(L"\pi_0^p(v)", 8, :left, color=:black))
annotate!(maximum(v_values_all)-0.4, π_0_f_values[end] - 0.47 , text(L"\pi_0^f(v)", 8, :left))
annotate!(maximum(v_values_all)-0.4, π_1_f_values[end] - 0.45 , text(L"\pi_1^f(v)", 8, :left))


##q_high and q_low labels 
#on pi_0_p
v_label = (v_s+x_min)/2 - 1
sol_π_0_p_label = nlsolve(x -> π_0_p_eq(x[1], v_label, σ, θ, κ, c), [0.5 * v_label])
q_high_0_p = sol_π_0_p_label.zero[1]
annotate!(v_label, q_high_0_p + 0.22, text(L"q_{high}", 8, :left))

v_label = (v_s+x_min)/2
sol_π_0_p_label = nlsolve(x -> π_0_p_eq(x[1], v_label, σ, θ, κ, c_lowq), [0.5 * v_label])
q_low_0_p_lowq = sol_π_0_p_label.zero[1]
annotate!(v_label, q_low_0_p_lowq - offset_value - 0.2, text(L"q_{low}", 8, :left))

#on pi_0_f
v_label = (v_s+x_max)/2
sol_π_0_f_label = nlsolve(x -> π_0_f_eq(x[1], v_label, σ, θ, κ, c,η₀), [0.5 * v_label])
q_high_0_f = sol_π_0_f_label.zero[1]
annotate!(v_label, q_high_0_f + 0.22, text(L"q_{high}", 8, :left))

sol_π_0_f_label = nlsolve(x -> π_0_f_eq(x[1], v_label, σ, θ, κ, c_lowq,η₀), [0.5 * v_label])
q_low_0_f = sol_π_0_f_label.zero[1]
annotate!(v_label, q_low_0_f - offset_value - 0.2, text(L"q_{low}", 8, :left))

#on pi_0_f

v_label = (x_min+x_max)/2
sol_π_1_f_label = nlsolve(x -> π_1_f_eq(x[1], v_label, σ, θ, κ, c,η₁), [0.5 * v_label])
q_high_1_f = sol_π_1_f_label.zero[1]
annotate!(v_label, q_high_1_f + 0.22, text(L"q_{high}", 8, :left))

sol_π_1_f_label = nlsolve(x -> π_1_f_eq(x[1], v_label, σ, θ, κ, c_lowq,η₁), [0.5 * v_label])
q_low_1_f = sol_π_1_f_label.zero[1]
annotate!(v_label - 0.3, q_low_1_f - offset_value - 0.2, text(L"q_{low}", 8, :left))



# point Annotations
#v_s and v_sat
annotate!(x_min, y_min - 0.2, text(L"v_{sat}", 8))
annotate!(v_s, y_min - 0.2, text(L"v_s \, q_{high}", 8, :left))
annotate!(v_s_lowq-0.05, y_min - 0.2, text(L"v_s \, q_{low}", 8, :left))

##labels to F
annotate!(x_min - 0.15, π_F, text(L"F", 8, :left)) #F



# Annotate axis labels at the end of the axes at chosen points
annotate!(x_max, y_min - 0.2, text(L"v", 8))
annotate!(x_min - 0.1, y_max, text(L"\pi(v)", 8))

############labeling all the effects along F and F high #########
# a # 
function find_v_for_pi_1_f(π_F, σ, θ, κ, c, η₁, x_min, x_max)
    sol = nlsolve(v -> π_1_f_eq(π_F, v[1], σ, θ, κ, c, η₁), [0.5 * (x_min + x_max)])
    return sol.zero[1]
end

# Call the function to find v_value
v_a_value = find_v_for_pi_1_f(π_F, σ, θ, κ, c, η₁, x_min, x_max)

# Find the midpoint between v_value and x_min
v_a = (v_a_value + x_min) / 2
annotate!(v_a, π_F + 0.12, text(L"a", 8, color=:blue))

# b #
π_F_offset = π_F + offset_value

function find_v_for_pi_1_f(π_F_offset, σ, θ, κ, c, η₁, x_min, x_max)
    sol = nlsolve(v -> π_1_f_eq(π_F_offset, v[1], σ, θ, κ, c_lowq, η₁), [0.5 * (x_min + x_max)])
    return sol.zero[1]
end
# Call the function to find v_value
v_b_value = find_v_for_pi_1_f(π_F_offset, σ, θ, κ, c_lowq, η₁, x_min, x_max)
v_b = (v_b_value + v_a_value) / 2
annotate!(v_b, π_F - 0.12, text(L"b", 8, color=:blue))

# c #
function find_v_for_pi_0_p(π_F, σ, θ, κ, c, x_min, x_max)
    sol = nlsolve(v -> π_0_p_eq(π_F, v[1], σ, θ, κ, c), [0.5 * (x_min + x_max)])
    return sol.zero[1]
end
# Call the function to find v_value
v_c_value = find_v_for_pi_0_p(π_F, σ, θ, κ, c, x_min, x_max)
v_c = (v_c_value + v_b_value) / 2
annotate!(v_c, π_F - 0.12, text(L"c", 8, color=:blue))

# d #
function find_v_for_pi_0_p(π_F_offset, σ, θ, κ, c, x_min, x_max)
    sol = nlsolve(v -> π_0_p_eq(π_F_offset, v[1], σ, θ, κ, c_lowq), [0.5 * (x_min + x_max)])
    return sol.zero[1]
end
# Call the function to find v_value
v_d_value = find_v_for_pi_0_p(π_F_offset, σ, θ, κ, c_lowq, x_min, x_max)
v_d = (v_d_value + v_c_value) / 2
annotate!(v_d, π_F - 0.12, text(L"d", 8, color=:blue))

# e #
v_e = (v_d_value + v_s_lowq) / 2
annotate!(v_e, π_F - 0.12, text(L"e", 8, color=:blue))

# f #
v_f = (v_s_lowq + v_s) / 2
annotate!(v_f, π_F - 0.12, text(L"f", 8, color=:blue))

# g #
v_g = (v_s + v_max) / 2
annotate!(v_g, π_F - 0.12, text(L"g", 8, color=:blue))

savefig(joinpath(output_dir, "Fig_8.pdf"))
savefig(joinpath(output_dir, "Fig_8.png"))
display(plot!)





# Master Code to Run All Scripts for Labour Project

# Set the base directory for the project 
base_dir = "C:\\Users\\121685\\Desktop\\Code_for_Labour_Paper\\Code_for_Labour_Paper" #change accordingly

# Set directories for codes and output
script_dir = joinpath(base_dir, "Codes")
output_dir = joinpath(base_dir, "Output")

# Ensure the output directory exists
isdir(output_dir) || mkdir(output_dir)

# Change working directory to the script folder
cd(script_dir)

# Set the environment 
using Pkg
Pkg.activate(".")  # Activate the current directory

# Add required packages (only if not already installed)

Pkg.add("NLsolve")
Pkg.add("Plots")
Pkg.add("LaTeXStrings")

# Import necessary modules
using Plots
using NLsolve
using LaTeXStrings
gr(dpi=450)


# Execute the scripts in sequence
include("B2_(a).jl")  # Script for B2 (a)
include("B2_(b).jl")  # Script for B2 (b)
include("Fig_7.jl")   # Script for Figure 7
include("Fig_8.jl")   # Script for Figure 8


# Confirmation message
println("All scripts executed successfully, and outputs are saved in the Output folder!")

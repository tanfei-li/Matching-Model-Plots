# Master Code to Run All Scripts for Labour Project

# Set the base directory for the project 
base_dir = "C:\\Users\\121685\\Desktop\\Code_for_Labour_Paper\\Code_for_Labour_Paper" ##change accordingly.

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

using Pkg
Pkg.add("Plots")
Pkg.add("CSV")
Pkg.add("XLSX")
Pkg.add("DataFrames")

using Plots, CSV, XLSX, DataFrames


# Load the dataset from Excel file
file_path = "C:\\Users\\121685\\Desktop\\Code_for_Labour_Paper\\Code_for_Labour_Paper\\Extra_material\\Fig_Displacement.xlsx"
##change accordingly

df = DataFrame(XLSX.readtable(file_path, "Feuil1"))

# Extract columns
n = df.n  # x-axis
x = df.x  # y-axis

# Plot
plot(n, x, 
    xlabel="n",  
    ylabel="x", 
    title="",
    xticks=false, yticks=false,  # Remove axis ticks
    legend=false,  # No legend
    top_margin=30Plots.pt, bottom_margin=25Plots.pt, 
    left_margin=45Plots.pt, right_margin=30Plots.pt, 
    label="", 
    lw=1.5, 
    color=:blue,
    yguidefontrotation=90)  # Rotate the y-axis label 
    
savefig(joinpath(output_dir, "x_n_plot.png"))
savefig(joinpath(output_dir, "x_n_plot.pdf"))
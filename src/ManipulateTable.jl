module ManipulateTable

using QML, StatPlots, DataFrames

export choose_data, build_window, get_plot, my_function

include("types.jl")
include("select_functions.jl")
include("build_window.jl")
include("build_plot.jl")

end # module

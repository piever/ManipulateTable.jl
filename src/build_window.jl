function build_window(; kwargs...)
    @qmlapp joinpath(Pkg.dir("ManipulateTable","src"), "QML", "choose_file.qml")
    path = Path("")
    @qmlset qmlcontext().choose = path
    exec()
    return build_window(clean(path); kwargs...)
end

function build_window(datafile; nbox = 5)
    df = readtable(datafile)#DataFrame(FileIO.load(datafile))
    selectlist = [Column(string(name), string.(union(df[name])))
        for name in names(df) if length(union(df[name])) < nbox]

    # run QML window
    qview = init_qquickview()
    @qmlset qmlcontext()._selectlist = ListModel(selectlist)
    # julia_array = ["A", 1, 2.2]
    #myrole(x::AbstractString) = x
    #myrole(x::Number) = Int(round(x))
    #
    # array_model = ListModel(julia_array)

    plotvalues = ComboBoxType.(["X","Y"],0,[ComboBoxEntry.(["aaa","b", "c"]),ComboBoxEntry.(["aaa","b", "c"])] )
    #addrole.(getfield.(plotvalues, :_options), "myrole", myrole, setindex!)
    @qmlset qmlcontext()._plotvalues = ListModel(plotvalues)
    qml_file = joinpath(Pkg.dir("ManipulateTable","src"), "QML", "gui.qml")
    set_source(qview, qml_file)
    QML.show(qview)

    exec()
    selectdata = choose_data(df, selectlist)
    return selectdata, selectlist,plotvalues
end

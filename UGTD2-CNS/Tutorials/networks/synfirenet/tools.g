//genesis - output.g for netsim.g

// Not used in this simulation, but is available:
// ===========================================
// sets up data file output of either binary or ascii type
// ===========================================
function disk_output(path,type)
    str path,type
    if(type == "binary")
	create 		disk_out		{path}
    end
    if(type == "ascii")
	create 		asc_file		{path}
    end
    setfield	 {path}		flush			1 \
			leave_open		1
    useclock {path} 1
end

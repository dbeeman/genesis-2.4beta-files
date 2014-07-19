// genesis 2.2
// Kerstin Menne
// Luebeck, 02.10.2001
// function that creates asc_file object

function make_asc_file(ascname,clock,path_to_save,field_to_save)
	str ascname // name of asc_file object and at the same time name
		     // of output file
	int clock // specifies clock that is to use and therefore saved time
                  // steps
	str path_to_save // path to object whose data is supposed to be saved
	str field_to_save // e.g. Vm or Im

	create asc_file {ascname}
//	setfield ^ flush 1 leave_open 1
	setfield ^ filename DATA/{ascname} flush 0 leave_open 1 append 0 \
		notime 0
	useclock {ascname} {clock}
	addmsg {path_to_save} {ascname} SAVE {field_to_save}
end


 
	
// genesis 2.2
// Kerstin Menne
// Luebeck, 02.10.2001
// function to create randomspike element for the simulation of afferent input;
// array of randomspike elements is built in "provide_input.g"

function make_afferent_1
	if (({exists {aff_input_name_1}}))
                return
        end
	
	create randomspike {aff_input_name_1}
	setfield ^ min_amp {aff_min_amp} max_amp {aff_max_amp} rate {aff_rate}\
		   abs_refract {aff_abs_refract}
end

// randomspike element not handled by hsolve

function make_afferent_2
	if (({exists {aff_input_name_2}}))
                return
        end
	
	create randomspike {aff_input_name_2}
	setfield ^ min_amp {aff_min_amp} max_amp {aff_max_amp} rate {aff_rate}\
		   abs_refract {aff_abs_refract}
end


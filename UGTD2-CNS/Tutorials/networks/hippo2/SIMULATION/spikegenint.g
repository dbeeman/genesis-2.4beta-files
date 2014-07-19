// genesis 2.2
// Kerstin Menne
// Medical University of Luebeck, 02.10.2001
//
// definition of prototype spikegenerator for interneurons; 
// constants are defined in constants.g

function make_spikegen
	if (({exists spikegen}))
                return
        end
	
	create spikegen spikegen
	setfield ^ thresh {int_thresh} abs_refract {int_refract} output_amp \
			{int_amplitude}
end

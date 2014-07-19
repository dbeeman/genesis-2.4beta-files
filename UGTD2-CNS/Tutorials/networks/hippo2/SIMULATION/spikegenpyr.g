// genesis 2.2
// Kerstin Menne
// Medical University of Luebeck, 02.10.2001
//
// definition of prototype spikegenerator for pyramidal cells; 
// constants are defined in constants.g

function make_pyr_spikegen
	if (({exists pyr_spikegen}))
                return
        end
	
	create spikegen pyr_spikegen
	setfield ^ thresh {pyr_thresh} abs_refract {pyr_refract} output_amp \
			{pyr_amplitude}
end


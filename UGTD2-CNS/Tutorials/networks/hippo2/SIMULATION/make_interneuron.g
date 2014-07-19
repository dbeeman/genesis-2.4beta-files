// genesis 2.2
// Kerstin Menne
// Medical University of Luebeck, 01.10.2001
//
// function to create prototype elements for the interneuron


function make_interneuron
	if (!({exists /library}))
		create neutral /library
		if (!({exists /library/compartment}))
			create compartment /library/compartment
		end
	end

	pushe /library

	make_Na // Na_chan.g
	make_Ca // Ca_chan.g
	make_Ca_conc // Ca_chan.g
	make_Ca_conc_somai // Ca_chan.g
	make_K_DRi // K_DR_chan.g
	make_K_AHPi // K_AHP_chan.g
	make_K_AHP_somai // K_AHP_chan.g
	make_K_Ci // K_C_chan.g
	make_K_C_somai // K_C_chan.g
	make_K_Ai  // K_A_chan.g
	make_Na_axon // Na_chan.g
	make_K_DR_axoni // K_DR_chan.g

	make_AMPA // AMPA_chan.g

	make_spikegen // spikegenint.g

	pope
end

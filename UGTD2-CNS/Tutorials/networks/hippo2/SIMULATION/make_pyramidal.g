// genesis 2.2
// Kerstin Menne
// Medical University of Luebeck, 01.10.2001
//
// function to create prototype elements for the pyramidal cell 

function make_pyramidal
	if (!({exists /library}))
		create neutral /library
		if (!({exists /library/compartment}))
			create compartment /library/compartment
		end
	end

	pushe /library

	make_Na // Na_chan.g
	make_Ca // Ca_chan.g
	make_K_DR // K_DR_chan.g
	make_K_AHP // K_AHP_chan.g
	make_K_AHP_soma // K_AHP_chan.g
	make_K_C // K_C_chan.g
	make_K_C_soma // K_C_chan.g
	make_K_A // K_A_chan.g
	make_Na_axon // Na_chan.g
	make_K_DR_axon // K_DR_chan.g
	make_Ca_conc // Ca_chan.g
	make_Ca_conc_soma // Ca_chan.g

	make_AMPA // AMPA_chan.g
	make_NMDA // NMDA_chan.g
	make_GABA_A // GABA_A_chan.g
	make_GABA_B // GABA_B_chan.g

	make_pyr_spikegen // spikegenpyr.g

	pope
end


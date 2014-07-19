// genesis 2.2
// Kerstin Menne
// Medical University of Luebeck, 02.10.2001
//
// prototype AMPA channels for pyramidal cells and interneurons
// taken from granule cell model of cerebellar granular layer by
// Reinoud Maex, University of Antwerp



function make_AMPA
	
	//============================================================
	// AMPA channel, made by CP 
	// Reference: voltage clamp data from
	// Gabbiani et al. (model): J.Neurophys. 1994 
	// Silver et al.: Nature 1992.
	//=============================================================

	if (({exists AMPA}))
		return
	end
        
	create synchan2 AMPA    	
    	setfield AMPA Ek {E_AMPA} tau2 {0.09e-3  / Q10_synapse} \
                              tau1 {1.5e-3   / Q10_synapse} \
                              gmax {G_AMPA} \
                              frequency {AMPA_frequency} \
			      normalize_weights 1
end







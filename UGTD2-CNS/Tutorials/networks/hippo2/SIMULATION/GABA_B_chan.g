// genesis 2.2
// Kerstin Menne
// Medical University of Luebeck, 01.10.2001
//
// prototype GABA_B channel for pyramidal cells 
// taken from granule cell model of cerebellar granular layer by
// Reinoud Maex, University of Antwerp


//=============================================================
// GABA_B channel, using a dual exponential function with time 
// constants of 80	and 40 msec as in Suarez, Koch and Douglas 
// 1995 (J. Neurosci. 15,6700-1719; cat visual cortex).  
// A more detailed model can be found in Otis, De Koninck and Mody 1993
// (J. Physiol. 463, 391-407; rat hippocampal slices; this model uses
// 4th power exponential activation and dual exponential inactivation).
// See also Benardo 1994 (J. Physiol. 476.2, 203-215; slice rat 
// neocortex) and Connors, Malenka and Silva 1988 (J. Physiol. 406,
// 443-468; slice rat and cat visual cortex.
//================================================================

function make_GABA_B
	 
    	if (!({exists GABA_B}))
                create synchan2 GABA_B
   	end

    	setfield GABA_B Ek {E_GABAB} tau1 {0.080 / Q10_synapse} \
                                tau2 {0.040 / Q10_synapse} \
                                gmax {G_GABAB} frequency {0.0} \
			        frequency {GABAB_frequency} \
				normalize_weights 1
end

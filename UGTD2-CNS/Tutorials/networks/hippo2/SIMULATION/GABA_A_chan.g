// genesis 2.2
// Kerstin Menne
// Medical University of Luebeck, 01.10.2001
//
// prototype GABA_A channel for pyramidal cells 
// taken from granule cell model of cerebellar granular layer by
// Reinoud Maex, University of Antwerp

//=============================================================
// GABAA? channel, made by EDS 
// Reference: voltage clamp data from 
// Miles R: . J Physiol 1990.
// Tpeak: 3.25 ms, Tdecay = 28 ms 
// Note the high frequency.  This is being used to model tonic
// Golgi cell inhibition to the granule cell. 
//============================================================

function make_GABA_A

    	if (!({exists GABA_A}))
                create synchan2 GABA_A
    	end
    	
    	// should be large for tonic inhibition
    	setfield GABA_A Ek {E_GABAA} tau1 {0.93e-3  / Q10_synapse} \
                                tau2 {26.50e-3 / Q10_synapse} \
                                gmax {G_GABAA} frequency {0.0} \
                                frequency {GABAA_frequency} \
			        normalize_weights 1

end 

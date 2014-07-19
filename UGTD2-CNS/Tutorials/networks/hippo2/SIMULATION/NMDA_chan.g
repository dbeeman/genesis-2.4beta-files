// genesis 2.2
// Kerstin Menne
// Medical University of Luebeck, 01.10.2001
//
// prototype NMDA channel for pyramidal cells 
// taken from granule cell model of cerebellar granular layer by
// Reinoud Maex, University of Antwerp

//=============================================================
// NMDA channel made by CP 
// From Gabbiani et al. (model) 1994 
//=============================================================

function make_NMDA

//[Mg] in mM
float CMg = 1.2
// per mM
float eta = 0.2801
// per V
float gamma = 62

float offset = - 0.01

//echo eta = {eta}

eta = eta * {exp {- gamma * offset}}

//echo new eta = {eta}


        if (!({exists NMDA}))
                create synchan2 NMDA
        end

        setfield NMDA Ek {E_NMDA} tau2 {3e-3  / Q10_synapse} \
                                  tau1 {40e-3 / Q10_synapse} \
                                  gmax {G_NMDA} \
				  frequency {NMDA_frequency} \
				  normalize_weights 1
	// use the following value for synaptic activation when TEST.g is run
	//                                  gmax {4.0 * G_NMDA}

        if (! {exists NMDA/Mg_BLOCK})
                create Mg_block NMDA/Mg_BLOCK
        end

        setfield NMDA/Mg_BLOCK CMg {CMg}  \
            KMg_A {1/eta} \ \\ *({exp {EREST_ACT*gamma}})} \ 
            KMg_B {1.0/gamma}

	if(!{exists NMDA sendmsg1})
	    addfield NMDA sendmsg1
        end
	setfield NMDA sendmsg1 ". ./Mg_BLOCK CHANNEL Gk Ek"
end


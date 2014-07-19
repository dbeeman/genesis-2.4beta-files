//genesis cell.g

/*                 functions which appear in this file

=============================================================================
	FUNCTION NAME		ARGUMENTS
=============================================================================
	makecompartment		(path,l,d,Eleak)
	makeneuron		(path,soma_l,soma_d)
=============================================================================
*/



       //==========================================================================
       //                   declare constants
       //==========================================================================
 // initialize the random # generator
 randseed 

 float PI = 3.14159

 // channel equilibrium potentials	mV
 // leakage potential
 float Eleak = -0.065

 // default jnput level parameters
 float injwidth = 100
 float injdelay = 0.00
 float injcurrent = 0e-9



//===========================================================================
//                       create compartment
//===========================================================================
function makecompartment(path, l, d, Erest)
    str path
    float l, d
    float Erest
    float area = l*PI*d
    float xarea = PI*d*d/4
    // Ohm-m^2
    float rm = 2
    // F/m^2
    float cm = 0.01
    // ohm-m
    float ra = 2.5

    create compartment {path}
    // V
    // ohm
    // F
    // ohm
    setfield {path} Em {Erest} Rm {rm/area} Cm {cm*area} Ra {ra*l/xarea}
end

//===========================================================================
//                   function to create neuron
//===========================================================================
function makeneuron(path, soma_l, soma_d)
    str path
    float soma_l, soma_d

    // 100% of the soma active
    float active_area = soma_l*PI*soma_d*1.0
	
	if (!{exists {path}})
    create neutral {path}
    end

    pushe {path}
    //=============================================
    //                   cell body
    //=============================================

    makecompartment soma {soma_l} {soma_d} {Eleak}
    position soma I I R{-soma_l/2.0}


    //=============================================
    //              injection pulse
    //=============================================
    create pulsegen soma/injectpulse
    setfield ^ delay1 0 level1 0 width1 100
    addmsg soma/injectpulse soma INJECT output

	//=============================================
	//				voltage gated currents
	//=============================================
	addspikecurrent {path}/soma
 // addothercurrent {path}/soma
	
	
	//=============================================
	//				synapses and spikegens
	//=============================================
	makealphasyn {path} esyn 5e-9 0 0.001 0.003
	makealphasyn {path} isyn 1e-8 -0.07 0.002 0.01
	makespike {path}

    pope
end

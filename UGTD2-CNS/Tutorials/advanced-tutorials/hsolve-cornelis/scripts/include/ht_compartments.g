//genesis - Purkinje cell M9 genesis2.1 script
/* Copyright E. De Schutter (Caltech and BBF-UIA) */

/**********************************************************************
** Sets up active membrane Purkinje cell compartment prototypes 
**  and dendritic spine prototypes.
** E. De Schutter, Caltech, 1991-1992
** This version sets up active compartments with basket cell, climbing
**  fiber and stellate cell synapses.
**********************************************************************/

/* References:
** E. De Schutter and J.M. Bower: An active membrane model of the
** cerebellar Purkinje cell. I. Simulation of current clamps in slice.
** Journal of Neurophysiology  71: 375-400 (1994).
** http://www.bbf.uia.ac.be/TNB/TNB_pub8.html
** E. De Schutter and J.M. Bower: An active membrane model of the
** cerebellar Purkinje cell: II. Simulation of synaptic responses.
** Journal of Neurophysiology  71: 401-419 (1994).
** http://www.bbf.uia.ac.be/TNB/TNB_pub7.html
** Consult these references for sources of experimental data.
*/


int include_compartments

if ( {include_compartments} == 0 )

	include_compartments = 1


// we need the defaults for the definition of PI

include defaults.g

include ht_channels.g

include ht_synapses.g


function make_compartments

	make_synapses

	pushe /library

/* separate function so we can have local variables */

	float len, dia, surf, shell_vol, shell_dia
	int i

	echo making Purkinje compartment library...

	/* make spherical soma prototype with sodium currents*/
	len = 0.00e-6
	dia = 20.0e-6
	surf = dia*dia*{PI}
	shell_dia = 2*{Shell_thick}
	shell_vol = (3*dia*dia*shell_dia - 3*dia*shell_dia*shell_dia + shell_dia*shell_dia*shell_dia)*{PI}/6.0
	if (!({exists soma}))
		create compartment soma
	end
	setfield soma Cm {{CM}*surf} Ra {8.0*{RA}/(dia*{PI})}  \
	    Em {ELEAK} initVm {EREST_ACT} Rm {{RMs}/surf} inject 0.0  \
	    dia {dia} len {len}

	copy NaF soma/NaF
	addmsg soma soma/NaF VOLTAGE Vm
	addmsg soma/NaF soma CHANNEL Gk Ek
	setfield soma/NaF Gbar {{GNaFs}*surf}
	copy NaP soma/NaP
	addmsg soma soma/NaP VOLTAGE Vm
	addmsg soma/NaP soma CHANNEL Gk Ek
	setfield soma/NaP Gbar {{GNaPs}*surf}
	copy CaT soma/CaT
	addmsg soma soma/CaT VOLTAGE Vm
	addmsg soma/CaT soma CHANNEL Gk Ek
	setfield soma/CaT Gbar {{GCaTs}*surf}
	copy KA soma/KA
	addmsg soma soma/KA VOLTAGE Vm
	addmsg soma/KA soma CHANNEL Gk Ek
	setfield soma/KA Gbar {{GKAs}*surf}
	copy Kdr soma/Kdr
	addmsg soma soma/Kdr VOLTAGE Vm
	addmsg soma/Kdr soma CHANNEL Gk Ek
	setfield soma/Kdr Gbar {{GKdrs}*surf}
	copy KM soma/KM
	addmsg soma soma/KM VOLTAGE Vm
	addmsg soma/KM soma CHANNEL Gk Ek
	setfield soma/KM Gbar {{GKMs}*surf}
	copy h1 soma/h1
	addmsg soma soma/h1 VOLTAGE Vm
	addmsg soma/h1 soma CHANNEL Gk Ek
	setfield soma/h1 Gbar {{Ghs}*surf}
	copy h2 soma/h2
	addmsg soma soma/h2 VOLTAGE Vm
	addmsg soma/h2 soma CHANNEL Gk Ek
	setfield soma/h2 Gbar {{Ghs}*surf}
	create Ca_concen soma/Ca_pool
	setfield soma/Ca_pool tau {CaTau}  \
	    B {1.0/(2.0*96494*shell_vol)} Ca_base {CCaI}  \
	    thick {Shell_thick}
	addmsg soma/CaT soma/Ca_pool I_Ca Ik
	copy GABA2 soma/basket
	setfield soma/basket gmax    {{GB_GABA}*surf}
	addmsg soma/basket  soma  CHANNEL Gk  Ek
	addmsg soma  soma/basket    VOLTAGE Vm

    /* make main dendrite prototype with fast Ca currents */
    len = 200.00e-6
    dia = 2.00e-6
    surf = len*dia*{PI}
    shell_vol = (2*dia*shell_dia - shell_dia*shell_dia)*len*{PI}/4.0
    if (!({exists maind}))
        create compartment maind
    end
    setfield maind Cm {{CM}*surf} Ra {4.0*{RA}*len/(dia*dia*{PI})}  \
        Em {ELEAK} initVm {EREST_ACT} Rm {{RMd}/surf} inject 0.0  \
        dia {dia} len {len}

    if (!({exists thickd}))    // Lets copy before we add currents

        copy maind thickd
    end
    if (!({exists spinyd}))    // Lets copy before we add currents

        copy maind spinyd
    end

	copy CaT maind/CaT
	addmsg maind maind/CaT VOLTAGE Vm
	addmsg maind/CaT maind CHANNEL Gk Ek
	setfield maind/CaT Gbar {{GCaTm}*surf}
	copy KA maind/KA
	addmsg maind maind/KA VOLTAGE Vm
	addmsg maind/KA maind CHANNEL Gk Ek
	setfield maind/KA Gbar {{GKAm}*surf}
	copy Kdr maind/Kdr
	addmsg maind maind/Kdr VOLTAGE Vm
	addmsg maind/Kdr maind CHANNEL Gk Ek
	setfield maind/Kdr Gbar {{GKdrm}*surf}
	copy KM maind/KM
	addmsg maind maind/KM VOLTAGE Vm
	addmsg maind/KM maind CHANNEL Gk Ek
	setfield maind/KM Gbar {{GKMm}*surf}
	copy CaP maind/CaP
	addmsg maind maind/CaP VOLTAGE Vm
	addmsg maind/CaP maind CHANNEL Gk Ek
	setfield maind/CaP Gbar {{GCaPm}*surf}
	copy KC maind/KC
	addmsg maind maind/KC VOLTAGE Vm
	addmsg maind/KC maind CHANNEL Gk Ek
	setfield maind/KC Gbar {{GKCm}*surf}
	copy K2 maind/K2
	addmsg maind maind/K2 VOLTAGE Vm
	addmsg maind/K2 maind CHANNEL Gk Ek
	setfield maind/K2 Gbar {{GK2m}*surf}
	create Ca_concen maind/Ca_pool
	setfield maind/Ca_pool tau {CaTau}  \
	    B {1.0/(2.0*96494*shell_vol)} Ca_base {CCaI}  \
	    thick {Shell_thick}
	addmsg maind/CaT maind/Ca_pool I_Ca Ik
	addmsg maind/CaP maind/Ca_pool I_Ca Ik
	addmsg maind/Ca_pool maind/KC CONCEN Ca
	addmsg maind/Ca_pool maind/K2 CONCEN Ca
	create nernst maind/Ca_nernst
	setfield maind/Ca_nernst Cin {CCaI} Cout {CCaO} valency {2} \
	     scale {1.0} T {37}
	addmsg maind/Ca_pool maind/Ca_nernst CIN Ca
	addmsg maind/Ca_nernst maind/CaP EK E
	addmsg maind/Ca_nernst maind/CaT EK E
	copy non_NMDA2 maind/climb
	setfield maind/climb gmax    {{G_cli_syn}*surf/2}
	addmsg maind/climb  maind  CHANNEL Gk  Ek
	addmsg maind  maind/climb    VOLTAGE Vm
	copy GABA2 maind/basket
	setfield maind/basket gmax    {{GB_GABA}*surf/2}
	addmsg maind/basket  maind  CHANNEL Gk  Ek
	addmsg maind  maind/basket    VOLTAGE Vm


	/* make thick dendrite prototype with fast Ca current */
	/* similar to main dendrite but has CaP and no Kdr */
	/* passive prototype already copied from maind */
	copy CaT thickd/CaT
	addmsg thickd thickd/CaT VOLTAGE Vm
	addmsg thickd/CaT thickd CHANNEL Gk Ek
	setfield thickd/CaT Gbar {{GCaTt}*surf}
	copy CaP thickd/CaP
	addmsg thickd thickd/CaP VOLTAGE Vm
	addmsg thickd/CaP thickd CHANNEL Gk Ek
	setfield thickd/CaP Gbar {{GCaPt}*surf}
	copy KM thickd/KM
	addmsg thickd thickd/KM VOLTAGE Vm
	addmsg thickd/KM thickd CHANNEL Gk Ek
	setfield thickd/KM Gbar {{GKMt}*surf}
	copy KC thickd/KC
	addmsg thickd thickd/KC VOLTAGE Vm
	addmsg thickd/KC thickd CHANNEL Gk Ek
	setfield thickd/KC Gbar {{GKCt}*surf}
	copy K2 thickd/K2
	addmsg thickd thickd/K2 VOLTAGE Vm
	addmsg thickd/K2 thickd CHANNEL Gk Ek
	setfield thickd/K2 Gbar {{GK2t}*surf}
	create Ca_concen thickd/Ca_pool
	setfield thickd/Ca_pool tau {CaTau}  \
	    B {1.0/(2.0*96494*shell_vol)} Ca_base {CCaI}  \
	    thick {Shell_thick}
	addmsg thickd/CaT thickd/Ca_pool I_Ca Ik
	addmsg thickd/CaP thickd/Ca_pool I_Ca Ik
	addmsg thickd/Ca_pool thickd/KC CONCEN Ca
	addmsg thickd/Ca_pool thickd/K2 CONCEN Ca
	create nernst thickd/Ca_nernst
	setfield thickd/Ca_nernst Cin {CCaI} Cout {CCaO}  \
	    valency {2} scale {1.0} T {37}
	addmsg thickd/Ca_pool thickd/Ca_nernst CIN Ca
	addmsg thickd/Ca_nernst thickd/CaP EK E
	addmsg thickd/Ca_nernst thickd/CaT EK E
	for (i=1; i<=2; i = i+1)
	    copy GABA thickd/stell{i}
	    setfield thickd/stell{i} gmax {{G_GABA}/5*surf}
	    addmsg thickd/stell{i} thickd CHANNEL Gk Ek
		addmsg thickd  thickd/stell{i}  VOLTAGE Vm
	end
	copy non_NMDA2 thickd/climb
	setfield thickd/climb gmax    {{G_cli_syn}*surf}
	addmsg thickd/climb  thickd  CHANNEL Gk  Ek
	addmsg thickd  thickd/climb    VOLTAGE Vm

	/* make spiny dendrite prototype with high threshold Ca current  \
	    */
	/* passive prototype already copied from maind */
	copy CaT spinyd/CaT
	addmsg spinyd spinyd/CaT VOLTAGE Vm
	addmsg spinyd/CaT spinyd CHANNEL Gk Ek
	setfield spinyd/CaT Gbar {{GCaTd}*surf}
	copy CaP spinyd/CaP
	addmsg spinyd spinyd/CaP VOLTAGE Vm
	addmsg spinyd/CaP spinyd CHANNEL Gk Ek
	setfield spinyd/CaP Gbar {{GCaPd}*surf}
	copy KM spinyd/KM
	addmsg spinyd spinyd/KM VOLTAGE Vm
	addmsg spinyd/KM spinyd CHANNEL Gk Ek
	setfield spinyd/KM Gbar {{GKMd}*surf}
	copy KC spinyd/KC
	addmsg spinyd spinyd/KC VOLTAGE Vm
	addmsg spinyd/KC spinyd CHANNEL Gk Ek
	setfield spinyd/KC Gbar {{GKCd}*surf}
	copy K2 spinyd/K2
	addmsg spinyd spinyd/K2 VOLTAGE Vm
	addmsg spinyd/K2 spinyd CHANNEL Gk Ek
	setfield spinyd/K2 Gbar {{GK2d}*surf}
	create Ca_concen spinyd/Ca_pool
	setfield spinyd/Ca_pool tau {CaTau}  \
	    B {1.0/(2.0*96494*shell_vol)} Ca_base {CCaI}  \
	    thick {Shell_thick}
	addmsg spinyd/CaP spinyd/Ca_pool I_Ca Ik
	addmsg spinyd/CaT spinyd/Ca_pool I_Ca Ik
	addmsg spinyd/Ca_pool spinyd/KC CONCEN Ca
	addmsg spinyd/Ca_pool spinyd/K2 CONCEN Ca
	create nernst spinyd/Ca_nernst
	setfield spinyd/Ca_nernst Cin {CCaI} Cout {CCaO}  \
	    valency {2} scale {1.0} T {37}
	addmsg spinyd/Ca_pool spinyd/Ca_nernst CIN Ca
	addmsg spinyd/Ca_nernst spinyd/CaP EK E
	addmsg spinyd/Ca_nernst spinyd/CaT EK E
	copy GABA spinyd/stell
	setfield spinyd/stell gmax {{G_GABA}*surf}
	addmsg spinyd/stell spinyd CHANNEL Gk Ek
	addmsg spinyd  spinyd/stell  VOLTAGE Vm

	pope
end

/*********************************************************************/
function make_spine_compartments
/* separate function so we can have local variables */
/* one standard format, may be rescaled in attach_spines */
/* Reference: Harris KM, Stevens JK: Dendritic spines of rat
**  cerebellar Purkinje cells: serial electron microscopy with
**  reference to their biophysical characteristics.  J Neurosci 8: p
**  4455-4469, 1988. */

	pushe /library

	float len, dia, surf, vol

    /* make spine with average length and diameter */
	/* make spine neck */
	len = 0.66e-6
	dia = 0.20e-6
	surf = len*dia*{PI}
	vol = len*dia*dia*{PI}/4.0
	if (!({exists spine}))
		create compartment spine
	end
	setfield spine Cm {{CM}*surf}  \
	    Ra {4.0*{RA}*len/(dia*dia*{PI})} Em {ELEAK}  \
	    initVm {EREST_ACT} Rm {{RMd}/surf} inject 0.0 x {len} dia {dia} \
		len {len}

	/* make spine head */
	len = 0.00e-6
	// derived from average surface
	dia = 0.54e-6
	surf = dia*dia*{PI}
	create compartment spine/head
	setfield spine/head Cm {{CM}*surf} Ra {8.0*{RA}/(dia*{PI})} \
	     Em {ELEAK} initVm {EREST_ACT} Rm {{RMd}/surf} inject 0.0  \
	    x {dia} dia {dia} len {len}

	/* make a combined prototype: neck+head */
	addmsg spine/head spine RAXIAL Ra Vm
	addmsg spine spine/head AXIAL Vm

	copy spine spine2

	/* put non-NMDA channel on combined prototype */
	copy non_NMDA spine/head/par
	setfield spine/head/par gmax {{G_par_syn}*surf}
	addmsg  spine/head  spine/head/par	VOLTAGE Vm
	addmsg spine/head/par spine/head CHANNEL Gk Ek

	/* put non-NMDA channel on combined prototype */
	copy non_NMDA2 spine2/head/par2
	setfield spine2/head/par2 gmax {{G_par_syn}*surf}
	addmsg  spine2/head  spine2/head/par2	VOLTAGE Vm
	addmsg spine2/head/par2 spine2/head CHANNEL Gk Ek

	pope

end
/*********************************************************************/


end



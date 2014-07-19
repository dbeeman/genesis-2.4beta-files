//genesis - Purkinje cell M9 genesis2 script
/* Copyright E. De Schutter (Caltech and BBF-UIA) */

/**********************************************************************
** Set of currents developed for rat cerebellum Purkinje neuron by
**  and dendritic spine prototypes.
** This version actually computes all the tables and saves it to files
** E. De Schutter, Caltech, 1991-1992
**********************************************************************/

/* Reference:
** E. De Schutter and J.M. Bower: An active membrane model of the
** cerebellar Purkinje cell. I. Simulation of current clamps in slice.
** Journal of Neurophysiology  71: 375-400 (1994).
** http://www.bbf.uia.ac.be/TNB/TNB_pub8.html
** Consult this reference for sources of equations and experimental data.
*/


/* The data on which these currents are based were collected at room
**   temperature (anything in the range 20 to 25C).  All rate factors were
**   adapted for body temperature (37C), assuming a Q10 of about 3;
**   in practice all rate factors were multiplied by a factor of 5 */

// CONSTANTS
/* should be defined by calling routine (all correctly scaled):
**	ENa, GNa
**	ECa, GCa
**	EK, GK 
**  	Eh, Gh */

int include_channels_create

if ( {include_channels_create} == 0 )

	include_channels_create = 1


/*********************************************************************
**                  Central channel creation routine
*********************************************************************/

/* Make tabchannels */
function make_chan_create(chan, Ec, Gc, Xp, XAA, XAB, XAC, XAD, XAF, XBA, XBB,  \
    XBC, XBD, XBF, Yp, YAA, YAB, YAC, YAD, YAF, YBA, YBB, YBC, YBD, YBF \
    , Zp, ZAA, ZAB, ZAC, ZAD, ZAF, ZBA, ZBB, ZBC, ZBD, ZBF)
    str chan
    int Xp, Yp, Zp
    float Ec, Gc
    float XAA, XAB, XAC, XAD, XAF, XBA, XBB, XBC, XBD, XBF
    float YAA, YAB, YAC, YAD, YAF, YBA, YBB, YBC, YBD, YBF
    float ZAA, ZAB, ZAC, ZAD, ZAF, ZBA, ZBB, ZBC, ZBD, ZBF

    pushe /library

    if ({exists {chan}})
        return
    end

    create tabchannel {chan}
    setfield {chan} Ek {Ec} Gbar {Gc} Ik 0 Gk 0 Xpower {Xp} Ypower {Yp}  \
        Zpower {Zp}
    if (Xp > 0)
        setupalpha {chan} X {XAA} {XAB} {XAC} {XAD} {XAF} {XBA} {XBB} {XBC} \
			{XBD} {XBF} -size {tab_xfills+1} -range {tab_xmin} {tab_xmax}
    end
    if (Yp > 0)
        setupalpha {chan} Y {YAA} {YAB} {YAC} {YAD} {YAF} {YBA} {YBB} {YBC} \
			{YBD} {YBF} -size {tab_xfills+1} -range {tab_xmin} {tab_xmax}
	end
    if (Zp != 0)
        setupalpha {chan} Z {ZAA} {ZAB} {ZAC} {ZAD} {ZAF} {ZBA} {ZBB} {ZBC} \
			{ZBD} {ZBF} -size {tab_xfills+1} -range {tab_xmin} {tab_xmax}
    end

    pope

end


/******************************************************************* \
**
**               The current equations themselves 
*********************************************************************/

function make_channels_create
    int i, cdivs
    float zinf, ztau, c, dc, cmin, cmax
    float x, dx, y
    float a, b

    pushe /library

    echo making and saving channel library....
/* Equations specific to the Purkinje cell, made by EDS */
    /* Fast Na current, eq#3a */
    make_chan_create NaF {ENa} {GNa} 3 35.0e3 0.0 0.0 0.005 -10.0e-3 7.0e3 \
         0.0 0.0 0.065 20.0e-3 1 0.225e3 0.0 1.0 0.080 10.0e-3 7.5e3 0.0 \
         0.0 -0.003 -18.0e-3 0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0
    call NaF TABSAVE NaF.tab

    /* Persistent Na current, eq#2b */
    make_chan_create NaP {ENa} {GNa} 3 200.0e3 0.0 1.0 -0.018 -16.0e-3  \
        25.00e3 0.0 1.0 0.058 8.0e-3 0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0  \
        0.0 0.0 0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0
    call NaP TABSAVE NaP.tab

    /* P type Ca current, eq#1e */
    make_chan_create CaP {ECa} {GCa} 1 8.50e3 0.0 1.0 -0.0080 -12.5e-3  \
        35.0e3 0.0 1.0 0.074 14.5e-3 1 0.0015e3 0.0 1.0 0.029 8.0e-3  \
        0.0055e3 0.0 1.0 0.023 -8.0e-3 0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 \
         0.0 0.0
    call CaP TABSAVE CaP.tab

    /* T type Ca current, eq#2 */
    make_chan_create CaT {ECa} {GCa} 1 2.60e3 0.0 1.0 0.021 -8.0e-3  \
        0.180e3 0.0 1.0 0.040 4.0e-3 1 0.0025e3 0.0 1.0 0.040 8.0e-3  \
        0.190e3 0.0 1.0 0.050 -10.0e-3 0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 \
         0.0 0.0
    call CaT TABSAVE CaT.tab

    /* A type K current, eq#2b */
    make_chan_create KA {EK} {GK} 4 1.40e3 0.0 1.0 0.027 -12.0e-3 0.490e3  \
        0.0 1.0 0.030 4.0e-3 1 0.0175e3 0.0 1.0 0.050 8.0e-3 1.30e3 0.0  \
        1.0 0.013 -10.0e-3 0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0
    call KA TABSAVE KA.tab

    /* non-inactivating BK-type Ca-dependent K current eq 3 (Gruol K1)
    /* scaled for units: V, sec, mM */
    make_chan_create KC {EK} {GK} 1 7.5e3 0.0 0.0 0.0 1.0e12 0.110e3 0.0  \
        0.0 -0.035 14.9e-3 0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0  \
        0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0

    /* Z: Ca-activation, tabchannel specific implementation */
    cmin = ({CCaI}) // will create a z-range from 0.0021 to 0.9727
    cmax = ({Ca_tab_max})
    cdivs = tab_xfills+1
    c = cmin
    dc = cdivs
    dc = (cmax - cmin)/cdivs
    //slow (Gola, Ikemoto:50-280ms delay)
    ztau = 0.010
    call KC TABCREATE Z {cdivs} {cmin} {cmax}
    for (i = 0; i <= (cdivs); i = i + 1)
	    zinf = 1/(1 + (4.0e-3/c))
	    setfield KC Z_A->table[{i}] {zinf/ztau}
	    setfield KC Z_B->table[{i}] {1/ztau}
	    c = c + dc
    end
    setfield KC Zpower 2
    setfield KC Z_A->calc_mode 0
    setfield KC Z_B->calc_mode 0
    call KC TABSAVE KC.tab

    /* non-inactivating Ca-dependent K current eq 1 (Gruol K2) */
    /* scaled for units: V, sec, mM */
    make_chan_create K2 {EK} {GK} 1 25.0e3 0.0 0.0 0.0 1.0e12 0.075e3 0.0  \
        0.0 0.025 6.0e-3 0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0 0.0 \
         0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0
    /* Z: Ca-activation, tabchannel specific implementation */
    cmin = ({CCaI}) // will create a z-range from 0.0021 to 0.9727
    cmax = ({Ca_tab_max})
    cdivs = tab_xfills+1
    c = cmin
    dc = cdivs
    dc = (cmax - cmin)/cdivs
    ztau = 0.010
    call K2 TABCREATE Z {cdivs} {cmin} {cmax}
    for (i = 0; i <= (cdivs); i = i + 1)
	    zinf = 1/(1 + (0.2e-3/c))
	    setfield K2 Z_A->table[{i}] {zinf/ztau}
	    setfield K2 Z_B->table[{i}] {1/ztau}
	    c = c + dc
    end
    setfield K2 Zpower 2
    setfield K2 Z_A->calc_mode 0
    setfield K2 Z_B->calc_mode 0
    call K2 TABSAVE K2.tab


    /* Equations from the literature */
    /* delayed rectifier type K current eq1
    ** Refs: Yamada (his equations are also for 22C) */
    if (!{exists Kdr})
	    float VKTAU_OFFSET = 0.000
	    float VKMINF_OFFSET = 0.020
	    create tabchannel Kdr
	    setfield Kdr Ek {EK} Gbar {GK} Ik 0 Gk 0 Xpower 2  \
		Ypower 1 Zpower 0

	    call Kdr TABCREATE X {tab_xdivs} {tab_xmin}  \
		{tab_xmax}
	    x = {tab_xmin}
	    dx = ({tab_xmax} - {tab_xmin})/{tab_xdivs}

	    for (i = 0; i <= ({tab_xdivs}); i = i + 1)
		    a = -23.5e3*(x + 0.012 - VKTAU_OFFSET)/({exp {(x + 0.012 - VKTAU_OFFSET)/-0.012}} - 1.0)
		    b = 5.0e3*{exp {-(x + 0.147 - VKTAU_OFFSET)/0.030}}
		    setfield Kdr X_A->table[{i}] {1.0/(a + b)}

		    a = -23.5e3*(x + 0.012 - VKMINF_OFFSET)/({exp {(x + 0.012 - VKMINF_OFFSET)/-0.012}} - 1.0)
		    b = 5.0e3*{exp {-(x + 0.147 - VKMINF_OFFSET)/0.030}}
		    setfield Kdr X_B->table[{i}] {a/(a + b)}
		    x = x + dx
	    end
	    tweaktau Kdr X
	    setfield Kdr X_A->calc_mode 0 X_B->calc_mode 0
	    call Kdr TABFILL X {tab_xfills + 1} 0


	    call Kdr TABCREATE Y {tab_xdivs} {tab_xmin}  \
		{tab_xmax}
	    x = {tab_xmin}

	    for (i = 0; i <= ({tab_xdivs}); i = i + 1)
		    if (x < -0.025)
			    setfield Kdr Y_A->table[{i}] 1.2
		    else
			    setfield Kdr Y_A->table[{i}] 0.010
		    end

		    y = 1.0 + {exp {(x + 0.025)/0.004}}
		    setfield Kdr Y_B->table[{i}] {1.0/y}
		    x = x + dx
	    end
	    tweaktau Kdr Y
	    setfield Kdr Y_A->calc_mode 0 Y_B->calc_mode 0
	    call Kdr TABFILL Y {tab_xfills + 1} 0
    end
    call Kdr TABSAVE Kdr.tab

    /* non-inactivating (muscarinic) type K current, eq#2 
    ** eq#2: corrected typo in Yamada equation for tau: 20 instead of 40
    ** Refs: Yamada (his equations are also for 22C) */
    if (!{exists KM})
	    create tabchannel KM
	    setfield KM Ek {EK} Gbar {GK} Ik 0 Gk 0 Xpower 1  \
		Ypower 0 Zpower 0

	    call KM TABCREATE X {tab_xdivs} {tab_xmin} {tab_xmax}
		x = {tab_xmin}
		dx = ({tab_xmax} - {tab_xmin})/{tab_xdivs}

	    for (i = 0; i <= ({tab_xdivs}); i = i + 1)
		    y = 0.2/(3.3*({exp {(x + 0.035)/0.02}}) + {exp {-(x + 0.035)/0.02}})
		    setfield KM X_A->table[{i}] {y}

		    y = 1.0/(1.0 + {exp {-(x + 0.035)/0.01}})
		    setfield KM X_B->table[{i}] {y}
		    x = x + dx
	    end
	    tweaktau KM X
	    setfield KM X_A->calc_mode 0 X_B->calc_mode 0
	    call KM TABFILL X {tab_xfills + 1} 0
    end
    call KM TABSAVE KM.tab

    /* Anomalous rectifier eq#2: */
    if (!{exists h1})
	    create tabchannel h1
	    setfield h1 Ek {Eh} Gbar {Gh} Ik 0 Gk 0 Xpower 1  \
		Ypower 0 Zpower 0
	    call h1 TABCREATE X {tab_xdivs} {tab_xmin} {tab_xmax}

	    create tabchannel h2
	    setfield h2 Ek {Eh} Gbar {Gh} Ik 0 Gk 0 Xpower 1  \
		Ypower 0 Zpower 0
	    call h2 TABCREATE X {tab_xdivs} {tab_xmin} {tab_xmax}

	    x = {tab_xmin}
	    dx = ({tab_xmax} - {tab_xmin})/{tab_xdivs}

	    for (i = 0; i <= ({tab_xdivs}); i = i + 1)
		    //fast component
		    setfield h1 X_A->table[{i}] 0.0076
		    //slow component
		    setfield h2 X_A->table[{i}] 0.0368
		    y = 1.0/(1 + {exp {(x + 0.082)/0.007}})
		    setfield h1 X_B->table[{i}] {0.8*y}
		    setfield h2 X_B->table[{i}] {0.2*y}
		    x = x + dx
	    end
	    tweaktau h1 X
	    setfield h1 X_A->calc_mode 0 X_B->calc_mode 0
	    call h1 TABFILL X {tab_xfills + 1} 0
	    tweaktau h2 X
	    setfield h2 X_A->calc_mode 0 X_B->calc_mode 0
	    call h2 TABFILL X {tab_xfills + 1} 0
    end
    call h1 TABSAVE h1.tab
    call h2 TABSAVE h2.tab

    pope

end
/*********************************************************************/


end



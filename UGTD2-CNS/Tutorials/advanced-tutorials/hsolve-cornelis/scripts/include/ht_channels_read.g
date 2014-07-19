//genesis - Purkinje cell M9 genesis2 script
/* Copyright E. De Schutter (Caltech and BBF-UIA) */

/**********************************************************************
** Set of currents developed for rat cerebellum Purkinje neuron by
**  and dendritic spine prototypes.
** This version just loads the data from a file: this is about 8 times
**  faster than computing the equations
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

int include_channels_read

if ( {include_channels_read} == 0 )

	include_channels_read = 1


/*********************************************************************
**                  Central channel creation routine
*********************************************************************/

/* Make tabchannels, and load from table */
function make_chan_read(chan, Ec, Gc, Xp, XAA, XAB, XAC, XAD, XAF, XBA, XBB,  \
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
	call {chan} TABREAD {chan}.tab
        return
    end

    create tabchannel {chan}
    setfield {chan} Ek {Ec} Gbar {Gc} Ik 0 Gk 0 Xpower {Xp} Ypower {Yp}  \
        Zpower {Zp}
    if (Xp > 0)
	call {chan} TABCREATE X {tab_xfills+1} {tab_xmin} {tab_xmax}
    end
    if (Yp > 0)
	call {chan} TABCREATE Y {tab_xfills+1} {tab_xmin} {tab_xmax}
    end
    if (Zp != 0)
	call {chan} TABCREATE Z {tab_xfills+1} {CCaI} {Ca_tab_max}
    end
    call {chan} TABREAD {chan}.tab

    pope

end


/******************************************************************* \
**
**               The current equations themselves 
*********************************************************************/

function make_channels_read

    echo loading channel library....

    pushe /library

/* Equations specific to the Purkinje cell, made by EDS */
    /* Fast Na current, eq#3a */
    make_chan_read NaF {ENa} {GNa} 3 35.0e3 0.0 0.0 0.005 -10.0e-3 7.0e3 \
         0.0 0.0 0.065 20.0e-3 1 0.225e3 0.0 1.0 0.080 10.0e-3 7.5e3 0.0 \
         0.0 -0.003 -18.0e-3 0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0

    /* Persistent Na current, eq#2b */
    make_chan_read NaP {ENa} {GNa} 3 200.0e3 0.0 1.0 -0.018 -16.0e-3  \
        25.00e3 0.0 1.0 0.058 8.0e-3 0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0  \
        0.0 0.0 0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0

    /* P type Ca current, eq#1e */
    make_chan_read CaP {ECa} {GCa} 1 8.50e3 0.0 1.0 -0.0080 -12.5e-3  \
        35.0e3 0.0 1.0 0.074 14.5e-3 1 0.0015e3 0.0 1.0 0.029 8.0e-3  \
        0.0055e3 0.0 1.0 0.023 -8.0e-3 0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 \
         0.0 0.0

    /* T type Ca current, eq#2 */
    make_chan_read CaT {ECa} {GCa} 1 2.60e3 0.0 1.0 0.021 -8.0e-3  \
        0.180e3 0.0 1.0 0.040 4.0e-3 1 0.0025e3 0.0 1.0 0.040 8.0e-3  \
        0.190e3 0.0 1.0 0.050 -10.0e-3 0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 \
         0.0 0.0

    /* A type K current, eq#2b */
    make_chan_read KA {EK} {GK} 4 1.40e3 0.0 1.0 0.027 -12.0e-3 0.490e3  \
        0.0 1.0 0.030 4.0e-3 1 0.0175e3 0.0 1.0 0.050 8.0e-3 1.30e3 0.0  \
        1.0 0.013 -10.0e-3 0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0

    /* non-inactivating BK-type Ca-dependent K current eq 3 (Gruol K1)
    /* scaled for units: V, sec, mM */
    make_chan_read KC {EK} {GK} 1 7.5e3 0.0 0.0 0.0 1.0e12 0.110e3 0.0  \
        0.0 -0.035 14.9e-3 0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 2  \
        0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0

    /* non-inactivating Ca-dependent K current eq 1 (Gruol K2) */
    /* scaled for units: V, sec, mM */
    make_chan_read K2 {EK} {GK} 1 25.0e3 0.0 0.0 0.0 1.0e12 0.075e3 0.0  \
        0.0 0.025 6.0e-3 0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 2 \
         0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0


    /* Equations from the literature */
    /* delayed rectifier type K current eq1
    ** Refs: Yamada (his equations are also for 22C) */
    if (!{exists Kdr})
	    create tabchannel Kdr
	    setfield Kdr Ek {EK} Gbar {GK} Ik 0 Gk 0 Xpower 2  \
		Ypower 1 Zpower 0

	    call Kdr TABCREATE X {tab_xfills+1} {tab_xmin}  {tab_xmax}
	    call Kdr TABCREATE Y {tab_xfills+1} {tab_xmin}  {tab_xmax}
    end
    call Kdr TABREAD Kdr.tab

    /* non-inactivating (muscarinic) type K current, eq#2 
    ** eq#2: corrected typo in Yamada equation for tau: 20 instead of 40
    ** Refs: Yamada (his equations are also for 22C) */
    if (!{exists KM})
	    create tabchannel KM
	    setfield KM Ek {EK} Gbar {GK} Ik 0 Gk 0 Xpower 1  \
		Ypower 0 Zpower 0

	    call KM TABCREATE X {tab_xfills+1} {tab_xmin} {tab_xmax}
    end
    call KM TABREAD KM.tab

    /* Anomalous rectifier eq#2: */
    if (!{exists h1})
	    create tabchannel h1
	    setfield h1 Ek {Eh} Gbar {Gh} Ik 0 Gk 0 Xpower 1  \
		Ypower 0 Zpower 0
	    call h1 TABCREATE X {tab_xfills+1} {tab_xmin} {tab_xmax}

	    create tabchannel h2
	    setfield h2 Ek {Eh} Gbar {Gh} Ik 0 Gk 0 Xpower 1  \
		Ypower 0 Zpower 0
	    call h2 TABCREATE X {tab_xfills+1} {tab_xmin} {tab_xmax}
    end
    call h1 TABREAD h1.tab
    call h2 TABREAD h2.tab

    pope

end
/*********************************************************************/


end



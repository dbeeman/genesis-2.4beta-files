// genesis - GP synapse definitions
/* Copyright D. Jaeger  (Emory University) */
/* Adapted from EDS gp cell simulation for now */

/* The data on which these currents are based were collected at room
**   temperature (anything in the range 20 to 25C).  All rate factors were
**   adapted for body temperature (37C), assuming a Q10 of about 3;
**   in practice all rate factors were multiplied by a factor of 5 */

// HELPER VARIABLES AND FUNCTIONS
float PI = 3.14159

/* VARIABLES USED BY ACTIVE COMPONENTS */
int EXPONENTIAL = 1
int SIGMOID = 2
int LINOID = 3

/***********************************************************************/

/**********************************************************************
**
**		Creating the library
**
**********************************************************************/

if (!{exists /library})
	create neutral /library
	/* We don't want the library to try to calculate anything, 
	**	so we disable it */
	disable /library
end

/**********************************************************************
**
**		Some utility functions for tabulated channels
**
**********************************************************************/

int TAB_XDIVS = 3000
float TAB_XMIN = -0.1
float TAB_XMAX = 0.05

/* 
** These SLI functions  been replaced by compiled functions with
** clearer names.   The aliases defined below are just for
** backwards compatibility. They replace the script functions below.
*/

addalias setup_table2 setupgate		// aka setupgate
// The usage of this has changed, so "setupgate" should be used instead

addalias tweak_tabchan tweakalpha	// aka tweakalpha
addalias tau_tweak_tabchan tweaktau	// aka tweaktau
addalias setup_tabchan setupalpha	// aka setupalpha
addalias setup_tabchan_tau setuptau	// aka setuptau

function setup_table3(gate, table, xdivs, xmin, xmax, A, B, C, D, F)
	setup_table2 {gate} {table} {A} {B} {C}  \
	    {D} {F} -size {xdivs} -range {xmin} {xmax} -noalloc
end

function setup_table(gate, table, xdivs, A, B, C, D, F)
	setup_table2 {gate} {table} {A}  \
	    {B} {C} {D} {F} -size {xdivs} -range {TAB_XMIN} {TAB_XMAX}
end

// settab2const sets a range of entries in a tabgate table to a constant
function settab2const(gate, table, imin, imax, value)
    str gate
    str table
    int i, imin, imax
    float value
    for (i = (imin); i <= (imax); i = i + 1)
        setfield {gate} {table}->table[{i}] {value}
    end
end

/* The following "commented-out" functions were replaced by more
   efficient compiled functions in GENESIS ver. 1.4.  The older GENESIS
   Script Language implementations are included here in order to illustrate
   what they do.

function setup_table3(gate,table,xdivs,xmin,xmax,A,B,C,D,F)
	str	gate,table
	int	xdivs
	float	xmin,xmax,A,B,C,D,F

	int i
	float x,dx,y

	dx = xdivs
	dx = (xmax - xmin)/dx
	x = xmin

	for (i = 0 ; i <= {xdivs} ; i = i + 1)
		y = (A + B * x) / (C + {exp({(x + D) / F})})
		setfield {gate} {table}->table[{i}] {y}
		x = x + dx
	end
end

function setup_table2(gate,table,xdivs,xmin,xmax,A,B,C,D,F)
	str	gate,table
	int	xdivs
	float	xmin,xmax,A,B,C,D,F

	if (xdivs <= 9)
		echo must have at least 9, preferably over 100 elements in table
		return
	end
	call {gate} TABCREATE {table} {xdivs} {xmin} {xmax}
	setup_table3({gate},{table},{xdivs},{xmin},{xmax},{A},{B},{C},{D},{F})
end

function setup_table(gate,table,xdivs,A,B,C,D,F)
	str	gate,table
	int	xdivs
	float	A,B,C,D,F

	setup_table2({gate},{table},{xdivs},-0.1,0.1,{A},{B},{C},{D},{F})
end

// Alters the values in the B arrays of tabchan to 1/tau 
function tweak_tabchan(chan,gate)
	str chan,gate
	str tabA = {gate}+"_A"
	str tabB = {gate}+"_B"
	int xdivs,i
	float A,B

	xdivs = get({chan},{tabA}->xdivs)
	for (i = 0 ; i <= xdivs ; i = i + 1)
		A = get({chan},{tabA}->table[{i}])
		B = get({chan},{tabB}->table[{i}])
		setfield {chan} {tabB}->table[{i}] {A + B}
	end
end

// Alters the values in the A and B arrays of tabchan to A and 1/tau,
// from tau and minf 
function tau_tweak_tabchan(chan,gate)
	str chan,gate
	str tabA = {gate}+"_A"
	str tabB = {gate}+"_B"
	int xdivs,i
	float A,B
	float T,M

	xdivs = get({chan},{tabA}->xdivs)
	for (i = 0 ; i <= xdivs ; i = i + 1)
		T = get({chan},{tabA}->table[{i}])
		M = get({chan},{tabB}->table[{i}])
		A = M / T
		B = 1.0/T
		setfield {chan} {tabA}->table[{i}] {A}
		setfield {chan} {tabB}->table[{i}] {B}
	end
end

// Sets up a tabchan with hh params, with the non-interp option in
// a table of 3000 entries 
function setup_tabchan(chan,gate,AA,AB,AC,AD,AF,BA,BB,BC,BD,BF)
	str chan,gate
	str tabA = {gate}+"_A"
	str tabB = {gate}+"_B"
	float AA,AB,AC,AD,AF,BA,BB,BC,BD,BF
	call {chan} TABCREATE {gate} 49 -0.1 0.05
	setup_table3({chan},{tabA},49,-0.1,0.05,{AA},{AB},{AC},{AD},{AF})
	setup_table3({chan},{tabB},49,-0.1,0.05,{BA},{BB},{BC},{BD},{BF})
	tweak_tabchan({chan},{gate})
	setfield {chan} {tabA}->calc_mode 0	 {tabB}->calc_mode 0
	call {chan} TABFILL {gate} 3000 0
end

// Sets up a tabchan with hh params, with the non-interp option in
// a table of 3000 entries.
// This version uses parameters for tau and minf instead
// of alpha and beta 
function setup_tabchan_tau(chan,gate,TA,TB,TC,TD,TF,MA,MB,MC,MD,MF)
	str chan,gate
	str tabA = {gate}+"_A"
	str tabB = {gate}+"_B"
	float TA,TB,TC,TD,TF,MA,MB,MC,MD,MF
	call {chan} TABCREATE {gate} 49 -0.1 0.05
	setup_table3({chan},{tabA},49,-0.1,0.05,{TA},{TB},{TC},{TD},{TF})
	setup_table3({chan},{tabB},49,-0.1,0.05,{MA},{MB},{MC},{MD},{MF})
	tau_tweak_tabchan({chan},{gate})
	setfield {chan} {tabA}->calc_mode 0	 {tabB}->calc_mode 0
	call {chan} TABFILL {gate} 3000 0
end
*/

int tab_xdivs = 149
int tab_xfills = 2999
float tab_xmin = -0.10
float tab_xmax = 0.05
float CCaO = 2.4000 //external Ca as in normal slice Ringer
float CCaI = 0.000040 //internal Ca in mM
float CCaI = 0.000040 //internal Ca in mM
float Ca_tab_max = 0.200
float Shell_thick = 0.20e-6 //diameter of Ca_shells
float CaTau = 0.00010 // Ca_concen tau


// CONSTANTS
float GNa = 1, GCa = 1, GK = 1, Gh = 1 // only used for proto channels
float ENa = 0.045
float GNaFs = 30000.0
float GNaPs = 0.0
float ECa = 0.0125*{log {CCaO/CCaI}} // 0.135 V
float GCaTs = 0.0
float GCaTm = 0.00
float GCaTd = 0.00
float GCaPm = 0.0
float GCaPd = 0.0
float EK = -0.085
float GKAs = 0.0
float GKAm = 0.0
float GKdrs = 2000.0
float GKdrm = 0.0
float GKMs = 0.0
float GKMm = 0.0
float GKMd = 0.0
float GKCm = 0.0
float GKCd = 0.0
float GK2m = 0.0
float GK2d = 0.0
float Eh = -0.030
float Ghs = 0.0

/*********************************************************************
**                  Central channel creation routine
*********************************************************************/

/* The make_eds_chans routine calls this function.  It
**  allows me to change the object_type of all channels in the
**  simulation by just editing this function */
/* Note however that gp_CaL contains a tabchannel specific part 
**  and gp_Kdr and gp_KM are also created as tabchannels */

/* Make tabchannels */
function make_chan(chan, Ec, Gc, Xp, XAA, XAB, XAC, XAD, XAF, XBA, XBB,  \
    XBC, XBD, XBF, Yp, YAA, YAB, YAC, YAD, YAF, YBA, YBB, YBC, YBD, YBF \
    , Zp, ZAA, ZAB, ZAC, ZAD, ZAF, ZBA, ZBB, ZBC, ZBD, ZBF)
    str chan
    int Xp, Yp, Zp
    float Ec, Gc
    float XAA, XAB, XAC, XAD, XAF, XBA, XBB, XBC, XBD, XBF
    float YAA, YAB, YAC, YAD, YAF, YBA, YBB, YBC, YBD, YBF
    float ZAA, ZAB, ZAC, ZAD, ZAF, ZBA, ZBB, ZBC, ZBD, ZBF

    if (({exists {chan}}))
        return
    end

    create tabchannel {chan}
    setfield {chan} Ek {Ec} Gbar {Gc} Ik 0 Gk 0 Xpower {Xp} Ypower {Yp}  \
        Zpower {Zp}

    if (Xp > 0)
        setup_tabchan {chan} X {XAA} {XAB} {XAC} {XAD} {XAF} {XBA} {XBB} \
             {XBC} {XBD} {XBF}
    end
    if (Yp > 0)
        setup_tabchan {chan} Y {YAA} {YAB} {YAC} {YAD} {YAF} {YBA} {YBB} \
             {YBC} {YBD} {YBF}
    end
    if (Zp != 0)
        setup_tabchan {chan} Z {ZAA} {ZAB} {ZAC} {ZAD} {ZAF} {ZBA} {ZBB} \
             {ZBC} {ZBD} {ZBF}
    end
end


/******************************************************************* \
**
**               The current equations themselves 
*********************************************************************/

function make_eds_chans
    int i, cdivs
    float zinf, ztau, c, dc, cmin, cmax
    float x, dx, y
    float a, b

echo making eds channel library....
if ( !{exists /library} )
create neutral /library
disable /libary
end

pushe /library

/* Equations specific to the Purkinje cell, made by EDS */
/* Fast Na current, eq#3a
** Refs:Hirano: Ipeak, approx Tpeak data
**	Gahwiller: Hinf, TauH data
**	Hodgkin: basis of equations */
    make_chan eds_NaF {ENa} {GNa} 3 35.0e3 0.0 0.0 0.005 -10.0e-3 7.0e3 \
         0.0 0.0 0.065 20.0e-3 1 0.225e3 0.0 1.0 0.080 10.0e-3 7.5e3 0.0 \
         0.0 -0.003 -18.0e-3 0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0

/* Persistent Na current, eq#2b
** Refs:Kay: Tactivation, Tdeactivation, threshold data 
**      French Minf data 
**      Hodgkin: basis of equations */
    make_chan eds_NaP {ENa} {GNa} 3 200.0e3 0.0 1.0 -0.018 -16.0e-3  \
        25.00e3 0.0 1.0 0.058 8.0e-3 0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0  \
        0.0 0.0 0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0

/* P type Ca current, eq#1e
** Refs: Regan: Minf and Hinf, TauM -100 to -20mV, TauH -30mV
**  Hirano: Tpeak -> TauM >-20mV
**	Fox: TauH (10 to 40mV) data
**	Huang: TauH (-30 to -10 mV) data
**  We do not use the [Ca2+] inactivation for now 
    make_chan eds_CaP {ECa} {GCa} 1 8.50e3 0.0 1.0 -0.0080 -12.5e-3  \
        35.0e3 0.0 1.0 0.074 14.5e-3 1 0.0015e3 0.0 1.0 0.029 8.0e-3  \
        0.0055e3 0.0 1.0 0.023 -8.0e-3 0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 \
         0.0 0.0
*/

    make_chan eds_CaP {ECa} {GCa} \
        1 8.50e3 0.0 1.0 -0.0080 -12.5e-3 35.0e3 0.0 1.0 0.074 14.5e-3  \
                0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0  \
                0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0

/* T type Ca current, eq#2
** Refs:Kaneda: Ipeak, Tpeak, TauH (dep + hyp) data
**	Gruol: TauH hyperpolarized data
**	Hirano: Ipeak, Tpeak, Hinf, TauH data */
    make_chan eds_CaT {ECa} {GCa} 1 2.60e3 0.0 1.0 0.001 -8.0e-3  \
        0.180e3 0.0 1.0 0.000 4.0e-3 1 0.0025e3 0.0 1.0 0.020 8.0e-3  \
        0.190e3 0.0 1.0 0.030 -10.0e-3 0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 \
         0.0 0.0

/* A type K current, eq#2b
** 2: shifted M -0.018V, H -0.005V (compatible with Li et al)
**	Li: Minf data (different from Tpeak Hirano!), TauH hyp data
**	Connor: basis of equations */
    make_chan eds_KA {EK} {GK} 4 1.40e3 0.0 1.0 0.027 -12.0e-3 0.490e3  \
        0.0 1.0 0.030 4.0e-3 1 0.0175e3 0.0 1.0 0.050 8.0e-3 1.30e3 0.0  \
        1.0 0.013 -10.0e-3 0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0


/* Equations from the literature */
/* delayed rectifier type K current eq1
** Refs: Yamada (his equations are also for 22C) */
    if (!({exists eds_KM}))
		float VKTAU_OFFSET = 0.000
		float VKMINF_OFFSET = 0.020
		create tabchannel eds_Kdr
		setfield eds_Kdr Ek {EK} Gbar {GK} Ik 0 Gk 0 Xpower 2  \
		    Ypower 0 Zpower 0

		call eds_Kdr TABCREATE X {tab_xdivs} {tab_xmin}  \
		    {tab_xmax}
		x = {tab_xmin}
		dx = ({tab_xmax} - {tab_xmin})/{tab_xdivs}

		for (i = 0; i <= ({tab_xdivs}); i = i + 1)
			a = -23.5e3*(x + 0.012 - VKTAU_OFFSET)/({exp {(x + 0.012 - VKTAU_OFFSET)/-0.012}} - 1.0)
			b = 5.0e3*{exp {-(x + 0.147 - VKTAU_OFFSET)/0.030}}
			setfield eds_Kdr X_A->table[{i}] {1.0/(a + b)}

			a = -23.5e3*(x + 0.012 - VKMINF_OFFSET)/({exp {(x + 0.012 - VKMINF_OFFSET)/-0.012}} - 1.0)
			b = 5.0e3*{exp {-(x + 0.147 - VKMINF_OFFSET)/0.030}}
			setfield eds_Kdr X_B->table[{i}] {a/(a + b)}
			x = x + dx
		end
		tau_tweak_tabchan eds_Kdr X
		setfield eds_Kdr X_A->calc_mode 0 X_B->calc_mode 0
		call eds_Kdr TABFILL X {{tab_xfills} + 1} 0

/*
		call eds_Kdr TABCREATE Y {tab_xdivs} {tab_xmin}  \
		    {tab_xmax}
		x = {tab_xmin}

		for (i = 0; i <= ({tab_xdivs}); i = i + 1)
			if (x < -0.025)
				setfield eds_Kdr Y_A->table[{i}] 1.2
			else
				setfield eds_Kdr Y_A->table[{i}] 0.010
			end

			y = 1.0 + {exp {(x + 0.025)/0.004}}
			setfield eds_Kdr Y_B->table[{i}] {1.0/y}
			x = x + dx
		end
		tau_tweak_tabchan eds_Kdr Y
		setfield eds_Kdr Y_A->calc_mode 0 Y_B->calc_mode 0
		call eds_Kdr TABFILL Y {{tab_xfills} + 1} 0
*/
	end

/* non-inactivating (muscarinic) type K current, eq#2
** eq#2: corrected typo in Yamada equation for tau: 20 instead of 40
** Refs: Yamada (his equations are also for 22C) */
    if (!({exists eds_KM}))
		create tabchannel eds_KM
		setfield eds_KM Ek {EK} Gbar {GK} Ik 0 Gk 0 Xpower 1  \
		    Ypower 0 Zpower 0

	    call eds_KM TABCREATE X {tab_xdivs} {tab_xmin} {tab_xmax}
		x = {tab_xmin}
		dx = ({tab_xmax} - {tab_xmin})/{tab_xdivs}

	    for (i = 0; i <= ({tab_xdivs}); i = i + 1)
			y = 0.2/(3.3*({exp {(x + 0.035)/0.02}}) + {exp {-(x + 0.035)/0.02}})
			setfield eds_KM X_A->table[{i}] {y}

			y = 1.0/(1.0 + {exp {-(x + 0.035)/0.01}})
			setfield eds_KM X_B->table[{i}] {y}
			x = x + dx
	    end
	    tau_tweak_tabchan eds_KM X
	    setfield eds_KM X_A->calc_mode 0 X_B->calc_mode 0
	    call eds_KM TABFILL X {{tab_xfills} + 1} 0
    end

/* non-inactivating BK-type Ca-dependent K current eq 3 (Gruol K1)
** Refs:Gruol89: presence of BK-type KC channel (84 pS single
**             channel, physiol [K], and 165 pS symmetric [K])
**      Gruol91: presence of BK-type KC channel (92 and 222pS), requires
**             >50 mV depol for activation
**      Reinhart: Hill coeff of 2 for big conductance channels.
**      Gahwiller: presence of 90 pS KC channel.
** \
              Franciolini: [Ca] dep and Minf data (rat hippocampus) k=14, V0=-15mV
**      Gola: am, ab equations (Helix neurones), k=14.9, V0=-5mV
**            slow Ca-dependent opening (50-100 ms delay)
**      Ikemoto: 18-280ms delay, [Ca] dependent
**      Yamada: does not work well, activates too fast, follows
**              ICaL current to closely to be able to repolarize */
    /* scaled for units: V, sec, mM */
    make_chan eds_KC {EK} {GK} 1 7.5e3 0.0 0.0 -0.020 1.0e12 0.110e3 0.0  \
        0.0 -0.055 14.9e-3 0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0  \
        0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0
    /*3a:    make_chan(eds_KC,{EK},{GK}, \
		1,7.5e3,0.0,0.0,0.0,1.0e12,0.110e3,0.0,0.0,-0.025,14.9e-3, \
		0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0, \
		0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0)  */
    /* 2c:    make_chan(eds_KC,{EK},{GK}, \
		1,7.5e3,0.0,0.0,0.0,0.0,0.110e3,0.0,0.0,0.000,14.9e-3, \
		0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0, \
		0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0) */
    /* Z: Ca-activation, tabchannel specific implementation,
    ** based on Franciolini */
    cmin = ({CCaI}) // 0.000050
    cmax = ({Ca_tab_max}) // will create a z-range from 0.0021 to 0.9727
    cdivs = 2999
    c = cmin
    dc = cdivs
    dc = (cmax - cmin)/cdivs
    ztau = 0.020
    call eds_KC TABCREATE Z {cdivs} {cmin} {cmax}
    for (i = 0; i <= (cdivs); i = i + 1)
	//	zinf = 1/(1 + (8.0e-3/c))
		zinf = 1.0 / (1 + {exp {-0.3 * ((c * 2.5e4) - 65)}})
		setfield eds_KC Z_A->table[{i}] {zinf/ztau}
		setfield eds_KC Z_B->table[{i}] {1/ztau}
		c = c + dc
    end
    setfield eds_KC Zpower 2
    setfield eds_KC Z_A->calc_mode 0
    setfield eds_KC Z_B->calc_mode 0

/* non-inactivating Ca-dependent K current eq 1 (Gruol K2)
** Refs:Gruol91: presence of K2 KC channel (57 and 134pS), requires
**             10-20 mV depol for activation.  About 20% of KC channels
**             with correct conductance, about 13% of gmax.
**      Reinhart: Hill coeff of 2 for big conductance channels.  Tau-values.
**             For alfa: 90% C1, 10% C2.  For beta: mean open shorter than
**             K1 (fig3c versus 3a). Blocked by low outside TEA, not by
**             apamine, slow, small conductance  channel blocked by CTX.
**      Farley: 110-125pS channel large fraction open at [Ca]=0.1uM,
**             requires however 30-40mV depol to open. Not 4-AP sensitive,
**             low sensitivity to cis-TEA (inside?). */
    /* scaled for units: V, sec, mM */
    make_chan eds_K2 {EK} {GK} 1 25.0e3 0.0 0.0 0.003 1.0e12 0.075e3 0.0  \
        0.0 0.028 6.0e-3 0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0 0.0 \
         0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0 0.0
    /* Z: Ca-activation, tabchannel specific implementation */
    cmin = ({CCaI})
    cmax = ({Ca_tab_max})
    cdivs = 2999
    c = cmin
    dc = cdivs
    dc = (cmax - cmin)/cdivs
    ztau = 0.010
    call eds_K2 TABCREATE Z {cdivs} {cmin} {cmax}
    for (i = 0; i <= (cdivs); i = i + 1)
//		zinf = 1/(1 + (0.2e-3/c))
//		zinf = 0.8 /(1 + (0.6e-3/c)) + 0.2
//		zinf = 1 / (1 + {exp {-0.8 * ((c * 1e4) - 3.0)}})
		zinf = 1.0 / (1 + {exp {-0.3 * ((c * 2.5e4) - 10)}})
		setfield eds_K2 Z_A->table[{i}] {zinf/ztau}
		setfield eds_K2 Z_B->table[{i}] {1/ztau}
		c = c + dc
    end
    setfield eds_K2 Zpower 2
    setfield eds_K2 Z_A->calc_mode 0
    setfield eds_K2 Z_B->calc_mode 0

/* Anomalous rectifier eq#2:
** Refs: Spain: all data, one current represented as 2 separate channels
**				with different time constants */
    if (!({exists eds_h1}))
		create tabchannel eds_h1
		setfield eds_h1 Ek {Eh} Gbar {Gh} Ik 0 Gk 0 Xpower 1  \
		    Ypower 0 Zpower 0
	    call eds_h1 TABCREATE X {tab_xdivs} {tab_xmin} {tab_xmax}

		create tabchannel eds_h2
		setfield eds_h2 Ek {Eh} Gbar {Gh} Ik 0 Gk 0 Xpower 1  \
		    Ypower 0 Zpower 0
	    call eds_h2 TABCREATE X {tab_xdivs} {tab_xmin} {tab_xmax}

		x = {tab_xmin}
		dx = ({tab_xmax} - {tab_xmin})/{tab_xdivs}

	    for (i = 0; i <= ({tab_xdivs}); i = i + 1)
			//fast component
			setfield eds_h1 X_A->table[{i}] 0.0076
			//slow component
			setfield eds_h2 X_A->table[{i}] 0.0368
			y = 1.0/(1 + {exp {(x + 0.082)/0.007}})
			setfield eds_h1 X_B->table[{i}] {0.8*y}
			setfield eds_h2 X_B->table[{i}] {0.2*y}
			x = x + dx
	    end
	    tau_tweak_tabchan eds_h1 X
	    setfield eds_h1 X_A->calc_mode 0 X_B->calc_mode 0
	    call eds_h1 TABFILL X {{tab_xfills} + 1} 0
	    tau_tweak_tabchan eds_h2 X
	    setfield eds_h2 X_A->calc_mode 0 X_B->calc_mode 0
	    call eds_h2 TABFILL X {{tab_xfills} + 1} 0
    end

	pope
echo Done
end  // making eds chans
/*********************************************************************
** Complete references:
** CURRENT KINETICS
** Connor JA, Stevens CF: Prediction of repetitive firing
**  behaviour from voltage clamp data on an isolated neurone soma. 
**  J Physiol 213, p 31-53, 1971.
** Farley J., Rudy B: Multiple types of voltage-dependent Ca2+-activated
**  K+ channels of large conductance in rat synaptosomal membranes. J Biophys
**  53, p 919-934, 1988.
** Fox AP, Nowycky MC, Tsien RW: Kinetic and pharmacological
**  properties distinguishing three types of calcium currents in chick
**  sensory neurons.  J Physiol 394, p 149-172, 1987.
** Franciolini F: Calcium and voltage denpendence of single
**  Ca2+-activated K+ channels from cultured hippocampal neurons of
**  rat.  Biochim Biophys Acta 93, p 419-427, 1988.
** French CR, Sah P, Buckett KJ, Gage PW: A voltage-dependent
**  persistent sodium current in mammalian hippocampal neurons.  J Gen
**  Physiol 95, p 1139-1157, 1990.
** Gahwiller BH, Llano I: Sodium and potassium conductances in
**  somatic membranes of rat Purkinje cells from organotypic cerebellar
**  cultures.  J Physiol 417, p 105-122, 1989 .
** Gruol DL, Dionne VE, Yool AJ: Multiple voltage-sensitive K
**  channels regulate dendritic excitability in cerebellar Purkinje
**  neurons. Neurosci Lett 97, p 97-102, 1989.
** Gruol DL, Jacquin T, Yool AJ:  Single-channel K+ currents recorded from
**  the somatic and dendritic regions of cerebellar Purkinje neurons in
**  culture.  J Neurosci 11, p 1002-1015, 1991.
** Gola M, Ducreux C, Chagneux H: Ca2+-activated K+ current
**  involvement in neuronal function revealed by in situ single-channel
**  analysis in Helix neurones.  J Physiol 420, p 73-109, 1990.
** Hirano T, Hagiwara S: Kinetics and distribution of
**  voltage-gated Ca, Na and K channels on the somata of rat
**  cerebellar Purkinje cells. Pflugers Arch 413, p 463-469, 1989.
** Hockberger PE, Yousif L: Voltage-dependent and pharmacological
**  properties of calcium currents in isolated rat cerebellar
**  Purkinje cells.  Abstr Soc Neurosci 16, p 956, 1990.
** Hodgkin AL, Huxley AF: A quantitative description of membrane
**  current and its application to conduction and excitation in nerve.
**  J Physiol 117, p 500-544, 1952.
** Huang L-YM J Physiol 411, p161, 1961.
** Ikemoto Y, Ono K, Yoshida A, Akaike N: Delayed activation of
**  large-conductance Ca2+-activated K channels in hippocampal neurons
**  in the rat.  Biophys J 56, p 207-212, 1989.
** Kaneda M, Wakamori M, Ito C, Akaike N: Low-threshold calcium
**  current in isolated Purkinje cell bodies of rat cerebellum. J
**  Neurophys 63, p 1046-1051, 1990.
** Kay AR, Sugimori M, Llinas RR: Voltage clamp analysis of a
**  persistent TTX-sensitive Na currrent in cerebellar
**  Purkinje cells.  Abstr Soc Neurosci 16, p 182, 1990.
** Knopfel T, Staub C, Gahwiler BH: Spatial spread of voltage
**  transients in cerebellar Purkinje cells.  Abstr Soc 
**  Neurosci 16, p 636, 1990.
** Li SJ, Wang Y, Strahlendorf HK, Strahlendorf JC: A transient
**  voltage-dependent outward current recorded from rat cerebellar
**  Purkinje cells under voltage clamp.  Abstr Soc 
**  Neurosci 16, p 507, 1990.
** Reinhart PH, Chung S, Levitan IB: A family of calcium-dependent
**  potassium channels from rat brain.  Neuron 2, p 1031-1041, 1989.
** Regan LJ: Voltage-dependent calcium curents in Purkinje cells from rat
**  cerebellar vermis.  J Neurosci 11, p 2259-2269, 1991.
** Spain WJ, Schwindt PC, Crill WE: Anomalous rectification in neurons 
**  from cat sensorimotor cortex in vitro. J Neurophysiol 57, p 1555-1576,
**  1987.
** Wang Y, Li SJ, Strahlendorf JC, Strahlendorf HK: Serotonin
**  reduces an inwardly rectifying cesium sensitive current in
**  cerebellar Purkinje cells under voltage clamp.  Abstr Soc
**  Neurosci 16, p 1019, 1990.
** Yamada WM, Koch C, Adams PR: Mutiple channels and calcium
**  dynamics.  In Koch C, Segev I (eds): Methods in neuronal modeling,
**  MIT Press, Cambridge, p 97-133, 1989
** Yue DT, Backx PH, Imredy JP: Calcium-sensitive inactivation in
**  the gating of single calcium channels. Science 250,
**  p 1735-1738, 1990.
** CHANNEL DISTRIBUTIONS:
** Ahlijanian MK, Westenbroek RE, Catteral WA: Subunit structure and
**  localization of dihydropyridine-sensitive calcium channels in mammalian
**  brain, spinal cord, and retina. Neuron 4, p 819-832, 1990.
**** "Cell bodies of all Purkinje cells appear darkly labeled" (L-type Ca-
**** channel from skeletal muscle antibody)
** Fortier LP, Tremblay JP, Rafrafi J, Hawkes R: A monoclonal antibody to
**  conotoxin reveals the distribution of a subset of calcium channels in the
**  rat cerebellar cortex.  Molec Brain Res 9, p 209-215, 1991.
**** "staining of Purkinje cells was more intense in the soma and at large
**** dendritic branching points"
** Lev-Ram V, Miyakawa H, Lasser-Ross N, Ross WN: Spatial distribution of
**  TTX-sensitive and TTX-insensitive calcium changes in cerebellar Purkinje
**  cells in vitro.  Biophys J 57, p 130, 1990.
**** "spike related signals were largest over the fine spiny dendrites and
**** were much bigger than the plateau signals (all over dendritic field). A
**** small but clear ... somatic signal was detected"
*********************************************************************/


function tabtofile(channel, gate)

	str channel
	str gate

	int i
	int xdivs
	float gate_a
	float gate_b
	float xmin
	float xmax
	str fname

	fname = {channel} @ "." @ {gate}
	pushe /library
	echo Channel {channel} gate {gate} saved to file {fname}
	
	xdivs = {getfield  {channel} {gate}_A->xdivs }
	xmin = {getfield {channel} {gate}_A->xmin }
	xmax = {getfield {channel} {gate}_A->xmax }

	echo Number of entries in table: {xdivs}, xmin={xmin}, xmax={xmax}

	openfile {fname} w 
	writefile {fname} /plotname {channel} tau
	writefile {fname} /xscale {{xmax - xmin} / {xdivs}}
	writefile {fname} /xintcpt {xmin}
	writefile {fname} /xoffset_axis {xmin}
		
	for (i=0; i<{xdivs}; i=i+1)
		writefile {fname} {1.0 / {getfield {channel} {gate}_B->table[{i}]}} 
	end	

	writefile {fname} /newplot
	writefile {fname} /plotname {channel} minf
	writefile {fname} /xscale {{xmax - xmin} / {xdivs}}
	writefile {fname} /xintcpt {xmin}
	writefile {fname} /xoffset_axis {xmin}

	for (i=0; i<{xdivs}; i=i+1)
		gate_a = {getfield {channel} {gate}_A->table[{i}]}
		gate_b = {getfield {channel} {gate}_B->table[{i}]}
		writefile {fname} { {gate_a} / {gate_b} }
	end
	closefile {fname}

	pope
end

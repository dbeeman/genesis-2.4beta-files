// genesis

int include_tutorial_granule_channels_read

if ( {include_tutorial_granule_channels_read} == 0 )

	include_tutorial_granule_channels_read = 1



/* First include Gran_chan_KCa_tab.g for non-inactivating BK-type 
** Ca-dependent K current.
*/

include ht_granule_channel_KCa_read.g 

function granule_make_channels_read

    int i, cdivs
    float zinf, ztau, c, dc, cmin, cmax
    float x, dx, y
    float a, b
    /* The folowing variables are temporary (not temperature) variables
	used to speed up computations */
    float mintau
    float tau
    float temp1
    float temp2

    pushe /library

    /* Equations specific to the Granule cell, made by CP */
    /* Inactivating Na current */

    if (!{exists Gran_InNa})
	create tabchannel Gran_InNa
	setfield Gran_InNa Ek {ENa} Gbar 70 Ik 0 Gk 0 Xpower 3 Ypower 1  \
	    Zpower 0

	call Gran_InNa TABCREATE X {tab_xdivs} {tab_xmin} {tab_xmax}
	setfield Gran_InNa X_A->calc_mode 1 X_B->calc_mode 1
	call Gran_InNa TABCREATE Y {tab_xdivs} {tab_xmin} {tab_xmax}
	setfield Gran_InNa Y_A->calc_mode 1 Y_B->calc_mode 1
	call Gran_InNa TABREAD tabInNa37.data
    end

	/* Delayed Rectifier K current */

    if (!{exists Gran_KDr})
	create tabchannel Gran_KDr
	setfield Gran_KDr Ek {EK} Gbar 19 Ik 0 Gk 0 Xpower 4 Ypower 1  \
	    Zpower 0

	call Gran_KDr TABCREATE X {tab_xdivs} {tab_xmin} {tab_xmax}
	setfield Gran_KDr X_A->calc_mode 1 X_B->calc_mode 1
	call Gran_KDr TABCREATE Y {tab_xdivs} {tab_xmin} {tab_xmax}
	setfield Gran_KDr Y_A->calc_mode 1 Y_B->calc_mode 1
	call Gran_KDr TABREAD tabKDr37.data
    end

	/*  K A-current  fast transient potassium channel*/

    if (!{exists Gran_KA})
	create tabchannel Gran_KA
	setfield Gran_KA Ek {EK} Gbar 3.67 Ik 0 Gk 0 Xpower 3 Ypower 1  \
	    Zpower 0

	call Gran_KA TABCREATE X {tab_xdivs} {tab_xmin} {tab_xmax}
	setfield Gran_KA X_A->calc_mode 1 X_B->calc_mode 1
	call Gran_KA TABCREATE Y {tab_xdivs} {tab_xmin} {tab_xmax}
	setfield Gran_KA Y_A->calc_mode 1 Y_B->calc_mode 1
	call Gran_KA TABREAD tabKA37.data
    end

	/* High Voltage Activated HVA Ca current */

    if (!{exists Gran_CaHVA})
	create tabchannel Gran_CaHVA
	setfield Gran_CaHVA Ek {ECa} Gbar 2.91 Ik 0 Gk 0 Xpower 2  \
	    Ypower 1 Zpower 0

	call Gran_CaHVA TABCREATE X {tab_xdivs} {tab_xmin} {tab_xmax}
	setfield Gran_CaHVA X_A->calc_mode 1 X_B->calc_mode 1
	call Gran_CaHVA TABCREATE Y {tab_xdivs} {tab_xmin} {tab_xmax}
	setfield Gran_CaHVA Y_A->calc_mode 1 Y_B->calc_mode 1
	call Gran_CaHVA TABREAD tabCaHVA37.data
    end

	/* Slowly relaxing, mixed Na/K current H 
** Gabbiani et al. used this to model sag in membrane potential during
** hyperpolarizing current pulses 
*/

    if (!{exists Gran_H})
	create tabchannel Gran_H
	setfield Gran_H Ek {EH} Gbar 0.09 Ik 0 Gk 0 Xpower 1 Ypower 0  \
	    Zpower 0

	call Gran_H TABCREATE X {tab_xdivs} {tab_xmin} {tab_xmax}
	setfield Gran_H X_A->calc_mode 1 X_B->calc_mode 1
	call Gran_H TABREAD tabH37.data
    end

	/* non-inactivating BK-type Ca-dependent K current 
   see Moczyd_KC.g
*/
echo diag gran chan 1
granule_make_Moczyd_KC_read
echo diag gran chan 2

    pope


end


end



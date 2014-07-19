// genesis

// Customized userprefs.g to run the Bush and Sejnowski 1993 model
// This version uses the channels by Bernander, Douglas and Koch

echo Using local user preferences
 
/**********************************************************************
**
**	1	Including script files for prototype functions
**
**********************************************************************/

/* file for standard compartments */
include compartments

/* file for channels */
include BDKchan

/* file which makes a spike generator */
include protospike

/**********************************************************************
**
**	2	Invoking functions to make prototypes in the /library element
**
**********************************************************************/

/* To ensure that all subsequent elements are made in the library */
pushe /library

	make_cylind_compartment		/* makes "compartment" */
        make_cylind_symcompartment      /* makes "symcompartment" */

/* make the channels */
make_Na_pyr_bdk    Na
make_Kdr_pyr_bdk   Kdr
make_Ca_pyr_bdk    Ca
make_Ka_pyr_bdk    Ka
make_Ca_conc
make_Kahp_pyr_bdk  Kahp
make_Km_pyr_bdk    Km
make_Nap_pyr_bdk   Nap
make_AR1_pyr_bdk   AR1
make_AR2_pyr_bdk   AR2
make_Ex_channel
make_spike	/* Make a spike generator element */

pope /		/* return to the root element */

/**********************************************************************
**
**	3	Setting preferences for user-variables.
**
**********************************************************************/

/* See defaults.g for default values of these */
str user_help = "README"

user_cell = "/cell"
user_pfile = "layer5BDK.p"
user_symcomps = 1 // symmetric

user_runtime = 0.1
user_dt = 50e-6  // 0.05 msec
user_refresh = 5


// These are used for the two buttons which can be used to enter a value
// in the "Syn Type" dialog box
user_syntype1 = "Ex_channel"
user_syntype2 = "Inh_channel"

user_inject = 1.0  // default injection current (nA)

//position the cell in the draw

user_wx = 500e-6
user_wy = 550e-6
user_cx = 0.0
user_cy = 90e-6
user_fatrange1 = -60.0
user_fatrange2 = -60.0

// Set the scales for the graphs in the two cell windows
user_ymin1 = -0.1
user_ymax1 = 0.05
user_xmax1 = 0.1
user_xmax2 = 0.1
user_ymin2 = 0.0
user_ymax2 = 0.1 // mM

user_yoffset1 = 0.0
user_yoffset2 = 0.0

user_numxouts = 1
user_field2	= "Ca"
user_path2 = "Ca_conc"
user_colmin2 = 0        // use appropriate color scale for Ca_conc values
user_colmax2 = 0.00015

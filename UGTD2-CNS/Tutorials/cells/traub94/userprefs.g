// genesis

// Customized userprefs.g to run the "Traub91" simulation with neurokit

echo Using local user preferences

/**********************************************************************
**
**   1   Including script files for prototype functions
**
**********************************************************************/

/* file for standard compartments */
include compartments 
/* file for 1994 Traub model channels */
include traub94proto.g 

/****************************************************************************
**
**   2   Invoking functions to make prototypes in the /library element
**
****************************************************************************/

/* To ensure that all subsequent elements are made in the library */
	pushe /library

	/* makes "compartment" */
	make_cylind_compartment

make_Na
make_Ca
make_K_DR
make_K_AHP
make_K_AHP_soma
make_K_C
make_K_C_soma
make_K_A
make_Na_axon
make_K_DR_axon
make_Ca_conc
make_Ca_conc_soma

/* return to the root element */
pope

/**********************************************************************
**
**	3	Setting preferences for user-variables.
**
**********************************************************************/
/* See defaults.g for default values of these */

// asymmetric -by pulin to incorporate asym compts
user_symcomps = 0
str user_help = "README"
user_intmethod = 11  // Hines Crank-Nicholson

// wx, wy, cx, cy, cz for the draw widget
float user_wx = 0.45e-3
// 1.1e-3
float user_wy = 0.5e-3
float user_cx = 0.0
float user_cy = 0.1e-3
float user_cz = 0.1e-3

user_cell = "/CA3"
user_pfile = "CA3.p"

user_runtime = 0.10
// 2.5 usec -- traub 94
//user_dt = 2.5e-6
user_dt = 25e-6
user_refresh = 10

// default injection current (nA)
user_inject = 0.0

// Set the scales for the graphs in the two cell windows
user_ymin1 = -0.1
user_ymax1 = 0.15
user_xmax1 = 0.1
user_xmax2 = 0.1
user_ymin2 = 0.0
user_ymax2 = 5e-7
user_yoffset2 = 0.0

// user_colmax2 = 10000 this should keep it black, even if colfix doen't work
/*  This displays the second cell window and plots the "Gk" field of the
    "Ca" channel for the compartment in which a recording electrode
    has been planted.  The default values of the field and path
    are "Vm" and ".", meaning to plot the Vm field for the compartment
    which is selected for recording.
*/

user_numxouts = 1
user_field2 = "Gk"
user_path2 = "Ca"

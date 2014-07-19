// genesis

// Customized userprefs.g to run the "simplecell" simulation with neurokit

echo Using local user preferences
 
/***************************************************************************
**
**  Step 1: Including script files for prototype functions
**          Included files or code below should provide any needed prototype
**          elements that are used by the cell reader in /library, or
**          the functions needed to create them.
**********************************************************************/

include protodefs.g

/**********************************************************************
**
**	2	Invoking functions to make prototypes in the /library element
**
**********************************************************************/

/* In this case, protodefs.g also makes the prototypes, so there is
   nothing else to do.
*/

/**********************************************************************
**
**	3	Setting preferences for user-variables.
**
**********************************************************************/

/* See defaults.g for default values of these */
str user_help = "README"

user_cell = "/cell"
user_pfile = "cell.p"
user_symcomps = 0 // asymmetric

user_runtime = 0.100
user_dt = 20e-6  // 0.02 msec
user_refresh = 5


// These are used for the two buttons which can be used to enter a value
// in the "Syn Type" dialog box
user_syntype1 = "Ex_channel"
user_syntype2 = "Inh_channel"

user_inject = 0.3  // default injection current (nA)

//position the cell in the draw

user_wx = 500e-6
user_wy = 550e-6
user_cx = 0.0
user_cy = 0.0
//user_cy = 90e-6
user_fatrange1 = -60.0
user_fatrange2 = -60.0

// Set the scales for the graphs in the two cell windows
user_ymin1 = -0.1
user_ymax1 = 0.05
user_xmax1 = 0.1
user_xmax2 = 0.1
user_ymin2 = -0.1
user_ymax2 = 0.05

user_yoffset1 = 0.0
user_yoffset2 = 0.0

user_numxouts = 1

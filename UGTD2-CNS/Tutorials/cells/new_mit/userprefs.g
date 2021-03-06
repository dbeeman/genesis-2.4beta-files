// genesis

/**********************************************************************
**
**	DO NOT EDIT THIS FILE IN THE neurokit DIRECTORY!
**
**	Make a copy of this file in every directory that contains .p
**	files and edit the copies, in order to customize neurokit for
**	different simulations. When you run neurokit from other
**	directories, the simulator will look for the local version of
**	userprefs.g, and if it cannot find it there will look for the
**	default in the neurokit directory. This version of userprefs is
**	set up to run the Coarse Asymmetric Mitral cell demo.
**	
**	There are three aspects to customisation :
**	
**    	1	Include the appropriate script files from the /neuron/prototype
**  		directory and from wherever you have defined new prototype
**		elements.
**
**    	2	Invoke the functions that make the prototypes you want for
**		your simulation.
**
**	3	Put your preferences for the user_variables defined in
** 		defaults.g in the copies of this file.
**
**********************************************************************/

echo Using default user preferences!

/**********************************************************************
**
**	1	Including script files for prototype functions
**
**********************************************************************/

/* file for standard compartments */
include compartments 

/* file for Hodgkin-Huxley Squid Na and K channels */
include newbulbchan

/* file for Upi's mitral cell channels */
// include mitchan 

/* file for Upi's mitral cell synaptic channels */
// include mitsynC2 // for now use channelC2 version
// later convert Neurokit to use synchan version
// include mitsyn 

/************************************************************************
**  2	Invoking functions to make prototypes in the /library element
************************************************************************/

/*   To ensure that all subsequent elements are made in the library    */
	pushe /library


	/* Make the standard types of compartments  */

                make_cylind_compartment		/* makes "compartment" */
                make_LCa3_mit_usb
                make_K2_mit_usb
                make_K_mit_usb
                make_KA_bsg_yka
                setfield KA_bsg_yka Ek -0.07
                make_Na_mit_usb
                make_Ca_mit_conc
                make_Kca_mit_usb

	/* returning to the root element */
	pope

/*************************************************************** *******
**
**	3	Setting preferences for user-variables.
**
**********************************************************************/

/* See defaults.g for default values of these. Put your preferred
   values for these in your copy of userprefs in the directory from
   which you are running your simulations. */
user_pfile = "smit2.p"
user_cell = "/cell"
user_dt = 50e-6
user_runtime = 0.32
user_inject = 0.5  //  nA
user_help = "Notes"
user_intmethod = 11

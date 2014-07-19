// protodefs.g - Definition of prototype elements and globals
// When using the GENESIS sever, many of these commands should be uploaded by
// the client

// This version is for Upi's mitral cell model

include defaults.g  // Defines necessary functions and global variables
                    // This should be in SIMPATH (Scripts/neurokit)

// These variables are defined and initialized in defaults.g

user_pfile = "smit2.p"
user_cell = "/cell"
comptname = "soma"
user_intmethod = 11
user_dt = 50e-6
user_runtime = 0.32
user_inject = 0.5e-9  // 0.5 nA
user_refresh = 10.0   // use this factor for plot and xcell clocks
user_filename = "smit_somaVm" // filename for output of comptname Vm
int user_symcomps = 0 // Does cell use symcompartments?

/* files for standard compartments */
include compartments

/* channels used in this simulation */
include newbulbchan

/* When used with the GENESIS server, most of these should be created by
   commands from the client.  Also, check to be sure that these are all
   needed by mit.p
*/

pushe /library
        make_cylind_compartment

        make_LCa3_mit_usb
        make_K2_mit_usb
        make_K_mit_usb
        make_KA_bsg_yka
        setfield KA_bsg_yka Ek -0.07
        make_Na_mit_usb
        make_Ca_mit_conc
        make_Kca_mit_usb
pope

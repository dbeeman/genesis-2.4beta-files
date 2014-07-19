// protodefs.g - Definition of prototype elements for "BDK5cell"

/* Included files are in genesis/Scripts/neurokit/prototypes */

/* file for standard compartments */
include compartments

// include the definitions for the functions to create H-H tabchannels
include  BDKchan.g


/* file for synaptic channels */
include synchans

/* file which makes a spike generator */
include protospike

// Make a "library element" to hold the prototypes which will be used
// by the cell reader to add compartments and channels to the cell.

if (!{exists /library})     // But, only if it doesn't already exist
    create neutral /library
end

// We don't want the library to try to calculate anything, so we disable it
disable /library

// To ensure that all subsequent elements are made in the library
pushe /library

/* Make a prototype compartment.  The internal fields will be set by
   the cell reader, so they do not need to be set here.  The
   make_cylind_compartment function is defined in compartments.g.
*/
make_cylind_compartment         /* makes "compartment" */
make_cylind_symcompartment      /* makes "symcompartment" */

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


// Make a prototype excitatory channel, "Ex_channel" - from synchans.g
make_Ex_channel     /* synchan with Ek = 0.045, tau1 = tau2 = 3 msec */

// Make a prototype inhibitory channel, "Inh_channel"
// make_Inh_channel     /* synchan with Ek = -0.082, tau1 = tau2 = 20 msec */

/* Make a spike generator (spikegen) element "spike" - from protospike.g */
make_spike

pope // Return to the original place in the element tree

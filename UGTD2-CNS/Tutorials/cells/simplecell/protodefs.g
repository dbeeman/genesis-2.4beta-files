// protodefs.g - Definition of prototype elements for "simplecell"

/* Included files are in genesis/Scripts/neurokit/prototypes */

/* file for standard compartments */
include compartments

// include the definitions for the functions to create H-H tabchannels
include hh_tchan

/* hh_tchan.g assigns values to the global variables EREST_ACT, ENA, EK, and
   SOMA_A.  The first three will be superseded by values defined below.  The
   value of SOMA_A set in hh_tchan.g is not relevant, as the cell reader
   calculates the compartment area.
*/

EREST_ACT = -0.07	// resting membrane potential (volts)
ENA   = 0.045           // sodium equilibrium potential
EK    = -0.082          // potassium equilibrium potential

/* file for synaptic channels */
include synchans

/* file which makes a spike generator */
include protospike

// Make a "library element" to hold the prototypes, which will be used
// by the cell reader to add compartments and channels to the cell.
create neutral /library

// We don't want the library to try to calculate anything, so we disable it
disable /library

// To ensure that all subsequent elements are made in the library
pushe /library

/* Make a prototype compartment.  The internal fields will be set by
   the cell reader, so they do not need to be set here.  The
   make_cylind_compartment function is defined in compartments.g.
*/
make_cylind_compartment

/* Functions in hh_tchan.g create prototype H-H tabchannels
   "Na_hh_tchan" and "K_hh_tchan"
*/
make_Na_hh_tchan
make_K_hh_tchan

// Make a prototype excitatory channel, "Ex_channel" - from synchans.g
make_Ex_channel     /* synchan with Ek = 0.045, tau1 = tau2 = 3 msec */

// Make a prototype inhibitory channel, "Inh_channel"
make_Inh_channel     /* synchan with Ek = -0.082, tau1 = tau2 = 20 msec */

/* Make a spike generator (spikegen) element "spike" - from protospike.g */
make_spike

pope // Return to the original place in the element tree

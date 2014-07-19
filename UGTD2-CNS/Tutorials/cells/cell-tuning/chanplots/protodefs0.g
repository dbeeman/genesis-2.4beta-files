// protodefs.g - Definition of prototype elements for Auditory Cortex Cells

/* Included files are in genesis/Scripts/neurokit/prototypes */

float EREST_ACT = -0.07       // resting membrane potential (volts)
float ENA   = 0.045           // sodium equilibrium potential
float EK    = -0.082          // potassium equilibrium potential

/* file for standard compartments */
include compartments

// include the definitions for the functions to create channels
include  pyrchans0.g

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
make_cylind_symcompartment      /* makes "symcompartment" */

/* Make the pyramidal cell channels.  

   Note that pyrchans.g changes some global variables.  Different
   values could be added here.
*/

/* the values in pyrchans.g are
float EREST_ACT = -0.060 // hippocampal cell resting potl
float ENA = 0.115 + EREST_ACT // 0.055
float EK = -0.015 + EREST_ACT // -0.075
float ECA = 0.140 + EREST_ACT // 0.080
*/

make_Na_hip_traub91 Na_pyr
make_Kdr_hip_traub91 Kdr_pyr
// slow down the firng by doubling Kdr_pyr
// scaletabchan Kdr_pyr X tau 1.0 2.0 0.0 0.0

make_Ca_hip_traub91  // This needs to keep the name Ca_hip_traub91
make_Kahp_hip_traub91 Kahp_pyr
/* The original traub91 Kahp tau had a max of 1 sec at [Ca]=0, dropping
   to 0.2 when [Ca]=200, and 0.1 at higher values.  This scaling makes the
   typical range 10-50 msec, which is roughly the time for adaptation in
   neocortical pyramidal cells.
*/
// scaletabchan Kahp_pyr Z tau 1.0 0.05 0.0 0.0

make_Ca_hip_conc Ca_conc
/* The original Ca_conc tau was 0.0133 sec.  A value of 0.05 sec gives
    [Ca] more time to decay.
*/
setfield Ca_conc tau 0.1

/* Make the synaptically activated channels */
make_AMPA_pyr AMPA_pyr /* synchan with Ek = 0.0, tau1 = tau2 = 3 msec */
setfield AMPA_pyr frequency 0.0
make_GABA_pyr GABA_pyr /* synchan with Ek = -0.080, tau1 = 3, tau2 = 8 msec */
setfield GABA_pyr frequency 0.0

/* Make a spike generator (spikegen) element "spike" - from protospike.g */
make_spike

pope // Return to the original place in the element tree

//genesis

/* This script should be modified to create the channels for which the
   activations and taus will be plotted
*/

/* First create the channels.  This example is taken from the traub91
  channels in neurokit/prototypes
*/

include defaults.g   // Some definitions used by traub91chan.g
include traub91chan.g // the functions to create the channels

// a place to put channels - usually created in defaults.g or protodefs.g
if (!({exists /library}))
    create neutral /library
end
pushe /library
make_Ca_hip_traub91
make_Kdr_hip_traub91
make_Kahp_hip_traub91
make_Ka_hip_traub91
make_Na_hip_traub91
pope

/* This defines the default channel that will be plotted */
str channelpath = "/library/Ca_hip_traub91"

include chanplot.g  // modified from neurokit/xchannel_funcs.g
do_xchannel_funcs    // defined in chanplot.g 

ce /
xshow /channel_params  // show the form with graphs and widgets

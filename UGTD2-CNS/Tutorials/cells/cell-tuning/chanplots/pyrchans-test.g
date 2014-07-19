//genesis

/* This script should be modified to create the channels for which the
   activations and taus will be plotted
*/

/* First create the channels.  This example is taken from the traub91
  channels in neurokit/prototypes
*/

include pyrchans0.g
include protodefs0.g

// a place to put channels - usually created in defaults.g or protodefs.g

/*
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

*/

/* This defines the default channel that will be plotted */
str channelpath = "/library/Na_pyr"

include chanplot.g  // modified from neurokit/xchannel_funcs.g
do_xchannel_funcs    // defined in chanplot.g 
ce /

    setfield /##[ISA=xbutton] offbg rosybrown1 onbg rosybrown1
    setfield /##[ISA=xtoggle] onfg red offbg cadetblue1 onbg cadetblue1
    setfield /##[ISA=xdialog] bg palegoldenrod
    setfield /##[ISA=xgraph] bg ivory

xshow /channel_params  // show the form with graphs and widgets

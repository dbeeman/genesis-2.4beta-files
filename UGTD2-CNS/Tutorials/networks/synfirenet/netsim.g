// genesis  netsim.g

echo " "
echo "          *************************************************"
echo "          *                                               *"
echo "          *     A network demonstration of connected      *"
echo "          *               single compartments             *"
echo "          *                                               *"
echo "          *            Hacked by Dieter Jaeger            *"
echo "          *                     2/99                      *"
echo "          *************************************************"
echo " "
echo " "
echo "                   Special Thanks to Sharon Crook            "
echo "                          for the Use of                    "
echo "                    Documentation and Files from            "
echo "                              CPG                           "
echo " "
echo " "
// set the prompt
setprompt "netsim >"
// simulation time step in msec
setclock 0 0.1e-3
// output interval
setclock 1 0.2e-3
floatformat %.3g // do reasonable rounding for display

float injectval = 1e-9 // activated upon clicking on cell in view window

//========================================================================
//                            startup scripts
//========================================================================

include setcolors.g
// include output.g 
include xtools.g 
include toggles.g 
include graphs25.g
include ggraphs.g
// include graphs100.g
include help.g 
include settings.g 
include inputs.g 
include graphcontrols.g
// include vclamp.g
// include pulsesyn.g
// include alphasyn.g
include hebbsyn.g
include utilfuncs.g
include addvgchan.g
// include addspikechan.g
include cell.g 
include makeobjects.g 
include connections.g
// include eicon.g
include viewform.g 

//=======================================================================
//                      make simulation
//=======================================================================
makelibrary
makearray /cellarray
makeconnections /cellarray

//=======================================================================
//                      make graphics
//=======================================================================
loadgraphics
loadhelp

echo Making 25 graphs ...
makegraph /graphs/form1 /cellarray 1 10
makegraph /graphs/form2 /cellarray 11 20
makegraph /graphs/form3 /cellarray 21 30
makegraph /graphs/form4 /cellarray 61 70
makegraph /graphs/form5 /cellarray 91 100

makeggraph /graphs/gform1 /cellarray 11 20
makeggraph /graphs/gform2 /cellarray 61 70
makeggraph /graphs/gform3 /cellarray 91 100

//echo Making 100 graphs ...
int i

//echo Making 100 graphs ...
int i
int j=1

//for (i=1; i<100; i=i+10)
//makegraph /graphs/form{j} /cellarray {i} {{i}+9}
//j=j+1
//end
echo Done

// makesettings /cell
// makeinputs /cell 0.01
makeviewform /cellarray

//======================================================================
//                   check and initialize the simulation
//======================================================================
colorize  // change default colors of all widgets.
check
reset
echo Simulation loaded.

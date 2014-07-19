//genesis  -  simplecell.g
/*======================================================================
  A sample script to create a neuron containing channels taken from
  hh_tchan.g in the neurokit prototypes library.  SI units are used.
  ======================================================================*/

// Create a library of prototype elements to be used by the cell reader
include protodefs

float tmax = 0.5		// simulation time in sec
float dt = 0.00005		// simulation time step in sec
setclock  0  {dt}		// set the simulation clock

// include the graphics functions
include graphics

//===============================
//         Main Script
//===============================

readcell cell.p /cell1

// make the control panel
make_control

// make the graph to display soma Vm and pass messages to the graph
make_Vmgraph
addmsg /cell1/soma /data/voltage PLOT Vm *volts *red

setfield /control/Injection value 0.5e-9
set_inject /control/Injection  // set initial injection from Injection dialog

check
reset

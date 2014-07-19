//genesis  - gapdemo.g, modified from  simplecell.g
/*======================================================================
  A sample script to create a neuron containing channels taken from
  hh_tchan.g in the neurokit prototypes library.  SI units are used.
  ======================================================================*/

// This version creates two cells with a gap junction between their dendrites

// Create a library of prototype elements to be used by the cell reader
include protodefs

float tmax = 0.5		// simulation time in sec
float dt = 0.00005		// simulation time step in sec
setclock  0  {dt}		// set the simulation clock


float R_gap = 200e6  // ohms

// include the graphics functions
include graphics

//===============================
//         Main Script
//===============================

readcell cell.p /cell1
readcell cell.p /cell2

// make the control panel
make_control

// make the graph to display soma Vm and pass messages to the graph
make_Vmgraph
addmsg /cell1/soma /data/voltage PLOT Vm *Vm_1 *red
addmsg /cell2/soma /data/voltage PLOT Vm *Vm_2 *blue

setfield /cell1/dend/Ex_channel frequency 200
setfield /cell2/dend/Ex_channel frequency 200

addmsg /cell1/dend /cell2/dend RAXIAL {R_gap} Vm
addmsg /cell2/dend /cell1/dend RAXIAL {R_gap} Vm

check
reset
 

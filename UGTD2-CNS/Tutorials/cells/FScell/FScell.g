//genesis  -  FScell.g
/*======================================================================
  Creates a neuron from a specified cell parameter file, with channels
  taken from the prototypes created by the file protodefs.g.  When used
  with the GUI functions defined in graphics.g, it allows an injection
  current and a variety of synaptic inputs to be applied.
  ======================================================================*/

// Simple fast spiking interneuron model
// Customize these strings and parameters to simulate another cell.

str cellfile = "cell.p"
str cellpath = "/cell"
// Define the places for current injection and synaptic input
str injectpath = {cellpath} @ "/soma"  // Use '@' to concatenate strings
str synpath = {cellpath} @ "/dend/Ex_channel"
// For no synaptic input, set
// str synpath = ""

float tmax = 0.25		// simulation time in sec
float dt = 20e-6		// simulation time step in sec
float injcurrent = 0.3e-9	// current injection in Amperes

// If there is synaptic input, define gmax for the target synchan
float gmax  // value will be obtained from cell created by readcell
float spikeinterval = 0.01 // Default interval in applied spike train

// Label for the graph
str graphlabel = "Soma contains Na and K channels"

// Create a library of prototype elements to be used by the cell reader
include protodefs

//===============================
//      Function Definitions
//===============================

function step_tmax
    // Add any other commands here that you want to execute for each run
    step {tmax} -time
end

function do_quit
    // Add any other commands here to execute before quitting
    quit
end

function set_frequency(frequency) // random background activation
    float frequency
    setfield {synpath} frequency {frequency}
end

//===============================
//    Main simulation section
//===============================

setclock  0  {dt}		// set the simulation clock

// read a cell parameter file and create cell in "cellpath"
readcell {cellfile} {cellpath}

// Set up circuitry for synaptic input if synapse exists
if({synpath} != "")
    gmax = {getfield {synpath} gmax}
    create spikegen /spiketrain
    setfield /spiketrain thresh 0.5 abs_refract {spikeinterval}
    addmsg /spiketrain {synpath} SPIKE
end

// Include the functions used to build the GUI
include graphics

// make the control panel
make_control

// make the graph to display soma Vm and pass messages to the graph
make_Vmgraph
addmsg {cellpath}/soma /data/voltage PLOT Vm *volts *red

/* Set the initial injection current to the cell */
setfield {injectpath} inject {injcurrent}

colorize    // function defined in graphics.g adds colors to widgets
check       // self-consistency check of the simulation elements
reset	    // Initialize all simulation elements

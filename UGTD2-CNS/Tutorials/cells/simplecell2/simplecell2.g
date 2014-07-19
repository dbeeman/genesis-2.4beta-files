//genesis  -  simplecell2.g
/*======================================================================
  A sample script to create a neuron from a specified cell parameter file,
  with channels taken from the prototypes created by the file protodefs.g
  When used with the GUI functions defined in graphics.g, it allows a
  variety of pulsed current injection and synaptic inputs to be applied.
  ======================================================================*/

/* Customize these strings and parameters to modify this simulation for
   another cell.
*/

str cellfile = "cell.p"
str cellpath = "/cell"
// Define the places for current injection and synaptic input
str injectpath = {cellpath} @ "/soma"  // Use '@' to concatenate strings
str synpath = {cellpath} @ "/dend/Ex_channel"
// For no synaptic input, set
// str synpath = ""

float tmax = 0.25		// simulation time in sec
float dt = 0.00005		// simulation time step in sec

float injdelay = 0.05
// for constant injection, use injwidth = tmax, injdelay = 0
float injwidth = 0.15 // 10 msec
float injinterval = 1
float injcurrent = 0.5e-9

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
    // Add any other commands here that you want to execute before quitting
    quit
end

function set_inj_timing(delay, width, interval)
    float delay, width, interval
    setfield /injectpulse level1 1 width1 {width} delay1 {delay}  \
        baselevel 0.0 trig_mode 0 delay2 {interval - delay} width2 0
    // free run mode with no second level2 pulse
end

function set_frequency(frequency) // Frequency of random background activation
    float frequency
    setfield {synpath} frequency {frequency}
end


//===============================
//    Main simulation section
//===============================

setclock  0  {dt}		// set the simulation clock

// Use readcell read a cell parameter file and create a cell in "cellpath"
readcell {cellfile} {cellpath}

/* Set up the circuitry to provide injection pulses to the cell */
create pulsegen /injectpulse // Make a periodic injection current step
set_inj_timing {injdelay} {injwidth} {injinterval}
// set the amplitude (current) with the gain of a differential amplifier
create diffamp /injectpulse/injcurr
setfield /injectpulse/injcurr saturation 10000 gain {injcurrent}
addmsg /injectpulse /injectpulse/injcurr PLUS output
addmsg /injectpulse/injcurr {injectpath} INJECT output

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

colorize    // function defined in setcolors.g

check
reset

//genesis  -  ACcell01.g

/*======================================================================
  A sample script to create a neuron from a specified cell parameter file,
  with channels taken from the prototypes created by the file protodefs.g
  When used with the GUI functions defined in graphics.g, it allows a
  variety of pulsed current injection and synaptic inputs to be applied.
  ======================================================================*/

/* Customize these strings and parameters to modify this simulation for
   another cell.
*/

str cellfile = "pyr_4_test.p"
str cellpath = "/cell"
// Define the places for current injection and synaptic input
str injectpath = {cellpath} @ "/soma"  // Use '@' to concatenate strings
//str synpath = {cellpath} @ "/dend/Ex_channel"
// For no synaptic input, set
str synpath = ""
// str synpath = {cellpath} @ "/soma/Ex_channel"

float tmax = 0.5		// simulation time in sec
float dt = 0.00002		// simulation time step in sec

float injdelay = 0.05
// for constant injection, use injwidth = tmax, injdelay = 0
float injwidth = 0.45
float injinterval = 0.5
float injcurrent = 0.6e-9
// If there is synaptic input, define gmax for the target synchan
float gmax  // value will be obtained from cell created by readcell
float spikeinterval = 0.01 // Default interval in applied spike train

// Label for the graph
str graphlabel = "layer 5 pyramidal cell: " @ {cellfile}

/* These definitions are highly model specific !!! */

float gdens_Na, gdens_K, gdens_Ca, gdens_Kahp, B_Ca_conc, tau_Ca_conc
float gdens_CaT, gdens_Nap, gdens_H, Kahp_tauscale
str Na_chan = "Na_pyr"
str K_chan = "Kdr_pyr"
str Ca_chan = "Ca_hip_traub91"
str CaT_chan = "CaT"
str Kahp_chan = "Kahp_pyr"
str Ca_conc = "Ca_conc"
str Nap_chan = "Nap"
str H_chan = "H"

// Create a library of prototype elements to be used by the cell reader
include protodefs.g 

//===============================
//      Function Definitions
//===============================

// Calculate the spike frequencies from the table of spike times
function echo_spike_freqs
  int imax = {getfield /intertab output}  // index of last spike time
  float time1 = {getfield /intertab table->table[0]}
  float time2 = {getfield /intertab table->table[1]}
  float time3 = {getfield /intertab table->table[2]}
  float time4 = {getfield /intertab table->table[3]}
  echo "Injection: " {getfield /injectpulse/injcurr gain} {imax} " spikes"
  if ({imax} > 0)
    float lastinterval = {getfield /intertab table->table[{imax-1}]} \
    - {getfield /intertab table->table[{imax-2}]}
    echo "Spike intervals:  latency  "{time1-injdelay} " ; 1st "{time2 - time1} \
       " ; 2nd " {time3-time2} \
       " ; 3rd " {time4-time3} " ; last interval " {lastinterval}
    echo "Spike frequencies : 1/latency "{1/(time1 - injdelay)} " ; 1st "{1/(time2 - time1)} " ;"
    echo " 2nd "{1/(time3 - time2)} " ; 3rd " {1/(time4-time3)} \
      " ; last " {1/lastinterval}
  end
end

function step_tmax
    // Add any other commands here that you want to execute for each run
    step {tmax} -time
    echo_spike_freqs
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
//   Main simulation section
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

/* set up table object to record spike times */
create table /intertab  // table of spike times
call /intertab TABCREATE 151 0 150
setfield /intertab step_mode 4 stepsize 0 // tab_spike, thresh = 0
addmsg {cellpath}/soma /intertab INPUT Vm

// Initialize the channel conductance density variables by looking at the cell

SOMA_A = 3.14159*{getfield {cellpath}/soma len}*{getfield {cellpath}/soma dia}
gdens_Na = {getfield {cellpath}/soma/{Na_chan} Gbar}/SOMA_A
gdens_K = {getfield {cellpath}/soma/{K_chan} Gbar}/SOMA_A
gdens_Ca = {getfield {cellpath}/soma/{Ca_chan} Gbar}/SOMA_A
gdens_CaT = {getfield {cellpath}/soma/{CaT_chan} Gbar}/SOMA_A
gdens_Kahp = {getfield {cellpath}/soma/{Kahp_chan} Gbar}/SOMA_A
B_Ca_conc = {getfield {cellpath}/soma/{Ca_conc} B}
tau_Ca_conc = {getfield {cellpath}/soma/{Ca_conc} tau}
gdens_Nap = {getfield {cellpath}/soma/{Nap_chan} Gbar}/SOMA_A
gdens_H = {getfield {cellpath}/soma/{H_chan} Gbar}/SOMA_A

// Include the functions used to build the GUI
include graphics1.g

// make the control panel
make_control

// make the graph to display soma Vm and pass messages to the graph
make_Vmgraph
addmsg {cellpath}/soma /data/voltage PLOT Vm *volts *red

make_Injgraph
addmsg  /injectpulse/injcurr  /Injdata/injection PLOT output *Inject *blue

// make the popup menu for changing soma parameters (channel densities, etc)
make_soma_params

colorize    // give the widgets some color

check
reset

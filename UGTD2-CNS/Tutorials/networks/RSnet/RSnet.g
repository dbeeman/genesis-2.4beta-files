//genesis  -  RSnet.g                                
/*======================================================================

  RSnet.g is a customizeable script for creating a network of simplified
  Regular Spiking neocortical neurons with local excitatory connections.
  The simulation script is analyzed and explained in the GENESIS Neural
  Modeling Tutorials (http://www.genesis-sim.org/GENESIS/Tutorials/)

  ======================================================================*/

/* Customize these strings and parameters to modify this simulation for
   another cell.
*/

str cellfile = "RScell.p"  // name of the cell parameter file
str synpath = "soma/Ex_channel" // compartment-name/synchan-name
// Label to appear on the graph
str graphlabel = "Network of simplified cortical pyramidal cells"

float tmax = 0.5		// simulation time
float dt = 50e-6		// simulation time step

int NX = 25  // number of cells = NX*NY
int NY = NX

/* Neurons will be placed on a two dimensional NX by NY grid, with points
   SEP_X and SEP_Y apart in the x and y directions.

   Cortical networks typically have pyramidal cell separations on the order
   of 10 micrometers, and can have local pyramidal cell axonal projections
   of up to a millimeter or more.  For small network models, one sometimes
   uses a larger separation, so that the model represents a larger cortical
   area.  In this case, the neurons in the model are a sparse sample of the
   those in the actual network, and each one of them represents many in the
   biological network.  To compensate for this, the conductance of each
   synapse is scaled by a synaptic weight factor, to represent the
   increased number of neurons that would be providing input in the actual
   network.  Here, we use a very large separation of 1 mm that would be
   appropriate for a piriform cortex model with long range connections
   between cells.
*/

float SEP_X = 0.001 // 1 mm
float SEP_Y = 0.001


/* parameters for synaptic connections */

float syn_weight = 10 // synaptic weight, effectively multiplies gmax

// Typical conduction velocity for myelinated pyramidal cell axon
float cond_vel = 0.5 // m/sec
// With these separations, there is 2 msec delay between nearest neighbors
float prop_delay = SEP_X/cond_vel

float gmax = 1e-9 // 1 nS - possibly a little small for this cell

// index of middle cell (or approximately, if NX, NY are even)
int middlecell = {round {(NY-1)/2}}*NX + {round {(NX -1)/2}}
int InjCell = middlecell // default current injection point
// default (initial) parameters for current injection

float injwidth = 0.05 // 50 msec
// for constant injection, use injwidth >= tmax
float injdelay = 0
float injinterval = 1
float injcurrent = 1.0e-9

/* for debugging and exploring - see comments in file for details
   Usage:   synapse_info path_to_synchan
   Example: synapse_info /network/cell[5]/Ex_channel
*/
include synapseinfo.g

// =============================
//   Function definitions
// =============================

function step_tmax
    echo {NX*NY}" cells    dt = "{getclock 0}"   tmax = "{tmax}
    echo "START: " {getdate}
    step {tmax} -time
    echo "END  : " {getdate}
end

function set_weights(weight)
   float weight
   planarweight /network/cell[]/soma/spike -fixed {weight}
end

function set_delays(delay)
   float delay
   planardelay /network/cell[]/soma/spike -fixed {delay}
//   planardelay /network/cell[]/soma/spike -radial {cond_vel}
end


function set_inj_timing(delay, width, interval)
    float delay, width, interval
    setfield /injectpulse width1 {width} delay1 {delay}  \
        baselevel 0.0 trig_mode 0 delay2 {interval - delay} width2 0
    // free run mode with very long delay for 2nd pulse (non-repetitive)
    // level1 is set by the inj_toggle function
end

function set_frequency(frequency)
    float frequency
    setfield /network/cell[]/{synpath} frequency {frequency}
end

//===============================
//    Main simulation section
//===============================

setclock  0  {dt}		// set the simulation clock

/* Make the network
   Step 1: Assemble the components to build the prototype cell under the
	   neutral element /library.
*/

// create prototype definitions used by the cell parameter file 'cellfile'

include protodefs.g  // This creates /library with the cell components

// Now /library contains prototype channels, compartments, spikegen

/* Step 2: Create the prototype cell specified in 'cellfile', using readcell.
	   Then, set up the excitatory synchan in the appropriate compartment,
	   and the spikegen attached to the soma
*/
readcell {cellfile} /library/cell
setfield /library/cell/{synpath} gmax {gmax}
setfield /library/cell/soma/spike thresh 0  abs_refract 0.004  output_amp 1

/* Step 3 - make a 2D array of cells with copies of /library/cell */
// usage: createmap source dest Nx Ny -delta dx dy [-origin x y]

createmap /library/cell /network {NX} {NY} -delta {SEP_X} {SEP_Y}

/* There will be NX cells along the x-direction, separated by SEP_X,
   and  NY cells along the y-direction, separated by SEP_Y.
   The default origin is (0, 0).  This will be the coordinates of cell[0].
   The last cell, cell[{NX*NY-1}], will be at (NX*SEP_X -1, NY*SEP_Y-1).
*/

/* Step 4: Now connect them up with planarconnect.  Usage:
 * planarconnect source-path destination-path
 *               [-relative]
 *               [-sourcemask {box,ellipse} xmin ymin xmax ymax]
 *               [-sourcehole {box,ellipse} xmin ymin xmax ymax]
 *               [-destmask   {box,ellipse} xmin ymin xmax ymax]
 *               [-desthole   {box,ellipse} xmin ymin xmax ymax]
 *               [-probability p]
 */

/* Connect each source spike generator to excitatory synchans on the 4
   nearest neighbors.  Set the ellipse axes or box size just higher than the
   cell spacing, to be sure cells are included.  To connect to nearest
   neighbors and the 4 diagonal neighbors, use a box:
     -destmask box {-SEP_X*1.01} {-SEP_Y*1.01} {SEP_X*1.01} {SEP_Y*1.01}
   For all-to-all connections with a 10% probability, set both the sourcemask
   and the destmask to have a range much greater than NX*SEP_X using options
     -destmask box -1 -1  1  1 \
     -probability 0.1
   Set desthole to exclude the source cell, to prevent self-connections.
*/

planarconnect /network/cell[]/soma/spike /network/cell[]/{synpath} \
    -relative \	    // Destination coordinates are measured relative to source
    -sourcemask box -1 -1  1  1 \   // Larger than source area ==> all cells
    -destmask ellipse 0 0 {SEP_X*1.2}  {SEP_Y*1.2} \
    -desthole box {-SEP_X*0.5} {-SEP_Y*0.5} {SEP_X*0.5} {SEP_Y*0.5} \
    -probability 1.1	// set probability > 1 to connect to all in destmask


/* Step 5: Set the axonal propagation delay and weight fields of the target
   synchan synapses for all spikegens.  To scale the delays according to
   distance instead of using a fixed delay, use
       planardelay /network/cell[]/soma/spike -radial {cond_vel}
   and change dialogs in graphics.g to set cond_vel.  This would be
   appropriate when connections are made to more distant cells.  Other
   options of planardelay and planarweight allow some randomized variations
   in the delay and weight.
*/

planardelay /network/cell[]/soma/spike -fixed {prop_delay}
planarweight /network/cell[]/soma/spike -fixed {syn_weight}

/* Set up the circuitry to provide injection pulses to the network */
create pulsegen /injectpulse // Make a periodic injection current step
set_inj_timing {injdelay} {injwidth} {injinterval}
// set the amplitude (current) with the gain of a differential amplifier
create diffamp /injectpulse/injcurr
setfield /injectpulse/injcurr saturation 10000 gain {injcurrent}
addmsg /injectpulse /injectpulse/injcurr PLUS output
addmsg /injectpulse/injcurr /network/cell[{InjCell}]/soma INJECT output

// include the graphics functions
include graphics

// make the control panel
make_control

// make the graph to display soma Vm and pass messages to the graph
make_Vmgraph

/* To eliminate net view and run faster, comment out the next line */
make_netview
colorize
check
reset
echo "Network of "{NX}" by "{NY}" cells with separations "{SEP_X}" by "{SEP_Y}

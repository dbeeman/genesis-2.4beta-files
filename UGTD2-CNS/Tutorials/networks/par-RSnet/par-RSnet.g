//genesis  -  par-RSnet.g                                
/*======================================================================

  RSnet.g is a customizeable script for creating a network of simplified
  Regular Spiking neocortical neurons with local excitatory connections.
  The simulation script is analyzed and explained in the GENESIS Neural
  Modeling Tutorials (http://www.genesis-sim.org/GENESIS/Tutorials/)

  par-RSnet is the version for parallel GENESIS by Dave Beeman June 2009
  ======================================================================*/

// Booleans indicating the type of output
int graphics = 1	// display control panel, graphs, optionally net view
int output = 0          // send simulation output to a file
int batch = 0           // if (batch) do a run with default params and quit
int netview = 0         // show network activity view (very slow, but pretty)

/* Definitions for the parallel version */
// typically n_nodes = n_slices + 1, so start with
// pgenesis -nodes 5 par-RSnet.g
// unless output = 0, then use -nodes 4

int n_slices = 4        // each slice will do a horizontal slice of network

int n_nodes             // total number of nodes
int control_node        // mode for console i/o and injection circuitry
int graphics_node	// node for XODUS display
int output_node         // which node is handling output to file
int i_am_control_node, i_am_worker_node // booleans indicating the function
int i_am_output_node, i_am_spare_node   //   assigned to this node
int i_am_graphics_node

if (output)
        n_nodes = n_slices + 1
else
        n_nodes = n_slices
end

control_node = 0  // This should be the terminal window starting pgenesis
graphics_node = 0 // If there is a GUI, put it in this node also
output_node = n_slices // Use a separate node for output to files

// Create a comma-separated list of n_slices worker nodes holding slices
// of the network.  For interactive debugging, have the first worker
// be in the control_node.

int worker0 = 0	    // node for the first of n_slices workers
str workers = "0"   // "0" is first in list of nodes
int i
for (i = 1; i < n_slices; i = i + 1)
        workers = workers @ "," @ {i} // add a comma and the next worker
end


/* Customize these strings and parameters to modify this simulation for
   another cell.
*/

str cellfile = "RScell.p"  // name of the cell parameter file
str synpath = "soma/Ex_channel" // compartment-name/synchan-name
// Label to appear on the graph
str graphlabel = "Network of simplified cortical pyramidal cells"
str ofile  = "Vm.dat"  //  filename for output to a file

float tmax = 0.5		// simulation time
float dt = 50e-6		// simulation time step
float out_dt = 0.0005    // output every 0.5 msec
int NX = 32  // number of cells = NX*NY
int NY = 32

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
float SEP_Z = 1.0e-6 // give it a tiny z range in case of round off errors

/* For the parallel version, the network will be divided into horizontal
   slices of dimension NX x NY/n_slices.

   Be sure that NY is a multiple of n_slices !!!
*/

int cells_per_slice = NX*NY / n_slices
/* parameters for synaptic connections */

float syn_weight = 10 // synaptic weight, effectively multiplies gmax

// Typical conduction velocity for myelinated pyramidal cell axon
float cond_vel = 0.5 // m/sec
// With these separations, there is 2 msec delay between nearest neighbors
float prop_delay = SEP_X/cond_vel

float gmax = 1e-9 // 1 nS - possibly a little small for this cell

// index of middle cell (or approximately, if NX, NY are odd)
int middle_cell = {round {(NY-1)/2}}*NX + {round {(NX -1)/2}}
int Redge_cell = {{round {(NY-1)/2}}*NX} + NX -1 // middle right edge
int LLcorner_cell = 0                    // index of lower left corner
int InjCell = middle_cell // default current injection point

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
// include synapseinfo.g

// =============================
//   Function definitions
// =============================

function step_tmax
    echo@{control_node} {NX*NY}" cells    dt = "{getclock 0}"   tmax = "{tmax}
    echo@{control_node} "START: " {getdate}
    step@all {tmax} -time
    echo@{control_node} "END  : " {getdate}
end


/* The function quit_sim is designed to be issued from just one node,
   and causes all nodes, including itself, with "quit@all".  One can quit at
   the command prompt with "quit_sim", or with the QUIT button in the GUI,
   which invokes quit_sim.
*/
function quit_sim
    echo@{control_node} Quitting simulation
    quit@all
end

function set_gmax(gmax)
    float gmax
    setfield@{workers} /network/cell[]/{synpath} {gmax}
end

function set_weights(weight)
    float weight
    rvolumeweight@{workers} /network/cell[]/soma/spike -fixed {weight}
end

function set_delays(delay)
    float delay
    rvolumedelay@{workers} /network/cell[]/soma/spike -fixed {delay}
//   rvolumedelay@{workers} /network/cell[]/soma/spike -radial {cond_vel}
end

function set_frequency(frequency)
    float frequency
    setfield@{workers} /network/cell[]/{synpath} frequency {frequency}
end

function set_inj_params(amplitude, delay, width, interval)
    float amplitude, delay, width, interval
    setfield /injectpulse width1 {width} delay1 {delay}  \
        baselevel 0.0 trig_mode 0 delay2 {interval - delay} width2 0
    // free run mode with very long delay for 2nd pulse (non-repetitive)
    // level1 is set by the inj_toggle function
    // set the amplitude (current) with the gain of a differential amplifier
    setfield /injectpulse/injcurr saturation 10000 gain {amplitude}
end

/* Set up the circuitry to provide injection pulses to the network.  This
   will be invoked on all worker nodes, duplicating the circuit for each
   slice.  This allows the INJECT message to the chosen cell to be a local
   message, which can be deleted, unlike a remote message.
*/
function make_injection
    create pulsegen /injectpulse // Make a periodic injection current step
    create diffamp /injectpulse/injcurr
    setfield /injectpulse/injcurr saturation 10000
    set_inj_params  {injcurrent} {injdelay} {injwidth} {injinterval}
    addmsg /injectpulse /injectpulse/injcurr PLUS output
end // function make_injection


/* Likewise, add_injection should be invoked on all worker nodes,
   to get rid of any existing injection, and to add an INJECT message
   to the chosen cell, if it is on the node.
*/

/* The user of this simulation should think of the cell numbering as
   cell_num = ix + NX*iy, where cells lie on the unsliced network at points
   (ix*SEP_X, iy*SEP_Y) with ix = 0 to NX-1 and iy = 0 to NY-1.  Thus,
   cell_num runs from 0 to NX*NY-1.  cell_num is used to specify the cell
   to receive injection or to have its soma Vm sent to a file or plotted on
   a graph.  The function make_slice, defined further below, creates slices
   of the network on each worker node. Each worker node will then have a
   slice with cells numbered 0 to NX*NY/n_slices - 1.  As the cell
   numbering is different within a slice, we need to translate betweeen
   cell_num and the slice number and index of the cell within the slice.
   The functions cell_node and cell_index are used to perform this
   translation.  As the cell numbers on the unsliced network are filled by
   rows, starting with iy = 0, the translation between cell_num and the
   cell_index within the slice is very simple when horizontal slices are
   used, as is done below.
*/

/* These functions assume that network has been divided horizontal
   slices that are on nodes 0 through  n_slices-1.  Each slice has
   cells_per_slice = NX*NY / n_slices cells.
*/
function cell_node(cell_num) // return the node that cell_num is in
    int cell_num
    return {trunc {cell_num/cells_per_slice}}
end

function cell_index(cell_num) // return the cell index within that node
    int cell_num, node
    node = {cell_node {cell_num}}
    return {cell_num - node*cells_per_slice}
end

function add_injection(cell_num)
    int cell_num,  INJECT_mesg_num
    if (cell_num > {NX*NY-1})
      echo@{control} "There are only "{NX*NY}" cells - numbering begins with 0"
      return
    end
    // remove any existing injection, without removing any other messages
    if ({mynode} == {cell_node {InjCell}})
        // See if the INJECT message exists, before trying to delete it
        INJECT_mesg_num = {getmsg /network/cell[{cell_index {InjCell}}]/soma \
            -find /injectpulse/injcurr INJECT}
        if ({INJECT_mesg_num} >= 0)
	    deletemsg /network/cell[{cell_index {InjCell}}]/soma \
		{INJECT_mesg_num} -in
	end
    end
    // check to see if cell_num is on this node
    if ({mynode} == {cell_node {cell_num}})
      addmsg /injectpulse/injcurr /network/cell[{cell_index {cell_num}}]/soma \
         INJECT output
      echo@{control_node} "Removed injection  to cell number "{InjCell}
      echo@{control_node} "Current injection is to cell number "{cell_num} \
          "on node "{mynode}" index = "{cell_index {cell_num}}
    end
    InjCell = cell_num
end // function add_injection

function make_output(filename)
    str filename
    create par_asc_file {filename}
    setfield ^    flush 1    leave_open 1
    setclock 1 {out_dt}
    useclock {filename} 1
end

//=============================================================
//    Functions to set up the network - used by worker nodes
//=============================================================

function make_slice
    /*   Step 1: Assemble the components to build the prototype cell under the
	   neutral element /library.
    */

    /* Step 2: Create prototype cell specified in 'cellfile', using readcell.
	   Then, set up the excitatory synchan in the appropriate compartment,
	   and the spikegen attached to the soma
    */
    readcell {cellfile} /library/cell
    addfield /library/cell/soma io_index // used for ordering i/o messages
    setfield /library/cell/{synpath} gmax {gmax}
    setfield /library/cell/soma/spike thresh 0  abs_refract 0.004  output_amp 1

    /* Step 3 - make a 2D array of cells with copies of /library/cell */
    // usage: createmap source dest Nx Ny -delta dx dy [-origin x y]
    /*
       For the unsliced network, there will be NX cells along the
       x-direction, separated by SEP_X, and NY cells along the y-direction,
       separated by SEP_Y.  The default origin is (0, 0).  This will be the
       coordinates of cell[0].  The last cell, cell[{NX*NY-1}], will be at
       (NX*SEP_X -1, NY*SEP_Y-1).

       For the parallel version, each worker node makes a slice of the net
       with the origin set at the lower left corner of the slice, and a
       soma io_index that represents the cell number on the unsliced net.
       Each slice node will have a set of cells cell[0] -
       cell[{cells_per_slice - 1}], but the soma io_index will be in the
       appropriate part of the range from 0 - NX*NX-1, in order to
       identify its location on the full net.

       Here, the network is divided into horizontal slices of dimension
       NX x NY/n_slices.
    */

    int slice = {mynode}  // The worker node number is the slice number
    createmap /library/cell /network {NX} {NY / n_slices} \
	-delta {SEP_X} {SEP_Y} \
        -origin 0 {slice * SEP_Y * NY / n_slices}
        // Label the cell soma with the io_index. For horizontal slices,
        // this is equal to cell_num on the unsliced network.
        for (i = 0; i < cells_per_slice; i=i+1)
            setfield /network/cell[{i}]/soma \
                     io_index {slice * cells_per_slice + i}
        end

end // function make_slice

function connect_cells

    /* Step 4: Now connect them up with planarconnect in the serial GENESIS
     * version, and rvolumeconnect for PGENESIS.  The pgenesis/Hyperdoc/ref
     * directory in the PGENESIS distribution has documentation for the
     * parallel network commands rvolumeconnect, rvolumedelay,
     * rvolumeweight, raddmsg, etc.  Usage:
     * rvolumeconnect source_elements  \
     *               destination_elements@destination-node-list \
     *               [-relative]
     * [-sourcemask {box,ellipsoid} xmin ymin zmin xmax ymax zmax]
     *               [-sourcehole {box,ellipsoid} xmin ymin zmin xmax ymax zmax]
     *               [-destmask   {box,ellipsoid} xmin ymin zmin xmax ymax zmax]
     *               [-desthole   {box,ellipoid} xmin ymin zmin xmax ymax zmax]
     *               [-probability p]
     */

 /* Connect each source spike generator to excitatory synchans on the 4
   nearest neighbors.  Set the ellipse axes or box size just higher than the
   cell spacing, to be sure cells are included.  To connect to nearest
   neighbors and the 4 diagonal neighbors, use a box:
     -destmask box {-SEP_X*1.01} {-SEP_Y*1.01} {SEP_X*1.01} {SEP_Y*1.01}
   For all-to-all connections with a 10% probability, set both the sourcemask
   and the destmask to have a range much greater than NX*SEP_X using options
     -destmask box -1 -1 0 1  1 0 \
     -probability 0.1
   Set desthole to exclude the source cell, to prevent self-connections.
*/

    rvolumeconnect /network/cell[]/soma/spike \
        /network/cell[]/{synpath}@{workers}   \
    -relative \	    // Destination coordinates are measured relative to source
    -sourcemask box -1 -1 -1 1  1 1 \ // Larger than source area ==> all cells
    -destmask ellipsoid 0 0 0 {SEP_X*1.2}  {SEP_Y*1.2} {SEP_Z*0.5} \
    -desthole box {-SEP_X*0.5} {-SEP_Y*0.5} {-SEP_Z*0.5} \
        {SEP_X*0.5} {SEP_Y*0.5} {SEP_Z*0.5} \
    -probability 1.1	// set probability > 1 to connect to all in destmask

  /* Step 5: Set the axonal propagation delay and weight fields of the target
   synchan synapses for all spikegens.  To scale the delays according to
   distance instead of using a fixed delay, use
       planardelay /network/cell[]/soma/spike -radial {cond_vel}
   and change dialogs in graphics.g to set cond_vel.  This would be
   appropriate when connections are made to more distant cells.  Other
   options of planardelay and planarweight allow some randomized variations
   in the delay and weight.  For the parallel version use rvolumedelay
   and rvolumeweight.  The remote version of these commands is used
   because the target synapse may be in a slice on another node.
  */

    rvolumedelay /network/cell[]/soma/spike -fixed {prop_delay}
    rvolumeweight /network/cell[]/soma/spike -fixed {syn_weight}

end // function connect_cells

/* This function is only used if graphics have been enabled.  It is
   defined here, rather than in the file of graphics functions, because
   it must be invoked by the worker nodes, rather than by the graphics node.

   When using raddmsg to send messages between elements on different nodes,
   the node specifier can only be used on the destination node.  Therefore,
   the function make_graph_messages has to be invoked from each worker node
   to send PLOT or PLOTSCALE messages to the graph.
*/
function make_graph_messages
    /* Set up plotting messages, with offsets */
    // middle_cell is a middle point (exactly, if NX and NY are odd)
    if ({mynode} == {cell_node {middle_cell}})
        raddmsg /network/cell[{cell_index {middle_cell}}]/soma \
            /data/voltage@{graphics_node} \
            PLOT Vm *"center "{middle_cell} *black
    end
    if ({mynode} == {cell_node {Redge_cell}})
        raddmsg /network/cell[{cell_index {Redge_cell}}]/soma \
            /data/voltage@{graphics_node} \
           PLOTSCALE Vm *"R edge "{Redge_cell} *blue  1 0.05
    end
    if ({mynode} == {cell_node {LLcorner_cell}})
        raddmsg /network/cell[{cell_index {LLcorner_cell}}]/soma \
            /data/voltage@{graphics_node} \
        PLOTSCALE Vm *"LL corner "{LLcorner_cell} *red 1 0.1
    end
end // function  make_graph_messages

//===============================
//    Main simulation section
//===============================

setclock  0  {dt}		// set the simulation clock

//===================================================================
//    Start up parallel nodes - console output goes to control_node
//===================================================================

paron -parallel -silent 0 -nodes {n_nodes}

/* When all nodes but the control_node are waiting at the final barrier,
   only report this every 60 seconds instead of the default 3 seconds.
   This is described in BoG Sec. Sec. 21.9.6
*/
setfield /post pvm_hang_time 60

i_am_control_node = {mynode} == {control_node}
i_am_graphics_node =  (graphics) && ({mynode} == {graphics_node})
i_am_worker_node =  {mynode} <  n_slices
// this assumes slices start at node 0
i_am_output_node =  (output) && ({mynode} == {output_node})

randseed {17 + {mynode}*347} // this avoids artifacts of each node using
                             // the same random number sequence
echo@{control_node}  "n_nodes = " {n_nodes}
echo@{control_node} I am node {mynode}
echo@{control_node} Worker nodes are: {workers}
echo@{control_node} Completed startup at {getdate}

barrier // wait for everyone to catch up

/* Set up the network on the worker nodes */
if (i_am_worker_node)
    // create prototype definitions used by the cell parameter file 'cellfile'
    include protodefs.g  // This creates /library with the cell components
    // Now /library contains prototype channels, compartments, spikegen

    /* Make the network */
    make_slice
    // barrier needed to be sure all slices are made before connecting
    barrier 1
    connect_cells
    barrier 2  // to be safe, wait until all nodes have done these:
    make_injection
    barrier 3
    add_injection {InjCell}
    /* In case there are any nodes that are not also workers, set up
       compensating barriers, so that all nodes wait at the same points.
    */
else
    barrier 1
    barrier 2
    barrier 3
end  // if (i_am_worker_node)

barrier         // wait for all elements to be created and connected
echo@{control_node} Completed network creation at {getdate}

/* Set up any GUI or graphics that may be requested */
if (i_am_graphics_node && graphics)
    // include the graphics functions
    include pgraphics
    // make the control panel
    make_control
    // make the graph to display soma Vm and pass messages to the graph
    make_Vmgraph
    colorize  // set some colors for the graphical widgets
    // use a slower clock for graphics
    useclock /data/voltage 1
    useclock /data/injection 1
    setclock 1 {out_dt}
    if (netview)
	make_netview
	useclock /netview/draw/view 1
    end
    echo@{control_node}  graphics set up on node {mynode}
end

barrier // wait for graphics to be set up
if (i_am_output_node)
    make_output {ofile}
end
barrier // wait for output to file to be set up

// set up any output and graphics messages
if (i_am_worker_node)
    if (output)
	// Add a message from each cell on the net to the par_asc_file
        raddmsg /network/cell[]/soma /{ofile}@{output_node} SAVE io_index Vm
        echo@{control_node} Outputs from worker {mynode} to file {ofile}
    end
    if (graphics)
	make_graph_messages
        xcolorscale hot
        echo@{control_node} setting up PLOT messages
    end
end // if (i_am_worker_node)
barrier // wait for any output and graphics messages to be set up

reset  // all nodes
echo@{control_node} "Network of "{NX}" by "{NY}" cells with separations "{SEP_X}" by "{SEP_Y}

if (batch && i_am_control_node)
	step_tmax
        quit_sim
end

// All the other nodes will get stuck at this barrier
// and the genesis prompt will be available in Node 0
if (!i_am_control_node)
   barrier 15
end

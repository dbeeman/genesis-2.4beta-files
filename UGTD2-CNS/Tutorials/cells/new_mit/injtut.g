//genesis  -  injtut.g - generic script for current injection - uses readcell

/* Flags to set display options (file, plot, xcell, etc.) */

int file_mode = 0   // Vm output to a file if > 0
int plot_mode = 1   // Plot Vm on a graph if > 0
int xcell_mode = 1  // Show Vm in all compartments with xcell
int cellfile_mode = 0 // Vm of every compartment to a file

/* File to create channel prototypes, and define variables specific to cell
   model.  Besides including any channel prototype files that are needed, it
   should include neurokit/defaults.g (in the simpath) to define certain
   functions and the global "user_" variables.
*/
include protodefs.g

// Some other global variables
str inj_compt = user_cell @ "/" @ comptname
str plot_compt = {user_cell}@ "/" @ {comptname}
str cellVmfile = "cell_Vm"

// simulation time in sec
float tmax = 0.1                // Use this for a short run
float tmax = user_runtime       // default  tmax defined in protodefs

float dt = user_dt		// simulation time step in sec
setclock  0  {dt}		// set the simulation clock
setclock  1 {{getclock 0}*user_refresh}  // display clock

function step_tmax
    echo "START: "{getdate}
    step {tmax} -time
    echo "END: "{getdate}
    if (file_mode > 0)      // flush any remaining data to the file
        setfield /comptVm flush 1 leave_open 0
        call /comptVm PROCESS
    end
    if (cellfile_mode > 0)
        setfield /cellVm flush 1 leave_open 0 append 0
        call /cellVm PROCESS
    end
end

function set_inject(dialog)
    str dialog
    setfield {inj_compt} inject {getfield {dialog} value}
end

function make_control
    create xform /control [10,50,250,145]
    create xlabel /control/label -hgeom 25 -fg white -bg blue3 \
        -label "CONTROL PANEL"
    create xbutton /control/RESET -wgeom 33%       -script reset_sim
    create xbutton /control/RUN  -xgeom 0:RESET -ygeom 0:label -wgeom 33% \
         -script step_tmax
    create xbutton /control/QUIT -xgeom 0:RUN -ygeom 0:label -wgeom 34% \
        -script quit
    create xdialog /control/Injection -label "Injection (amperes)" \
                -value {user_inject} -script "set_inject <widget>"
    xshow /control
end

function make_Vmgraph
    float vmin = -0.100
    float vmax = 0.05
    create xform /data [265,50,350,350]
    create xlabel /data/label -hgeom 10% -fg white -bg blue3 \
        -label "Plot of Vm for "{plot_compt}
    create xgraph /data/voltage  -bg white -hgeom 90%  \
        -title "Membrane Potential"
    setfield ^ XUnits sec YUnits Volts
    setfield ^ xmax {tmax} ymin {vmin} ymax {vmax}
    addmsg {plot_compt} /data/voltage PLOT Vm *volts *red
    useclock /data 1
    xshow /data
end

function make_Vmfile  // write a compartment Vm to a file
    create asc_file /comptVm
    addmsg {plot_compt} /comptVm SAVE Vm
    // For speed, leave file open and don't flush the buffer between writes
    setfield /comptVm filename {user_filename} leave_open 1 flush 0
    useclock /comptVm 1
end

include cellview.g  // defines functions to make an xcell

function get_cellVm_compts  // names of compartments sending Vm to a file
    int i
    int count = {getmsg /cellVm -in -count}
    str cellVm_compts = ""
    for (i=0; i < count; i=i+1)
        cellVm_compts = cellVm_compts @ " " @ \
            {getpath {getmsg /cellVm -in -source {i}} -tail}
    end
    return {cellVm_compts}
end

function make_cellfile
    if ({exists  /cellVm})
        delete /cellVm
        rm  {cellVmfile}
    end
    create asc_file /cellVm
    if (user_symcomps == 0)
        addmsg {user_cell}/#[TYPE=compartment] /cellVm SAVE Vm
    else
        addmsg {user_cell}/#[TYPE=symcompartment] /cellVm SAVE Vm
    end
    openfile {cellVmfile} w
    writefile {cellVmfile} {get_cellVm_compts}
    closefile {cellVmfile}
    setfield /cellVm filename {cellVmfile} append 1 leave_open 1 flush 0
    useclock /cellVm 1
end

function reset_sim
    if (cellfile_mode > 0)
        make_cellfile
    end
    reset
end

/*   Main Script  */

// Build the cell from a parameter file using the cell reader
if (user_intmethod >= 10)
   readcell {user_pfile} {user_cell} -hsolve
   setfield {user_cell} chanmode 1
   call {user_cell} SETUP
   setmethod {user_intmethod}
   reset
else
   readcell {user_pfile} {user_cell}
   setmethod {user_intmethod}
end

// provide current injection to inj_compt (usually the soma)
setfield {inj_compt} inject {user_inject}

// make the control panel
make_control

// make the graph to display soma Vm and pass messages to the graph
if (plot_mode > 0)
    make_Vmgraph
end

if (file_mode > 0)
    make_Vmfile
end

if (xcell_mode > 0)
    make_xcell  620 50
    useclock 1 /cellform
    set_drawrange // set draw widget x/y/z min/max values from cell dimensions
    xshow /cellform
end

// check
reset_sim

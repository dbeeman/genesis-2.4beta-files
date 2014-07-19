// genesis 2.1 - "Stand-alone" version of the traub94 model

int hflag = 1    // use hsolve if hflag = 1
int chanmode = 1

/* chanmodes 0 and 1 allow use non-hsolved elements, such as vdep_channels.
   chanmode  is fastest when there are tabchannels.
*/

float tmax = 0.1               // simulation time in sec
float dt = 25e-6             // simulation time step in sec
setclock  0  {dt}               // set the simulation clock
setclock 1 {10*dt}

float injcurr = 0.3e-9		// default injection

/* file for 1994 Traub model channels */
include traub94proto.g

/* Make channel prototypes */
create neutral /library
pushe /library
create compartment compartment

make_Na
make_Ca
make_K_DR
make_K_AHP
make_K_AHP_soma
make_K_C
make_K_C_soma
make_K_A
make_Na_axon
make_K_DR_axon
make_Ca_conc
make_Ca_conc_soma

pope


//===============================
//      Function Definitions
//===============================

function step_tmax
    step {tmax} -time
end

//===============================
//    Graphics Functions
//===============================

function make_control
    create xform /control [10,50,250,170]
    create xlabel /control/label -hgeom 50 -bg cyan -label "CONTROL PANEL"
    create xbutton /control/RESET -wgeom 33%       -script reset
    create xbutton /control/RUN  -xgeom 0:RESET -ygeom 0:label -wgeom 33% \
         -script step_tmax
    create xbutton /control/QUIT -xgeom 0:RUN -ygeom 0:label -wgeom 34% \
        -script quit
    create xdialog /control/Injection -label "Injection (amperes)" \
		-value {injcurr}  -script "set_inject <widget>"
    create xdialog /control/stepsize -title "dt (sec)" -value {dt} \
                -script "change_stepsize <widget>"
    create xtoggle /control/overlay  \
           -script "overlaytoggle <widget>"
    setfield /control/overlay offlabel "Overlay OFF" onlabel "Overlay ON" state 0

    xshow /control
end

function make_Vmgraph
    float vmin = -0.100
    float vmax = 0.05
    create xform /data [265,50,350,350]
    create xlabel /data/label -hgeom 10% -label "Traub 1994 CA3 Pyramidal Cell"
    create xgraph /data/voltage  -hgeom 90%  -title "Membrane Potential"
    setfield ^ XUnits sec YUnits Volts
    setfield ^ xmax {tmax} ymin {vmin} ymax {vmax}
    xshow /data
end

function make_xcell
    create xform /cellform [620,50,400,400]
    create xdraw /cellform/draw [0,0,100%,100%]
    setfield /cellform/draw xmin -0.00025 xmax 0.00025 ymin -15e-5 ymax 35e-5 \
        zmin -5e-4 zmax 9e-4 vx 10 vy -15 vz 7\
        transform o3d
    xshow /cellform
    echo creating xcell
    create xcell /cellform/draw/cell
    setfield /cellform/draw/cell colmin -0.1 colmax 0.1 \
        path /cell/##[TYPE=compartment] field Vm \
        script "echo <w> <v>"
end

function set_inject(dialog)
    str dialog
    setfield /cell/soma inject {getfield {dialog} value}
end

function change_stepsize(dialog)
   str dialog
   dt =  {getfield {dialog} value}
   setclock 0 {dt}
   echo "Changing step size to "{dt}
end

// Use of the wildcard sets overlay field for all graphs
function overlaytoggle(widget)
    str widget
    setfield /##[TYPE=xgraph] overlay {getfield {widget} state}
end

//===============================
//         Main Script
//===============================
// Build the cell from a parameter file using the cell reader
readcell CA3.p /cell

setfield /cell/soma inject {injcurr}

// make the control panel
make_control

// make the graph to display soma Vm and pass messages to the graph
make_Vmgraph
addmsg /cell/soma /data/voltage PLOT Vm *volts *red

/* uncomment the two lines below to create a cell display (slower)  */
// make_xcell // create and display the xcell
// xcolorscale hot

if (hflag)
    create hsolve /cell/solve
    setfield /cell/solve path "/cell/##[][TYPE=compartment]"
    setmethod 11
    setfield /cell/solve chanmode {chanmode}
    call /cell/solve SETUP
    reset
    echo "Using hsolve"
end

//check
reset

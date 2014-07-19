/*======================================================================
    A GENESIS GUI for cell models with a  control panel for
    providing inputs, and  a graph with axis scaling
  ======================================================================*/

include xtools.g    // functions to make graph "scale" buttons, etc.

//===============================
//      Function Definitions
//===============================

function overlaytoggle(widget)
    str widget
    setfield /##[TYPE=xgraph] overlay {getfield {widget} state}
end

function set_injection(value)
    float value
    injcurrent = {value}*1e-9
    setfield {injectpath} inject {injcurrent}
end

function set_gmax(value)
    float value
    gmax = {value}*1e-9
    setfield {synpath} gmax {gmax}
end

/*  A subset of the functions defined in genesis/startup/xtools.g
    These are used to provide a "scale" button to graphs.
    "makegraphscale path_to_graph" creates the button and the popup
     menu to change the graph scale.
*/

/* Add some interesting colors to any widgets that have been created */
function colorize
    setfield /##[ISA=xlabel] fg white bg blue3
    setfield /##[ISA=xbutton] offbg rosybrown1 onbg rosybrown1
    setfield /##[ISA=xtoggle] onfg red offbg cadetblue1 onbg cadetblue1
    setfield /##[ISA=xdialog] bg palegoldenrod
    setfield /##[ISA=xgraph] bg ivory
end

//==========================================================
//    Functions to create the Graphical User Interface
//==========================================================

function make_control
  int control_height = 125
  create xform /control [10,50,250,{control_height}]
  create xlabel /control/label -hgeom 25 -bg cyan -label "CONTROL PANEL"
  create xbutton /control/RESET -wgeom 33%       -script reset
  create xbutton /control/RUN  -xgeom 0:RESET -ygeom 0:label -wgeom 33% \
         -script step_tmax
  create xbutton /control/QUIT -xgeom 0:RUN -ygeom 0:label -wgeom 34% \
        -script do_quit
  create xdialog /control/Injection -label "Injection (nA)" \
      -value {injcurrent*1e9} -script "set_injection <value>"
  create xtoggle /control/overlay   -script "overlaytoggle <widget>"
  setfield /control/overlay offlabel "Overlay OFF" onlabel "Overlay ON" state 0
  xshow /control

  // if synchanpath non-null
  if({synpath} != "")
    create xform /syninput [10,{75 + control_height},250,155]
    create xdialog /syninput/gmax -label "gmax (nS)" \
	-value {gmax*1e9} -script "set_gmax <value>"
    create xlabel /syninput/randact -label "Random background activation"
    create xdialog /syninput/randfreq -label "Frequency (Hz)" -value 0 \
        -script "set_frequency <v>"

    create xtoggle /syninput/spiketrain_toggle
    setfield /syninput/spiketrain_toggle offlabel "Spike input OFF" \
        onlabel "Spike input ON" state 0
    addmsg /syninput/spiketrain_toggle /spiketrain INPUT  state
    create xdialog /syninput/spike_interval -label "Spike interval (sec)" \
        -value {spikeinterval} -script "setfield /spiketrain abs_refract <v>"
    xshow /syninput
  end
end

function make_Vmgraph
    float vmin = -0.100
    float vmax = 0.05
    create xform /data [265,50,350,350]
    create xlabel /data/label -hgeom 10% -label {graphlabel}
    create xgraph /data/voltage -hgeom 90% -title "Membrane Potential" -bg white
    setfield ^ XUnits sec YUnits Volts
    setfield ^ xmax {tmax} ymin {vmin} ymax {vmax}
    makegraphscale /data/voltage
    xshow /data
end

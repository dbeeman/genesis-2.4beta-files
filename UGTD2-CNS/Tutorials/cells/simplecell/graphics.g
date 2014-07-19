/*======================================================================
  A GENESIS GUI with a simple control panel and graph, with axis scaling
  ======================================================================*/

include xtools.g    // functions to make "scale" buttons, etc.

//===============================
//      Function Definitions
//===============================

function step_tmax
    step {tmax} -time
end

function overlaytoggle(widget)
    str widget
    setfield /##[TYPE=xgraph] overlay {getfield {widget} state}
end

//===============================
//    Graphics Functions
//===============================

function make_control
  create xform /control [10,50,250,180]
  create xlabel /control/label -hgeom 25 -bg cyan -label "CONTROL PANEL"
  create xbutton /control/RESET -wgeom 33%       -script reset
  create xbutton /control/RUN  -xgeom 0:RESET -ygeom 0:label -wgeom 33% \
         -script step_tmax
  create xbutton /control/QUIT -xgeom 0:RUN -ygeom 0:label -wgeom 34% \
        -script quit
  create xdialog /control/Injection -label "Injection (amperes)" \
                -value 0.5e-9 -script "set_inject <widget>"
  create xtoggle /control/overlay   -script "overlaytoggle <widget>"
  setfield /control/overlay offlabel "Overlay OFF" onlabel "Overlay ON" state 0

  xshow /control
end

function make_Vmgraph
    float vmin = -0.100
    float vmax = 0.05
    create xform /data [265,50,700,350]
    create xlabel /data/label -hgeom 10% -label "Soma contains Na and K channels"
    create xgraph /data/voltage -hgeom 90% -title "Membrane Potential" -bg white
    setfield ^ XUnits sec YUnits Volts
    setfield ^ xmax {tmax} ymin {vmin} ymax {vmax}
    makegraphscale /data/voltage
    xshow /data
end

function set_inject(dialog)
    str dialog
    setfield /cell/soma inject {getfield {dialog} value}
end

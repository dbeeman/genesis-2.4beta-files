/*======================================================================
  A GENESIS GUI with a simple control panel and graph, with axis scaling
  ======================================================================*/

//========================================================
//      Function definitions used by graphics widgets
//========================================================

function overlaytoggle(widget)
    str widget
    setfield /##[TYPE=xgraph] overlay {getfield {widget} state}
end

function change_stepsize(dialog)
   str dialog
   dt =  {getfield {dialog} value}
   setclock 0 {dt}
   echo "Changing step size to "{dt}
end

function inj_toggle // toggles current injection ON/OFF
    if ({getfield /control/injtoggle state} == 1)
        setfield /injectpulse level1 1.0        // ON
    else
        setfield /injectpulse level1 0.0        // OFF
    end
end

function set_injection
   str dialog = "/control"
   set_inj_timing {getfield {dialog}/injectdelay value}  \
       {getfield {dialog}/width value} {getfield {dialog}/interval value}
   setfield /injectpulse/injcurr gain {getfield {dialog}/inject value}
   echo "Injection current = "{getfield {dialog}/inject value}
   echo "Injection pulse delay = "{getfield {dialog}/injectdelay value}" sec"
   echo "Injection pulse width = "{getfield {dialog}/width value}" sec"
   echo "Injection pulse interval = "{getfield {dialog}/interval value}" sec"
end

/*  A subset of the functions defined in genesis/startup/xtools.g
    These are used to provide a "scale" button to graphs.
    "makegraphscale path_to_graph" creates the button and the popup
     menu to change the graph scale.
*/

function setgraphscale(graph)
    str graph
    str form = graph @ "_scaleform"
    str xmin = {getfield {form}/xmin value}
    str xmax = {getfield {form}/xmax value}
    str ymin = {getfield {form}/ymin value}
    str ymax = {getfield {form}/ymax value}
    setfield {graph} xmin {xmin} xmax {xmax} ymin {ymin} ymax {ymax}
    xhide {form}
end

function showgraphscale(form)
    str form
    str x, y
    // find the parent form
    str parent = {el {form}/..}
    while (!{isa xform {parent}})
        parent = {el {parent}/..}
    end
    x = {getfield {parent} xgeom}
    y = {getfield {parent} ygeom}
    setfield {form} xgeom {x} ygeom {y}
    xshow {form}
end

function makegraphscale(graph)
    if ({argc} < 1)
        echo usage: makegraphscale graph
        return
    end
    str graph
    str graphName = {getpath {graph} -tail}
    float x, y
    str form = graph @ "_scaleform"
    str parent = {el {graph}/..}
    while (!{isa xform {parent}})
        parent = {el {parent}/..}
    end

    x = {getfield {graph} x}
    y = {getfield {graph} y}

    create xbutton {graph}_scalebutton  \
        [{getfield {graph} xgeom},{getfield {graph} ygeom},50,25] \
           -title scale -script "showgraphscale "{form}
    create xform {form} [{x},{y},180,170] -nolabel
    disable {form}
    pushe {form}
    create xbutton DONE [10,5,55,25] -script "setgraphscale "{graph}
    create xbutton CANCEL [70,5,55,25] -script "xhide "{form}
    create xdialog xmin [10,35,160,25] -value {getfield {graph} xmin}
    create xdialog xmax [10,65,160,25] -value {getfield {graph} xmax}
    create xdialog ymin [10,95,160,25] -value {getfield {graph} ymin}
    create xdialog ymax [10,125,160,25] -value {getfield {graph} ymax}
    pope
end


/* shift activation curves for minf and tau on both Na and K channels */

float Na_K_offset = 0.0

function adjust_Na_K(offset)
    float offset
    scaletabchan {cellpath}/soma/Na X minf 1.0 1.0 {offset} 0.0
    scaletabchan {cellpath}/soma/Na Y minf 1.0 1.0 {offset} 0.0
    scaletabchan {cellpath}/soma/Kdr X minf 1.0 1.0 {offset} 0.0

    scaletabchan {cellpath}/soma/Na X tau 1.0 1.0 {offset} 0.0
    scaletabchan {cellpath}/soma/Na Y tau 1.0 1.0 {offset} 0.0
    scaletabchan {cellpath}/soma/Kdr X tau 1.0 1.0 {offset} 0.0
end


/* this depends on channel names defined in main script */
float Kahp_tauscale = 1.0

function set_params

  float Em =  {getfield /soma_params/Em value}
  float RM_scale =  {getfield /soma_params/RM_scale value}
  float CM_scale =  {getfield /soma_params/CM_scale value}

  str compt
  foreach compt ({el {cellpath}/##[OBJECT=symcompartment]})
    setfield {compt} Em {Em}
    setfield {compt} Rm { {getfield {compt} Rm} * RM_scale}
    setfield {compt} Cm { {getfield {compt} Cm} * CM_scale}
  end

  float Kahp_tauscale = {getfield /soma_params/tau_Kahp value}
  float K_tauscale = {getfield /soma_params/tau_K value}
  gdens_Na = {getfield /soma_params/gdens_Na value}
  gdens_K = {getfield /soma_params/gdens_K value}
  gdens_Ca = {getfield /soma_params/gdens_Ca value}
  gdens_Kahp = {getfield /soma_params/gdens_Kahp value}
  B_Ca_conc = {getfield /soma_params/B_Ca_conc value}
  tau_Ca_conc = {getfield /soma_params/tau_Ca_conc value}
  gdens_Nap = {getfield /soma_params/gdens_Nap value}
  gdens_H = {getfield /soma_params/gdens_H value}

  setfield {cellpath}/soma/{Na_chan} Gbar {gdens_Na*SOMA_A}
  setfield {cellpath}/soma/{K_chan} Gbar {gdens_K*SOMA_A}
  setfield {cellpath}/soma/{Ca_chan} Gbar {gdens_Ca*SOMA_A}
  setfield {cellpath}/soma/{CaT_chan} Gbar {gdens_CaT*SOMA_A}
  setfield {cellpath}/soma/{Nap_chan} Gbar {gdens_Nap*SOMA_A}
  setfield {cellpath}/soma/{H_chan} Gbar {gdens_H*SOMA_A}
  setfield {cellpath}/soma/{Kahp_chan} Gbar {gdens_Kahp*SOMA_A}
  scaletabchan {cellpath}/soma/{K_chan}  X tau 1.0 {K_tauscale} 0.0 0.0
  scaletabchan {cellpath}/soma/{Kahp_chan}  Z tau 1.0 {Kahp_tauscale} 0.0 0.0
  setfield {cellpath}/soma/{Ca_conc} B {B_Ca_conc}
  setfield {cellpath}/soma/{Ca_conc} tau {tau_Ca_conc}

  Na_K_offset = {getfield /soma_params/Na_K_offset value}
  adjust_Na_K {Na_K_offset}
end


//===============================
//    Graphics Functions
//===============================

function make_control
  create xform /control [10,30,250,285]
  create xlabel /control/label -hgeom 25 -bg cyan -label "CONTROL PANEL"
  create xbutton /control/RESET -wgeom 33%       -script reset
  create xbutton /control/RUN  -xgeom 0:RESET -ygeom 0:label -wgeom 33% \
         -script step_tmax
  create xbutton /control/QUIT -xgeom 0:RUN -ygeom 0:label -wgeom 34% \
        -script quit
  create xdialog /control/stepsize -title "dt (sec)" -value {dt} \
                -script "change_stepsize <widget>"
  create xtoggle /control/overlay   -script "overlaytoggle <widget>"
  setfield /control/overlay offlabel "Overlay OFF" onlabel "Overlay ON" state 0
//  create xdialog /control/gmax -label "synchan gmax" \
//	-value {getfield {synpath} gmax} \
//        -script "setfield "{synpath}" gmax "<v>
//    create xdialog /control/weight -label "Weight" -wgeom 50% \
//        -value {syn_weight} -script "set_weights <v>"

    create xlabel /control/stimlabel -label "Stimulation Parameters"
    create xtoggle /control/injtoggle -label "" -script inj_toggle
    setfield /control/injtoggle offlabel "Current Injection OFF"
    setfield /control/injtoggle onlabel "Current Injection ON" state 1
    inj_toggle     // initialize
    create xdialog /control/inject -label "Injection" -value {injcurrent}  \
        -script "set_injection"
    create xdialog /control/injectdelay -label "Delay (sec)" -value {injdelay}  \
        -script "set_injection"
    create xdialog /control/width -label "Width (sec)" -value {injwidth}  \
        -script "set_injection"
    create xdialog /control/interval -label "Interval (sec)" -value {injinterval}  \
        -script "set_injection"

//    create xlabel /control/randact -label "Random background activation"
//    create xdialog /control/randfreq -label "Frequency (Hz)" -value 0 \
//        -script "set_frequency <v>"
  xshow /control
end

function make_soma_params
  create xform /soma_params [260, 30, 250, 515] -title params

 
  create xdialog /soma_params/Em -label "Em (Volts)" \
	-value {EREST_ACT}
  create xdialog /soma_params/RM_scale -label "RM scale" \
	-value 1.0
   create xdialog /soma_params/CM_scale -label "CM scale" \
	-value 1.0
  create xdialog /soma_params/gdens_Na -label "Na gdens (S/m^2)" \
	-value {gdens_Na}
  create xdialog /soma_params/gdens_K -label "K gdens (S/m^2)" \
	-value {gdens_K}
  create xdialog /soma_params/gdens_Ca -label "Ca gdens (S/m^2)" \
	-value {gdens_Ca}
  create xdialog /soma_params/gdens_CaT -label "CaT gdens (S/m^2)" \
	-value {gdens_CaT}
  create xdialog /soma_params/gdens_Nap -label "Nap gdens (S/m^2)" \
	-value {gdens_Nap}
  create xdialog /soma_params/gdens_H -label "H gdens (S/m^2)" \
	-value {gdens_H}
  create xdialog /soma_params/gdens_Kahp -label "Kahp gdens (S/m^2)" \
	-value {gdens_Kahp}

  create xdialog /soma_params/tau_K -label "K tau scale" \
	-value 1.0

  create xdialog /soma_params/tau_Kahp -label "Kahp tau scale" \
	-value 1.0

  create xdialog /soma_params/Na_K_offset -label "Na/Kdr offset (V)" \
	-value {Na_K_offset}

  create xdialog /soma_params/B_Ca_conc -label "Ca_conc B" \
	-value {B_Ca_conc}

  create xdialog /soma_params/tau_Ca_conc -label "Ca_conc tau" \
	-value {tau_Ca_conc}

  create xbutton /soma_params/APPLY -wgeom 50% -script set_params
  create xbutton /soma_params/Cancel -wgeom 50% -xgeom 0:APPLY  \
         -ygeom 0:tau_Ca_conc -script "xhide /soma_params"
  xshow  /soma_params
end

// Make the graph for plotting Vm
function make_Vmgraph
    float vmin = -0.100
    float vmax = 0.05
    create xform /data [520,50,500,350]
    create xlabel /data/label -hgeom 10% -label {graphlabel}
    create xgraph /data/voltage -hgeom 90% -title "Membrane Potential" -bg white
    setfield ^ XUnits sec YUnits Volts
    setfield ^ xmax {tmax} ymin {vmin} ymax {vmax}
    makegraphscale /data/voltage
    xshow /data
end

function make_Injgraph
    create xform /Injdata [520,420,500,150]
    create xlabel /Injdata/label -hgeom 10% -label Injection
    create xgraph /Injdata/injection -hgeom 90% -title "Injection" -bg white
    setfield ^ XUnits sec YUnits A
    setfield ^ xmax {tmax} ymin 0 ymax 0.8e-9
    makegraphscale /Injdata/injection
    xshow /Injdata
end

// Give the widgets more interesting colors
function colorize
    setfield /##[ISA=xlabel] fg white bg blue3
    setfield /##[ISA=xbutton] offbg rosybrown1 onbg rosybrown1
    setfield /##[ISA=xtoggle] onfg red offbg cadetblue1 onbg cadetblue1
    setfield /##[ISA=xdialog] bg palegoldenrod
    setfield /##[ISA=xgraph] bg ivory
end

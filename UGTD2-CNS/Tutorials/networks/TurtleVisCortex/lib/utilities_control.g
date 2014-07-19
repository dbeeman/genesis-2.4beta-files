//============= UTILITIES FOR VIEWING 4 SELECTED TIME SERIES =========//
// This file contains functions to display 4 time series plus a       // 
// control panel to start and stop the simulation.                    //
//                                                                    //
// Setup:                                                             //
// 1. connect_compartments - connect adjacent cylindrical compartments//
//    coordinates for the neurons, one neuron per line.               //
// 2. Call make_geniculate_cells                                      //
//                                                                    //
//====================================================================//

include ../lib/global_constants.g

str FIRST_SERIES = "/network_lateral/cell321/soma"
str SECOND_SERIES ="/network_medial/cell279/soma"
str THIRD_SERIES = "/network_lateral/cell1/soma"
str FOURTH_SERIES = "/network_medial/cell1/soma"

function step_sim (num_steps)
    int num_steps
    if (ECHO_ON == 1); showstat; end
    step {num_steps}
    if (ECHO_ON == 1); showstat; showstat -process; end
end


 
/* ******************************************************************
                      make_graph
     Creates 4 graphs called /data1/response, /data2/response,
     /data3/response, and /data4/response.
     
     Parameters:
        tmin            minimum time to be displayed on graphs
        tmax

****************************************************************** */  
function make_graph(name, tmin, tmax, ymin, ymax, x0, y0)
   str name
   int x0, y0 
   float tmin, tmax, ymin, ymax
   
   int width = 300;
   int height = 350;
   create xform {name} 
   setfield ^ xgeom {x0} ygeom {y0} wgeom {width} hgeom {height}
   str gname = {name}@"/response"
   create xgraph {gname}
   setfield ^ xmin {tmin} xmax {tmax} ymin {ymin} ymax {ymax} \
      xlabel "Time (sec)" bg white hgeom 100%
   xshow {name} 
end

/************************************************************************
 Function make_netview
   This is specialized for the standard NGU model simulation, and creates
   'xview' elements to display a color map of soma membrane potenial at
   the location of the lateral (represented by squares) and medial
   (represented by triangles) pyramidal cells.
*************************************************************************/

function make_netview  // sets up xview widget to display Vm of each cell
    create xform /netview [0,200,400,400] -title \
        "Vm of lateral (squares) and medial (triangles) pyramidal cells"
    create xdraw /netview/draw [0%,0%,100%, 100%]
    // Make the display region = (or a little larger than) the cell coord range
    setfield /netview/draw xmin 0 xmax 1.6 ymin 0 ymax 1.6 bg white
    create xview /netview/draw/lateral_view
    setfield /netview/draw/lateral_view path /network_lateral/cell# \
        relpath soma field Vm \
        value_min -0.08 value_max 0.03 viewmode colorview sizescale 0.04
    create xview /netview/draw/medial_view
    // The xview object needs a path to the elements that contain [xyz]
    // coordinates for the network display.  If the field to display (Vm) is
    // not in this path, then the relpath field gives its location relative
    // to 'path'.  The wildcard 'cell#' will refer to all elements with
    // names starting with 'cell'  'sizescale' sets the sie of the shapes.
    setfield /netview/draw/medial_view path /network_medial/cell# \
        relpath soma field Vm \
        value_min -0.08 value_max 0.03 viewmode colorview sizescale 0.04
    // hack to change the shape from default squares to triangles
    // See docs for xview and xshape
    setfield /netview/draw/medial_view/shape[0] \
        coords [-0.02,-0.02,0][0,0.02,0][0.02,-0.02,0][-0.02,-0.02,0]
    setfield /netview/draw/medial_view/shape[1] \
        coords [-0.02,-0.02,0][0,0.02,0][0.02,-0.02,0][-0.02,-0.02,0]
    xshow /netview
end


/*******************************************************************
                      make_control_panel
     Creates a control panel to run the simulation for the specified
     number of steps.
     
     Parameters:
        num_steps            number of steps to run the simulation
   
     Note: If you don't want to run the simulation without using
     a control panel, you will need to use the step command in the
     main script. 

****************************************************************** */  
function make_control_panel (num_steps)
   int num_steps
   
   create xform /control 
   setfield /control xgeom 10 ygeom 50 wgeom 250 hgeom 115
   create xlabel /control/label
   float label_w = {getfield /control/label wgeom} 
   setfield /control/label hgeom 50 bg cyan label "CONTROL PANEL"
   create xbutton /control/RESET -wgeom 25% -script reset
   create xbutton /control/RUN -xgeom 0:RESET -ygeom 0:label \
     -wgeom 25% -script "step_sim "{num_steps}" "
   create xbutton /control/STOP -xgeom 0:RUN -ygeom 0:label \
     -wgeom 25% -script stop
   create xbutton /control/QUIT -xgeom 0:STOP -ygeom 0:label \
     -wgeom 25% -script quit
   create xbutton /control/"CLOSE WINDOW" -wgeom {label_w}\
      -script "delete /control; delete /data1; delete /data2; delete /data3; delete /data4" 
   xshow /control
end

/* ******************************************************************
                      run_simulation
     Creates a control panel to run the simulation for the specified
     number of steps. If view_flag is 1, it also creates four windows
     to graph specified variables as the simulation runs.
     
     Parameters:
        num_steps            number of steps to run the simulation
   
     Note: If you don't want to run the simulation without using
     a control panel, you will need to use the step command in the
     main script. 

****************************************************************** */  
function run_simulation (tmax, ymin, ymax, num_steps, view_flag)
   float tmax, ymin, ymax
   int num_steps, view_flag
  
   make_control_panel {num_steps}
   if (view_flag == 1)
       make_graph "/data1" 0 {tmax} {ymin} {ymax} 400 10
       setfield /data1 title {FIRST_SERIES}
       addmsg {FIRST_SERIES} /data1/response PLOT Vm *volts *red

       make_graph "/data2" 0 {tmax} {ymin} {ymax} 700 10
       setfield /data2 title {SECOND_SERIES}
       addmsg {SECOND_SERIES} /data2/response PLOT Vm *volts *red

       make_graph "/data3" 0 {tmax} {ymin} {ymax} 400 400
       setfield /data3 title {THIRD_SERIES}
       addmsg {THIRD_SERIES} /data3/response PLOT Vm *volts *red

       make_graph "/data4" 0 {tmax} {ymin} {ymax} 700 400
       setfield /data4 title {FOURTH_SERIES}
       addmsg {FOURTH_SERIES}  /data4/response PLOT Vm *volts *red
       make_netview
   end
   
   if (ECHO_ON == 1 && view_flag == 1)
      echo "Graphing selected voltages to monitor progress:"
      echo "   /data1/response:" {FIRST_SERIES}
      echo "   /data2/response:" {SECOND_SERIES}
      echo "   /data3/response:" {THIRD_SERIES}
      echo "   /data4/response:" {FOURTH_SERIES}
   end
   
   check
   reset
end


/* ******************************************************************
                      run_simulation_no_graphics
     Creates a control panel to run the simulation for the specified
     number of steps. If view_flag is 1, it also creates four windows
     to graph specified variables as the simulation runs.
     
     Parameters:
        num_steps            number of steps to run the simulation
   
     Note: If you don't want to run the simulation without using
     a control panel, you will need to use the step command in the
     main script. 

****************************************************************** */  
function run_simulation_no_graphics (num_steps)
   int num_steps
   
   check
   reset
   step {num_steps}
end

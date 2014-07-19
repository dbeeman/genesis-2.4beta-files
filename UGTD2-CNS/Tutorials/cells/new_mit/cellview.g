//genesis - cellview.g - cell viewer

/* This assumes that the SIMPATH is set to include the neurokit directory,
   (to get defaults.g) and that there is a local protodefs.g to make any
   compartment and channel prototypes used in the cell parameter file,
   and to set various "user_" variables used here.
*/

function make_xcell(x,y)
    int x,y  // use 620,50 to go with Vm_graph
    create xform /cellform [{x},{y},475,400]  // later add optional args
    create xlabel /cellform/label [0,0,100%,25] -bg green \
      -label "Use arrows to pan; < and > to zoom; x, y, z, o, p for transform"
    create xdraw /cellform/draw [0,25,100%,375] -bg white -transform o
    create xcell /cellform/draw/cell
    if (user_symcomps == 0)
        setfield /cellform/draw/cell path {user_cell}/##[TYPE=compartment]
    else
        setfield /cellform/draw/cell path {user_cell}/##[TYPE=symcompartment]
    end
    setfield /cellform/draw/cell colmin -0.1 colmax 0.1 field Vm \
	diarange -30 soma -2
   xcolorscale hot
end

// Set the dimensions of the draw widget from the cell dimensions
function set_drawrange
    str i
    float x,y,z
    float xmin = -1e-6, xmax = 1e-6, ymin = -1e-6, ymax = 1e-6
    float zmin = -1e-6, zmax = 1e-6
    foreach i ( {el {user_cell}/#[]} )
        x = {getfield {i} x}; y = {getfield {i} y}; z =  {getfield {i} z}
        xmin = {min {xmin} {x}}; xmax = {max {xmax} {x}}
        ymin = {min {ymin} {y}}; ymax = {max {ymax} {y}}
        zmin = {min {zmin} {z}}; zmax = {max {zmax} {z}}
    end
    setfield /cellform/draw xmin {xmin*1.1} xmax {xmax*1.1} \
        ymin {ymin*1.1} ymax {ymax*1.1} zmin {zmin*1.1} zmax {zmax*1.1}
end

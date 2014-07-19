//genesis

include ht_compartments.g


make_compartments

setclock 0 0.000010

readcell main.p /main -hsolve
setmethod main 11
setfield main chanmode 4

create xform /out [200,50,300,300]
create xgraph /out/voltage [0,0,100%,100%]
setfield ^ xmax 2 ymin -0.1 ymax 0.05
xshow /out
addmsg /main/main /out/voltage PLOT Vm *cmp *red

// create xform /cell [550,50,300,300]
// create xdraw /cell/draw [0,0,100%,100%]
// setfield /cell/draw xmin -0.00005 xmax 0.00005 \
// 	ymin -1e-5 ymax 4e-5 \
// 	zmin -1e-5 zmax 1e-5
// create xcell /cell/draw/xcell
// setfield /cell/draw/xcell colmin -0.1 colmax 0.1 \
//     path /main/##[TYPE=compartment] field Vm \
//     script "echo <w> <v>"
// xshow /cell

call main SETUP

addmsg /main /out/voltage PLOT {findsolvefield /main /main/main Vm} *fsf *blue

reset

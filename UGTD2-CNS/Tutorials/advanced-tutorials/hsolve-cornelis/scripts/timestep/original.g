//genesis

include ht_compartments.g


make_compartments

make_spine_compartments

setclock 0 0.000010

readcell Purk2M9s.p /purkinje

// create xform /out [200,50,300,300]
// create xgraph /out/voltage [0,0,100%,100%]
// setfield ^ xmax 2 ymin -0.1 ymax 0.05
// xshow /out
// addmsg /purkinje/soma /out/voltage PLOT Vm *cmp *red

reset

echo original.g

step 1000

echo original.g

quit

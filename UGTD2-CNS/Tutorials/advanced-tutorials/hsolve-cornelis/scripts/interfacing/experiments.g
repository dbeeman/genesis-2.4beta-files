//genesis

include ht_compartments.g


make_compartments

setclock 0 0.000010

readcell main.p /cell -hsolve
setmethod /cell 11
setfield /cell chanmode 4

create xform /out [200,50,300,300]
create xgraph /out/voltage [0,0,100%,100%]
setfield ^ xmax 2 ymin -0.1 ymax 0.05
xshow /out
//addmsg /cell/soma /out/voltage PLOT Vm *cmp *red

// create xform /cell [200,350,300,300]
// create xdraw /cell/draw [0,0,100%,100%]
// setfield /cell/draw xmin -0.00005 xmax 0.00005 \
// 	ymin -1e-5 ymax 4e-5 \
// 	zmin -1e-5 zmax 1e-5
// create xcell /cell/draw/xcell
// setfield /cell/draw/xcell colmin -0.1 colmax 0.1 \
//     path /cell/##[TYPE=compartment] field Vm \
//     script "echo <w> <v>"
// xshow /cell

// point 1

create neutral /messengers
create neutral /messengers/n1
setfield /messengers/n1 x 0.0 y 0.0 z 0.0
addmsg /messengers/n1 /cell/soma/basket ACTIVATION x
addmsg /messengers/n1 /cell/main[0-4]/basket ACTIVATION y
addmsg /messengers/n1 /cell/main[5-8]/basket ACTIVATION z


call /cell SETUP

addmsg /cell /out/voltage PLOT {findsolvefield /cell /cell/soma Vm} *fsf *blue

create xform /xout [200,350,300,300]
create xdraw /xout/draw [0,0,100%,100%]
setfield /xout/draw xmin -0.00005 xmax 0.00005 \
	ymin -1e-5 ymax 4e-5 \
	zmin -1e-5 zmax 1e-5
create xcell /xout/draw/xcell

setfield /xout/draw/xcell colmin -0.1 colmax 0.05 \
    path /cell/##[TYPE=compartment] \
    script "echo <w> <v>"

str element

foreach element ( { el /cell/##[TYPE=compartment] } )
	addmsg /cell /xout/draw/xcell \
		COLOR {findsolvefield /cell {element} Vm}
end

setfield /xout/draw/xcell nfield {countelementlist /cell/##[TYPE=compartment]}

xshow /xout

reset

// point 2

// current injection

// setfield /cell {findsolvefield /cell /cell/soma inject} 1e-9
// step 0.5 -time
// setfield /cell {findsolvefield /cell /cell/soma inject} 0
// step 0.5 -time

// activation messages

step 0.2 -time
setfield /messengers/n1 x 1.0 y 1.0 z 1.0
step
setfield /messengers/n1 x 0.0 y 0.0 z 0.0
step 0.2 -time
setfield /messengers/n1 x 1.0 y 1.0 z 1.0
step
setfield /messengers/n1 x 0.0 y 0.0 z 0.0
step 0.2 -time

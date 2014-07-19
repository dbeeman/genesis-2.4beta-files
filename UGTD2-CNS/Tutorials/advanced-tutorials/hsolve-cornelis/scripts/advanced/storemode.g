//genesis

include ht_compartments.g

make_compartments

setclock 0 0.000010

readcell main.p /cell -hsolve
setmethod /cell 11
setfield /cell chanmode 4 storemode 1

create xform /out [200,50,300,300]
create xgraph /out/current [0,0,100%,100%]
setfield ^ xmax 2 ymin -0.1e-10 ymax 8e-10
xshow /out
// addmsg /cell/main /out/current PLOT Im *cmp *red

call /cell SETUP

addmsg /cell /out/current \
	PLOT {findsolvefield /cell /cell/main Im} *main *blue

addmsg /cell /out/current \
	PLOT itotal[0] *totalLeak *red

reset

//genesis

include ht_compartments.g


make_compartments

setclock 0 0.000010

int use_hsolve = 1

if ({use_hsolve} == 1)
	readcell main.p /cell -hsolve
	setmethod /cell 11
	setfield /cell chanmode 4 computeIm 1
else
	readcell main.p /cell
end

create xform /out [200,50,300,300]
create xgraph /out/current [0,0,100%,100%]
setfield ^ xmax 2 ymin -0.1e-10 ymax 8e-10
xshow /out
// addmsg /cell/main /out/current PLOT Im *cmp *red

create efield field_recorder
setfield field_recorder scale -20 x 40e-6 y 40e-6 z {0}

addmsg /cell/##[][TYPE=compartment] \
	field_recorder CURRENT Im 0.0

create xform /out2 [200,350,300,300]
create xgraph /out2/field_potential [0,0,100%,100%]
setfield ^ xmax 2 ymin -0.001 ymax 0.0005
xshow /out2

addmsg /field_recorder /out2/field_potential \
	PLOT field *field *blue

if ({use_hsolve} == 1)
	call /cell SETUP

	if ({getfield /cell chanmode} < 2)

		addmsg /cell/main /out/current \
			PLOT Im *solver *blue
	else
		addmsg /cell /out/current \
			PLOT {findsolvefield /cell /cell/main Im} *fsf *blue
	end
else

	addmsg /cell/main /out/current \
		PLOT Im *cmp *blue
end

reset

//genesis

include ht_granule_compartments.g


granule_make_compartments

setclock 0 0.0000030

readcell granule.p /granule


//- create map

createmap \
	/granule /granule_cell_layer 5 1 \
	-delta 1e-4 7.5e-5 -origin 5e-5 3.75e-5

ce /granule_cell_layer/granule[0]
create hsolve solver
setmethod solver 11
setfield solver calcmode 1 chanmode 4 path "../[][TYPE=compartment]"

call solver SETUP
int i

for (i = 1 ; i < 5 ; i = i + 1)
	call solver DUPLICATE \
		/granule_cell_layer/granule[{i}]/solver \
		../##[][TYPE=compartment]
end
reset

//- create output

create xform /out [200,50,300,300]
create xgraph /out/voltage [0,0,100%,100%]
setfield ^ xmax 2 ymin -0.1 ymax 0.05
xshow /out
for (i = 0 ; i < 5 ; i = i + 1)
	ce /granule_cell_layer/granule[{i}]
	addmsg solver /out/voltage \
		PLOT {findsolvefield solver soma Vm} *{i} *{i}
// 	addmsg soma /out/voltage PLOT Vm *{i} *{i}
end
reset

//genesis


int include_cell

if ( {include_cell} == 0 )

	include_cell = 1


include ht_compartments.g


make_compartments

make_spine_compartments

setclock 0 0.000010

readcell main.p /main -hsolve
setmethod main 11
setfield main chanmode 4


end



// genesis makeobjects.g

/*

==========================================================================
               FUNCTION                 ARGUEMENTS
==========================================================================
          makelibrary
		  makearray
===========================================================================
*/


//========================================================================
//                  create the cells and connections
//========================================================================
function makelibrary
	// create voltage gated channels
    //                            create cell
	if (!{exists /library})
    create neutral /library
    /* We don't want the library to try to calculate anything,
    **  so we disable it */
    disable /library
	end

	makeneuron /library/cell 100e-6 100e-6
end

function makearray ( path )
str path

if (!{exists {path}} )
create neutral {path}
end

pushe {path}
int i
int x, y

x=0
y=0
for (i=1; i<=100; i=i+1)

	if ({y%10} == 0)
		x = x + 1
	end

	copy /library/cell c[{i}]
	setfield c[{i}]/soma y {{y}%10 +1} x {x}
	setfield c[{i}]/esyn y {{y}%10 +1} x {x}
	setfield c[{i}]/isyn y {{y}%10 +1} x {x}
	setfield c[{i}]/spike y {{y}%10 +1} x {x}
	setfield c[{i}]/soma  initVm {{Eleak}+{rand -15e-3 10e-3}}
//	setfield c[{i}]/soma  Em {{Eleak}+{rand -5e-3 5e-3}}

	y=y+1
end

for (i=1; i<=10; i=i+1)
//	setfield c[{i}]/soma Em {{Eleak}+15e-3} // make input array spont. act.
end
pope

end

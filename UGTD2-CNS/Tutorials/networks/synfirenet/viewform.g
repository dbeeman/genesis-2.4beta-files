//genesis viewform.g

/*
             functions defined in this script
=============================================================================
      FUNCTION                  ARGUMENTS
============================================================================
    setci                   (path)
    soma_doodle              (path,x_coord,y_coord)
    makeviewform
============================================================================
*/

// =========================================================================
//        show the information associated with the cell clicked on
// =========================================================================
function setci(path)
	str path
	echo {path}
	if ({getfield {path}/injectpulse level1} == 0)
	setfield {path}/injectpulse level1 {injectval}
	echo setting inject on {path} to {injectval}
	else
	setfield {path}/injectpulse level1 0
	echo setting inject on {path} to 0.0
	end
end


 // =========================================================================
 //                   create cell symbol in the viewform
 // =========================================================================
function soma_doodle(path, name)
     str path
	 str name
     float radius, dtheta, x, y
     int i
     create xvar /viewform/draw/{name}  \
         -value_min -70e-3 -value_max 0e-3   \
         -varmode shape -color_val 1 -morph_val 0 -script "setci "{path}

     pushe /viewform/draw/{name}

     setfield . tx {getfield {path} x}  ty {11-{getfield {path} y}}
     addmsg {path} .  VAL1 Vm

     // create circle for icon
     dtheta = 3.14159/10
     radius = 0.3
     for(i=0;i<=20;i=i+1)
         x = radius*{cos {i*dtheta}}
         y = radius*{sin {i*dtheta}}
         setfield shape[0] xpts->table[{i}] {x}
         setfield shape[0] ypts->table[{i}] {y}
         setfield shape[1] xpts->table[{i}] {x}
         setfield shape[1] ypts->table[{i}] {y}
     end
     setfield shape[0] npts 20
     setfield shape[1] npts 20
     pope

     useclock /viewform/draw/{name} 2
     create xshape /viewform/draw/text_{name} -text {name} -tx  \
         {getfield {path} x} -ty {11.5-{getfield {path} y}}  \
		-textfont -adobe-courier-bold-*-*-*-13-*-75-*-*-*-*-*
end


// ==========================================================================
//      create viewform, put in graphics, and show buttons
// ==========================================================================
function makeviewform (comppath)
str comppath
     //use slow clock for updates
     setclock 2 2e-4
     create xform /viewform [410,150,600,600] -nolabel
     create xdraw /viewform/draw [2%,2%,96%,92%] 
	setfield ^ xmin 0 xmax 11 ymin 0 ymax 11 cx 5.5 cy 5.5 bg white 
     create xlabel /viewform/label  [2%,90%,96%,10%] -title  \
         "cell array"
     useclock /viewform/draw 2

	int i
	for (i=1; i<=100; i=i+1)
     soma_doodle {comppath}/c[{i}]/soma c[{i}]
	end
     xshow /viewform
end

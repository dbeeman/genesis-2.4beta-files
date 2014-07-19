//genesis toggles.g

/* 
	functions defined in this script
=============================================================================
	FUNCTION NAME		ARGUMENTS
=============================================================================
	overlaytoggle		(widget)
        windowtoggle            (widget,path)
        donetoggle              (widget,path,type)
        maketoggle              (path,type)
        synapsetoggle           (widget,path,num)
=============================================================================
*/



// ==========================================================================
//                 toggles the overlaying of graph outputs 
// ==========================================================================
function overlaytoggle(widget)
    overlay / {getfield {widget} state}
end

// ==========================================================================
// toggles the display of graphics, settings, or connections  control panels 
// ==========================================================================
function windowtoggle(widget, path)
    if ({getfield {widget} state} == 1)
	xshow {path}
     //   setfield {widget} state 1
    else
	xhide {path}
     //  setfield {widget} state 0
    end
end

//===========================================================================
//                      done toggles for windows
//===========================================================================
function donetoggle(widget, togglepath, windowpath)
     if ({getfield {widget} state} == 0)
        xhide {windowpath}
        setfield {togglepath} state 0
     else
        xshow {windowpath}
        setfield {togglepath} state 1
     end
end


// ========================================================================
//   add a toggle for a cell in the main cell control panel
// ========================================================================
function maketoggle(path, togglepath, typepath)
    str path, togglepath, typepath
    str temp1, temp2

    create xtoggle {togglepath} -script  \
        "windowtoggle <widget> "{typepath}
    temp2 = (path) @ "  VISIBLE"
    setfield {togglepath} onlabel {temp2}
    temp2 = (path) @ "  HIDDEN"
    setfield {togglepath} offlabel {temp2}
    setfield {togglepath} state 0
end

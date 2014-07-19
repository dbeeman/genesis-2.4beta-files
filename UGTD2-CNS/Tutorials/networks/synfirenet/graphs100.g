//genesis graphs.g

/* 
	functions defined in this script
=============================================================================
	FUNCTION NAME		ARGUMENTS
=============================================================================
 	makegraph		(gpath, comppath, fc, lc)
=============================================================================
*/


// ==========================================================================
//                 create form and graphs for display of voltages
// ==========================================================================
function makegraph(gpath, comppath, fc, lc)

    // path gives the location of the cell
    // graphicspath gives the location of the control form for the cell
      str gpath
	str comppath
	int fc, lc
      str graphicspath = (gpath)
      str togglepath =  "/graphicscontrol/graphics/" @ {fc} @ "-" @ {lc}
	int i


    // =================================================
    //               create graphics form
    // =================================================
	if (!{exists /graphs})
		create neutral /graphs
	end
	str temp = "c" @ {fc} @ "-" @ {lc}
    create xform {graphicspath} [5,100,500,500] -title {temp}

    // =================================================
    //      make graph for cell intracellular potential
    // =================================================
    pushe {graphicspath}
    create xgraph graph [2%,20,96%,92%] -title  "  "
    setfield graph xmin 0 xmax 0.2 ymin -80e-3 ymax 200e-3 yoffset 15e-3

	int j = 0
	for (i = fc; i <= lc; i = i + 1)
	temp = "Vm" @ "c" @ {i}
    addmsg {comppath}/c[{i}]/soma graph PLOT Vm *{temp} *{j%60}
	j = j + 10
	end

    useclock graph 1
    makegraphscale {graphicspath}/graph

    // add a toggle for this cell in the main cell control panel
    maketoggle {gpath} {togglepath} {graphicspath}

	// xshow {graphicspath}
    pope
end

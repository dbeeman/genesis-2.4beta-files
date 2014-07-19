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
//                 create form and graphs for display of conductances
// ==========================================================================
function makeggraph(gpath, comppath, fc, lc)

    // path gives the location of the cell
    // graphicspath gives the location of the control form for the cell
      str gpath
	str comppath
	int fc, lc
      str graphicspath = (gpath)
      str togglepath =  "/graphicscontrol/graphics/g" @ {fc} @ "-" @ {lc}
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
    setfield graph xmin 0 xmax 0.2 ymin 0 ymax 1e-7 yoffset 1e-8

	int j = 0
	for (i = fc; i <= lc; i = i + 2)
	temp = "Gex" @ "c" @ {i}
    addmsg {comppath}/c[{i}]/esyn graph PLOTSCALE Gk *{temp} *{j%60} 1.0 0.0
	temp = "Gin/10" @ "c" @ {i}
    addmsg {comppath}/c[{i}]/isyn graph PLOTSCALE Gk *{temp} *{j%60} 0.1 0.0
	j = j + 10
	end

    useclock graph 1
    makegraphscale {graphicspath}/graph

    // add a toggle for this cell in the main cell control panel
    maketoggle {gpath} {togglepath} {graphicspath}

	// xshow {graphicspath}
    pope
end

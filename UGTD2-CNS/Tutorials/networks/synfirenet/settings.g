//genesis settings.g

/*	functions defined in this script
=============================================================================
	FUNCTION NAME		ARGUMENTS
=============================================================================
 	parameter_form	(graphicspath,cellpath,x,y)
        makesettings            (path)
=============================================================================
*/

// ==========================================================================
//      create a display of conductance information for settings window
// ==========================================================================
function parameter_form(graphicspath, cellpath, x, y)
    str graphicspath
    str cellpath
	str parampath
    float x, y

	parampath = {graphicspath} @ "/" @ "parameters"
    create xlabel {parampath}  [{x},{y},200,30] -title  \
        {cellpath}
    pushe {parampath}
    create xdialog E [{x},{y + 35},200,30] -script  \
        "fieldbutton "{cellpath}" Em <widget>" -title "Eequil (V)" -value \
         {getfield {cellpath} Em}
    create xdialog Rm [{x},{y + 70},200,30] -script  \
        "fieldbutton "{cellpath}" Rm <widget>" -title "Rm (Ohm)"  \
        -value {getfield {cellpath} Rm}
    create xdialog Cm [{x},{y + 105},200,30] -script  \
        "fieldbutton "{cellpath}" Cm <widget>" -title "Cm (F)"  \
        -value {getfield {cellpath} Cm}
    create xdialog initVm [{x},{y + 140},200,30] -script  \
        "fieldbutton "{cellpath}" initVm <widget>" -title "initVm (V)" -value \
         {getfield {cellpath} initVm}
    pope
end


// ==========================================================================
//           create settings form and place displays in the window
// ==========================================================================
function makesettings(path)
    // path gives the location of the cell
    // settings path gives the location of the control form for the cell

    str path, temp1, temp2
    str settingspath = (path) @ "/settings"
    str togglepath = "/output/settings" @ (path)

    // add a toggle for this cell in the main cell control panel
    maketoggle "Parameters" {togglepath} {settingspath}

    // =================================================
    //           create settings form
    // =================================================
   create xform {settingspath} [855,5,210,225] -title {settingspath}
   create xtoggle {settingspath}/done [5,20,200,25] -script  \
       "donetoggle <widget> "{togglepath}" "{settingspath}
    setfield {settingspath}/done offlabel "HIDDEN"
    setfield {settingspath}/done onlabel "VISIBLE"
    pushe {settingspath}

	//=================================================
	//       create parameter buttons
	//=================================================
	parameter_form {settingspath} {path}/soma 5 50

    pope
end

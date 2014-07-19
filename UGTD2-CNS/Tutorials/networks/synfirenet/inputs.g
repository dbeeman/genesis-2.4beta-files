//inputs.g for CPG tutorial

/*
                  Functions defined in this Script 
=========================================================================
            Function                        Arguements
=========================================================================
            set_injection                 (formpath,injpath)
            injection_form                (inputspath,injpath,name,x,y) 
            makeinputs                    (path)
===========================================================================
*/

//======================================================================
//      used to set the injection parameters
//======================================================================
function set_injection(formpath, injpath)
   float width, delay, current
   str formpath, injpath
   width = ({getfield {formpath}/width value})
   delay = ({getfield {formpath}/delay value})
   setfield {injpath}/injectpulse level1 1.0 width1 {width}  \
       delay1 {delay} baselevel 0.0 trig_mode 0 delay2 100000
   setfield {injpath}/injectpulse/injcurr  \
       gain {getfield {formpath}/inject value}
   echo  \
       "Injection current = "{getfield {formpath}/inject value}" amperes"
   echo  \
       "Injection pulse delay = "{getfield {formpath}/delay value}" sec"
   echo  \
       "Injection pulse width = "{getfield {formpath}/width value}" sec"
end

// =========================================================================
//    create a display of current injection info for the inputs window
// =========================================================================
function injection_form(inputspath, injpath, name, x, y)
    str inputspath, injpath, name
    float x, y

    str formpath = (inputspath) @ "/" @ (name)
    create xlabel {formpath} [{x},{y},200,30] -title  \
        "input to "{injpath}
    create xdialog {formpath}/inject [{x},{y + 35},200,30] -title  \
        "Current (A)" -value {injcurrent}
    create xdialog {formpath}/delay [{x},{y + 70},200,30] -title  \
        "Delay (s)" -value {injdelay}
    create xdialog {formpath}/width [{x},{y + 105},200,30] -title  \
        "Duration (s)" -value {injwidth}
    create xbutton {formpath}/APPLY [{x},{y + 140},200,30] -script  \
        "set_injection "{formpath}" "{injpath}
end

// ==========================================================================
//           create settings form and place displays in the window
// ==========================================================================
function makeinputs(path, delayval)
    // path gives the location of the cell
    // inputspath gives the location of the control form for the cell

    str path, temp1, temp2
    str inputspath = (path) @ "/inputs"
    str togglepath = "/output/settings/inputs"
    float delayval

    // add a toggle for this cell in the main cell control panel
    maketoggle "Input Pulse" {togglepath} {inputspath}

    // =================================================
    //           create inputs form
    // =================================================
    create xform {inputspath} [855,50,210,250] -title {inputspath}  \
        -nolabel
    create xtoggle {inputspath}/done [5,20,200,25] -script  \
        "donetoggle <widget> "{togglepath}" "{inputspath}
    setfield {inputspath}/done label0 "HIDDEN"
    setfield {inputspath}/done label1 "VISIBLE"

    // =================================================
    //    create current injection buttons
    // =================================================
    injection_form {inputspath} {path}/soma soma 5 55

    //==================================================
    //            initialize injection
    //==================================================
   setfield {inputspath}/soma/width value 0.05
   setfield {inputspath}/soma/delay value {delayval}
   setfield {inputspath}/soma/inject value 0.0
   set_injection {inputspath}/soma {path}/soma
end

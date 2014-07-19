//genesis initialize.g

/* 
	functions defined in this script
=============================================================================
	FUNCTION NAME		ARGUMENTS
=============================================================================
 	loadgraphics
=============================================================================
*/

// ==========================================================================
//            initiate graphics at beginning of simulation
// ==========================================================================
function loadgraphics
    // activate XODUS
    
    // give it color
    xcolorscale hot
    // =====================================================
    //               create main control panel
    // =====================================================
	create neutral /graphicscontrol
    create xform /graphicscontrol/main_control [489,5,400,125] -title  \
        "netsim -- by D. Jaeger 2-99"
    pushe /graphicscontrol/main_control
    create xbutton reset [3%,20,30%,25] -script reset -title RESET
    create xtoggle overlay [35%,20,30%,25] -title "OVERLAY" -script  \
        "overlaytoggle <widget>"
    create xbutton stop [67%,20,30%,25] -title STOP -script stop
    create xbutton quit [3%,47,30%,25] -title QUIT -script  \
        "quitbutton <widget>"
    create xbutton help [35%,47,30%,25] -title HELP -script  \
        "xshow /helpmenu"
    create xbutton noinject [67%,47,30%,25] -title "Remove Inject" -script  \
        "setfield /cellarray/c[]/soma/injectpulse level1 0.0 ; 	\
        echo Setting injection to 0.0 on all cells"

    makeconfirm quit "Quit?" "quit" "cancelquit <widget>" 500 400
    create xdialog step [3%,74,46%,30] -script "stepbutton <widget>"  \
        -title "STEP (s)" -value 0.02
    create xdialog stepsize [51%,74,46%,30] -title "dt (s)" -script  \
        "setstepsize <widget>" -value {getclock 0}
    pope
    xshow /graphicscontrol/main_control

    // ======================================================
    // create graphics, settings, and connection toggle forms
    // ======================================================

//    create xform /graphicscontrol/settings [195,5,180,145] -title Settings
//   xshow /graphicscontrol/settings

	create xform /graphicscontrol/graphics [5,5,200,300] -title Graphs
    xshow /graphicscontrol/graphics

end

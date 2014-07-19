//genesis help.g

//=======================================================================
//                    load the help stuff 
//=======================================================================
function loadhelp
   str screens = "/helpscreens"
   create neutral {screens}
   textwindow {screens}/help 50 400 help.hlp
   textwindow {screens}/README 50 400 README
   textwindow {screens}/running 50 400 running.hlp
   textwindow {screens}/params 50 400 params.hlp
   textwindow {screens}/totry 50 400 totry.hlp

   str form = "/helpmenu"
   create xform {form} [855,5,210,240] -nolabel
   pushe {form}
   create xbutton helphelp [5,5,190,30] -title "USING HELP" -script  \
       "xshowontop "{screens}"/help"
   create xbutton README [5,40,190,30] -title "VIEW THE README FILE" \
        -script "xshowontop "{screens}"/README"
   create xbutton running [5,75,190,30] -title "RUNNING THE SIMULATION" \
        -script "xshowontop "{screens}"/running"
   create xbutton parameters [5,110,190,30] -title "MODEL PARAMETERS"  \
       -script "xshowontop "{screens}"/params"
   create xbutton totry [5,145,190,30] -title "THINGS TO TRY" -script  \
       "xshowontop "{screens}"/totry"
   create xbutton quit [5,180,190,30] -title "QUIT HELP" -script  \
       "xhide "{form}
   pope
end

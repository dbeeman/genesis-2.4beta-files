/* Use this with inj_tut.g to simulate blocking of Na and Kfast (K2_mit_usb)
   and partial blocking of K channels, with mit.p or smit2.p.  It makes use
   of definitions in inj_tut.g and the files included by it.
*/

function do_blocking
    float Gbar
    str chan
    setfield {user_cell}/#[]/Na_mit_usb Gbar 0.0
    setfield {user_cell}/#[]/K2_mit_usb Gbar 0.0
    foreach chan ( {el {user_cell}/#[]/K_mit_usb} )
        Gbar = {getfield {chan} Gbar}
        setfield {chan} Gbar {Gbar/1.3}
        echo "Changing "{chan}" Gbar from "{Gbar}" to "{Gbar/1.3}
    end
end

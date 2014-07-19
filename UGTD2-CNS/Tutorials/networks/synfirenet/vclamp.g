// genesis

function vclampon

    // Electronics for voltage clamp 

	create pulsegen /vcommand
	setfield ^ baselevel -0.06 level1 -0.03 width1 0.05 delay1 0.1 delay2 999 \
		trig_mode 0.0 trig_time 0.0

    //  time constant of 0.5 msec

    create RC /lowpass
    setfield ^ R 500.0 C 0.1e-6

    create diffamp /Vclamp
    setfield ^ saturation 999.0 gain 0.002  // 1/R from /lowpass

    create PID /PID
    setfield ^ gain 1e-6 tau_i 1e-3 tau_d 1.0e-4 saturation 6e-9

    // hook up voltage clamp circuitry

    addmsg /vcommand /lowpass INJECT output
    addmsg /lowpass /Vclamp PLUS state
	addmsg /Vclamp /PID CMD output
    addmsg /cell/soma /PID SNS Vm
    addmsg /PID /cell/soma INJECT output
	addmsg /PID /cell/graphics/graph PLOTSCALE output *vclamp_current_nA/10 *green 1e8 0e-3
	addmsg /Vclamp /cell/graphics/graph PLOTSCALE output *vclamp_command-10mV *green 1.0 -0.01


end


function vclampoff

delete /Vclamp
delete /PID
delete /lowpass
delete /vcommand

end

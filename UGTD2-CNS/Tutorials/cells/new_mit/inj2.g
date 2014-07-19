//genesis
/* 
** This simulation script performs 4 simulations :
** 1 : TEA/TTX blocked mitral cell model, inj=0.62nA
** 2 : TEA/TTX blocked mitral cell model, no Ca in soma/axons.
** 3 : Unblocked mitral cell model, inj=0.5nA
** 4 : Unblocked mitral cell model, no trode leak in soma.
*/

/* Simulation parameters */
float dt = 50e-6
float filet = 100e-6
setclock 0 {dt}
setclock 1 {filet}
float simtime = 0.32
float injblock = 0.62e-9
float injnoblock = 0.5e-9
str refblock = "correct.block"
str refnoblock = "correct.noblock"
// This is mit.p minus Na/Kfast channels
str mitblock = "P53.p"
str mitnoblock = "mit.p"

/* Display_mode selects how you want the output.
** 0 : Only file output
** 1 : Xodus output
** 2 : xplot output
*/
int display_mode = 1

/*
** hines_mode is a flag to select the level of optimization for the
** hsolver.
** Level 0 does not use the hines solver.
** Level 1 sets the hines solver to the older (slower) mode.
** Level 2 is the most optimized.  
*/
int hines_mode = 1 // (Kca_mit_usb can't use GENESIS 2.1 hsolve chanmode 3)

// Flag added for file output - set to 1 for output
int fileio = 0

/*
** Loading in the prototypes
*/
if (!({exists /library}))
		include defaults // assume neurokit/prototypes is in SIMPATH
		include compartments 
		include newbulbchan

		ce /library

		make_cylind_compartment
		make_LCa3_mit_usb
    	make_K2_mit_usb
    	make_K_mit_usb
		make_Na_rat_smsnn
		make_KA_bsg_yka
		setfield KA_bsg_yka Ek -0.07
		make_KM_bsg_upi
		setfield KM_bsg_upi Ek -0.07
		make_Na_mit_usb
		make_Na2_mit_usb
		make_Ca_mit_conc
		make_Kca_mit_usb
		ce /
end


/*
** Creating the cells 
*/
// Reading in the basic cell descriptor files 
readcell {mitnoblock} /mit
/* We could read in the 'blocked' model, which would be more efficient.
** instead, let us do the channel blocking by reducing the conductances
** on the complete model.
** read_cell {mitblock} /block
*/
copy /mit /block
// Eliminate Na, K2, and reduce K appropriately
scaleparms /block /mit #[]/Na_mit_usb Gbar 0.0 #[]/K2_mit_usb Gbar 0.0  \
    #[]/K_mit_usb Gbar {1.0/1.3}


// Duplicating the unblocked model and eliminating electrode leak
float correct_Rm = {RM}/(32e-6*32e-6*{PI})
copy /mit /noleak
setfield /noleak/soma Rm {correct_Rm}

// duplicating the blocked model and eliminating Ca from the
// soma,axon and secondary dends, and doubling it in the glom
copy /block /noca
setfield /noca/soma/LCa3_mit_usb Gbar 0.0
setfield /noca/axon[]/LCa3_mit_usb Gbar 0.0
// Doubling the conc in the glom to compensate
scaleparms /noca /block glom#[]/LCa3_mit_usb Gbar 2.0

// Setting the injection currents
setfield /mit/soma inject {injnoblock}
// We need to scale the noleak input current to the input resistance
// Note that this is not an exact equivalent, since the electrotonic
// structure of the cell has changed considerably
float mit_input_res, noleak_input_res
	mit_input_res = {calcRm /mit/soma}
	noleak_input_res = {calcRm /noleak/soma}
setfield /noleak/soma  \
    inject {1.6*injnoblock*mit_input_res/noleak_input_res}
setfield /block/soma inject {injblock}
setfield /noca/soma inject {injblock}

// Setting up the hsolvers
if (hines_mode > 0)
	create hsolve /mit/solve
	setfield ^ path /mit/##[][TYPE=compartment]
	create hsolve /noleak/solve
	setfield ^ path /noleak/##[][TYPE=compartment]
	create hsolve /block/solve
	setfield ^ path /block/##[][TYPE=compartment]
	create hsolve /noca/solve
	setfield ^ path /noca/##[][TYPE=compartment]

	if (hines_mode == 1)
		setfield /#/solve comptmode 1 chanmode 1
	end
	if (hines_mode == 2)
		setfield /#/solve comptmode 1 chanmode 3
	end
	call /mit/solve SETUP
	call /noleak/solve SETUP
	call /block/solve SETUP
	call /noca/solve SETUP
	setmethod 11
end

// Setting up the file I/O
if ((fileio > 0) || (display_mode == 0))
    create asc_file /output/mitVm
    create asc_file /output/noleakVm
    create asc_file /output/blockVm
    create asc_file /output/nocaVm
    addmsg /mit/soma /output/mitVm SAVE Vm
    addmsg /noleak/soma /output/noleakVm SAVE Vm
    addmsg /block/soma /output/blockVm SAVE Vm
    addmsg /noca/soma /output/nocaVm SAVE Vm
    setfield /output/# leave_open 1 initialize 1 flush 0
    useclock /output/# 1
end

// Seting up graphics
if (display_mode == 1)
//	xstartup
	create xform /form [0,0,1000,800]
	create xgraph /form/mit [50%,0%,50%,50%]
	create xgraph /form/noleak [50%,50%,50%,50%]
	create xgraph /form/block [0%,0%,50%,50%]
	create xgraph /form/noca [0%,50%,50%,50%]
	setfield /form/# ymin -0.1 ymax 0.05 xmax {simtime}
	addmsg /mit/soma /form/mit PLOT Vm *somaVm *red
	addmsg /noleak/soma /form/noleak PLOT Vm *somaVm *green
	addmsg /block/soma /form/block PLOT Vm *somaVm *blue
	addmsg /noca/soma /form/noca PLOT Vm *somaVm *orange
	xshow /form
	useclock /form/# 1
end

// change some default colors
setfield /##[ISA=xgraph] bg white
setfield /##[ISA=xform] bg lightblue


// Running simulation
reset
step {simtime} -time

// Flushing pending file output
if ((fileio > 0) || (display_mode == 0))
    setfield /output/# flush 1 leave_open 0
    call /output/# PROCESS
end

// Displaying xplots in mode 2
if (display_mode == 2)
	plotall
	/*
	xplot correct.block -geometry =300x300+0+0 &
	xplot correct.noblock -geometry =300x300+300+0 &
	xplot blockVm -geometry =300x300+0+300 &
	sleep 2
	xplot mitVm -geometry =300x300+300+300 &
	sleep 2
	xplot nocaVm -geometry =300x300+0+600 &
	sleep 2
	xplot noleakVm -geometry =300x300+300+600 &
	*/
end

if (display_mode != 1)
	quit
end

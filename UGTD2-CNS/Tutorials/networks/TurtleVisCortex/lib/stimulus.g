//====================== STIMULUS FOR NGU MODEL ======================//
// This file contains functions for different stimuli for NGU model:  //
//     a) diffuse flash stimulus of a specified duration              //
//                                                                    //
// To use another stimulus, create a function to replace              //
// make_diffuse_flash and call it from the model program.             //
//====================================================================//

include ../lib/global_constants.g

float LGN_EREST = -74.0 * 1e-3 //LGN resting membrane potential (volts)

/* ******************************************************************
                       make_diffuse_flash
     Sets up a diffuse flash input by stimulating all members of 
     target group for fixed time
     
     Parameters:
        src            		base name of spike source
        target_group   		destination neurons for stimulation 
                           	are{target_group#}/soma
		  input_level    		injected current in amps
        flash_dur          flash duration in sec
        tmax           		maximum time of simulation in sec
     	  stim_delay			stimulus onset delay in sec
        
****************************************************************** */  
function make_diffuse_flash (src, target_group, input_level, flash_dur, tmax, stim_delay)
   str src, target_group
   float input_level, flash_dur, tmax, stim_delay

   create neutral /input1 
   
   int count = 0
   str pulse, target, name
   foreach name  ({el {target_group}#})
      count = count + 1
      pulse = {src}@{count}
      target = {name}@"/soma" 
      create pulsegen {pulse}
      setfield {pulse} level1 {input_level} baselevel 0 \
             width1 {flash_dur} delay1 {stim_delay} delay2 {tmax}
      addmsg {pulse} {target} INJECT output
      setfield {target} initVm {LGN_EREST}
   end

   if (ECHO_ON == 1)
      echo "Created" {count} {src} "pulse sources" for {target_group}
      echo "   Stimulus is diffuse flash of" {flash_dur} "seconds duration"
   end

end

/* ******************************************************************
                       make_spot_flash
     Sets up a spot flash input by stimulating a range of  
     target group for fixed time
     
     Parameters:
			first_lgn		 	first LGN cell to stimulate	
			last_lgn				last LGN cell to stimulate
        	src            	base name of spike source
        	target_group   	destination neurons for forcing 
                           	are{target_group#}/soma
		   input_level    	injected current in amps
         flash_dur         flash duration in sec
        	tmax           	maximum time of simulation in sec
        	stim_delay			stimulus onset delay in sec
        
****************************************************************** */
function make_stationary_spot (first_lgn, last_lgn, src, target_group, input_level, flash_dur, tmax, stim_delay)
   int first_lgn, last_lgn
   str src, target_group
   float input_level, flash_dur, tmax, stim_delay

   create neutral /input2 

   int count, number
   
   number = {abs {{first_lgn} - {last_lgn}}} + 1
   str pulse, target, name
   for (count = first_lgn; count <= last_lgn; count=count+1)
      name = {target_group}@{count}
      pulse = {src}@{count}
      target = {name}@"/soma" 
      create pulsegen {pulse}
      setfield {pulse} level1 {input_level} baselevel 0 \
             width1 {flash_dur} delay1 {stim_delay} delay2 {tmax}
      addmsg {pulse} {target} INJECT output
      setfield {target} initVm {LGN_EREST}
   end

   if (ECHO_ON == 1)
      echo "Created" {number} {src} "pulse sources for" {target_group}
      echo "   Stimulus is a stationary spot flash of" {flash_dur} "sec duration"
      echo "   starting at LGN cell" {first_lgn} "and ending at LGN cell" {last_lgn}
   end

end

/* ******************************************************************
                       make_moving_spot
     Sets up a moving spot flash input by sequentially stimulating a   
     range of LGN neurons at a speed measured in lgn neurons/ms. The
     direction of movement depends on the sign of the speed. Use a 
     positive speed to cycle from lower number LGN neurons to higher
     number; Use negative speed to cycle from higher number to lower
     
     Parameters:

			start					first neuron to stimulate	
			end					last neuron to stimulate
			speed 				direction and movement of spot in lgn neurons/ms
        	src            	base name of spike source
        	target_group   	destination neurons for stimulation 
                           	are{target_group#}/soma
		   input_level    	injected current in amps
         flash_dur         flash duration in sec
        	tmax           	maximum time of simulation in sec
        	stim_delay			stimulus onset delay in sec
        
****************************************************************** */
function make_moving_spot (spot_speed, src, target_group, input_level, flash_dur, tmax, stim_delay) 
   int first_lgn, last_lgn
   float spot_speed
   str src, target_group
   float input_level, flash_dur, tmax, stim_delay

   create neutral /input3 

   int count, number
   float total_delay
	int startpos

	if (spot_speed > 0) 
		startpos = 1
	else
		startpos = {TOTAL_LGN_NEURONS}
	end 
   
   number = 0
   str pulse, target, name
   foreach name  ({el {target_group}#})
      count = count + 1
      name = {target_group}@{count}
      pulse = {src}@{count}
      target = {name}@"/soma" 
      create pulsegen {pulse}
      total_delay = {stim_delay} + (0.001*({count}-{startpos})/{spot_speed})
      setfield {pulse} level1 {input_level} baselevel 0 \
             width1 {flash_dur} delay1 {total_delay} delay2 {tmax}
      addmsg {pulse} {target} INJECT output
      setfield {target} initVm {LGN_EREST}
		number = number+1
   end

   if (ECHO_ON == 1)
      echo "Created" {number} {src} "pulse sources for" {target_group}
      echo "   Stimulus is a spot moving at" {spot_speed} "LGN cells/ms"
		if (startpos == 1)
			echo "   in a nasal-to-temporal direction"
		else
      	echo "   in a temporal-to-nasal direction"
		end 
   end

end

/* ******************************************************************
                       make_neuron_stim_rec
     Inject current into a rectangular area of neurons
     
     Parameters:

			x1,y1					lower left corner for stim area	
			x2,y2					upper right corner for stim area
        	src            	base name of spike source
        	target_group   	destination neurons for forcing  
                           	are{target_group#}/soma
		   input_level    	injected current in amps
		   target_erest		resting membrane potential of target
        	stim_dur          stimulus duration in sec
        	tmax           	maximum time of simulation in sec
        	stim_delay			stimulus onset delay in sec
        
******************************************************************  */ 
function make_neuron_stim_rec (x1, x2, y1, y2, src, target_group, input_level, target_erest, stim_dur, tmax, stim_delay) 
   float x1, x2, y1, y2
   str src, target_group
   float input_level, stim_dur, tmax, stim_delay

   create neutral /input4 
	float cell_x, cell_y, dist
   int count = 0
   int num_stim = 0
   str pulse, target, name
   
   foreach name  ({el {target_group}#})
      count = count + 1
      pulse = {src}@{count}
      cell_x = {getfield {name} x}
      cell_y = {getfield {name} y}
      if (cell_x >= {x1} && cell_x <= {x2} && cell_y >= {y1} && cell_y <= {y2})
      	target = {name}@"/soma" 
      	create pulsegen {pulse}
      	setfield {pulse} level1 {input_level} baselevel 0 \
             width1 {stim_dur} delay1 {stim_delay} delay2 {tmax}
      	addmsg {pulse} {target} INJECT output
      	setfield {target} initVm {target_erest}
//      	echo "Stimulating cell" {name} "at (" {cell_x} "," {cell_y} ")"    // uncomment for debugging
			num_stim = num_stim +1
      end
   end

   if (ECHO_ON == 1)
      echo "Created" {num_stim} {src} "pulse sources for" {target_group}
      echo "   Stimulating a rectangular area between (" {x1} "," {y1} ") and (" {x2} "," {y2} ")"
   end

end
/* ******************************************************************
                       make_neuron_stim_cir
     Inject current into a circle area of neurons
     
     Parameters:

			x1,y1					lower left corner for stim area	
			stim_rad				radius of stimulation in mm
        	src            	base name of spike source
        	target_group   	destination neurons for forcing  
                           	are{target_group#}/soma
		   input_level    	injected current in amps
		   target_erest		resting membrane potential of target
        	stim_dur          stimulus duration in sec
        	tmax           	maximum time of simulation in sec
        	stim_delay			stimulus onset delay in sec
        
******************************************************************  */ 
function make_neuron_stim_cir (x1, y1, stim_rad, src, target_group, input_level, target_erest, stim_dur, tmax, stim_delay) 
   float x1, y1, stim_rad
   str src, target_group
   float input_level, stim_dur, tmax, stim_delay

   create neutral /input5 
	float cell_x, cell_y, dist
   int count = 0
   int num_stim = 0
   str pulse, target, name
   float dist
   
   foreach name  ({el {target_group}#})
      count = count + 1
      pulse = {src}@{count}
      cell_x = {getfield {name} x}
      cell_y = {getfield {name} y}
      dist={sqrt  {(cell_x - {x1})**2 + (cell_y - {y1})**2}}
      if (dist <= {stim_rad})
      	target = {name}@"/soma" 
      	create pulsegen {pulse}
      	setfield {pulse} level1 {input_level} baselevel 0 \
             width1 {stim_dur} delay1 {stim_delay} delay2 {tmax}
      	addmsg {pulse} {target} INJECT output
      	setfield {target} initVm {target_erest}
 //     	echo "Stimulating cell" {name} "at (" {cell_x} "," {cell_y} ")"    // uncomment for debugging
			num_stim = num_stim +1
      end
   end

   if (ECHO_ON == 1)
      echo "Created" {num_stim} {src} "pulse sources for" {target_group}
      echo "   Stimulating a circular area at (" {x1} "," {y1} ") with radius" {stim_rad} "mm"
   end

end



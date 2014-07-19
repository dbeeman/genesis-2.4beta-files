// genesis
// by D. Jaeger 2-15-99

function makealphasyn (path, name, Gbar, Vrev, tau1, tau2)
str path
str name 
float Gbar
float Vref
float tau1
float tau2

// synaptic input to compartment tutorial using synchan object

if ( !{exists {path}} )
create neutral {path}
end

pushe {path}
create hebbsynchan {name}
setfield ^ gmax {Gbar} Ek {Vrev} tau1 {tau1} tau2 {tau2} change_weights 0 \
	pre_tau1 0.003 pre_tau2 0.02 post_tau 0.01 \
	pre_thresh_lo 0.1 pre_thresh_hi 0.4 post_thresh_lo -0.065 post_thresh_hi -0.06 \
	post_scale 0.01 weight_change_rate 10 \
	min_weight 0.1 max_weight 2

addmsg {name} soma CHANNEL Gk Ek
addmsg soma {name} VOLTAGE Vm

pope // back to where we started
end // end function

function makespike (path)
str path

pushe {path}

// create spike detector
create spikegen spike
setfield ^ thresh 0.0 abs_refract 0.002 output_amp 1.0
addmsg soma spike INPUT Vm

pope // back to where we started

end

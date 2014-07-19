// genesis 2.2
// Kerstin Menne
// Luebeck, 02.10.2001
// establish synatpic connections 

//==================================================================
// connections
//==================================================================

// recurrent excitation from pyramidal cells to pyramidal cells
// AMPA channels

randseed 12345
volumeconnect {pyr_array_name}{pyr_cell_name}[]/ax/pyr_spikegen \
	      {pyr_array_name}{pyr_cell_name}[]/bas2_#/AMPA,{pyr_array_name}{pyr_cell_name}[]/ap8_#/AMPA,{pyr_array_name}{pyr_cell_name}[]/ap9_#/AMPA,{pyr_array_name}{pyr_cell_name}[]/ap10_#/AMPA \
	      -relative \
	      -sourcemask box -1 -1 -1 1 1 1 \ // all pyramidal cells 
	      -destmask box \
		{pyr2pyr_x1} {pyr2pyr_y1} {pyr2pyr_z1} \
		{pyr2pyr_x2} {pyr2pyr_y2} {pyr2pyr_z2} \
	      -probability {p_pyr2pyr_AMPA}

// NMDA channels

randseed 12345 // ensures that AMPA and NMDA channels occur paired
volumeconnect {pyr_array_name}{pyr_cell_name}[]/ax/pyr_spikegen \
	      {pyr_array_name}{pyr_cell_name}[]/ap8_#/NMDA,{pyr_array_name}{pyr_cell_name}[]/ap9_#/NMDA,{pyr_array_name}{pyr_cell_name}[]/ap10_#/NMDA \
	      -relative \
	      -sourcemask box -1 -1 -1 1 1 1 \ // all pyramidal cells 
	      -destmask box \
		{pyr2pyr_x1} {pyr2pyr_y1} {pyr2pyr_z1} \
		{pyr2pyr_x2} {pyr2pyr_y2} {pyr2pyr_z2} \
	      -probability {p_pyr2pyr_NMDA}

// excitation from pyramidal cells to fb interneurons
volumeconnect {pyr_array_name}{pyr_cell_name}[]/ax/pyr_spikegen \
	      {fb_array_name}{fb_cell_name}[]/bas1_#/AMPA,{fb_array_name}{fb_cell_name}[]/bas2_#/AMPA,{fb_array_name}{fb_cell_name}[]/ap6_#/AMPA,{fb_array_name}{fb_cell_name}[]/ap7_#/AMPA,{fb_array_name}{fb_cell_name}[]/ap8_#/AMPA \
	      -relative \
	      -sourcemask box -1 -1 -1 1 1 1 \ // all pyramidal cells 
	      -destmask box \
		{pyr2fb_x1} {pyr2fb_y1} {pyr2fb_z1} \
		{pyr2fb_x2} {pyr2fb_y2} {pyr2fb_z2} \
	      -probability {p_pyr2fb_AMPA}	

// feedback inhibition from fb interneurons to pyramidal cells

volumeconnect {fb_array_name}{fb_cell_name}[]/ax/spikegen \
	      {pyr_array_name}{pyr_cell_name}[]/bas3_#/GABA_A,{pyr_array_name}{pyr_cell_name}[]/soma/GABA_A,{pyr_array_name}{pyr_cell_name}[]/ap5_#/GABA_A \
	      -relative \
	      -sourcemask box -1 -1 -1 1 1 1 \ // all pyramidal cells 
	      -destmask ellipsoid \
		{fb2pyr_x1} {fb2pyr_y1} {fb2pyr_z1} \
		{fb2pyr_x2} {fb2pyr_y2} {fb2pyr_z2} \
	      -probability {p_fb2pyr_GABA_A}

// feedforward inhibition from ff interneurons to pyramidal cells

volumeconnect {ff_array_name}{ff_cell_name}[]/ax/spikegen \
	      {pyr_array_name}{pyr_cell_name}[]/bas1_#/GABA_B,{pyr_array_name}{pyr_cell_name}[]/ap9_#/GABA_B,{pyr_array_name}{pyr_cell_name}[]/ap10_#/GABA_B \
	      -relative \
	      -sourcemask box -1 -1 -1 1 1 1 \ // all pyramidal cells 
	      -destmask ellipsoid \
		{ff2pyr_x1} {ff2pyr_y1} {ff2pyr_z1} \
		{ff2pyr_x2} {ff2pyr_y2} {ff2pyr_z2} \
	      -probability {p_ff2pyr_GABA_B}

//====================================================
// delays
//====================================================

// delay for excitation from pyramidal cells
volumedelay {pyr_array_name}{pyr_cell_name}[]/ax/pyr_spikegen \
		-radial {cond_vel_pyr_ax} \
	        -uniform {rand_delay_pyr_ax}

// delay for inhibition from fb interneurons
volumedelay {fb_array_name}{fb_cell_name}[]/ax/spikegen \
		-radial {cond_vel_fb_ax} \
	        -uniform {rand_delay_fb_ax}


// delay for inhibition from ff interneurons
volumedelay {ff_array_name}{ff_cell_name}[]/ax/spikegen \
		-radial {cond_vel_ff_ax} \
	        -uniform {rand_delay_ff_ax}


//===============================================
// synaptic weights
//===============================================

// for synapses with pyramidal cells on presynaptic site
volumeweight {pyr_array_name}{pyr_cell_name}[]/ax/pyr_spikegen \
	-fixed {from_pyr_weight} \
	-uniform {rand_from_pyr_weight}

// for synapses with fb interneurons on presynaptic site
volumeweight {fb_array_name}{fb_cell_name}[]/ax/spikegen \
	-fixed {from_fb_weight} \
	-uniform {rand_from_fb_weight}


// for synapses with ff interneurons on presynaptic site
volumeweight {ff_array_name}{ff_cell_name}[]/ax/spikegen \
	-fixed {from_ff_weight} \
	-uniform {rand_from_ff_weight} 


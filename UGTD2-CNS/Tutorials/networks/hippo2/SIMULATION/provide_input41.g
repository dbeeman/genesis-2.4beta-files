// genesis 2.2
// Kerstin Menne
// Luebeck, 17.10.2001      
// build randomspike elements and connect them to network cells

// create prototype randomspike element
make_afferent_1 // afferent_input.g
make_afferent_2 // afferent_input.g

// create array of randomspike elements
// network.g: create_array(array_name,cell_name,nx,ny,dx,dy,origin_x,origin_y)
create_array {aff_input_array_name_1} {aff_input_name_1} {aff_nx} {aff_ny} \
	     	 {aff_dx} {aff_dy} {aff_origin_x_1} {aff_origin_y_1}

disable {aff_input_name_1}

// randomize positions and firing rate
// network.g: randomize_afferents(array_name,cell_name,inumber_cells)
randomize_afferents {aff_input_array_name_1} {aff_input_name_1} {n_of_aff}

// create array of randomspike elements
// network.g: create_array(array_name,cell_name,nx,ny,dx,dy,origin_x,origin_y)
create_array {aff_input_array_name_2} {aff_input_name_2} {aff_nx} {aff_ny} \
	     	 {aff_dx} {aff_dy} {aff_origin_x_2} {aff_origin_y_2}

disable {aff_input_name_2}

// randomize positions and firing rate
// network.g: randomize_afferents(array_name,cell_name,inumber_cells)
randomize_afferents {aff_input_array_name_2} {aff_input_name_2} {n_of_aff}

//==================================================================
// connections
//==================================================================




// excitations from afferents to pyramidal cells
// AMPA channels
randseed 54321
volumeconnect {aff_input_array_name_1}{aff_input_name_1}[] \
	      {pyr_array_name}{pyr_cell_name}[0-35]/bas3_#/AMPA,{pyr_array_name}{pyr_cell_name}[0-35]/ap5_#/AMPA,{pyr_array_name}{pyr_cell_name}[0-35]/ap6_#/AMPA \
 	      -relative \
	      -sourcemask box -1 -1 -1 1 1 1 \ // all afferents 
	      -destmask box \
		{aff2pyr_x1} {aff2pyr_y1} {aff2pyr_z1} \
		{aff2pyr_x2} {aff2pyr_y2} {aff2pyr_z2} \
	      -probability {p_aff2pyr_AMPA}

// NMDA channels

randseed 54321 // using of the same seed ensures, that AMPA and NMDA channels
	       // of the same compartments are selected
volumeconnect {aff_input_array_name_1}{aff_input_name_1}[] \
	      {pyr_array_name}{pyr_cell_name}[0-35]/bas3_#/NMDA,{pyr_array_name}{pyr_cell_name}[0-35]/ap5_#/NMDA,{pyr_array_name}{pyr_cell_name}[0-35]/ap6_#/NMDA \
 	      -relative \
	      -sourcemask box -1 -1 -1 1 1 1 \ // all afferents 
	      -destmask box \
		{aff2pyr_x1} {aff2pyr_y1} {aff2pyr_z1} \
		{aff2pyr_x2} {aff2pyr_y2} {aff2pyr_z2} \
	      -probability {p_aff2pyr_NMDA}


randseed 12345
volumeconnect {aff_input_array_name_2}{aff_input_name_2}[] \
	      {pyr_array_name}{pyr_cell_name}[36-71]/bas3_#/AMPA,{pyr_array_name}{pyr_cell_name}[36-71]/ap5_#/AMPA,{pyr_array_name}{pyr_cell_name}[36-71]/ap6_#/AMPA  \
 	      -relative \
	      -sourcemask box -1 -1 -1 1 1 1 \ // all afferents 
	      -destmask box \
		{aff2pyr_x1} {aff2pyr_y1} {aff2pyr_z1} \
		{aff2pyr_x2} {aff2pyr_y2} {aff2pyr_z2} \
	      -probability {p_aff2pyr_AMPA}


// NMDA channels

randseed 12345 // using of the same seed ensures, that AMPA and NMDA channels
	       // of the same compartments are selected
volumeconnect {aff_input_array_name_2}{aff_input_name_2}[] \
	      {pyr_array_name}{pyr_cell_name}[36-71]/bas3_#/NMDA,{pyr_array_name}{pyr_cell_name}[36-71]/ap5_#/NMDA,{pyr_array_name}{pyr_cell_name}[36-71]/ap6_#/NMDA \
 	      -relative \
	      -sourcemask box -1 -1 -1 1 1 1 \ // all afferents 
	      -destmask box \
		{aff2pyr_x1} {aff2pyr_y1} {aff2pyr_z1} \
		{aff2pyr_x2} {aff2pyr_y2} {aff2pyr_z2} \
	      -probability {p_aff2pyr_NMDA}


// excitation from afferents to ff interneurons
volumeconnect {aff_input_array_name_1}{aff_input_name_1}[] \
	      {ff_array_name}{ff_cell_name}[]/ap6_#/AMPA,{ff_array_name}{ff_cell_name}[]/ap7/AMPA,{ff_array_name}{ff_cell_name}[]/ap8_#/AMPA \
 	      -relative \
	      -sourcemask box -1 -1 -1 1 1 1 \ // all afferents 
	      -destmask box \
		{aff2ff_x1} {aff2ff_y1} {aff2ff_z1} \
		{aff2ff_x2} {aff2ff_y2} {aff2ff_z2} \
	      -probability {p_aff2ff_AMPA}

// delay for excitation from afferents
volumedelay {aff_input_array_name_1}{aff_input_name_1}[] \
		-radial {cond_vel_aff_ax} \
	        -uniform {rand_delay_aff_ax}

volumedelay {aff_input_array_name_2}{aff_input_name_2}[] \
		-radial {cond_vel_aff_ax} \
	        -uniform {rand_delay_aff_ax}

// synaptic weights for synapses with afferents on presynaptic site
volumeweight {aff_input_array_name_1}{aff_input_name_1}[] \
	-fixed {from_aff_weight} \
	-uniform {rand_from_aff_weight}

volumeweight {aff_input_array_name_2}{aff_input_name_2}[] \
	-fixed {from_aff_weight} \
	-uniform {rand_from_aff_weight}




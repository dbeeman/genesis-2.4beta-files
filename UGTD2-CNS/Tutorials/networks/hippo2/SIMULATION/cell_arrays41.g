// genesis 2.2
// Kerstin Menne
// Luebeck, 01.10.2001
// creation of prototypes, cells and cell arrays

// Make cell prototypes 
make_pyramidal // make_pyramidal.g
make_interneuron // make_interneuron.g

// Build the cells from parameter files using the cell reader and prototype
// elements
readcell fbsyn41.p {fb_cell_name} // fb inhibitory interneuron
readcell ffsyn.p {ff_cell_name} // ff inhibitory interneuron
readcell CA3_chan041.p {pyr_cell_name} // CA3 pyramidal cells

// did not find a better way to provide Mg_blocks with needed information:
int i
addmsg {pyr_cell_name}/ap5/NMDA/Mg_BLOCK {pyr_cell_name}/ap5 CHANNEL Gk Ek
addmsg {pyr_cell_name}/ap5 {pyr_cell_name}/ap5/NMDA/Mg_BLOCK VOLTAGE Vm
deletemsg {pyr_cell_name}/ap5 0 -incoming -find {pyr_cell_name}/ap5/NMDA CHANNEL

addmsg {pyr_cell_name}/ap6_1/NMDA/Mg_BLOCK {pyr_cell_name}/ap6_1 CHANNEL Gk Ek
addmsg {pyr_cell_name}/ap6_1 {pyr_cell_name}/ap6_1/NMDA/Mg_BLOCK VOLTAGE Vm
deletemsg {pyr_cell_name}/ap6_1 0 -incoming -find {pyr_cell_name}/ap6_1/NMDA CHANNEL

addmsg {pyr_cell_name}/ap6_2/NMDA/Mg_BLOCK {pyr_cell_name}/ap6_2 CHANNEL Gk Ek
addmsg {pyr_cell_name}/ap6_2 {pyr_cell_name}/ap6_2/NMDA/Mg_BLOCK VOLTAGE Vm
deletemsg {pyr_cell_name}/ap6_2 0 -incoming -find {pyr_cell_name}/ap6_2/NMDA CHANNEL

for (i=1;i<=4;i=i+1)
	addmsg {pyr_cell_name}/ap8_{i}/NMDA/Mg_BLOCK {pyr_cell_name}/ap8_{i} CHANNEL Gk Ek
	addmsg {pyr_cell_name}/ap8_{i} {pyr_cell_name}/ap8_{i}/NMDA/Mg_BLOCK VOLTAGE Vm
	deletemsg {pyr_cell_name}/ap8_{i} 0 -incoming -find {pyr_cell_name}/ap8_{i}/NMDA CHANNEL
end

for (i=1;i<=8;i=i+1)
	addmsg {pyr_cell_name}/ap9_{i}/NMDA/Mg_BLOCK {pyr_cell_name}/ap9_{i} CHANNEL Gk Ek
	addmsg {pyr_cell_name}/ap9_{i} {pyr_cell_name}/ap9_{i}/NMDA/Mg_BLOCK VOLTAGE Vm
	deletemsg {pyr_cell_name}/ap9_{i} 0 -incoming -find {pyr_cell_name}/ap9_{i}/NMDA CHANNEL
end

for (i=1;i<=8;i=i+1)
	addmsg {pyr_cell_name}/ap10_{i}/NMDA/Mg_BLOCK {pyr_cell_name}/ap10_{i} CHANNEL Gk Ek
	addmsg {pyr_cell_name}/ap10_{i} {pyr_cell_name}/ap10_{i}/NMDA/Mg_BLOCK VOLTAGE Vm
	deletemsg {pyr_cell_name}/ap10_{i} 0 -incoming -find {pyr_cell_name}/ap10_{i}/NMDA CHANNEL
end

for (i=1;i<=4;i=i+1)
	addmsg {pyr_cell_name}/bas3_{i}/NMDA/Mg_BLOCK {pyr_cell_name}/bas3_{i} CHANNEL Gk Ek
	addmsg {pyr_cell_name}/bas3_{i} {pyr_cell_name}/bas3_{i}/NMDA/Mg_BLOCK VOLTAGE Vm
	deletemsg {pyr_cell_name}/bas3_{i} 0 -incoming -find {pyr_cell_name}/bas3_{i}/NMDA CHANNEL
end

// Holding currents for interneurons
//setfield {ff_cell_name}/soma inject {ff_hold_cur}
//setfield {fb_cell_name}/soma inject {fb_hold_cur}
//setfield {pyr_cell_name}/soma inject {pyr_hold_cur}

setfield {ff_cell_name}/soma inject 0
setfield {fb_cell_name}/soma inject 0
setfield {pyr_cell_name}/soma inject 0
//setfield {pyr_cell_name2}/soma inject 0

// Build arrays of cells 
// network.g: create_array(array_name,cell_name,nx,ny,dx,dy,origin_x,origin_y) 
create_array {pyr_array_name} {pyr_cell_name} {pyr_nx} {pyr_ny} {pyr_dx} \
		 {pyr_dy} {pyr_origin_x} {pyr_origin_y}
create_array {fb_array_name} {fb_cell_name} {fb_nx} {fb_ny} {fb_dx} {fb_dy} \
		 {fb_origin_x} {fb_origin_y}
create_array {ff_array_name} {ff_cell_name} {ff_nx} {ff_ny} {ff_dx} {ff_dy} \
		 {ff_origin_x} {ff_origin_y}

disable {pyr_cell_name}
disable {fb_cell_name}
disable {ff_cell_name}
disable library

// Randomize positions in the arrays and rotate the cells
// network.g: randomize(array_name,cell_name,inumber_cells)
randomize {pyr_array_name} {pyr_cell_name} {n_of_pyr}
randomize {fb_array_name} {fb_cell_name} {n_of_fb}
randomize {ff_array_name} {ff_cell_name} {n_of_ff}








// genesis 2.2
// Kerstin Menne
// Medical University of Luebeck, 01.10.2001
//
// function to assign hsolve element to each neuron of the network

function make_hsolves(array_name,cell_name,n_of_cells)
	str array_name  // array where cells shall be assigned hsolve elements
	str cell_name // neurons that shall be taken over by hsolve
	int n_of_cells // number of cells in array
	int i

	// create prototype hsolve element
	create hsolve {array_name}{cell_name}[0]/solve
	setfield {array_name}{cell_name}[0]/solve path \
		{array_name}{cell_name}[0]/##[][TYPE=compartment] \
	 	chanmode {chanmode} \
		computeIm 1
	// SETUP action has to be called before DUPLICATE action
	call {array_name}{cell_name}[0]/solve SETUP
	// make a copy of the hsolve element for each cell in the cell-array
	for (i = 1; i < n_of_cells ; i=i+1)
		call {array_name}{cell_name}[0]/solve DUPLICATE \
		  {array_name}{cell_name}[{i}]/solve \
		  {array_name}{cell_name}[{i}]/##[][TYPE=compartment]
	end
end

// apply the function for each cell_array
make_hsolves {pyr_array_name} {pyr_cell_name} {n_of_pyr}
make_hsolves {fb_array_name} {fb_cell_name} {n_of_fb}
make_hsolves {ff_array_name} {ff_cell_name} {n_of_ff}

	
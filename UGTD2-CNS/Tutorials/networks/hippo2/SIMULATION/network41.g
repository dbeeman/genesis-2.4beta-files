// genesis 2.2
// Kerstin Menne
// Luebeck, 02.10.2001
// functions for the construction of arrays of cells including randomizatons;
// pattern of connectivity implemented in connections.g

// creation of two dimensional array
function create_array(array_name,cell_name,nx,ny,dx,dy,origin_x,origin_y)
	str array_name
	str cell_name // cell that has to be copied and arranged in network
	int nx, ny // number of cells in x- and y-dimension, respectively
	float dx, dy // distance between neighbouring cells in x and y
	float origin_x, origin_y // x- and y-coordinate of first cell (numbered
				 // 0) in array

	if (!({exists {array_name}}))
		create neutral {array_name}
	end
	createmap {cell_name} {array_name} {nx} {ny} -delta {dx} {dy} \
		-origin {origin_x} {origin_y}
end

// implement rotations of individual cells, randomization of cell-positions in
// array and randomizaton of resting potential to make data less monoton
function randomize(array_name,cell_name,inumber_cells)
	str array_name, cell_name
	int inumber_cells // number of cells in respective array
	str comp // help variables
	float iinitvm
	int i

	// randomize positions of cells in cell array and rotate them
	for (i = 0; i <inumber_cells; i = i + 1)
       		pushe {array_name}{cell_name}[{i}]
		// new position can differ upto 5 microns compared to
		// original position in each dimension
		// changed to 3 microns for x and y

       		position . {{getfield . x} + {rand -3e-6 3e-6}} \
                  {{getfield . y} + {rand -3e-6 3e-6}} \
                  {{getfield . z} + {rand -50e-6 50e-6}}

		// rotation around z-axis 
       		rotcoord . {rand 0 3.141592} -z \
                  -center {getfield . x} {getfield . y} {getfield . z}

		// randomization of resting potentials
		iinitvm = {rand -0.065 -0.060}
          foreach comp ({el  {array_name}{cell_name}[{i}]/#[TYPE=compartment]})
          	  setfield {comp}  initVm {iinitvm} Vm  {iinitvm}  Em {iinitvm}
          end //foreach
		pope
       end //for
end

// randomizations for afferent inputs: randomization of positions and 
// rates; since the afferent input layer is supposed to be above the
// network of pyramidal cells and interneurons, 100e-6 are added to the 
// z-component
function randomize_afferents(array_name,cell_name,inumber_cells)
	str array_name, cell_name
	int inumber_cells // number of randomspike-elements
	int i
	int new_rate

	// randomize positions 
	for (i = 0; i <inumber_cells; i = i + 1)
       		pushe {array_name}{cell_name}[{i}]
		// new position can differ upto 30microns compared to
		// original position in each dimension
		// changed to 5 microns
       		position . {{getfield . x} + {rand -5e-6 5e-6}} \
                  {{getfield . y} + {rand -5e-6 5e-6}} \
                  {{getfield . z} + 100e-6 + {rand -10e-6 10e-6}}

		// rate +/- upto 20 events
		// changed to +/- 5 events
	        new_rate = {{getfield . rate} + \
				  {rand -5 5}}
		setfield . rate {new_rate}
		pope
	end		
end

// genesis 2.2
// Kerstin Menne
// Luebeck, 24.10.2001

/*====================================
functions to create recording sites
====================================*/

// create single efield object
function place_recsite(recording_site_name, x, y, z, scale)
        str recording_site_name 
        float x, y, z // positions of recording_site
	float scale // scale factor for efield object
       
        create efield {recording_site_name}
        setfield ^ scale {scale} x {x} y {y} z {z}

        // call {recording_site_name} RECALC // calculate distances
	// input_for_electrodes does it now
end

// create one multisite-electrode
function electrode(electrode_name,recording_site,x,y,zmin,zmax,dz,scale)
	str electrode_name, recording_site 
 	float scale, x, y
	float zmin, zmax, dz // recording sites from zmin to zmax with distance
			     // dz (parallel to neurons)
        float i // help variables
        int count = 0

	if (!({exists {electrode_name}}))
         	create neutral {electrode_name}
        end
	// different recordings sites of electrode "electrode_name" 
	// are installed and 
	// named {electrode_name}{recording_site}[{count}]
	for (i=zmin; i<=zmax; i=i+dz)
        	place_recsite {electrode_name}{recording_site}[{count}] \
				{x} {y} {i} {scale} 
                count = count +1
        end
end



// =================================================================
// functions for the investigation of different regions of interest
// not very elegant, since "hard coded"
//====================================================================

function electrode_180(electrode_name,recsite_name)
	str electrode_name
	str recsite_name

	pushe {electrode_name}

	addmsg {pyr_array_name}{pyr_cell_name}[0-4]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[6-10]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0
	
	addmsg {pyr_array_name}{pyr_cell_name}[12-16]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[18-22]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[24-28]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[30-34]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[36-40]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[42-46]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[48-52]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[54-58]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[60-64]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[66-70]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {ff_array_name}{ff_cell_name}[0-4]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {ff_array_name}{ff_cell_name}[6-8]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {fb_array_name}{fb_cell_name}[0-1]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {fb_array_name}{fb_cell_name}[3-8]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	
	call {electrode_name}{recsite_name}[] RECALC // calculate
	//distances to
	//compartments that deliver input
	//call {electrode_name}{recsite_name}[1] RECALC
	//call {electrode_name}{recsite_name}[2] RECALC
	//call {electrode_name}{recsite_name}[3] RECALC
	//call {electrode_name}{recsite_name}[4] RECALC
	//call {electrode_name}{recsite_name}[5] RECALC
	//call {electrode_name}{recsite_name}[6] RECALC
	//call {electrode_name}{recsite_name}[7] RECALC
	//call {electrode_name}{recsite_name}[8] RECALC
	//call {electrode_name}{recsite_name}[9] RECALC
	//call {electrode_name}{recsite_name}[10] RECALC
	//call {electrode_name}{recsite_name}[11] RECALC
	//call {electrode_name}{recsite_name}[12] RECALC


	pope 	
		
end


function electrode_120soma(electrode_name,recsite_name)
	// recording from somas only
	str electrode_name
	str recsite_name

	pushe {electrode_name}
       	
	addmsg {pyr_array_name}{pyr_cell_name}[0-2]/soma \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[6-9]/soma \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0
	
	addmsg {pyr_array_name}{pyr_cell_name}[12-15]/soma \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[18-21]/soma \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[24-28]/soma \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[30-34]/soma \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[36-40]/soma \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[42-46]/soma \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[48-51]/soma \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[54-57]/soma \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[60-63]/soma \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[66-69]/soma \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {ff_array_name}{ff_cell_name}[0-1]/soma \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {ff_array_name}{ff_cell_name}[3-4]/soma \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {ff_array_name}{ff_cell_name}[6-7]/soma \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {fb_array_name}{fb_cell_name}[0-1]/soma \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {fb_array_name}{fb_cell_name}[3-4]/soma \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {fb_array_name}{fb_cell_name}[6-7]/soma \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	call {electrode_name}{recsite_name}[] RECALC // calculate distances to                                              //compartments that deliver input
	//call {electrode_name}{recsite_name}[1] RECALC
	//call {electrode_name}{recsite_name}[2] RECALC
	//call {electrode_name}{recsite_name}[3] RECALC
	//call {electrode_name}{recsite_name}[4] RECALC
	//call {electrode_name}{recsite_name}[5] RECALC
	//call {electrode_name}{recsite_name}[6] RECALC
	//call {electrode_name}{recsite_name}[7] RECALC
	//call {electrode_name}{recsite_name}[8] RECALC
	//call {electrode_name}{recsite_name}[9] RECALC
	//call {electrode_name}{recsite_name}[10] RECALC
	//call {electrode_name}{recsite_name}[11] RECALC
	//call {electrode_name}{recsite_name}[12] RECALC
	
	pope 	
end

function electrode_120(electrode_name,recsite_name)
	str electrode_name
	str recsite_name

	pushe {electrode_name}
       
	addmsg {pyr_array_name}{pyr_cell_name}[0-2]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[6-9]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0
	
	addmsg {pyr_array_name}{pyr_cell_name}[12-15]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[18-21]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[24-28]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[30-34]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[36-40]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[42-46]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[48-51]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[54-57]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[60-63]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[66-69]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {ff_array_name}{ff_cell_name}[0-1]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {ff_array_name}{ff_cell_name}[3-4]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {ff_array_name}{ff_cell_name}[6-7]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {fb_array_name}{fb_cell_name}[0-1]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {fb_array_name}{fb_cell_name}[3-4]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {fb_array_name}{fb_cell_name}[6-7]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	call {electrode_name}{recsite_name}[] RECALC // calculate distances to                                              //compartments that deliver input
	//call {electrode_name}{recsite_name}[1] RECALC
	//call {electrode_name}{recsite_name}[2] RECALC
	//call {electrode_name}{recsite_name}[3] RECALC
	//call {electrode_name}{recsite_name}[4] RECALC
	//call {electrode_name}{recsite_name}[5] RECALC
	//call {electrode_name}{recsite_name}[6] RECALC
	//call {electrode_name}{recsite_name}[7] RECALC
	//call {electrode_name}{recsite_name}[8] RECALC
	//call {electrode_name}{recsite_name}[9] RECALC
	//call {electrode_name}{recsite_name}[10] RECALC
	//call {electrode_name}{recsite_name}[11] RECALC
	//call {electrode_name}{recsite_name}[12] RECALC
	
	pope 	
end


function electrode_90(electrode_name,recsite_name)
	str electrode_name
	str recsite_name

	pushe {electrode_name}
       	
	addmsg {pyr_array_name}{pyr_cell_name}[0-2]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[6-8]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[12-15]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[18-21]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[24-27]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[30-33]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[36-40]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[42-45]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[48-51]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[54-56]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[60-62]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {pyr_array_name}{pyr_cell_name}[66-68]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {ff_array_name}{ff_cell_name}[0-1]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {ff_array_name}{ff_cell_name}[3-4]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {ff_array_name}{ff_cell_name}[6-7]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {fb_array_name}{fb_cell_name}[0-1]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {fb_array_name}{fb_cell_name}[3-4]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	addmsg {fb_array_name}{fb_cell_name}[6-7]/#[TYPE=compartment] \
	{electrode_name}{recsite_name}[] CURRENT Im 0.0

	call {electrode_name}{recsite_name}[] RECALC // calculate
	//distances to
	//compartments that deliver input
	//call {electrode_name}{recsite_name}[1] RECALC
	//call {electrode_name}{recsite_name}[2] RECALC
	//call {electrode_name}{recsite_name}[3] RECALC
	//call {electrode_name}{recsite_name}[4] RECALC
	//call {electrode_name}{recsite_name}[5] RECALC
	
	pope 	
end

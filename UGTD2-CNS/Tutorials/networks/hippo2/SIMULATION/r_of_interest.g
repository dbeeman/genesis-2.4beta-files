// genesis 2.2
// Kerstin Menne
// Luebeck, 11.10.2001
// creation of electrodes for the measurement of extracellular field potentials
// connections from interesting compartments to the electrodes

// create one multisite electrode
// the "electrode" can have arbitrary number of recording sites, depending
// on zmin, zmax and dz; 
// electrodes.g: electrode(electrode_name,recording_site,x,y,zmin,zmax,dz,scale)
electrode /e180 {e_recsite1} 43e-6 57e-6 \
	{e_z1_min} {e_z1_max} {e_dz1} {e_scale1}
electrode /e120 {e_recsite1} 43e-6 57e-6 \
		{e_z1_min} {e_z1_max} {e_dz1} {e_scale1}
electrode /e120soma {e_recsite1} 43e-6 57e-6 \
		{e_z1_min} {e_z1_max} {e_dz1} {e_scale1}
electrode /e90  {e_recsite1} 43e-6 57e-6 \
		{e_z1_min} {e_z1_max} {e_dz1} {e_scale1}


electrode_180 /e180 {e_recsite1} // electrodes.g
// record from an opening angle of 180°
electrode_120 /e120 {e_recsite1} // electrodes.g
// record from an opening anlge of 120°
electrode_120soma /e120soma {e_recsite1} // electrodes.g
// take only somatic transmembrane currents into account
electrode_90 /e90 {e_recsite1} // electrodes.g
// record from an opening angle of 90°


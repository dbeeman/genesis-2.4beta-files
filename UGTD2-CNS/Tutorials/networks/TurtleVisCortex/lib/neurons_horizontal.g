//======== CREATE POPULATION OF HORIZONTAL NEURONS FOR NGU MODEL======//
// This file contains functions to create a population of horizontal  //
// inhibitory neurons for the NGU model.                              //
//                                                                    //
// Setup:                                                             //
// 1. Specify the neurons by creating a text file of x y z            //
//    coordinates for the neurons, one neuron per line.               //
// 2. Call make_horizontal_cells                                      //
//                                                                    //
//====================================================================//
include ../lib/global_constants.g
include ../lib/utilities_build.g
include ../lib/channels.g


//=========== HORIZONTAL NEURON PARAMETER DEFINITIONS ================//
float HOR_RM = 1/0.029 * 1e3 * 1e-4 //specific membrane RESISTANCE (ohms m^2)
float HOR_CM = 1.6 * 1e-6/1e-4 //specific membrane CAPACITANNCE (farads/m^2)
float HOR_RA = 100.00 * 1e-2 //specific AXIAL resistance (ohms m)
float HOR_ELEAK = -75.0 * 1e-3 //membrane LEAKAGE potential (volts)
float HOR_ENa = 40.00 * 1e-3 //SODIUM reversal potential (volts)
float HOR_GNa = 9500.00 * 1e-3/1e-4 //maximum SODIUM conductance (S/m^2)
float HOR_EK = -90.00 * 1e-3 //POTASSIUM reversal potential (volts)
float HOR_GK = 300.00 * 1e-3/1e-4 //maximum POTASSIUM conductance (S/m^2)
float HOR_SF = 1.0 * PI   //membrane SCALE factor (dimensionless)

// compartment dimensions diameter(_D), length (_L) in meters
float HOR_SOMA_D = 25.0 * 1e-6
float HOR_DEND2_D = 10.0 * 1e-6,  HOR_DEND2_L = 300.00 * 1e-6
float HOR_DEND3_D = 10.0 * 1e-6,  HOR_DEND3_L = 300.00 * 1e-6

// effective compartment surface areas (_A) in m^2
float HOR_SOMA_A = (HOR_SOMA_D * HOR_SOMA_D - \
 0.25 * (HOR_DEND2_D * HOR_DEND2_D + HOR_DEND3_D * HOR_DEND3_D)) * HOR_SF
float HOR_DEND2_A = HOR_DEND2_D * (0.25 * HOR_DEND2_D + HOR_DEND2_L) * HOR_SF
float HOR_DEND3_A = HOR_DEND3_D * (0.25 * HOR_DEND3_D + HOR_DEND3_L) * HOR_SF

// soma spike parameters
float HOR_SPIKE_THRESH = -0.02
float HOR_SPIKE_REFRACT = 0.01
float HOR_SPIKE_AMP = 1


/* ******************************************************************
                       make_soma_horizontal
     Creates a spherical soma compartment containing sodium and 
     potassium channels
     
     Parameters:
        path           name of the soma object to be created
        dia            diameter of spherical compartment
        area           effective surface area
****************************************************************** */  
function make_soma_horizontal(path, dia, area)
   str path
   float dia, area

   make_sphere_compartment {path} {dia} {area} \
         {HOR_ELEAK} {HOR_RM} {HOR_CM} {HOR_RA}
   make_sodium_channel {path} {HOR_GNa} {HOR_ENa} {area}  //  sodium channel
   make_potassium_channel {path} {HOR_GK} {HOR_EK} {area}  // potassium channel
end


/* ******************************************************************
                       make_dendrite_horizontal
     Creates a dendrite for a horizontal cell consisting of a single
     cylindrical compartment
     
     Parameters:
        path           name of the dendrite object
        len            length of the dendrite
        dia            diameter of the dendrite
        area           effective membrane area
        
****************************************************************** */  
function make_dendrite_horizontal(path, len, dia, area)
   str path
   float len, dia, area

   make_cylind_compartment {path} {len} {dia} {area} \
         {HOR_ELEAK} {HOR_RM} {HOR_CM} {HOR_RA}
end


/* ******************************************************************
                       make_cell_horizontal
     Creates a horizontal cell consisting of a soma and 2 dendrites
     
     Parameters:
        parent           name of the horizontal cell to be created
        
****************************************************************** */  
function make_cell_horizontal(parent)
   str parent

   make_soma_horizontal {parent}/soma {HOR_SOMA_D} {HOR_SOMA_A}
   make_dendrite_horizontal {parent}/dend2 \
         {HOR_DEND2_L} {HOR_DEND2_D} {HOR_DEND2_A}
   make_dendrite_horizontal {parent}/dend3 \
         {HOR_DEND3_L} {HOR_DEND3_D} {HOR_DEND3_A}

   float d2, d3, s
   d2 = {getfield {parent}/dend2 Ra}
   d3 = {getfield {parent}/dend3 Ra}
   s = {getfield {parent}/soma Ra}

   setfield {parent}/dend3 Ra {0.5*(s + d3)}
   setfield {parent}/soma Ra {0.5*(s + d2)}

   connect_compartments {parent}/dend2 {parent}/soma
   connect_compartments {parent}/soma {parent}/dend3

   make_spike {parent}/soma \
      {HOR_SPIKE_THRESH} {HOR_SPIKE_REFRACT} {HOR_SPIKE_AMP}
end


/* ******************************************************************
                       make_horizontal_cells
     Creates a population of horizontal cells with names of the form
     {root}/cell#. 
     
     Parameters:
        coord_file     name of text file containing neuron positions 
        root           parent of all horizontal neurons
     
****************************************************************** */  
function make_horizontal_cells(coord_file, root)
   str coord_file, root

   create neutral {root}
   str parent = {root}@"/cell"
   read_coords {coord_file} {parent}

   str name
   foreach name  ({el {parent}#})
      make_cell_horizontal {name}
   end
end


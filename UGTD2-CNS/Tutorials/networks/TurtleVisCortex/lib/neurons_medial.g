//========= CREATE POPULATION OF MEDIAL NEURONS FOR NGU MODEL ========//
// This file contains functions to create a population of medial      //
// pyramidal neurons for the NGU model.                               //
//                                                                    //
// Setup:                                                             //
// 1. Specify the neurons by creating a text file of x y z            //
//    coordinates for the neurons, one neuron per line.               //
// 2. Call make_medial_cells                                          //
//                                                                    //
//====================================================================//
include ../lib/global_constants.g
include ../lib/utilities_build.g
include ../lib/channels.g

//=========== MEDIAL NEURON PARAMETER DEFINITIONS ===================//
float MED_RM = 1/0.027 * 1e3 * 1e-4 //specific membrane resistance (ohms m^2)
float MED_CM = 1.3 * 1e-6/1e-4 //specific membrane capacitance (farads/m^2)
float MED_RA = 100.00 * 1e-2 //specific axial resistance (ohms m)
float MED_ELEAK = -56.0 * 1e-3 //membrane leakage potential (volts)
float MED_ENa = 40.00 * 1e-3 //sodium reversal potential (volts)
float MED_GNa = 928.00 * 1e-3/1e-4 //maximum sodium conductance (S/m^2)
float MED_EK = -90.00 * 1e-3 //potassium reversal potential (volts)
float MED_GK = 925.00 * 1e-3/1e-4 //maximum potassium conductance (S/m^2)
float MED_ECa = 40.00 * 1e-3  //calcium reversal potential (volts)
float MED_GCa = 2.75 * 1e-3/1e-4 //maximum calcium conductance (S/m^2)
float MED_GKAHP = 0.01* 1e-3/1e-4 //maximum KAHP conductance (S/m^2)
float MED_SF = 2.2 * PI   //membrane scale factor (dimensionless)
float MED_TAU = 1
float MED_B = 6.00055e12

// compartment dimensions diameter(_D), length (_L) in meters
float MED_DEND1_D = 2.5 * 1e-6, MED_DEND1_L = 79.00 * 1e-6
float MED_DEND2_D = 2.4 * 1e-6, MED_DEND2_L = 76.00 * 1e-6
float MED_DEND3_D = 2.4 * 1e-6, MED_DEND3_L = 76.00 * 1e-6
float MED_DEND4_D = 2.3 * 1e-6, MED_DEND4_L = 74.00 * 1e-6
float MED_DEND5_D = 5.5 * 1e-6, MED_DEND5_L = 115.00 * 1e-6
float MED_SOMA_D = 30.0 * 1e-6
float MED_DEND7_D = 14.3 * 1e-6,  MED_DEND7_L = 186.00 * 1e-6
float MED_DEND8_D = 14.0 * 1e-6,  MED_DEND8_L = 186.00 * 1e-6
float MED_DEND9_D = 13.0 * 1e-6,  MED_DEND9_L = 177.00 * 1e-6
float MED_DEND10_D = 10.3 * 1e-6, MED_DEND10_L = 158.00 * 1e-6
float MED_DEND11_D = 6.4 * 1e-6,  MED_DEND11_L = 125.00 * 1e-6
float MED_DEND12_D = 3.0 * 1e-6,  MED_DEND12_L = 85.00 * 1e-6

// effective compartment surface areas (_A) in m^2
float MED_DEND1_A = MED_DEND1_D * (0.25 * MED_DEND1_D + MED_DEND1_L)* MED_SF
float MED_DEND2_A = MED_DEND2_D * MED_DEND2_L * MED_SF
float MED_DEND3_A = MED_DEND3_D * MED_DEND3_L * MED_SF
float MED_DEND4_A = MED_DEND4_D * MED_DEND4_L * MED_SF
float MED_DEND5_A = MED_DEND5_D * MED_DEND5_L * MED_SF
float MED_SOMA_A = (MED_SOMA_D * MED_SOMA_D - \
 0.25*(MED_DEND5_D * MED_DEND5_D + MED_DEND7_D * MED_DEND7_D)) * MED_SF
float MED_DEND7_A = MED_DEND7_D * MED_DEND7_L * MED_SF
float MED_DEND8_A = MED_DEND8_D * MED_DEND8_L * MED_SF
float MED_DEND9_A = MED_DEND9_D * MED_DEND9_L * MED_SF
float MED_DEND10_A = MED_DEND10_D * MED_DEND10_L * MED_SF
float MED_DEND11_A = MED_DEND11_D * MED_DEND11_L * MED_SF
float MED_DEND12_A = MED_DEND12_D * (0.25*MED_DEND12_D + MED_DEND12_L)* MED_SF

// soma spike parameters
float MED_SPIKE_THRESH = -0.01
float MED_SPIKE_REFRACT = 0.01
float MED_SPIKE_AMP = 1


/* ******************************************************************
                       make_soma_medial
     Creates a spherical soma compartment containing sodium and 
     potassium channels
     
     Parameters:
        path           name of the soma object to be created
        dia            diameter of spherical compartment
        area           effective surface area

****************************************************************** */  
function make_soma_medial(path, dia, area)
   str path
   float dia, area

   make_sphere_compartment {path} {dia} {area} \
         {MED_ELEAK} {MED_RM} {MED_CM} {MED_RA}
   make_sodium_channel {path} {MED_GNa} {MED_ENa} {area}
   make_potassium_channel {path} {MED_GK} {MED_EK} {area}
   make_calcium_dep_K_AHP {path} {MED_GKAHP} {MED_GCa} \
            {MED_EK} {MED_ECa} {area} {MED_TAU} {MED_B}
end


/* ******************************************************************
                       make_dendrite_medial
     Creates a dendrite for a medial cell consisting of a single
     cylindrical compartment
     
     Parameters:
        path           name of the dendrite object
        len            length of the dendrite
        dia            diameter of the dendrite
        area           effective membrane area
        
****************************************************************** */  
function make_dendrite_medial(path, len, dia, area)
   str path
   float len, dia, area
   make_cylind_compartment {path} {len} {dia} {area} \
         {MED_ELEAK} {MED_RM} {MED_CM} {MED_RA}
end


/* ******************************************************************
                       make_cell_medial
     Creates a medial cell consisting of a soma, 5 apical dendrites
     and 5 basal dendrites
     
     Parameters:
        parent           name of the medial cell to be created
        
****************************************************************** */
function make_cell_medial(parent)
   str parent

   make_soma_medial {parent}/soma {MED_SOMA_D} {MED_SOMA_A}
   make_dendrite_medial {parent}/dend1 \
         {MED_DEND1_L} {MED_DEND1_D} {MED_DEND1_A}
   make_dendrite_medial {parent}/dend2 \
         {MED_DEND2_L} {MED_DEND2_D} {MED_DEND2_A}
   make_dendrite_medial {parent}/dend3 \
         {MED_DEND3_L} {MED_DEND3_D} {MED_DEND3_A}
   make_dendrite_medial {parent}/dend4 \
         {MED_DEND4_L} {MED_DEND4_D} {MED_DEND4_A}
   make_dendrite_medial {parent}/dend5 \
         {MED_DEND5_L} {MED_DEND5_D} {MED_DEND5_A}
   make_dendrite_medial {parent}/dend7 \
         {MED_DEND7_L} {MED_DEND7_D} {MED_DEND7_A}
   make_dendrite_medial {parent}/dend8 \
         {MED_DEND8_L} {MED_DEND8_D} {MED_DEND8_A}
   make_dendrite_medial {parent}/dend9 \
         {MED_DEND9_L} {MED_DEND9_D} {MED_DEND9_A}
   make_dendrite_medial {parent}/dend10 \
         {MED_DEND10_L} {MED_DEND10_D} {MED_DEND10_A}
   make_dendrite_medial {parent}/dend11 \
         {MED_DEND11_L} {MED_DEND11_D} {MED_DEND11_A}
   make_dendrite_medial {parent}/dend12 \
         {MED_DEND12_L} {MED_DEND12_D} {MED_DEND12_A}

   float d1, d2, d3, d4, d5,  d7, d8, d9, d10, d11, d12, s
   d1 = {getfield {parent}/dend1 Ra}
   d2 = {getfield {parent}/dend2 Ra}
   d3 = {getfield {parent}/dend3 Ra}
   d4 = {getfield {parent}/dend4 Ra}
   d5 = {getfield {parent}/dend5 Ra}

   d7 = {getfield {parent}/dend7 Ra}
   d8 = {getfield {parent}/dend8 Ra}
   d9 = {getfield {parent}/dend9 Ra}
   d10 = {getfield {parent}/dend10 Ra}
   d11 = {getfield {parent}/dend11 Ra}
   d12 = {getfield {parent}/dend12 Ra}
   s = {getfield {parent}/soma Ra}

   setfield {parent}/dend2 Ra {0.5*(d2 + d1)}
   setfield {parent}/dend3 Ra {0.5*(d3 + d2)}
   setfield {parent}/dend4 Ra {0.5*(d4 + d3)}
   setfield {parent}/dend5 Ra {0.5*(d5 + d4)}
   setfield {parent}/dend7 Ra {0.5*(s + d7)}
   setfield {parent}/dend8 Ra {0.5*(d8 + d7)}
   setfield {parent}/dend9 Ra {0.5*(d9 + d8)}
   setfield {parent}/dend10 Ra {0.5*(d10 + d9)}
   setfield {parent}/dend11 Ra {0.5*(d11 + d10)}
   setfield {parent}/dend12 Ra {0.5*(d12 + d11)}
   setfield {parent}/soma Ra {0.5*(s + d5)}

   connect_compartments {parent}/dend1 {parent}/dend2
   connect_compartments {parent}/dend2 {parent}/dend3
   connect_compartments {parent}/dend3 {parent}/dend4
   connect_compartments {parent}/dend4 {parent}/dend5
   connect_compartments {parent}/dend5 {parent}/soma
   connect_compartments {parent}/soma  {parent}/dend7
   connect_compartments {parent}/dend7 {parent}/dend8
   connect_compartments {parent}/dend8 {parent}/dend9
   connect_compartments {parent}/dend9 {parent}/dend10
   connect_compartments {parent}/dend10 {parent}/dend11
   connect_compartments {parent}/dend11 {parent}/dend12

   make_spike {parent}/soma \
      {MED_SPIKE_THRESH} {MED_SPIKE_REFRACT} {MED_SPIKE_AMP}
end


/* ******************************************************************
                       make_medial_cells
     Creates a population of medial cells with names of the form
     {root}/cell#. 
     
     Parameters:
        coord_file     name of text file containing neuron positions 
        root           parent of all medial neurons
     
****************************************************************** */  
function make_medial_cells(coord_file, root)
   str coord_file, root

   create neutral {root}
   
   str name
   str parent = {root}@"/cell"
   read_coords {coord_file} {parent}
   foreach name  ({el {parent}#})
      make_cell_medial {name}
   end
end

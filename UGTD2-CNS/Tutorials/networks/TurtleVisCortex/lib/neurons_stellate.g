//======== CREATE POPULATION OF STELLATE NEURONS FOR NGU MODEL =======//
// This file contains functions to create a population of stellate    //
// inhibitory neurons for the NGU model.                              //
//                                                                    //
// Setup:                                                             //
// 1. Specify the neurons by creating a text file of x y z            //
//    coordinates for the neurons, one neuron per line.               //
// 2. Call make_stellate_cells                                        //
//                                                                    //
//====================================================================//
include ../lib/global_constants.g
include ../lib/utilities_build.g
include ../lib/channels.g


//========== STELLATE NEURON PARAMETER DEFINITIONS ===================//
float STE_RM = 1/0.116 * 1e3 * 1e-4 //specific membrane resistance (ohms m^2)
float STE_CM = 1.5 * 1e-6/1e-4 //specific membrane capacitance (farads/m^2)
float STE_RA = 100.00 * 1e-2 //specific axial resistance (ohms m)
float STE_ELEAK = -57.0 * 1e-3 //membrane leakage potential (volts)
float STE_ENa = 40.00 * 1e-3 //sodium reversal potential (volts)
float STE_GNa = 300.00 * 1e-3/1e-4 //maximum sodium conductance (S/m^2)
float STE_EK = -90.00 * 1e-3 //potassium reversal potential (volts)
float STE_GK = 200.00 * 1e-3/1e-4 //maximum potassium conductance (S/m^2)
float STE_SF = 1.5 * PI   //membrane scale factor (dimensionless)

// compartment dimensions diameter(_D), length (_L) in meters
float STE_SOMA_D = 12.7 * 1e-6
float STE_DEND2_D = 3.0 * 1e-6,  STE_DEND2_L = 90.00 * 1e-6
float STE_DEND3_D = 2.0 * 1e-6,  STE_DEND3_L = 90.00 * 1e-6
float STE_DEND4_D = 3.0 * 1e-6,  STE_DEND4_L = 90.00 * 1e-6
float STE_DEND5_D = 2.0 * 1e-6,  STE_DEND5_L = 90.00 * 1e-6
float STE_DEND6_D = 2.0 * 1e-6,  STE_DEND6_L = 90.00 * 1e-6
float STE_DEND7_D = 3.0 * 1e-6,  STE_DEND7_L = 90.00 * 1e-6
float STE_DEND8_D = 2.0 * 1e-6,  STE_DEND8_L = 90.00 * 1e-6
float STE_DEND9_D = 3.0 * 1e-6,  STE_DEND9_L = 90.00 * 1e-6
float STE_DEND10_D = 2.0 * 1e-6, STE_DEND10_L = 90.00 * 1e-6
float STE_DEND11_D = 2.0 * 1e-6, STE_DEND11_L = 90.00 * 1e-6
float STE_DEND12_D = 3.0 * 1e-6, STE_DEND12_L = 90.00 * 1e-6
float STE_DEND13_D = 2.0 * 1e-6, STE_DEND13_L = 90.00 * 1e-6
float STE_DEND14_D = 3.0 * 1e-6, STE_DEND14_L = 90.00 * 1e-6
float STE_DEND15_D = 2.0 * 1e-6, STE_DEND15_L = 90.00 * 1e-6
float STE_DEND16_D = 2.0 * 1e-6, STE_DEND16_L = 90.00 * 1e-6

// effective compartment surface areas (_A) in m^2
float STE_SOMA_A = (STE_SOMA_D * STE_SOMA_D - \
   0.25 * (STE_DEND2_D * STE_DEND2_D + STE_DEND4_D * STE_DEND4_D + \
   STE_DEND7_D * STE_DEND7_D + STE_DEND9_D * STE_DEND9_D +\
   STE_DEND12_D * STE_DEND12_D + STE_DEND14_D * STE_DEND14_D)) * STE_SF
float STE_DEND2_A = STE_DEND2_D * STE_DEND2_L * STE_SF
float STE_DEND3_A = STE_DEND3_D * (0.25 * STE_DEND3_D + STE_DEND3_L) * STE_SF
float STE_DEND4_A = STE_DEND4_D * STE_DEND4_L * STE_SF
float STE_DEND5_A = STE_DEND5_D * (0.25 * STE_DEND5_D + STE_DEND5_L) * STE_SF
float STE_DEND6_A = STE_DEND6_D * (0.25 * STE_DEND6_D + STE_DEND6_L) * STE_SF
float STE_DEND7_A = STE_DEND7_D * STE_DEND7_L * STE_SF
float STE_DEND8_A = STE_DEND8_D * (0.25 * STE_DEND8_D + STE_DEND8_L) * STE_SF
float STE_DEND9_A = STE_DEND9_D * STE_DEND9_L * STE_SF
float STE_DEND10_A = STE_DEND10_D * \
   (0.25 * STE_DEND10_D + STE_DEND10_L) * STE_SF
float STE_DEND11_A = STE_DEND11_D * \
   (0.25 * STE_DEND11_D + STE_DEND11_L) * STE_SF
float STE_DEND12_A = STE_DEND12_D * STE_DEND12_L * STE_SF
float STE_DEND13_A = STE_DEND13_D * \
   (0.25 * STE_DEND13_D + STE_DEND13_L) * STE_SF
float STE_DEND14_A = STE_DEND14_D * STE_DEND14_L * STE_SF
float STE_DEND15_A = STE_DEND15_D * \
   (0.25 * STE_DEND15_D + STE_DEND15_L) * STE_SF
float STE_DEND16_A = STE_DEND16_D * \
   (0.25 * STE_DEND16_D + STE_DEND16_L) * STE_SF

// soma spike parameters
float STE_SPIKE_THRESH = -0.02
float STE_SPIKE_REFRACT = 0.01
float STE_SPIKE_AMP = 1


/* ******************************************************************
                       make_soma_stellate
     Creates a spherical soma compartment containing sodium and 
     potassium channels
     
     Parameters:
        path           name of the soma object to be created
        dia            diameter of spherical compartment
        area           effective surface area

****************************************************************** */  
function make_soma_stellate(path, dia, area)
   str path
   float dia, area

   make_sphere_compartment {path} {dia} {area} \
         {STE_ELEAK} {STE_RM} {STE_CM} {STE_RA}
   make_sodium_channel {path} {STE_GNa} {STE_ENa} {area}  
   make_potassium_channel {path} {STE_GK} {STE_EK} {area} 
end


/* ******************************************************************
                       make_dendrite_stellate
     Creates a dendrite for a stellate cell consisting of a single
     cylindrical compartment
     
     Parameters:
        path           name of the dendrite object
        len            length of the dendrite
        dia            diameter of the dendrite
        area           effective membrane area
        
****************************************************************** */  
function make_dendrite_stellate (path, len, dia, area)
   str path
   float len, dia, area

   make_cylind_compartment {path} {len} {dia} {area} \
         {STE_ELEAK} {STE_RM} {STE_CM} {STE_RA}
end


/* ******************************************************************
                       make_cell_stellate
     Creates a stellate cell consisting of a soma and 16 basal
     dendrites
     
     Parameters:
        parent           name of the stellate cell to be created
        
****************************************************************** */
function make_cell_stellate(parent)
   str parent

   make_soma_stellate {parent}/soma {STE_SOMA_D} {STE_SOMA_A}
   make_dendrite_stellate {parent}/dend2 \
         {STE_DEND2_L} {STE_DEND2_D} {STE_DEND2_A}
   make_dendrite_stellate {parent}/dend3 \
         {STE_DEND3_L} {STE_DEND3_D} {STE_DEND3_A}
   make_dendrite_stellate {parent}/dend4 \
         {STE_DEND4_L} {STE_DEND4_D} {STE_DEND4_A}
   make_dendrite_stellate {parent}/dend5 \
         {STE_DEND5_L} {STE_DEND5_D} {STE_DEND5_A}
   make_dendrite_stellate {parent}/dend6 \
         {STE_DEND6_L} {STE_DEND6_D} {STE_DEND6_A}
   make_dendrite_stellate {parent}/dend7 \
         {STE_DEND7_L} {STE_DEND7_D} {STE_DEND7_A}
   make_dendrite_stellate {parent}/dend8 \
         {STE_DEND8_L} {STE_DEND8_D} {STE_DEND8_A}
   make_dendrite_stellate {parent}/dend9 \
         {STE_DEND9_L} {STE_DEND9_D} {STE_DEND9_A}
   make_dendrite_stellate {parent}/dend10 \
         {STE_DEND10_L} {STE_DEND10_D} {STE_DEND10_A}
   make_dendrite_stellate {parent}/dend11 \
         {STE_DEND11_L} {STE_DEND11_D} {STE_DEND11_A}
   make_dendrite_stellate {parent}/dend12 \
         {STE_DEND12_L} {STE_DEND12_D} {STE_DEND12_A}
   make_dendrite_stellate {parent}/dend13 \
         {STE_DEND13_L} {STE_DEND13_D} {STE_DEND13_A}
   make_dendrite_stellate {parent}/dend14 \
         {STE_DEND14_L} {STE_DEND14_D} {STE_DEND14_A}
   make_dendrite_stellate {parent}/dend15 \
         {STE_DEND15_L} {STE_DEND15_D} {STE_DEND15_A}
   make_dendrite_stellate {parent}/dend16 \
         {STE_DEND16_L} {STE_DEND16_D} {STE_DEND16_A}

   float d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15, d16, s
   d2 = {getfield {parent}/dend2 Ra}
   d3 = {getfield {parent}/dend3 Ra}
   d4 = {getfield {parent}/dend4 Ra}
   d5 = {getfield {parent}/dend5 Ra}
   d6 = {getfield {parent}/dend6 Ra}
   d7 = {getfield {parent}/dend7 Ra}
   d8 = {getfield {parent}/dend8 Ra}
   d9 = {getfield {parent}/dend9 Ra}
   d10 = {getfield {parent}/dend10 Ra}
   d11 = {getfield {parent}/dend11 Ra}
   d12 = {getfield {parent}/dend12 Ra}
   d13 = {getfield {parent}/dend13 Ra}
   d14 = {getfield {parent}/dend14 Ra}
   d15 = {getfield {parent}/dend15 Ra}
   d16 = {getfield {parent}/dend16 Ra}
   s = {getfield {parent}/soma Ra}

   setfield {parent}/dend2 Ra {0.5*(d2 + s)}
   setfield {parent}/dend3 Ra {0.5*(d3 + d2)}
   setfield {parent}/dend4 Ra {0.5*(d4 + s)}
   setfield {parent}/dend5 Ra {0.5*(d5 + d4)}
   setfield {parent}/dend6 Ra {0.5*(d6 + d4)}
   setfield {parent}/dend7 Ra {0.5*(d7 + s)}
   setfield {parent}/dend8 Ra {0.5*(d8 + d7)}
   setfield {parent}/dend9 Ra {0.5*(d9 + s)}
   setfield {parent}/dend10 Ra {0.5*(d10 + d9)}
   setfield {parent}/dend11 Ra {0.5*(d11 + d9)}
   setfield {parent}/dend12 Ra {0.5*(d12 + s)}
   setfield {parent}/dend13 Ra {0.5*(d13 + d12)}
   setfield {parent}/dend14 Ra {0.5*(d14 + s)}
   setfield {parent}/dend15 Ra {0.5*(d15 + d14)}
   setfield {parent}/dend16 Ra {0.5*(d16 + d14)}
    
   connect_compartments {parent}/soma {parent}/dend2
   connect_compartments {parent}/soma {parent}/dend4
   connect_compartments {parent}/soma {parent}/dend7
   connect_compartments {parent}/soma {parent}/dend9
   connect_compartments {parent}/soma {parent}/dend12
   connect_compartments {parent}/soma {parent}/dend14
   connect_compartments {parent}/dend2 {parent}/dend3
   connect_compartments {parent}/dend4 {parent}/dend5
   connect_compartments {parent}/dend4 {parent}/dend6
   connect_compartments {parent}/dend7 {parent}/dend8
   connect_compartments {parent}/dend9 {parent}/dend10
   connect_compartments {parent}/dend9 {parent}/dend11
   connect_compartments {parent}/dend12 {parent}/dend13
   connect_compartments {parent}/dend14 {parent}/dend15
   connect_compartments {parent}/dend14 {parent}/dend16

   make_spike {parent}/soma \
       {STE_SPIKE_THRESH} {STE_SPIKE_REFRACT} {STE_SPIKE_AMP}
end


/* ******************************************************************
                       make_stellate_cells
     Creates a population of stellate cells with names of the form
     {root}/cell#. 
     
     Parameters:
        coord_file     name of text file containing neuron positions 
        root           parent of all stellate neurons
     
****************************************************************** */  
function make_stellate_cells(coord_file, root)
   str coord_file, root

   create neutral {root}
   str parent = {root}@"/cell"
   read_coords {coord_file} {parent}

   str name
   foreach name  ({el {parent}#})
      make_cell_stellate {name}
   end
end

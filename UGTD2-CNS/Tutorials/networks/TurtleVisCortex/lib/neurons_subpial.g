//========= CREATE POPULATION OF SUBPIAL NEURONS FOR NGU MODEL =======//
// This file contains functions to create a population of subpial     //
// inhibitory neurons for the NGU model.                               //
//                                                                    //
// Setup:                                                             //
// 1. Specify the neurons by creating a text file of x y z            //
//    coordinates for the neurons, one neuron per line.               //
// 2. Call make_subpial_cells                                         //
//                                                                    //
//====================================================================//
include ../lib/global_constants.g
include ../lib/utilities_build.g
include ../lib/channels.g

//========== SUBPIAL NEURON PARAMETER DEFINITIONS ===================//
float SUB_RM = 34.65 * 1e3 * 1e-4 //specific membrane resistance (ohms m^2)
float SUB_CM = 0.4286 * 1e-6/1e-4 //specific membrane capacitance (farads/m^2)
float SUB_RA = 285.6 * 1e-2 //specific axial resistance (ohms m)
float SUB_ELEAK = -75 * 1e-3 //membrane leakage potential (volts)
float SUB_ENa = 40.00 * 1e-3 //sodium reversal potential (volts)
float SUB_GNa = 3256.00 * 1e-3/1e-4 //maximum sodium conductance (S/m^2)
float SUB_EK = -90.00 * 1e-3 //potassium reversal potential (volts)
float SUB_GK = 2200.00 * 1e-3/1e-4 //maximum potassium conductance (S/m^2)
float SUB_ECa = 40.00 * 1e-3 //calcium reversal potential (volts)
float SUB_GCa = 3.68 * 1e-3/1e-4 //maximum calcium conductance (S/m^2)
float SUB_GKAHP = 0.148 * 1e-3/1e-4 //maximum KAHP conductance (S/m^2)
float SUB_SF = 1.0 * PI
float SUB_TAU  = 5   
float SUB_B  = 6.00055e12

// compartment dimensions diameter(_D), length (_L) in meters
float SUB_SOMA_D = 9.493 * 1e-6  
float SUB_DEND2_D = 0.132 * 1e-6,  SUB_DEND2_L = 37 * 1e-6
float SUB_DEND3_D = 0.132 * 1e-6,  SUB_DEND3_L = 37 * 1e-6
float SUB_DEND4_D = 0.132 * 1e-6,  SUB_DEND4_L = 37 * 1e-6
float SUB_DEND5_D = 0.132 * 1e-6,  SUB_DEND5_L = 37 * 1e-6
float SUB_DEND6_D = 0.132 * 1e-6,  SUB_DEND6_L = 37 * 1e-6
float SUB_DEND7_D = 0.132 * 1e-6,  SUB_DEND7_L = 37 * 1e-6
float SUB_DEND8_D = 0.132 * 1e-6,  SUB_DEND8_L = 37 * 1e-6
float SUB_DEND9_D = 0.306 * 1e-6,  SUB_DEND9_L = 57 * 1e-6
float SUB_DEND10_D = 0.306 * 1e-6, SUB_DEND10_L = 57 * 1e-6
float SUB_DEND11_D = 0.306 * 1e-6, SUB_DEND11_L = 57 * 1e-6
float SUB_DEND12_D = 1.463 * 1e-6, SUB_DEND12_L = 13 * 1e-6
float SUB_DEND13_D = 1.647 * 1e-6, SUB_DEND13_L = 54 * 1e-6
float SUB_DEND14_D = 0.567 * 1e-6, SUB_DEND14_L = 57 * 1e-6
float SUB_DEND15_D = 0.567 * 1e-6, SUB_DEND15_L = 57 * 1e-6
float SUB_DEND16_D = 0.567 * 1e-6, SUB_DEND16_L = 57 * 1e-6
float SUB_DEND17_D = 0.686 * 1e-6, SUB_DEND17_L = 70 * 1e-6
float SUB_DEND18_D = 0.686 * 1e-6, SUB_DEND18_L = 70 * 1e-6
float SUB_DEND19_D = 0.462 * 1e-6, SUB_DEND19_L = 52 * 1e-6
float SUB_DEND20_D = 1.146 * 1e-6, SUB_DEND20_L = 95 * 1e-6
float SUB_DEND21_D = 1.146 * 1e-6, SUB_DEND21_L = 95 * 1e-6
float SUB_DEND22_D = 1.146 * 1e-6, SUB_DEND22_L = 95 * 1e-6
float SUB_DEND23_D = 0.358 * 1e-6, SUB_DEND23_L = 59 * 1e-6
float SUB_DEND24_D = 0.358 * 1e-6, SUB_DEND24_L = 59 * 1e-6
float SUB_DEND25_D = 0.358 * 1e-6, SUB_DEND25_L = 59 * 1e-6
float SUB_DEND26_D = 0.946 * 1e-6, SUB_DEND26_L = 6.0 * 1e-6
float SUB_DEND27_D = 0.948 * 1e-6, SUB_DEND27_L = 89 * 1e-6
float SUB_DEND28_D = 0.948 * 1e-6, SUB_DEND28_L = 89 * 1e-6
float SUB_DEND29_D = 0.948 * 1e-6, SUB_DEND29_L = 89 * 1e-6

// effective compartment surface areas (_A) in m^2
float SUB_SOMA_A = (SUB_SOMA_D * SUB_SOMA_D - 0.25 * \
   (SUB_DEND2_D * SUB_DEND2_D + SUB_DEND12_D * SUB_DEND12_D + \
   SUB_DEND14_D * SUB_DEND14_D + SUB_DEND19_D * SUB_DEND19_D + \
   SUB_DEND23_D * SUB_DEND23_D + SUB_DEND26_D * SUB_DEND26_D)) * SUB_SF
float SUB_DEND2_A = SUB_DEND2_D * SUB_DEND2_L * SUB_SF
float SUB_DEND3_A = SUB_DEND3_D * SUB_DEND3_L * SUB_SF
float SUB_DEND4_A = SUB_DEND4_D * SUB_DEND4_L * SUB_SF
float SUB_DEND5_A = SUB_DEND5_D * SUB_DEND5_L * SUB_SF
float SUB_DEND6_A = SUB_DEND6_D * SUB_DEND6_L * SUB_SF
float SUB_DEND7_A = SUB_DEND7_D * SUB_DEND7_L * SUB_SF
float SUB_DEND8_A = SUB_DEND8_D * SUB_DEND8_L * SUB_SF
float SUB_DEND9_A = SUB_DEND9_D * SUB_DEND9_L * SUB_SF
float SUB_DEND10_A = SUB_DEND10_D * SUB_DEND10_L * SUB_SF
float SUB_DEND11_A = SUB_DEND11_D * \
   (0.25 * SUB_DEND11_D + SUB_DEND11_L) * SUB_SF
float SUB_DEND12_A = SUB_DEND12_D * SUB_DEND12_L * SUB_SF
float SUB_DEND13_A = SUB_DEND13_D * \
   (0.25 * SUB_DEND13_D + SUB_DEND13_L) * SUB_SF
float SUB_DEND14_A = SUB_DEND14_D * SUB_DEND14_L * SUB_SF
float SUB_DEND15_A = SUB_DEND15_D * SUB_DEND15_L * SUB_SF
float SUB_DEND16_A = SUB_DEND16_D * SUB_DEND16_L * SUB_SF
float SUB_DEND17_A = SUB_DEND17_D * SUB_DEND17_L * SUB_SF
float SUB_DEND18_A = SUB_DEND18_D * \
   (0.25 * SUB_DEND18_D + SUB_DEND18_L) * SUB_SF
float SUB_DEND19_A = SUB_DEND19_D * SUB_DEND19_L * SUB_SF
float SUB_DEND20_A = SUB_DEND20_D * SUB_DEND20_L * SUB_SF
float SUB_DEND21_A = SUB_DEND21_D * SUB_DEND21_L * SUB_SF
float SUB_DEND22_A = SUB_DEND22_D * \
   (0.25 * SUB_DEND22_D + SUB_DEND22_L) * SUB_SF
float SUB_DEND23_A = SUB_DEND23_D * SUB_DEND23_L * SUB_SF
float SUB_DEND24_A = SUB_DEND24_D * SUB_DEND24_L * SUB_SF
float SUB_DEND25_A = SUB_DEND25_D * \
   (0.25 * SUB_DEND25_D + SUB_DEND25_L) * SUB_SF
float SUB_DEND26_A = SUB_DEND26_D * SUB_DEND26_L * SUB_SF
float SUB_DEND27_A = SUB_DEND27_D * SUB_DEND27_L * SUB_SF
float SUB_DEND28_A = SUB_DEND28_D * SUB_DEND28_L * SUB_SF
float SUB_DEND29_A = SUB_DEND29_D * \
   (0.25 * SUB_DEND29_D + SUB_DEND29_L) * SUB_SF

// soma spike parameters
float SUB_SPIKE_THRESH = -0.02
float SUB_SPIKE_REFRACT = 0.01
float SUB_SPIKE_AMP = 1


/* ******************************************************************
                       make_soma_subpial
     Creates a spherical soma compartment containing sodium,  
     potassium, and calcium-dependent potassium channels
     
     Parameters:
        path           name of the soma object to be created
        dia            diameter of spherical compartment
        area           effective surface area

****************************************************************** */  
function make_soma_subpial(path, dia, area)
   str path
   float dia, area

   make_sphere_compartment {path} {dia} {area}\ 
      {SUB_ELEAK} {SUB_RM} {SUB_CM} {SUB_RA}
   make_sodium_channel {path} {SUB_GNa} {SUB_ENa} {area}
   make_potassium_channel {path} {SUB_GK} {SUB_EK} {area}
   make_calcium_dep_K_AHP {path} {SUB_GKAHP} {SUB_GCa} \
      {SUB_EK} {SUB_ECa} {area} {SUB_TAU} {SUB_B}
end


/* ******************************************************************
                       make_dendrite_subpial
     Creates a dendrite for a subpial cell consisting of a single
     cylindrical compartment
     
     Parameters:
        path           name of the dendrite object
        len            length of the dendrite
        dia            diameter of the dendrite
        area           effective membrane area
        
****************************************************************** */  
function make_dendrite_subpial(path, len, dia, area)
   str path
   float len, dia, area

   make_cylind_compartment {path} {len} {dia} {area} \
      {SUB_ELEAK} {SUB_RM} {SUB_CM} {SUB_RA}
end


/* ******************************************************************
                       make_cell_subpial
     Creates a subpial cell consisting of a soma, 6 apical dendrites
     and 9 basal dendrites
     
     Parameters:
        parent           name of the subpial cell to be created
        
****************************************************************** */
function make_cell_subpial(parent)
   str parent

   make_soma_subpial {parent}/soma {SUB_SOMA_D} {SUB_SOMA_A}
   make_dendrite_subpial {parent}/dend2 \
      {SUB_DEND2_L} {SUB_DEND2_D} {SUB_DEND2_A}
   make_dendrite_subpial {parent}/dend3 \
      {SUB_DEND3_L} {SUB_DEND3_D} {SUB_DEND3_A}
   make_dendrite_subpial {parent}/dend4 \
      {SUB_DEND4_L} {SUB_DEND4_D} {SUB_DEND4_A}
   make_dendrite_subpial {parent}/dend5 \
      {SUB_DEND5_L} {SUB_DEND5_D} {SUB_DEND5_A}
   make_dendrite_subpial {parent}/dend6 \
      {SUB_DEND6_L} {SUB_DEND6_D} {SUB_DEND6_A}
   make_dendrite_subpial {parent}/dend7 \
      {SUB_DEND7_L} {SUB_DEND7_D} {SUB_DEND7_A}
   make_dendrite_subpial {parent}/dend8 \
      {SUB_DEND8_L} {SUB_DEND8_D} {SUB_DEND8_A}
   make_dendrite_subpial {parent}/dend9 \
      {SUB_DEND9_L} {SUB_DEND9_D} {SUB_DEND9_A}
   make_dendrite_subpial {parent}/dend10 \
      {SUB_DEND10_L} {SUB_DEND10_D} {SUB_DEND10_A}
   make_dendrite_subpial {parent}/dend11 \
      {SUB_DEND11_L} {SUB_DEND11_D} {SUB_DEND11_A}
   make_dendrite_subpial {parent}/dend12 \
      {SUB_DEND12_L} {SUB_DEND12_D} {SUB_DEND12_A}
   make_dendrite_subpial {parent}/dend13 \
      {SUB_DEND13_L} {SUB_DEND13_D} {SUB_DEND13_A}
   make_dendrite_subpial {parent}/dend14 \
      {SUB_DEND14_L} {SUB_DEND14_D} {SUB_DEND14_A}
   make_dendrite_subpial {parent}/dend15 \
      {SUB_DEND15_L} {SUB_DEND15_D} {SUB_DEND15_A}
   make_dendrite_subpial {parent}/dend16 \
      {SUB_DEND16_L} {SUB_DEND16_D} {SUB_DEND16_A}
   make_dendrite_subpial {parent}/dend17 \
      {SUB_DEND17_L} {SUB_DEND17_D} {SUB_DEND17_A}
   make_dendrite_subpial {parent}/dend18 \
      {SUB_DEND18_L} {SUB_DEND18_D} {SUB_DEND18_A}
   make_dendrite_subpial {parent}/dend19 \
      {SUB_DEND19_L} {SUB_DEND19_D} {SUB_DEND19_A}
   make_dendrite_subpial {parent}/dend20 \
      {SUB_DEND20_L} {SUB_DEND20_D} {SUB_DEND20_A}
   make_dendrite_subpial {parent}/dend21 \
      {SUB_DEND21_L} {SUB_DEND21_D} {SUB_DEND21_A}
   make_dendrite_subpial {parent}/dend22 \
      {SUB_DEND22_L} {SUB_DEND22_D} {SUB_DEND22_A}
   make_dendrite_subpial {parent}/dend23 \
      {SUB_DEND23_L} {SUB_DEND23_D} {SUB_DEND23_A}
   make_dendrite_subpial {parent}/dend24 \
      {SUB_DEND24_L} {SUB_DEND24_D} {SUB_DEND24_A}
   make_dendrite_subpial {parent}/dend25 \
      {SUB_DEND25_L} {SUB_DEND25_D} {SUB_DEND25_A}
   make_dendrite_subpial {parent}/dend26 \
      {SUB_DEND26_L} {SUB_DEND26_D} {SUB_DEND26_A}
   make_dendrite_subpial {parent}/dend27 \
      {SUB_DEND27_L} {SUB_DEND27_D} {SUB_DEND27_A}
   make_dendrite_subpial {parent}/dend28 \
      {SUB_DEND28_L} {SUB_DEND28_D} {SUB_DEND28_A}
   make_dendrite_subpial {parent}/dend29 \
      {SUB_DEND29_L} {SUB_DEND29_D} {SUB_DEND29_A}

   float d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15, d16
   float d17, d18, d19, d20, d21, d22, d23, d24, d25, d26, d27, d28, d29, s
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
   d17 = {getfield {parent}/dend17 Ra}
   d18 = {getfield {parent}/dend18 Ra}
   d19 = {getfield {parent}/dend19 Ra}
   d20 = {getfield {parent}/dend20 Ra}
   d21 = {getfield {parent}/dend21 Ra}
   d22 = {getfield {parent}/dend22 Ra}
   d23 = {getfield {parent}/dend23 Ra}
   d24 = {getfield {parent}/dend24 Ra}
   d25 = {getfield {parent}/dend25 Ra}
   d26 = {getfield {parent}/dend26 Ra}
   d27 = {getfield {parent}/dend27 Ra}
   d28 = {getfield {parent}/dend28 Ra}
   d29 = {getfield {parent}/dend29 Ra}
   s = {getfield {parent}/soma Ra}

   setfield {parent}/dend2 Ra {0.5*(d2 + s)}        // first branch
   setfield {parent}/dend3 Ra {0.5*(d3 + d2)}
   setfield {parent}/dend4 Ra {0.5*(d4 + d3)}
   setfield {parent}/dend5 Ra {0.5*(d5 + d4)}
   setfield {parent}/dend6 Ra {0.5*(d6 + d5)}
   setfield {parent}/dend7 Ra {0.5*(d7 + d6)}
   setfield {parent}/dend8 Ra {0.5*(d8 + d7)}
   setfield {parent}/dend9 Ra {0.5*(d9 + d8)}
   setfield {parent}/dend10 Ra {0.5*(d10 + d9)}
   setfield {parent}/dend11 Ra {0.5*(d11 + d10)}
   setfield {parent}/dend12 Ra {0.5*(d12 + s)}      // second branch
   setfield {parent}/dend13 Ra {0.5*(d13 + d12)}
   setfield {parent}/dend14 Ra {0.5*(d14 + s)}      // third branch
   setfield {parent}/dend15 Ra {0.5*(d15 + d14)}
   setfield {parent}/dend16 Ra {0.5*(d16 + d15)}
   setfield {parent}/dend17 Ra {0.5*(d17 + d16)}
   setfield {parent}/dend18 Ra {0.5*(d18 + d17)}
   setfield {parent}/dend19 Ra {0.5*(d19 + s)}      // fourth branch
   setfield {parent}/dend20 Ra {0.5*(d20 + d19)}
   setfield {parent}/dend21 Ra {0.5*(d21 + d20)}
   setfield {parent}/dend22 Ra {0.5*(d22 + d21)}
   setfield {parent}/dend23 Ra {0.5*(d23 + s)}      // fifth branch
   setfield {parent}/dend24 Ra {0.5*(d24 + d23)}
   setfield {parent}/dend25 Ra {0.5*(d25 + d24)}
   setfield {parent}/dend26 Ra {0.5*(d26 + s)}      // sixth branch
   setfield {parent}/dend27 Ra {0.5*(d27 + d26)}
   setfield {parent}/dend28 Ra {0.5*(d28 + d27)}
   setfield {parent}/dend29 Ra {0.5*(d29 + d28)}

   connect_compartments {parent}/soma {parent}/dend2      //first branch
   connect_compartments {parent}/dend2 {parent}/dend3
   connect_compartments {parent}/dend3 {parent}/dend4
   connect_compartments {parent}/dend4 {parent}/dend5
   connect_compartments {parent}/dend5 {parent}/dend6
   connect_compartments {parent}/dend6 {parent}/dend7
   connect_compartments {parent}/dend7 {parent}/dend8
   connect_compartments {parent}/dend8 {parent}/dend9
   connect_compartments {parent}/dend9 {parent}/dend10
   connect_compartments {parent}/dend10 {parent}/dend11
   connect_compartments {parent}/soma {parent}/dend12     //second branch
   connect_compartments {parent}/dend12 {parent}/dend13
   connect_compartments {parent}/soma {parent}/dend14     //third branch
   connect_compartments {parent}/dend14 {parent}/dend15
   connect_compartments {parent}/dend15 {parent}/dend16
   connect_compartments {parent}/dend16 {parent}/dend17
   connect_compartments {parent}/dend17 {parent}/dend18
   connect_compartments {parent}/soma {parent}/dend19     //fourth branch
   connect_compartments {parent}/dend19 {parent}/dend20
   connect_compartments {parent}/dend20 {parent}/dend21
   connect_compartments {parent}/dend21 {parent}/dend22
   connect_compartments {parent}/soma {parent}/dend23     //fifth branch
   connect_compartments {parent}/dend23 {parent}/dend24
   connect_compartments {parent}/dend24 {parent}/dend25
   connect_compartments {parent}/soma {parent}/dend26     //sixth branch
   connect_compartments {parent}/dend26 {parent}/dend27
   connect_compartments {parent}/dend27 {parent}/dend28
   connect_compartments {parent}/dend28 {parent}/dend29

   make_spike {parent}/soma \
      {SUB_SPIKE_THRESH} {SUB_SPIKE_REFRACT} {SUB_SPIKE_AMP}
end

/* ******************************************************************
                       make_subpial_cells
     Creates a population of subpial cells with names of the form
     {root}/cell#. 
     
     Parameters:
        coord_file     name of text file containing neuron positions 
        root           parent of all subpial neurons
     
****************************************************************** */  
function make_subpial_cells(coord_file, root)
   str coord_file, root

   create neutral {root}
   str parent = {root}@"/cell"
   read_coords {coord_file} {parent}

   str name
   foreach name  ({el {parent}#})
      make_cell_subpial {name}
   end
end



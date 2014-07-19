//========= CREATE POPULATION OF LATERAL NEURONS FOR NGU MODEL =======//
// This file contains functions to create a population of lateral     //
// pyramidal neurons for the NGU model.                               //
//                                                                    //
// Setup:                                                             //
// 1. Specify the neurons by creating a text file of x y z            //
//    coordinates for the neurons, one neuron per line.               //
// 2. Call make_lateral_cells                                         //
//                                                                    //
//====================================================================//
include ../lib/global_constants.g
include ../lib/utilities_build.g
include ../lib/channels.g


//========== LATERAL NEURON PARAMETER DEFINITIONS ===================//
float LAT_RM = 1/0.03 * 1e3 * 1e-4 //specific membrane resistance (ohms m^2)
float LAT_CM = 1.4 * 1e-6/1e-4 //specific membrane capacitance (farads/m^2)
float LAT_RA = 100.00 * 1e-2 //specific axial resistance (ohms m)
float LAT_EREST = -57.4 * 1e-3 //resting membrane potential (volts)
float LAT_ELEAK = -58.4 * 1e-3 //membrane leakage potential (volts)
float LAT_ENa = 40.00 * 1e-3 //sodium reversal potential (volts)
float LAT_GNa = 370.00 * 1e-3/1e-4 //maximum sodium conductance (S/m^2)
float LAT_EK = -90.00 * 1e-3 //potassium reversal potential (volts)
float LAT_GK = 250.00 * 1e-3/1e-4 //maximum potassium conductance (S/m^2)
float LAT_ECa = 40.00 * 1e-3 //calcium reversal potential (volts)
float LAT_GCa = 2.3 * 1e-3/1e-4 //maximum calcium conductance (S/m^2)
float LAT_GKAHP = 0.02* 1e-3/1e-4 //maximum KAHP conductance (S/m^2)
float LAT_SF = 1.8 * PI   //membrane scale factor (dimensionless)
float LAT_TAU = 1
float LAT_B = 6.00055e12

// compartment dimensions diameter(_D), length (_L) in meters
float LAT_SOMA_D = 20.6 * 1e-6 
float LAT_APICAL1_D = 8.5 * 1e-6, LAT_APICAL1_L = 153.00 * 1e-6
float LAT_APICAL2_D = 7.1 * 1e-6, LAT_APICAL2_L = 140.00 * 1e-6
float LAT_APICAL3_D = 5.1 * 1e-6, LAT_APICAL3_L = 119.00 * 1e-6
float LAT_APICAL4_D = 2.5 * 1e-6, LAT_APICAL4_L = 83.00 * 1e-6
float LAT_APICAL5_D = 2.3 * 1e-6, LAT_APICAL5_L = 79.00 * 1e-6
float LAT_APICAL6_D = 0.9 * 1e-6, LAT_APICAL6_L = 50.00 * 1e-6
float LAT_BASAL1_D = 14.7 * 1e-6, LAT_BASAL1_L = 201.00 * 1e-6
float LAT_BASAL2_D = 8.0 * 1e-6, LAT_BASAL2_L = 148.00 * 1e-6
float LAT_BASAL3_D = 3.6 * 1e-6, LAT_BASAL3_L = 124.00 * 1e-6
float LAT_BASAL4_D = 5.9 * 1e-6, LAT_BASAL4_L = 127.00 * 1e-6
float LAT_BASAL5_D = 5.0 * 1e-6, LAT_BASAL5_L = 117.00 * 1e-6
float LAT_BASAL6_D = 3.5 * 1e-6, LAT_BASAL6_L = 98.00 * 1e-6
float LAT_BASAL7_D = 3.4 * 1e-6, LAT_BASAL7_L = 97.00 * 1e-6
float LAT_BASAL8_D = 1.4 * 1e-6, LAT_BASAL8_L = 62.00 * 1e-6
float LAT_BASAL9_D = 0.8 * 1e-6, LAT_BASAL9_L = 47.00 * 1e-6

// effective compartment surface areas (_A) in m^2
float LAT_SOMA_A = (LAT_SOMA_D * LAT_SOMA_D - 0.25 * \
   (LAT_APICAL1_D * LAT_APICAL1_D + LAT_BASAL1_D * LAT_BASAL1_D)) * LAT_SF
float LAT_APICAL1_A = LAT_APICAL1_D * LAT_APICAL1_L * LAT_SF
float LAT_APICAL2_A = LAT_APICAL2_D * LAT_APICAL2_L * LAT_SF
float LAT_APICAL3_A = LAT_APICAL3_D * LAT_APICAL3_L * LAT_SF
float LAT_APICAL4_A = LAT_APICAL4_D * LAT_APICAL4_L * LAT_SF
float LAT_APICAL5_A = LAT_APICAL5_D * LAT_APICAL5_L * LAT_SF
float LAT_APICAL6_A = LAT_APICAL6_D * \
   (0.25 * LAT_APICAL6_D + LAT_APICAL6_L) * LAT_SF               
float LAT_BASAL1_A = LAT_BASAL1_D * LAT_BASAL1_L * LAT_SF
float LAT_BASAL2_A = LAT_BASAL2_D * LAT_BASAL2_L * LAT_SF
float LAT_BASAL3_A = LAT_BASAL3_D * LAT_BASAL3_L * LAT_SF
float LAT_BASAL4_A = LAT_BASAL4_D * LAT_BASAL4_L * LAT_SF
float LAT_BASAL5_A = LAT_BASAL5_D * LAT_BASAL5_L * LAT_SF
float LAT_BASAL6_A = LAT_BASAL6_D * LAT_BASAL6_L * LAT_SF
float LAT_BASAL7_A = LAT_BASAL7_D * LAT_BASAL7_L * LAT_SF
float LAT_BASAL8_A = LAT_BASAL8_D * LAT_BASAL8_L * LAT_SF
float LAT_BASAL9_A = LAT_BASAL9_D * \
   (0.25*LAT_BASAL9_D + LAT_BASAL9_L) * LAT_SF

// soma spike parameters
float LAT_SPIKE_THRESH = -0.02
float LAT_SPIKE_REFRACT = 0.01
float LAT_SPIKE_AMP = 1


/* ******************************************************************
                       make_soma_lateral
     Creates a spherical soma compartment containing sodium and 
     potassium channels
     
     Parameters:
        path           name of the soma object to be created
        dia            diameter of spherical compartment
        area           effective surface area

****************************************************************** */  
function make_soma_lateral(path, dia, area)
   str path
   float dia, area

   make_sphere_compartment {path} {dia} {area} \
      {LAT_ELEAK} {LAT_RM} {LAT_CM} {LAT_RA}
   make_sodium_channel {path} {LAT_GNa} {LAT_ENa} {area}
   make_potassium_channel {path} {LAT_GK} {LAT_EK} {area}
   make_calcium_dep_K_AHP {path} {LAT_GKAHP} {LAT_GCa} \
      {LAT_EK} {LAT_ECa} {area} {LAT_TAU} {LAT_B}
end


/* ******************************************************************
                       make_dendrite_lateral
     Creates a dendrite for a lateral cell consisting of a single
     cylindrical compartment
     
     Parameters:
        path           name of the dendrite object
        len            length of the dendrite
        dia            diameter of the dendrite
        area           effective membrane area
        
****************************************************************** */  
function make_dendrite_lateral(path, len, dia, area)
   str path
   float len, dia, area

   make_cylind_compartment {path} {len} {dia} \
      {area} {LAT_ELEAK} {LAT_RM} {LAT_CM} {LAT_RA}
end


/* ******************************************************************
                       make_cell_lateral
     Creates a lateral cell consisting of a soma, 6 apical dendrites
     and 9 basal dendrites
     
     Parameters:
        parent           name of the lateral cell to be created
        
****************************************************************** */
function make_cell_lateral(parent)
   str parent

   make_soma_lateral {parent}/soma {LAT_SOMA_D} {LAT_SOMA_A}
   make_dendrite_lateral {parent}/apical1 \
      {LAT_APICAL1_L} {LAT_APICAL1_D} {LAT_APICAL1_A}
   make_dendrite_lateral {parent}/apical2 \
      {LAT_APICAL2_L} {LAT_APICAL2_D} {LAT_APICAL2_A}
   make_dendrite_lateral {parent}/apical3 \
      {LAT_APICAL3_L} {LAT_APICAL3_D} {LAT_APICAL3_A}
   make_dendrite_lateral {parent}/apical4 \
      {LAT_APICAL4_L} {LAT_APICAL4_D} {LAT_APICAL4_A}
   make_dendrite_lateral {parent}/apical5 \
      {LAT_APICAL5_L} {LAT_APICAL5_D} {LAT_APICAL5_A}
   make_dendrite_lateral {parent}/apical6 \
      {LAT_APICAL6_L} {LAT_APICAL6_D} {LAT_APICAL6_A}
   make_dendrite_lateral {parent}/basal1  \
      {LAT_BASAL1_L}  {LAT_BASAL1_D}  {LAT_BASAL1_A}
   make_dendrite_lateral {parent}/basal2  \
      {LAT_BASAL2_L}  {LAT_BASAL2_D}  {LAT_BASAL2_A}
   make_dendrite_lateral {parent}/basal3  \
      {LAT_BASAL3_L}  {LAT_BASAL3_D}  {LAT_BASAL3_A}
   make_dendrite_lateral {parent}/basal4  \
      {LAT_BASAL4_L}  {LAT_BASAL4_D}  {LAT_BASAL4_A}
   make_dendrite_lateral {parent}/basal5  \
      {LAT_BASAL5_L}  {LAT_BASAL5_D}  {LAT_BASAL5_A}
   make_dendrite_lateral {parent}/basal6  \
      {LAT_BASAL6_L}  {LAT_BASAL6_D}  {LAT_BASAL6_A}
   make_dendrite_lateral {parent}/basal7  \
      {LAT_BASAL7_L}  {LAT_BASAL7_D}  {LAT_BASAL7_A}
   make_dendrite_lateral {parent}/basal8  \
      {LAT_BASAL8_L}  {LAT_BASAL8_D}  {LAT_BASAL8_A}
   make_dendrite_lateral {parent}/basal9  \
      {LAT_BASAL9_L}  {LAT_BASAL9_D} {LAT_BASAL9_A}

   float a1, a2, a3, a4, a5, a6, b1, b2, b3, b4, b5, b6, b7, b8, b9, s
   a1 = {getfield {parent}/apical1 Ra}
   a2 = {getfield {parent}/apical2 Ra}
   a3 = {getfield {parent}/apical3 Ra}
   a4 = {getfield {parent}/apical4 Ra}
   a5 = {getfield {parent}/apical5 Ra}
   a6 = {getfield {parent}/apical6 Ra}
   b1 = {getfield {parent}/basal1 Ra}
   b2 = {getfield {parent}/basal2 Ra}
   b3 = {getfield {parent}/basal3 Ra}
   b4 = {getfield {parent}/basal4 Ra}
   b5 = {getfield {parent}/basal5 Ra}
   b6 = {getfield {parent}/basal6 Ra}
   b7 = {getfield {parent}/basal7 Ra}
   b8 = {getfield {parent}/basal8 Ra}
   b9 = {getfield {parent}/basal9 Ra}
   s = {getfield {parent}/soma Ra}

   setfield {parent}/apical5 Ra {0.5*(a5 + a6)}
   setfield {parent}/apical4 Ra {0.5*(a4 + a5)}
   setfield {parent}/apical3 Ra {0.5*(a3 + a4)}
   setfield {parent}/apical2 Ra {0.5*(a2 + a3)}
   setfield {parent}/apical1 Ra {0.5*(a1 + a2)}
   setfield {parent}/soma Ra {0.5*(s + a1)}
   setfield {parent}/basal1 Ra {0.5*(s + b1)}
   setfield {parent}/basal2 Ra {0.5*(b1 + b2)}
   setfield {parent}/basal3 Ra {0.5*(b2 + b3)}
   setfield {parent}/basal4 Ra {0.5*(b3 + b4)}
   setfield {parent}/basal5 Ra {0.5*(b4 + b5)}
   setfield {parent}/basal6 Ra {0.5*(b5 + b6)}
   setfield {parent}/basal7 Ra {0.5*(b6 + b7)}
   setfield {parent}/basal8 Ra {0.5*(b7 + b8)}
   setfield {parent}/basal9 Ra {0.5*(b8 + b9)}

   connect_compartments {parent}/apical6 {parent}/apical5
   connect_compartments {parent}/apical5 {parent}/apical4
   connect_compartments {parent}/apical4 {parent}/apical3
   connect_compartments {parent}/apical3 {parent}/apical2
   connect_compartments {parent}/apical2 {parent}/apical1
   connect_compartments {parent}/apical1 {parent}/soma
   connect_compartments {parent}/soma {parent}/basal1
   connect_compartments {parent}/basal1 {parent}/basal2
   connect_compartments {parent}/basal2 {parent}/basal3
   connect_compartments {parent}/basal3 {parent}/basal4
   connect_compartments {parent}/basal4 {parent}/basal5
   connect_compartments {parent}/basal5 {parent}/basal6
   connect_compartments {parent}/basal6 {parent}/basal7
   connect_compartments {parent}/basal7 {parent}/basal8
   connect_compartments {parent}/basal8 {parent}/basal9

   make_spike {parent}/soma \
      {LAT_SPIKE_THRESH} {LAT_SPIKE_REFRACT} {LAT_SPIKE_AMP}
end


/* ******************************************************************
                       make_lateral_cells
     Creates a population of lateral cells with names of the form
     {root}/cell#. 
     
     Parameters:
        coord_file     name of text file containing neuron positions 
        root           parent of all lateral neurons
     
****************************************************************** */  
function make_lateral_cells(coord_file, root)
   str coord_file, root

   create neutral {root}
   str parent = {root}@"/cell"
   read_coords {coord_file} {parent}

   str name
   foreach name  ({el {parent}#})
      make_cell_lateral {name}
   end
end


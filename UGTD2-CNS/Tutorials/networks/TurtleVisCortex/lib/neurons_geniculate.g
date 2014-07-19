//======== CREATE POPULATION OF GENICULATE NEURONS FOR NGU MODEL======//
// This file contains functions to create a population of geniculate  // 
// neurons for the NGU model. The geniculate neurons are responsible  //
// for delivering the visual stimulus from the lateral geniculate     //
// nucleus (LGN).                                                     //
//                                                                    //
// Setup:                                                             //
// 1. Specify the neurons by creating a text file of x y z            //
//    coordinates for the neurons, one neuron per line.               //
// 2. Call make_geniculate_cells                                      //
//                                                                    //
//====================================================================//
include ../lib/global_constants.g
include ../lib/utilities_build.g
include ../lib/channels.g

//===================LGN PARAMETER DEFINITIONS =======================//
float LGN_RM = 1/0.03 * 1e3 * 1e-4 //specific membrane resistance (ohms m^2)
float LGN_CM = 1.4 * 1e-6/1e-4 //specific membrane capacitance (farads/m^2)
float LGN_RA = 100.00 * 1e-2 //specific axial resistance (ohms m)
float LGN_ELEAK = -58.4 * 1e-3 //membrane leakage potential (volts)
float LGN_ENa = 40.00 * 1e-3 //sodium reversal potential (volts)
float LGN_GNa = 370.00 * 1e-3/1e-4 //maximum sodium conductance (S/m^2)
float LGN_EK = -90.00 * 1e-3 //potassium reversal potential (volts)
float LGN_GK = 250.00 * 1e-3/1e-4 //maximum potassium conductance (S/m^2)
float LGN_SF = 1.8*PI   //membrane scale factor (dimensionless)

// compartment dimensions diameter(_D) in meters
float LGN_SOMA_D = 20.6 * 1e-6 

// compartment surface areas in m^2
float LGN_SOMA_A = (LGN_SOMA_D * LGN_SOMA_D) * LGN_SF

// soma spike parameters
float LGN_SPIKE_THRESH = 0.0
float LGN_SPIKE_REFRACT = 0.01
float LGN_SPIKE_AMP = 1


/* ******************************************************************
                       make_soma_lgn
     Creates a spherical soma compartment containing sodium and 
     potassium channels
     
     Parameters:
        path           name of the soma object to be created
        
****************************************************************** */  
function make_soma_lgn(path)
   str path

   make_sphere_compartment {path} {LGN_SOMA_D} {LGN_SOMA_A} \
         {LGN_ELEAK}, {LGN_RM}, {LGN_CM}, {LGN_RA}
   make_sodium_channel {path} {LGN_GNa} {LGN_ENa} {LGN_SOMA_A}
   make_potassium_channel {path} {LGN_GK} {LGN_EK} {LGN_SOMA_A}
   make_spike {path} {LGN_SPIKE_THRESH} {LGN_SPIKE_REFRACT} {LGN_SPIKE_AMP}
end


/* ******************************************************************
                       make_geniculate_cells
     Creates a population of geniculate cells with names of the form
     {root}/cell#. 
     
     Parameters:
        coord_file     name of text file containing neuron positions 
        root           parent of all geniculate neurons
     
****************************************************************** */  
function make_geniculate_cells (coord_file, root)
   str coord_file, root

   create neutral {root}
   str parent = {root}@"/cell"
   read_coords {coord_file} {parent}

   str name
   foreach name  ({el {parent}#})
      make_soma_lgn {name}/soma
   end
end

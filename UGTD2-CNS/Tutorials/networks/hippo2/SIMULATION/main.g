// genesis 2.2
// Kerstin Menne
// Luebeck, 18.12.2001
// main script for the simulation consisting of a network of pyramidal cells
// and interneurons and extracellular field potential recordings
// final version for diploma thesis

include constants41.g // file containing global constants

include Ca_chan.g // Ca channel prototype for pyr and interneuron  
include K_AHP_chan.g // K_AHP channel prototype for pyr and interneuron
include K_A_chan.g // K_A channel prototype for pyr and interneuron
include K_C_chan.g // K_C channel prototype for pyr and interneuron
include K_DR_chan.g // K_DR channel prototype for pyr and interneuron
include Na_chan.g // Na channel prototype for pyr and interneuron

include AMPA_chan.g // AMPA channel for pyr and interneuron
include NMDA_chan.g // NMDA channel for pyr
include GABA_A_chan.g // GABA_A channel for pyr
include GABA_B_chan.g // GABA_B channel for pyr

include spikegenpyr.g // spikegenerator for pyramidal cell axon
include spikegenint.g // spikegenerator for interneuron axon

include make_pyramidal.g // create the prototype elements
include make_interneuron.g // create the prototype elements

include network41.g // network functions and randomizations
include electrodes.g // functions for the implementation of efield objects
include afferent_input41.g // function to create randomspike element

include ascii41.g // file defining function for ascii-output

// Let's go!
include cell_arrays41.g //  creation of cells and cell arrays
include connections.g // creation of connections between cells, 
			 // synaptic weights and delays
include provide_input41.g // array of randomspike elements and their 
			  // connections: afferent input
include r_of_interest.g // realize different opening angles of electrodes

include ascii_output41.g // creation of ascii-files
include spikehist2409.g // save times of spike initiation

include hsolver.g // creation of hsolve-elements, needed for implicite
                  // Crank Nicholson integration method

setmethod 11

//check  // only issues warnings that compartments taken over by hsolve would
         // not get issued for simulation
reset








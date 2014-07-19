//======== CREATE SYNAPSES FROM STELLATE NEURONS FOR NGU MODEL =======//
// This file contains functions to create a synapses from the         //
// stellate neurons.                                                  //
//                                                                    //                                                                  
// Setup:                                                             //
// 1. Call make_stellate_synapses                                     //
//                                                                    //
// Modeling notes:                                                    //
// The stellate synapses are made to lateral, medial,and stellate     //
// neurons that are within a specified radius of a stellate neuron.   //
// The synapses contain both GABA_A and GABA_B receptors.             //
// Self synapses are not allowed.                                     //
//                                                                    //
// Different synaptic weights are used for synapses on excitatory     //
// neurons that are close to the LGN than are far from the LGN.       //
// Near weights are used for neurons whose position satisfies         //
// x > 1.0 and y < 0.6. Far weights are used for other neurons.       //
//                                                                    //                                                         
//====================================================================//
include ../lib/global_constants.g
include ../lib/synapses.g

//=============== LOCATION OF STELLATE SYNAPSE TARGETS ================//
str STE_LAT_TARGET = "/apical3"  // Lateral target of stellate synapse
str STE_MED_TARGET = "/dend3"    // Medial target of stellate synapse
str STE_STE_TARGET = "/dend11"   // Stellate target of stellate synapse

//=============== STELLATE SYNAPSE TARGET NAMES =======================//
str STE_LAT_SYNAPSE = "stel_lat"
str STE_MED_SYNAPSE = "stel_med"
str STE_STE_SYNAPSE = "stel_stel"

//============== SYNAPTIC WEIGHTS NEAR AND FAR FROM LGN ==============//
float STE_LAT_WA_N = 7.8  // Weight of stellate-lateral GABA_A synapse near
float STE_LAT_WA_F = 1.9  // Weight of stellate-lateral GABA_A synapse far
float STE_LAT_WB_N = 0.02  // Weight of stellate-lateral GABA_B synapse near
float STE_LAT_WB_F = 0.002  // Weight of stellate-lateral GABA_B synapse far
float STE_MED_WA_N = 2.3   // Weight of stellate-medial GABA_A synapse near
float STE_MED_WA_F = 1.37   // Weight of stellate-medial GABA_A synapse far
float STE_MED_WB_N = 0.01  // Weight of stellate-medial GABA_B synapse near
float STE_MED_WB_F = 0.001  // Weight of stellate-medial GABA_B synapse far
float STE_STE_WA = 0.1  // Weight of stellate-stellate GABA_A synapse
float STE_STE_WB = 2.5e-4   // Weight of stellate-stellate GABA_B synapse
float STE_X_NEAR_CUTOFF = 1.0
float STE_Y_NEAR_CUTOFF = 0.6

//============= SYNAPSES FROM STELLATE - EFFECTIVE DISTANCES ==========//
float STE_LAT_R = 0.350
float STE_MED_R = 0.350
float STE_STE_R = 0.350

//===================== STELLATE SYNAPTIC PARAMETERS ==================//
float STE_GS = 5e-9
float STE_DELAY_FACTOR = 1e-3/ 0.05

//========================== GABA_A PARAMETERS ========================//
float STE_TA = 1.7e-3
float STE_TTA = 1.7e-3
float STE_IA = -70.0e-3

//========================== GABA_B PARAMETERS ========================//
float STE_TB = 500e-3
float STE_TTB = 500e-3
float STE_IB = -90e-3

//============= SYNAPSE COUNTS FOR DEBUGGING ==========================//
int ste_lat_count = 0 
int ste_med_count = 0
int ste_ste_count = 0


/* ******************************************************************
                 create_stellate_synapses_for_group
     Create a synapse for each member of the root group. The synapse 
     contains a GABA_A and a GABA_B receptor that will sum
     the contributions of all stellate neuron sources that impinge on
     the neuron
     
     Parameters:
        root           root of the neuron group hierarchy
        target         target compartment for the group
        syn_name       base name of synapse for this group

****************************************************************** */  
function create_stellate_synapses_for_group (root, target, syn_name)
     str root, target, syn_name                            
  
     str name, dest
     str syn_chan_a = {syn_name}@"_a"
     str syn_chan_b = {syn_name}@"_b"
     foreach name  ({el {{root}@"/cell"}#})
         dest = {name}@{target}    
         // GABA_A receptor
         make_synapse {dest} {syn_chan_a} {STE_GS} {STE_IA} {STE_TA} {STE_TTA}
   
        // GABA_B receptor
        make_synapse {dest} {syn_chan_b} {STE_GS} {STE_IB} {STE_TB} {STE_TTB}   
     end
end


/* ******************************************************************
                connect_stellate_synapse_group
     Connects synapses for each member of the root group within a 
     specified radius of the src stellate neuron
     
     Parameters:
        root           root of the neuron group hierarchy
        src            stellate neuron source
        syn_name       base name of synapse for this group
        target         target compartment for the group
        x_ste          x coordinate for the stellate source
        y_ste          y coordinate for the stellate source
        radius         effective distance of synapse
        weight_a       synaptic weight for GABA_A 
        weight_b       synaptic weight for GABA_B
         
      Returns:  number of synapses created for this src
****************************************************************** */  
function connect_stellate_synapse_group(root, src, syn_name, target, \
                                x_ste, y_ste, radius, weight_a, weight_b)
   str root, src, syn_name, target
   float x_ste, y_ste, radius, weight_a, weight_b
   
   str dest, name
   str syn_chan_a = {{syn_name}@"_a"}
   str syn_chan_b = {{syn_name}@"_b"}
   str src_object = {src}@"/soma/spike"
   int syn_count = 0
   float x, y, dist, tdelay
   foreach name  ({el {{root}@"/cell"}#})
      x = {getfield {name} x}
      y = {getfield {name} y}
      dist = {sqrt  {(x_ste - x)**2 + (y_ste - y)**2} }
      if (dist <= radius && {strcmp {src} {name}} != 0)
         tdelay = {dist} * STE_DELAY_FACTOR //sec
         dest = {name}@{target}
         connect_synapse {src_object} {dest} {syn_chan_a} {tdelay} {weight_a}
         connect_synapse {src_object} {dest} {syn_chan_b} {tdelay} {weight_b}
         syn_count = syn_count + 1
      end
   end 
   return syn_count
 end
 
/* ******************************************************************
                 connect_stellate_lateral_synapses
     Connects synapses containing a GABA_A and a GABA_B receptor from 
     the stellate src neuron to the destination lateral neuron
     
     Parameters:
        root           root of lateral neuron hierarchy
        src            stellate neuron source
        x_ste          x coordinate of the stellate source neuron
        y_ste          y coordinate of the stellate source neuron
****************************************************************** */  
function connect_stellate_lateral_synapses (root, src, x_ste, y_ste)
   str root, src
   float x_ste, y_ste

   float weight_a, weight_b
   if (x_ste > STE_X_NEAR_CUTOFF && y_ste < STE_Y_NEAR_CUTOFF)
      weight_a = STE_LAT_WA_N
      weight_b = STE_LAT_WB_N
   else
      weight_a = STE_LAT_WA_F
      weight_b = STE_LAT_WB_F
   end

   ste_lat_count = ste_lat_count + {connect_stellate_synapse_group \
                   {root} {src} {STE_LAT_SYNAPSE} {STE_LAT_TARGET} \
                   {x_ste} {y_ste} {STE_LAT_R} {weight_a} {weight_b}}                            
end


/* ******************************************************************
                 connect_stellate_medial_synapses
     Connects synapses containing a GABA_A and a GABA_B receptor from 
     the stellate src neuron to the destination medial neuron
     
     Parameters:
        root           root of medial neuron hierarchy
        src            stellate neuron source
        x_ste          x coordinate of the stellate source neuron
        y_ste          y coordinate of the stellate source neuron
****************************************************************** */ 
function connect_stellate_medial_synapses (root, src, x_ste, y_ste)
   str root, src
   float x_ste, y_ste

   float weight_a, weight_b
   if (x_ste > STE_X_NEAR_CUTOFF && y_ste < STE_Y_NEAR_CUTOFF)
      weight_a = STE_MED_WA_N
      weight_b = STE_MED_WB_N
   else
      weight_a = STE_MED_WA_F
      weight_b = STE_MED_WB_F
   end

   ste_med_count = ste_med_count + {connect_stellate_synapse_group \
                   {root} {src} {STE_MED_SYNAPSE} {STE_MED_TARGET} \
                   {x_ste} {y_ste} {STE_MED_R} {weight_a} {weight_b}}                            
end


/* ******************************************************************
              connect_stellate_stellate_synapses
     Connects synapses containing a GABA_A and a GABA_B receptor from 
     the stellate src neuron to the destination stellate neuron
     
     Parameters:
        root           root of stellate neuron hierarchy
        src            stellate neuron source
        x_ste          x coordinate of the stellate source neuron
        y_ste          y coordinate of the stellate source neuron
        
     Note: Self synapses are not allowed.
****************************************************************** */
function connect_stellate_stellate_synapses (root, src, x_ste, y_ste)
   str root, src
   float x_ste, y_ste

   ste_ste_count = ste_ste_count + {connect_stellate_synapse_group \
                   {root} {src} {STE_STE_SYNAPSE} {STE_STE_TARGET} \
                   {x_ste} {y_ste} {STE_STE_R} {STE_STE_WA} {STE_STE_WB}}                          
 end


/* ******************************************************************
                  make_stellate_synapses
     Creates the synapses from stellate neurons in the NGU model
     
     Parameters:
        ste_root            root of the hierarchy for stellate neurons
        lat_root            root of the hierarchy for lateral neurons                   
        med_root            root of the hierarchy for medial neurons  
****************************************************************** */ 
function make_stellate_synapses (ste_root, lat_root, med_root)
   str ste_root, lat_root, med_root

  //Start by creating a representative synapse for each potential target neuron
   create_stellate_synapses_for_group {lat_root} {STE_LAT_TARGET} {STE_LAT_SYNAPSE} 
   create_stellate_synapses_for_group {med_root} {STE_MED_TARGET} {STE_MED_SYNAPSE} 
   create_stellate_synapses_for_group {ste_root} {STE_STE_TARGET} {STE_STE_SYNAPSE} 
   
   //Now create spikes from stellate source neurons
   str name
   int count = 0;
   float x_ste, y_ste
   foreach name  ({el {{ste_root}@"/cell"}#})
      count = count + 1;
      x_ste = {getfield {name} x}
      y_ste = {getfield {name} y}
      connect_stellate_lateral_synapses  {lat_root} {name} {x_ste} {y_ste}
      connect_stellate_medial_synapses {med_root} {name} {x_ste} {y_ste}
      connect_stellate_stellate_synapses {ste_root} {name} {x_ste} {y_ste}
   end

   if (ECHO_ON == 1)
      echo "Created synapses for" {count} "stellate source neurons"
      echo "  " {ste_lat_count} "synapses from stellate to lateral neurons"     
      echo "  " {ste_med_count} "synapses from stellate to medial neurons"     
      echo "  " {ste_ste_count} "synapses from stellate to stellate neurons"   
   end;
end

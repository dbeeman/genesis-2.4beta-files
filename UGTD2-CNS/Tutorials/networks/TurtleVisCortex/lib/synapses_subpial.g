//======== CREATE SYNAPSES FROM SUBPIAL NEURONS FOR NGU MODEL ========//
// This file contains functions to create a synapses from the         //
// subpial neurons.                                                   //
//                                                                    //                                                           
// Setup:                                                             //
// 1. Call make_subpial_synapses                                      //
//                                                                    //
// Modeling notes:                                                    //
// The subpial synapses are made to lateral, medial,and subpial       //
// neurons that are within a specified radius of a stellate neuron.   //
// The synapses contain both GABA_A and GABA_B receptors.             //
// Self synapses are not allowed.                                     //
//                                                                    //
// Different synaptic weights are used for synapses that are close    //
// to the LGN: near weights are used for neurons whose position       //
// satisfies x > 1.0 and y < 0.6. Far weights are used for other      //
// neurons.                                                           //                                                   
//                                                                    //
//====================================================================//
include ../lib/global_constants.g
include ../lib/synapses.g

//============ LOCATION OF SUBPIAL SYNAPSE TARGETS ====================//
str SUB_LAT_TARGET = "/apical4"  // Lateral target of subpial synapse
str SUB_MED_TARGET = "/dend2"    // Medial target of subpial synapse
str SUB_SUB_TARGET = "/dend24"   // Subpial target of subpial synapse

//============= SUBPIAL SYNAPSE TARGET NAMES ==========================//
str SUB_LAT_SYNAPSE = "subp_lat"
str SUB_MED_SYNAPSE = "subp_med"
str SUB_SUB_SYNAPSE = "subp_subp"

//============== SYNAPTIC WEIGHTS NEAR AND FAR FROM LGN ==============//
float SUB_LAT_WA_N = 7.8    // Weight of subpial-lateral GABA_A synapse near
float SUB_LAT_WA_F = 1.9    // Weight of subpial-lateral GABA_A synapse far
float SUB_LAT_WB_N = 0.02   // Weight of subpial-lateral GABA_B synapse near
float SUB_LAT_WB_F = 0.002  // Weight of subpial-lateral GABA_B synapse far
float SUB_MED_WA_N = 2.3    // Weight of subpial-medial GABA_A synapse near
float SUB_MED_WA_F = 1.37   // Weight of subpial-medial GABA_A synapse far
float SUB_MED_WB_N = 0.01   // Weight of subpial-medial GABA_B synapse near
float SUB_MED_WB_F = 0.001  // Weight of subpial-medial GABA_B synapse far
float SUB_SUB_WA = 0.1      // Weight of subpial-subpial GABA_A synapse
float SUB_SUB_WB = 2.5e-4   // Weight of subpial-subpial GABA_B synapse

float SUB_X_NEAR_CUTOFF = 1.0
float SUB_Y_NEAR_CUTOFF = 0.6

//============= SYNAPSES FROM SUBPIAL - EFFECTIVE DISTANCES ===========//
float SUB_LAT_R = 0.350
float SUB_MED_R = 0.350
float SUB_SUB_R = 0.350

//===================== SUBPIAL SYNAPTIC PARAMETERS ===================//
float SUB_GS = 3e-9
float SUB_GS2 = 5e-9
float SUB_DELAY_FACTOR = 1e-3/ 0.05

//=============== SUBPIAL PARAMETERS FOR GABA_A RECEPTORS =============//
float SUB_TA = 1.7e-3
float SUB_TTA = 1.7e-3
float SUB_IA = -70.0e-3

//=============== SUBPIAL PARAMETERS FOR GABA_B RECEPTORS =============//
float SUB_TB = 500e-3
float SUB_TTB = 500e-3
float SUB_IB = -90e-3

//============= SYNAPSE COUNTS FOR DEBUGGING ==========================//
int sub_lat_count = 0 
int sub_med_count = 0
int sub_sub_count = 0

/* ******************************************************************
                       create_subpial_synapses_for_group
     Create a synapse for each member of the root group. The synapse 
     contains a GABA_A and a GABA_B receptor that will sum
     the contributions of all subpial neuron sources that impinge on
     the neuron
     
     Parameters:
        root           root of the neuron group hierarchy
        target         target compartment for the group
        syn_name       base name of synapse for this group

****************************************************************** */  
function create_subpial_synapses_for_group (root, target, syn_name, gmax)
     str root, target, syn_name  
     float gmax                          
  
     str name, dest
     str syn_chan_a = {syn_name}@"_a"
     str syn_chan_b = {syn_name}@"_b"
     foreach name  ({el {{root}@"/cell"}#})
         dest = {name}@{target}    
         // GABA_A receptor
         make_synapse {dest} {syn_chan_a} {gmax} {SUB_IA} {SUB_TA} {SUB_TTA}
   
        // GABA_B receptor
        make_synapse {dest} {syn_chan_b} {gmax} {SUB_IB} {SUB_TB} {SUB_TTB}      
     end
end


/* ******************************************************************
                       connect_subpial_synapse_group
     Connects synapses for each member of the root group within a 
     specified radius of the src subpial neuron
     
     Parameters:
        root           root of the neuron group hierarchy
        src            subpial soma source
        syn_name       base name of synapse for this group
        target         target compartment for the group
        x_sub          x coordinate for the subpial source
        y_sub          y coordinate for the subpial source
        radius         effective distance of synapse
        weight_a       synaptic weight for GABA_A 
        weight_b       synaptic weight for GABA_B
        gmax           peak conductance

      Returns:  number of synapses created for this src
****************************************************************** */  
function connect_subpial_synapse_group(root, src, syn_name, target, \
                                x_sub, y_sub, radius, weight_a, weight_b)
   str root, src, syn_name, target
   float x_sub, y_sub, radius, weight_a, weight_b
   
   str dest, name
   str syn_chan_a = {{syn_name}@"_a"}
   str syn_chan_b = {{syn_name}@"_b"}
   str src_object = {src}@"/soma/spike" 
   int syn_count = 0
   float x, y, dist, tdelay
   foreach name  ({el {{root}@"/cell"}#})
      x = {getfield {name} x}
      y = {getfield {name} y}
      dist = {sqrt  {(x_sub - x)**2 + (y_sub - y)**2} }
      if (dist <= radius && {strcmp {src} {name}} != 0)
         tdelay = {dist} * SUB_DELAY_FACTOR //sec
         dest = {name}@{target}
         connect_synapse {src_object} {dest} {syn_chan_a} {tdelay} {weight_a}
         connect_synapse {src_object} {dest} {syn_chan_b} {tdelay} {weight_b}
         syn_count = syn_count + 1
      end
   end 
   return syn_count
 end
/* ******************************************************************
                       connect_subpial_lateral_synapses
     Connects synapses containing a GABA_A and a GABA_B receptor from 
     the subpial src neuron to the destination lateral neuron
     
     Parameters:
        root           root of lateral neuron hierarchy
        src            subpial soma source
        x_sub          x coordinate of the subpial source neuron
        y_sub          y coordinate of the subpial source neuron
****************************************************************** */ 
function connect_subpial_lateral_synapses (root, src, x_sub, y_sub)
   str root, src
   float x_sub, y_sub

   float weight_a, weight_b
   if (x_sub > SUB_X_NEAR_CUTOFF && y_sub < SUB_Y_NEAR_CUTOFF)
      weight_a = SUB_LAT_WA_N
      weight_b = SUB_LAT_WB_N
   else
      weight_a = SUB_LAT_WA_F
      weight_b = SUB_LAT_WB_F
   end
   
   sub_lat_count = sub_lat_count + {connect_subpial_synapse_group \
                   {root} {src} {SUB_LAT_SYNAPSE} {SUB_LAT_TARGET} \
                   {x_sub} {y_sub} {SUB_LAT_R} {weight_a} {weight_b}}                            
end


/* ******************************************************************
                       connect_subpial_medial_synapses
     Connects synapses containing a GABA_A and a GABA_B receptor from 
     the subpial src neuron to the destination medial neuron
     
     Parameters:
        root           root of medial neuron hierarchy
        src            subpial soma source
        x_sub          x coordinate of the subpial source neuron
        y_sub          y coordinate of the subpial source neuron
****************************************************************** */ 
function connect_subpial_medial_synapses (root, src, x_sub, y_sub)
   str root, src
   float x_sub, y_sub
  
   float weight_a, weight_b
   if (x_sub > SUB_X_NEAR_CUTOFF && y_sub < SUB_Y_NEAR_CUTOFF)
      weight_a = SUB_MED_WA_N
      weight_b = SUB_MED_WB_N
   else
      weight_a = SUB_MED_WA_F
      weight_b = SUB_MED_WB_F
   end

   sub_med_count = sub_med_count + {connect_subpial_synapse_group \
                   {root} {src} {SUB_MED_SYNAPSE} {SUB_MED_TARGET} \
                   {x_sub} {y_sub} {SUB_MED_R} {weight_a} {weight_b}}                        
end


/* ******************************************************************
                       connect_subpial_subpial_synapses
     Connects synapses containing a GABA_A and a GABA_B receptor from 
     the subpial src neuron to the destination subpial neuron
     
     Parameters:
        root           root of subpial neuron hierarchy
        src            subpial soma source
        x_sub          x coordinate of the subpial source neuron
        y_sub          y coordinate of the subpial source neuron
        
        Note: Self synapses are not allowed.
****************************************************************** */ 
function connect_subpial_subpial_synapses (root, src, x_sub, y_sub)
   str root, src
   float x_sub, y_sub

   sub_sub_count = sub_sub_count + {connect_subpial_synapse_group \
                   {root} {src} {SUB_SUB_SYNAPSE} {SUB_SUB_TARGET} \
                  {x_sub} {y_sub} {SUB_SUB_R} {SUB_SUB_WA} {SUB_SUB_WB}}                          
end


/* ******************************************************************
                       make_subpial_synapses
     Creates the synapses from subpial neurons in the NGU model
     
     Parameters:
        sub_root            root of the hierarchy for subpial neurons
        lat_root            root of the hierarchy for lateral neurons                   
        med_root            root of the hierarchy for medial neurons  
****************************************************************** */ 
function make_subpial_synapses (sub_root, lat_root, med_root)
   str sub_root, lat_root, med_root

   
   //Start by creating a representative synapse for each potential target neuron
   create_subpial_synapses_for_group {lat_root} {SUB_LAT_TARGET} \
                            {SUB_LAT_SYNAPSE} {SUB_GS}
   create_subpial_synapses_for_group {med_root} {SUB_MED_TARGET} \
                            {SUB_MED_SYNAPSE} {SUB_GS}
   create_subpial_synapses_for_group {sub_root} {SUB_SUB_TARGET} \
                            {SUB_SUB_SYNAPSE} {SUB_GS2} 
   
   //Now create spikes from subpial source neurons
   str name
   int count = 0;
   float x_sub, y_sub
   foreach name  ({el {{sub_root}@"/cell"}#})
      count = count + 1;
      x_sub = {getfield {name} x}
      y_sub = {getfield {name} y}
      connect_subpial_lateral_synapses {lat_root} {name} {x_sub} {y_sub}
      connect_subpial_medial_synapses {med_root} {name} {x_sub} {y_sub}
      connect_subpial_subpial_synapses {sub_root} {name} {x_sub} {y_sub}
   end

   if (ECHO_ON == 1)
      echo "Created synapses for" {count} "subpial source neurons"
      echo "  " {sub_lat_count} "synapses from subpial to lateral neurons"     
      echo "  " {sub_med_count} "synapses from subpial to medial neurons"     
      echo "  " {sub_sub_count} "synapses from subpial to subpial neurons"   
   end;
end

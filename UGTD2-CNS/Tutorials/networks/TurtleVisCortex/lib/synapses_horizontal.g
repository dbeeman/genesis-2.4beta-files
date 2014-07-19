//====== CREATE SYNAPSES FROM HORIZONTAL NEURONS FOR NGU MODEL ========//
// This file contains functions to create a synapses from the         //
// horizontal neurons.                                                //
//                                                                    //                                                                  
// Setup:                                                             //
// 1. Call make_horizontal_synapses                                   //
//                                                                    //
// Modeling notes:                                                    //
// The horizontal synapses are made to lateral and medial neurons     //
// that are within a specified radius of a horizontal neuron. The     //
// synapses contain both GABA_A and GABA_B receptors.                 //
//                                                                    //
// Different synaptic weights are used for synapses that are close    //
// to the LGN: near weights are used for neurons whose position       //
// satisfies x > 1.0 and y < 0.6. Far weights are used for other      //
// neurons.                                                           //
//====================================================================//
include ../lib/global_constants.g
include ../lib/synapses.g

//========= LOCATION OF HORIZONTAL SYNAPSE TARGETS ===================//
str HOR_LAT_TARGET = "/basal4"  // Lateral target of horizontal synapse
str HOR_MED_TARGET = "/dend9"   // Medial target of horizontal synapse

//=============== HORIZONTAL SYNAPSE TARGET NAMES ====================//
str HOR_LAT_SYNAPSE = "hor_lat"
str HOR_MED_SYNAPSE = "hor_med"

//============== SYNAPTIC WEIGHTS NEAR AND FAR FROM LGN ==============//
float HOR_LAT_WA_N = 24.0  // Weight of horizontal-lateral GABA_A synapse near
float HOR_LAT_WA_F = 7.6   // Weight of horizontal-lateral GABA_A synapse far
float HOR_LAT_WB_N = 0.02  // Weight of horizontal-lateral GABA_B synapse near
float HOR_LAT_WB_F = 0.002 // Weight of horizontal-lateral GABA_B synapse far
float HOR_MED_WA_N = 8.7   // Weight of horizontal-medial GABA_A synapse near
float HOR_MED_WA_F = 5.5   // Weight of horizontal-medial GABA_A synapse far
float HOR_MED_WB_N = 0.01  // Weight of horizontal-medial GABA_B synapse near
float HOR_MED_WB_F = 0.002 // Weight of horizontal-medial GABA_B synapse far

float HOR_X_NEAR_CUTOFF = 1.0
float HOR_Y_NEAR_CUTOFF = 0.6

//=========== SYNAPSES FROM HORIZONTAL - EFFECTIVE DISTANCES =========//
float HOR_LAT_R = 0.350
float HOR_MED_R = 0.350

//================== HORIZONTAL SYNAPTIC PARAMETERS ==================//
float HOR_GS = 5e-9
float HOR_DELAY_FACTOR = 1e-3/ 0.05

//=========== HORIZONTAL PARAMETERS FOR GABA_A RECEPTORS =============//
float HOR_TA = 1.7e-3
float HOR_TTA = 1.7e-3
float HOR_IA = -70.0e-3

//=========== HORIZONTAL PARAMETERS FOR GABA_B RECEPTORS =============//
float HOR_TB = 500e-3
float HOR_TTB = 500e-3
float HOR_IB = -90e-3

//============= SYNAPSE COUNTS FOR DEBUGGING =========================//
int hor_lat_count = 0 
int hor_med_count = 0

/* ******************************************************************
                       create_horizontal_synapses_for_group
     Create a synapse for each member of the root group. The synapse 
     contains a GABA_A and a GABA_B receptor that will sum
     the contributions of all horizontal neuron sources that impinge on
     the neuron
     
     Parameters:
        root           root of the neuron group hierarchy
        target         target compartment for the group
        syn_name       base name of synapse for this group

****************************************************************** */  
function create_horizontal_synapses_for_group (root, target, syn_name)
     str root, target, syn_name                            
  
     str name, dest
     str syn_chan_a = {syn_name}@"_a"
     str syn_chan_b = {syn_name}@"_b"
     foreach name  ({el {{root}@"/cell"}#})
         dest = {name}@{target}    
         // GABA_A receptor
         make_synapse {dest} {syn_chan_a} {HOR_GS} {HOR_IA} {HOR_TA} {HOR_TTA}
   
        // GABA_B receptor
        make_synapse {dest} {syn_chan_b} {HOR_GS} {HOR_IB} {HOR_TB} {HOR_TTB}      
     end
end


/* ******************************************************************
                       connect_horizontal_synapse_group
     Connects synapses for each member of the root group within a 
     specified radius of the src horizontal neuron
     
     Parameters:
        root           root of the neuron group hierarchy
        src            horizontal neuron source
        syn_name       base name of synapse for this group
        target         target compartment for the group
        x_hor          x coordinate for the horizontal source
        y_hor          y coordinate for the horizontal source
        radius         effective distance of synapse
        weight_a       synaptic weight for GABA_A 
        weight_b       synaptic weight for GABA_B

      Returns:  number of synapses created for this src 
****************************************************************** */  
function connect_horizontal_synapse_group(root, src, syn_name, target, \
                                x_hor, y_hor, radius, weight_a, weight_b)
   str root, src, syn_name, target
   float x_hor, y_hor, radius, weight_a, weight_b
   
   str dest, name
   str syn_chan_a = {syn_name}@"_a"
   str syn_chan_b = {syn_name}@"_b"
   str src_object = {src}@"/soma/spike"
   int syn_count = 0
   float x, y, dist, tdelay
   foreach name  ({el {{root}@"/cell"}#})
      x = {getfield {name} x}
      y = {getfield {name} y}
      dist = {sqrt  {(x_hor - x)**2 + (y_hor - y)**2} }
      if (dist <= radius)
         tdelay = {dist} * HOR_DELAY_FACTOR //sec
         dest = {name}@{target}
         connect_synapse {src_object} {dest} {syn_chan_a} {tdelay} {weight_a}
         connect_synapse {src_object} {dest} {syn_chan_b} {tdelay} {weight_b}
         syn_count = syn_count + 1
      end
   end 
   return syn_count
 end


/* ******************************************************************
                       connect_horizontal_lateral_synapses
     Connects synapses containing a GABA_A and a GABA_B receptor from 
     the horizontal src neuron to the destination lateral neuron
     
     Parameters:
        root           root of lateral neuron hierarchy
        src            horizontal soma source
        x_hor          x coordinate of the horizontal source neuron
        y_hor          y coordinate of the horizontal source neuron
****************************************************************** */  
function connect_horizontal_lateral_synapses (root, src, x_hor, y_hor)                                        
   str root, src
   float x_hor, y_hor

   float weight_a, weight_b
   if (x_hor > HOR_X_NEAR_CUTOFF && y_hor < HOR_Y_NEAR_CUTOFF)
      weight_a = HOR_LAT_WA_N
      weight_b = HOR_LAT_WB_N
   else
      weight_a = HOR_LAT_WA_F
      weight_b = HOR_LAT_WB_F
   end

   hor_lat_count = hor_lat_count + {connect_horizontal_synapse_group \
                    {root} {src} {HOR_LAT_SYNAPSE} {HOR_LAT_TARGET} \
                    {x_hor} {y_hor} {HOR_LAT_R} {weight_a} {weight_b}}                       
end


/* ******************************************************************
                       connect_horizontal_medial_synapses
     Connects synapses containing a GABA_A and a GABA_B receptor from 
     the horizontal src neuron to the destination medial neuron
     
     Parameters:
        root           root of medial neuron hierarchy
        src            horizontal soma source
        x_hor          x coordinate of the horizontal source neuron
        y_hor          y coordinate of the horizontal source neuron
 
****************************************************************** */  
function connect_horizontal_medial_synapses (root, src, x_hor, y_hor)                                        
   str root, src
   float x_hor, y_hor

   float weight_a, weight_b
   if (x_hor > HOR_X_NEAR_CUTOFF && y_hor < HOR_Y_NEAR_CUTOFF)
      weight_a = HOR_MED_WA_N
      weight_b = HOR_MED_WB_N
   else
      weight_a = HOR_MED_WA_F
      weight_b = HOR_MED_WB_F
   end
  
   hor_med_count = hor_med_count + {connect_horizontal_synapse_group \
                   {root} {src} {HOR_MED_SYNAPSE} {HOR_MED_TARGET} \
                   {x_hor} {y_hor} {HOR_MED_R} {weight_a} {weight_b}}                            
end


/* ******************************************************************
                       make_horizontal_synapses
     Creates the synapses from horizontal neurons in the NGU model
     
     Parameters:
        hor_root            root of the hierarchy for horizontal neurons
        lat_root            root of the hierarchy for lateral neurons
        med_root            root of the hierarchy for medial neurons                   
 
****************************************************************** */  
function make_horizontal_synapses(hor_root, lat_root, med_root)
   str hor_root, lat_root, med_root
   float x_hor, y_hor
   
   //Start by creating a representative synapse for each potential target neuron
   create_horizontal_synapses_for_group {lat_root} {HOR_LAT_TARGET} {HOR_LAT_SYNAPSE} 
   create_horizontal_synapses_for_group {med_root} {HOR_MED_TARGET} {HOR_MED_SYNAPSE} 
   
   //Now create spikes from horizontal source neurons
   str name, src
   int count = 0;
   foreach name  ({el {{hor_root}@"/cell"}#})
      count = count + 1;
      x_hor = {getfield {name} x}
      y_hor = {getfield {name} y}
      connect_horizontal_lateral_synapses {lat_root} {name} {x_hor} {y_hor}
      connect_horizontal_medial_synapses {med_root} {name} {x_hor} {y_hor}
   end

   if (ECHO_ON == 1)
      echo "Created synapses for" {count} "horizontal source neurons"
      echo "  " {hor_lat_count} "synapses from horizontal to lateral neurons"
      echo "  " {hor_med_count} "synapses from horizontal to medial neurons"
   end;
end

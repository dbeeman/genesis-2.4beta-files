//======== CREATE SYNAPSES FROM MEDIAL NEURONS FOR NGU MODEL =========//
// This file contains functions to create a synapses from the         //
// medial neurons.                                                    //
//                                                                    //                                                                  
// Setup:                                                             //
// 1. Call make_medial_synapses                                       //
//                                                                    //
// Modeling notes:                                                    //
// The medial synapses are made to horizontal, lateral, medial,       //
// stellate and subpial neurons that are within a specified radius    //
// of a medial neuron. The synapses contain both AMPA and NMDA        //
// receptors. The synaptic weights fall off with a Gaussian weighting //
// factor. Self synapses are not allowed.                             //
//====================================================================//
include ../lib/global_constants.g
include ../lib/synapses.g

//=============== LOCATION OF MEDIAL SYNAPSE TARGETS =================//
str MED_HOR_TARGET = "/dend3"    // Horizontal target of medial synapses
str MED_LAT_TARGET = "/basal4"   // Lateral target of medial synapses
str MED_MED_TARGET = "/dend7"    // Medial target of medial synapses
str MED_STE_TARGET = "/dend3"    // Stellate target of medial synapses
str MED_SUB_TARGET = "/dend16"   // Subpial target of medial synapses

//=============== MED SYNAPSE TARGET NAMES ===========================//
str MED_HOR_SYNAPSE = "med_hor"
str MED_LAT_SYNAPSE = "med_lat"
str MED_MED_SYNAPSE = "med_med"
str MED_STE_SYNAPSE = "med_stel"
str MED_SUB_SYNAPSE = "med_subp"

//==================== SYNAPSES FROM MEDIAL - WEIGHTS ================//
float MED_VAR = 1.5
float MED_HOR_WA = 0.02 * MED_VAR  // Weight of medial-horizontal AMPA synapse
float MED_HOR_WN = 0.22 * MED_VAR  // Weight of medial-horizontal NMDA synapse
float MED_LAT_WA = 0.3 * MED_VAR  // Weight of medial-lateral AMPA synapse
float MED_LAT_WN = 0.0167 * MED_VAR  // Weight of medial-lateral NMDA synapse
float MED_MED_WA = 0.4 * MED_VAR   // Weight of medial-medial AMPA synapse
float MED_MED_WN = 0.0167 * MED_VAR  // Weight of medial-medial NMDA synapse
float MED_STE_WA = 0.01 * MED_VAR  // Weight of medial-stellate AMPA synapse
float MED_STE_WN = 0.11 * MED_VAR   // Weight of medial-stellate NMDA synapse
float MED_SUB_WA = 0.01 * MED_VAR  // Weight of medial-subpial AMPA synapse
float MED_SUB_WN = 0.11 * MED_VAR   // Weight of medial-subpial NMDA synapse

//============= SYNAPSES FROM MEDIAL - EFFECTIVE DISTANCES ===========//
float MED_HOR_R = 0.250
float MED_LAT_R = 0.250
float MED_MED_R = 0.250
float MED_STE_R = 0.250
float MED_SUB_R = 0.250

//===================== MEDIAL SYNAPTIC PARAMETERS ===================//
float MED_GS = 5e-9
float MED_DELAY_FACTOR = 1e-3/ 0.05

//========================== AMPA PARAMETERS =========================//
float MED_TA = 3.0e-3
float MED_TTA = 0.3e-3
float MED_EA = 0.0e-3

//========================== NMDA PARAMETERS =========================//
float MED_TN = 80.0e-3
float MED_TTN = 0.67e-3
float MED_EN = 0.0

//============= SYNAPSE COUNTS FOR DEBUGGING =========================//
int med_hor_count = 0 
int med_lat_count = 0 
int med_med_count = 0
int med_ste_count = 0
int med_sub_count = 0

/* ******************************************************************
                       create_medial_synapses_for_group
     Create a synapse for each member of the root group. The synapse 
     contains an AMPA and an NMDA receptor that will sum
     the contributions of all medial neuron sources that impinge on
     the neuron
     
     Parameters:
        root           root of the neuron group hierarchy
        target         target compartment for the group
        syn_name       base name of synapse for this group

****************************************************************** */  
function create_medial_synapses_for_group (root, target, syn_name)
     str root, target, syn_name                            
  
     str name, dest
     str syn_chan_a = {syn_name}@"_a"
     str syn_chan_n = {syn_name}@"_n"
     foreach name  ({el {{root}@"/cell"}#})
         dest = {name}@{target}          
         // AMPA receptor
         make_synapse {dest} {syn_chan_a} {MED_GS} {MED_EA} {MED_TA} {MED_TTA}

         // NMDA receptor
         make_synapse_nmda {dest} {syn_chan_n} {MED_GS} {MED_EN} {MED_TN} {MED_TTN}
     end
end


/* ******************************************************************
                       connect_medial_synapse_group
     Connects synapses  for each member of the root group within a 
     specified radius of the src medial neuron
     
     Parameters:
        root           root of the neuron group hierarchy
        src            medial neuron source
        syn_name       base name of synapse for this group
        target         target compartment for the group
        x_med          x coordinate for the medial source
        y_med          y coordinate for the meidal source
        radius         effective distance of synapse
        weight_fac_a   synaptic weight factor for AMPA
        weight_fac_n   synaptic weight factor for NMDA
 
      Returns:  number of synapses created for this src
****************************************************************** */  
function connect_medial_synapse_group(root, src, syn_name, target, \
                                x_med, y_med, radius, weight_fac_a, weight_fac_n)                               
   str root, src, syn_name, target
   float x_med, y_med, radius, weight_fac_a, weight_fac_n
   
   str dest, name
   str syn_chan_a = {{syn_name}@"_a"}
   str syn_chan_n = {{syn_name}@"_n"}
   str src_object = {src}@"/soma/spike"
   int syn_count = 0
   float x, y, dist, tdelay, weight_a, weight_n, grade
   float gauss_r = {radius}/MED_VAR
   foreach name  ({el {{root}@"/cell"}#})
      x = {getfield {name} x}
      y = {getfield {name} y}
      dist = {sqrt  {(x_med - x)**2 + (y_med - y)**2} }
      if (dist <= radius && {strcmp {src} {name}} != 0)
         tdelay = {dist} * MED_DELAY_FACTOR //sec
         dest = {name}@{target}
         grade = {gauss {x_med} {x} {y_med} {y} {gauss_r}}
         weight_a = {weight_fac_a} * grade
         weight_n = {weight_fac_n} * grade
         connect_synapse {src_object} {dest} {syn_chan_a} {tdelay} {weight_a}
         connect_synapse {src_object} {dest} {syn_chan_n} {tdelay} {weight_n}
         syn_count = syn_count + 1
      end
   end 
   return syn_count
 end


/* ******************************************************************
                       connect_medial_horizontal_synapses
     Connects synapses containing an AMPA and an NMDA receptor from 
     the medial src neuron to the destination horizontal neuron
     
     Parameters:
        root           root of horizontal neuron hierarchy
        src            medial neuron source
        x_med          x coordinate of the medial source neuron
        y_med          y coordinate of the medial source neuron
****************************************************************** */  
function connect_medial_horizontal_synapses (root, src, x_med, y_med)
   str root, src
   float x_med, y_med

   med_hor_count = med_hor_count + {connect_medial_synapse_group \
                    {root} {src} {MED_HOR_SYNAPSE} {MED_HOR_TARGET}\
                    {x_med} {y_med} {MED_HOR_R} {MED_HOR_WA} {MED_HOR_WN}}                            
end


/* ******************************************************************
                       connect_medial_lateral_synapses
     Connects synapses containing an AMPA and an NMDA receptor from 
     the medial src neuron to the destination lateral neuron
     
     Parameters:
        root           root of lateral neuron hierarchy
        src            medial neuron source
        x_med          x coordinate of the medial source neuron
        y_med          y coordinate of the medial source neuron
****************************************************************** */
function connect_medial_lateral_synapses (root, src, x_med, y_med)
   str root, src
   float x_med, y_med
   
   med_lat_count = med_lat_count + {connect_medial_synapse_group \
                    {root} {src} {MED_LAT_SYNAPSE} {MED_LAT_TARGET} \
                    {x_med} {y_med} {MED_LAT_R} {MED_LAT_WA} {MED_LAT_WN}}                            
end


/* ******************************************************************
                       connect_medial_medial_synapses
     Connects synapses synapse containing an AMPA and an NMDA receptor from 
     the medial src neuron to the destination medial neuron
     
     Parameters:
        root           root of medial neuron hierarchy
        src            medial neuron source
        x_med          x coordinate of the medial source neuron
        y_med          y coordinate of the medial source neuron

     Note: Self synapses are not allowed.
****************************************************************** */
function connect_medial_medial_synapses (root, src,  x_med, y_med)
   str root, src
   float x_med, y_med

   med_med_count = med_med_count + {connect_medial_synapse_group \
                   {root} {src} {MED_MED_SYNAPSE} {MED_MED_TARGET} \
                   {x_med} {y_med} {MED_MED_R} {MED_MED_WA} {MED_MED_WN}}                            
end
  

/* ******************************************************************
                       connect_medial_stellate_synapses
     Connects synapses containing an AMPA and an NMDA receptor from 
     the medial src neuron to the destination stellate neuron
     
     Parameters:
        root           root of stellate neuron hierarchy
        src            medial neuron source
        x_med          x coordinate of the medial source neuron
        y_med          y coordinate of the medial source neuron
****************************************************************** */
function connect_medial_stellate_synapses (root, src, x_med, y_med)
   str root, src
   float x_med, y_med

   med_ste_count = med_ste_count + {connect_medial_synapse_group \
                   {root} {src} {MED_STE_SYNAPSE} {MED_STE_TARGET} \
                   {x_med} {y_med} {MED_STE_R} {MED_STE_WA} {MED_STE_WN}}                            
end


/* ******************************************************************
                       connect_medial_subpial_synapses
     Connects synapses containing an AMPA and an NMDA receptor from 
     the medial src neuron to the destination subpial neuron
     
     Parameters:
        root           root of subpial neuron hierarchy
        src            medial neuron source
        x_med          x coordinate of the medial source neuron
        y_med          y coordinate of the medial source neuron
****************************************************************** */
function connect_medial_subpial_synapses (root, src, x_med, y_med)
   str root, src
   float x_med, y_med

   med_sub_count = med_sub_count + {connect_medial_synapse_group \
                  {root} {src} {MED_SUB_SYNAPSE} {MED_SUB_TARGET} \
                  {x_med} {y_med} {MED_SUB_R} {MED_SUB_WA} {MED_SUB_WN}}                           
end


/* ******************************************************************
                       make_medial_synapses
        Creates the synapses from the medial neurons in the NGU model
     
     Parameters:
        med_root            root of the hierarchy for medial neurons
        hor_root            root of the hierarchy for horizontal neurons
        lat_root            root of the hierarchy for lateral neurons                   
        ste_root            root of the hierarchy for stellate neurons  
        sub_root            root of the hierarchy for subpial neurons  
****************************************************************** */ 
function make_medial_synapses(med_root, hor_root, lat_root, ste_root, sub_root)
   str med_root, hor_root, lat_root, ste_root, sub_root
   
   //Start by creating a representative synapse for each potential target neuron
   create_medial_synapses_for_group {lat_root} {MED_LAT_TARGET} {MED_LAT_SYNAPSE} 
   create_medial_synapses_for_group {med_root} {MED_MED_TARGET} {MED_MED_SYNAPSE} 
   create_medial_synapses_for_group {ste_root} {MED_STE_TARGET} {MED_STE_SYNAPSE} 
   create_medial_synapses_for_group {hor_root} {MED_HOR_TARGET} {MED_HOR_SYNAPSE} 
   create_medial_synapses_for_group {sub_root} {MED_SUB_TARGET} {MED_SUB_SYNAPSE} 
   
   //Now create spikes from medial source neurons
   str name, src
   int count = 0;
   float x_med, y_med
   foreach name  ({el {{med_root}@"/cell"}#})
      count = count + 1;
      x_med = {getfield {name} x}
      y_med = {getfield {name} y}
      connect_medial_lateral_synapses {lat_root} {name} {x_med} {y_med}
      connect_medial_medial_synapses {med_root} {name} {x_med} {y_med}
      connect_medial_stellate_synapses {ste_root} {name} {x_med} {y_med}
      connect_medial_horizontal_synapses {hor_root} {name} {x_med} {y_med}
      connect_medial_subpial_synapses {sub_root} {name} {x_med} {y_med}
   end

   if (ECHO_ON == 1)
      echo "Created synapses for" {count} "medial source neurons"
      echo "  " {med_hor_count} "synapses from medial to horizontal neurons"
      echo "  " {med_lat_count} "synapses from medial to lateral neurons"     
      echo "  " {med_med_count} "synapses from medial to medial neurons"     
      echo "  " {med_ste_count} "synapses from medial to stellate neurons"
      echo "  " {med_sub_count} "synapses from medial to subpial neurons"          
   end;
end


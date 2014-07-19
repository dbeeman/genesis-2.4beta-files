//======== CREATE SYNAPSES FROM LATERAL NEURONS FOR NGU MODEL ========//
// This file contains functions to create a synapses from the         //
// lateral neurons.                                                   //
//                                                                    //                                                                  
// Setup:                                                             //
// 1. Call make_lateral_synapses                                      //
//                                                                    //
// Modeling notes:                                                    //
// The lateral synapses are made to horizontal, lateral, medial,      //
// stellate and subpial neurons that are within a specified radius    //
// of a lateral neuron. The synapses contain both AMPA and NMDA       //
// receptors.  The weights fall off with a Gaussian weighting factor. //
// Self synapses are not allowed.                                     //
//====================================================================//      
include ../lib/global_constants.g                  
include ../lib/synapses.g

//============ LOCATION OF LATERAL SYNAPSE TARGETS ===================//
str LAT_HOR_TARGET = "/dend2"    // Horizontal target of lateral synapses
str LAT_LAT_TARGET = "/basal3"   // Lateral target of lateral synapses
str LAT_MED_TARGET = "/dend8"    // Medial target of lateral synapses
str LAT_STE_TARGET = "/dend8"    // Stellate target of lateral synapses
str LAT_SUB_TARGET = "/dend6"    // Subpial target of lateral synapses


//============= LATERAL SYNAPSE TARGET NAMES ==========================//
str LAT_HOR_SYNAPSE = "lat_hor"
str LAT_LAT_SYNAPSE = "lat_lat"
str LAT_MED_SYNAPSE = "lat_med"
str LAT_STE_SYNAPSE = "lat_stel"
str LAT_SUB_SYNAPSE = "lat_subp"

//================== SYNAPSES FROM LATERAL - WEIGHTS =================//
float LAT_VAR = 1.5
float LAT_HOR_WA = 0.02 * LAT_VAR  // Weight of lateral-horizontal AMPA synapse
float LAT_HOR_WN = 0.19 * LAT_VAR  // Weight of lateral-horizontal NMDA synapse
float LAT_LAT_WA = 0.95 * LAT_VAR  // Weight of lateral-lateral AMPA synapse
float LAT_LAT_WN = 0.03 * LAT_VAR  // Weight of lateral-lateral NMDA synapse
float LAT_MED_WA = 1.2 * LAT_VAR   // Weight of lateral-medial AMPA synapse
float LAT_MED_WN = 0.06 * LAT_VAR  // Weight of lateral-medial NMDA synapse
float LAT_STE_WA = 0.01 * LAT_VAR  // Weight of lateral-stellate AMPA synapse
float LAT_STE_WN = 0.1 * LAT_VAR   // Weight of lateral-stellate NMDA synapse
float LAT_SUB_WA = 0.01 * LAT_VAR  // Weight of lateral-subpial AMPA synapse
float LAT_SUB_WN = 0.1 * LAT_VAR   // Weight of lateral-subpial NMDA synapse

//============= SYNAPSES FROM LATERAL - EFFECTIVE DISTANCES =========//
float LAT_HOR_R = 0.250
float LAT_LAT_R = 0.250
float LAT_MED_R = 0.250
float LAT_STE_R = 0.250
float LAT_SUB_R = 0.250

//===================== LATERAL SYNAPTIC PARAMETERS =================//
float LAT_GS = 5e-9
float LAT_DELAY_FACTOR = 1e-3/ 0.05

//========================== AMPA PARAMETERS ========================//
float LAT_TA = 3.0e-3
float LAT_TTA = 0.3e-3
float LAT_EA = 0.0e-3

//========================== NMDA PARAMETERS ========================//
float LAT_TN = 80.0e-3
float LAT_TTN = 0.67e-3
float LAT_EN = 0.0

//============= SYNAPSE COUNTS FOR DEBUGGING ========================//
int lat_hor_count = 0 
int lat_lat_count = 0 
int lat_med_count = 0
int lat_ste_count = 0
int lat_sub_count = 0


/* ******************************************************************
              create_lateral_synapses_for_group
     Create a synapse for each member of the root group. The synapse 
     contains an AMPA and an NMDA receptor that will sum
     the contributions of all lateral neuron sources that impinge on
     the neuron
     
     Parameters:
        root           root of the neuron group hierarchy
        target         target compartment for the group
        syn_name       base name of synapse for this group

****************************************************************** */  
function create_lateral_synapses_for_group (root, target, syn_name)
     str root, target, syn_name                            
  
     str name, dest
     str syn_chan_a = {syn_name}@"_a"
     str syn_chan_n = {syn_name}@"_n"
     
     foreach name  ({el {{root}@"/cell"}#})
         dest = {name}@{target}          
         // AMPA receptor
         make_synapse {dest} {syn_chan_a} {LAT_GS} {LAT_EA} {LAT_TA} {LAT_TTA}

        // NMDA receptor
        make_synapse_nmda {dest} {syn_chan_n} {LAT_GS} {LAT_EN} {LAT_TN} {LAT_TTN}
     end
end


/* ******************************************************************
                   connect_lateral_synapse_group
     Connects synapses for each member of the root group within a 
     specified radius of the src lateral neuron
     
     Parameters:
        root           root of the neuron group hierarchy
        src            lateral neuron source
        syn_name       base name of synapse for this group
        target         target compartment for the group
        x_lat          x coordinate for the lateral source
        y_lat          y coordinate for the lateral source
        radius         effective distance of synapse
        weight_fac_a   synaptic weight factor for AMPA
        weight_fac_n   synaptic weight factor for NMDA
 
      Returns:  number of synapses created for this src and varicosity
****************************************************************** */  
function connect_lateral_synapse_group(root, src, syn_name, target, \
                                x_lat, y_lat, radius, weight_fac_a, weight_fac_n)                                
   str root, src, syn_name, target
   float x_lat, y_lat, radius, weight_fac_a, weight_fac_n
   
   str dest, name
   str syn_chan_a = {syn_name}@"_a"
   str syn_chan_n = {syn_name}@"_n"
   str src_object = {src}@"/soma/spike"
   int syn_count = 0
   float x, y, dist, tdelay, weight_a, weight_n, grade
   float gauss_r = {radius}/LAT_VAR
   foreach name  ({el {{root}@"/cell"}#})
      x = {getfield {name} x}
      y = {getfield {name} y}
      dist = {sqrt  {(x_lat - x)**2 + (y_lat - y)**2} }
      if (dist <= radius && {strcmp {src} {name}} != 0)
         tdelay = {dist} * LAT_DELAY_FACTOR //sec
         dest = {name}@{target}
         grade = {gauss {x_lat} {x} {y_lat} {y} {gauss_r}}
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
                connect_lateral_horizontal_synapses
     Connects synapses containing an AMPA and an NMDA receptor from 
     the lateral src neuron to the destination horizontal neuron
     
     Parameters:
        root           root of horizontal neuron hierarchy
        src            lateral neuron source
        x_lat          x coordinate of the lateral source neuron
        y_lat          y coordinate of the lateral source neuron
****************************************************************** */  
function connect_lateral_horizontal_synapses (root, src, x_lat, y_lat)
   str root, src
   float x_lat, y_lat

   lat_hor_count = lat_hor_count + {connect_lateral_synapse_group \
                   {root} {src} {LAT_HOR_SYNAPSE} {LAT_HOR_TARGET} \
                   {x_lat} {y_lat} {LAT_HOR_R} {LAT_HOR_WA} {LAT_HOR_WN}}                          
end


/* ******************************************************************
                  connect_lateral_lateral_synapses
     Connects synapses containing an AMPA and an NMDA receptor from 
     the lateral src neuron to the destination lateral neuron
     
     Parameters:
        root           root of lateral neuron hierarchy
        src            lateral neuron source
        x_lat          x coordinate of the lateral source neuron
        y_lat          y coordinate of the lateral source neuron
      
     Note: Self synapses are not allowed.
****************************************************************** */ 
function connect_lateral_lateral_synapses (root, src, x_lat, y_lat)
   str root, src
   float x_lat, y_lat

   lat_lat_count = lat_lat_count + {connect_lateral_synapse_group \
                   {root} {src} {LAT_LAT_SYNAPSE} {LAT_LAT_TARGET} \
                   {x_lat} {y_lat} {LAT_LAT_R} {LAT_LAT_WA} {LAT_LAT_WN}}                            
end


/* ******************************************************************
              connect_lateral_medial_synapses
     Connects synapses containing an AMPA and an NMDA receptor from 
     the lateral src neuron to the destination medial neuron
     
     Parameters:
        root           root of medial neuron hierarchy
        src            lateral neuron source
        x_lat          x coordinate of the lateral source neuron
        y_lat          y coordinate of the lateral source neuron
****************************************************************** */  
function connect_lateral_medial_synapses (root, src, x_lat, y_lat)
   str root, src
   float x_lat, y_lat

   lat_med_count = lat_med_count + {connect_lateral_synapse_group \
                   {root} {src} {LAT_MED_SYNAPSE} {LAT_MED_TARGET} \
                   {x_lat} {y_lat} {LAT_MED_R} {LAT_MED_WA} {LAT_MED_WN}}                         
end


/* ******************************************************************
              connect_lateral_stellate_synapses
     Connects synapses containing an AMPA and an NMDA receptor from 
     the lateral src neuron to the destination stellate neuron
     
     Parameters:
        root           root of stellate neuron hierarchy
        src            lateral neuron source
        x_lat          x coordinate of the lateral source neuron
        y_lat          y coordinate of the lateral source neuron
****************************************************************** */ 
function connect_lateral_stellate_synapses (root, src, x_lat, y_lat)
   str root, src
   float x_lat, y_lat

   lat_ste_count = lat_ste_count + {connect_lateral_synapse_group \
                    {root} {src} {LAT_STE_SYNAPSE} {LAT_STE_TARGET} \
                    {x_lat} {y_lat} {LAT_STE_R} {LAT_STE_WA} {LAT_STE_WN}}                           
end


/* ******************************************************************
                       connect_lateral_subpial_synapses
     Connects synapses containing an AMPA and an NMDA receptor from 
     the lateral src neuron to the destination subpial neuron
     
     Parameters:
        root           root of subpial neuron hierarchy
        src            lateral neuron source
        x_lat          x coordinate of the lateral source neuron
        y_lat          y coordinate of the lateral source neuron
****************************************************************** */ 
function connect_lateral_subpial_synapses (root, src, x_lat, y_lat)
   str root, src
   float x_lat, y_lat

   lat_sub_count = lat_sub_count + {connect_lateral_synapse_group \
                   {root} {src} {LAT_SUB_SYNAPSE} {LAT_SUB_TARGET} \
                   {x_lat} {y_lat} {LAT_SUB_R} {LAT_SUB_WA} {LAT_SUB_WN}}                            
end


/* ******************************************************************
                       make_lateral_synapses
     Creates the synapses from lateral neurons in the NGU model
     
     Parameters:
        lat_root            root of the hierarchy for lateral neurons
        hor_root            root of the hierarchy for horizontal neurons
        med_root            root of the hierarchy for medial neurons                   
        ste_root            root of the hierarchy for stellate neurons  
        sub_root            root of the hierarchy for subpial neurons  
****************************************************************** */ 
function make_lateral_synapses (lat_root, hor_root, med_root, ste_root, sub_root)
   str lat_root, hor_root, med_root, ste_root, sub_root
   float x_lat, y_lat
  
   //Start by creating a representative synapse for each potential target neuron
   create_lateral_synapses_for_group {lat_root} {LAT_LAT_TARGET} {LAT_LAT_SYNAPSE} 
   create_lateral_synapses_for_group {med_root} {LAT_MED_TARGET} {LAT_MED_SYNAPSE} 
   create_lateral_synapses_for_group {ste_root} {LAT_STE_TARGET} {LAT_STE_SYNAPSE} 
   create_lateral_synapses_for_group {hor_root} {LAT_HOR_TARGET} {LAT_HOR_SYNAPSE} 
   create_lateral_synapses_for_group {sub_root} {LAT_SUB_TARGET} {LAT_SUB_SYNAPSE} 
   
   //Now create spikes from lateral source neurons
   str name, src
   int count = 0;
   foreach name  ({el {{lat_root}@"/cell"}#})
      count = count + 1;
      x_lat = {getfield {name} x}
      y_lat = {getfield {name} y}
      connect_lateral_lateral_synapses {lat_root} {name} {x_lat} {y_lat}
      connect_lateral_medial_synapses {med_root} {name} {x_lat} {y_lat}
      connect_lateral_stellate_synapses {ste_root} {name} {x_lat} {y_lat}
      connect_lateral_horizontal_synapses {hor_root} {name} {x_lat} {y_lat}
      connect_lateral_subpial_synapses {sub_root} {name} {x_lat} {y_lat}
   end
   
   if (ECHO_ON == 1)
      echo "Created synapses for" {count} "lateral source neurons"
      echo "  " {lat_hor_count} "synapses from lateral to horizontal neurons"
      echo "  " {lat_lat_count} "synapses from lateral to lateral neurons"     
      echo "  " {lat_med_count} "synapses from lateral to medial neurons"     
      echo "  " {lat_ste_count} "synapses from lateral to stellate neurons"
      echo "  " {lat_sub_count} "synapses from lateral to subpial neurons"            
   end;
end

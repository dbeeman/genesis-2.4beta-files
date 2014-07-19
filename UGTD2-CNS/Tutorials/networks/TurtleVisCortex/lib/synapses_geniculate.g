//====== CREATE SYNAPSES FROM GENICULATE NEURONS FOR NGU MODEL =======//
// This file contains functions to create a synapses from the LGN     //
// based on varicosity positions that are read from a file.           //
//                                                                    //                                                                  
// Setup:                                                             //
// 1. Specify the varicosities by creating a text file of x y z       //
//    coordinates for the varicosities, one varicosity per line.      //
// 2. Call make_lgn_synapses                                          //
//                                                                    //
// Modeling notes:                                                    //
// The turtle visual cortex is characterized by long range input      //
// connections that go from the lateral geniculate across the entire  //
// cortex. The model assumes that the synapses to target neurons are  //
// made through varicosities, which are nodules that appear along     //
// these long range input connections. The lgn has synapses to the    //
// lateral, medial, stellate and subpial neurons, but not the         //
// horizontal neurons. Neurons that are within a specified distance   //
// from these varicosities have a synapse target. The lateral, medial //
// and stellate neurons have a single target, but the subpial cells   //
// contain a range of target compartments.                            //
//====================================================================//
include ../lib/global_constants.g
include ../lib/synapses.g

//============ LOCATION OF LGN SYNAPSE TARGETS ======================//
str LGN_LAT_TARGET = "/basal2"  // Lateral target for geniculate synapses
str LGN_MED_TARGET = "/dend3"   // Medial target for geniculate synapses
str LGN_STE_TARGET = "/dend16"  // Stellate target for geniculate synapses
str LGN_SUB_TARGET = "/dend"    // Subpial target base for geniculate synapses

// Subpial targets are dendrites [LGN_SUB_TARGET_LO, LGN_SUB_TARGET_HI]
int LGN_SUB_TARGET_LO = 2
int LGN_SUB_TARGET_HI = 29

//=============== LGN SYNAPSE TARGET NAMES =========================//
str LGN_LAT_SYNAPSE = "lgn_lat"
str LGN_MED_SYNAPSE = "lgn_med"
str LGN_STE_SYNAPSE = "lgn_stel"
str LGN_SUB_SYNAPSE = "lgn_subp"

//================LGN SYNAPTIC WEIGHTS ============================//
float LGN_LAT_W = 1.87
float LGN_MED_W = 0.25
float LGN_STE_W = 0.25
float LGN_SUB_W = 0.25

//========LGN EFFECTIVE DISTANCE TO VARICOSITIES (in mm)==========//
float LGN_LAT_R = 0.026
float LGN_MED_R = 0.06
float LGN_STE_R = 0.025
float LGN_SUB_R = 0.025

//=====================LGN SYNAPTIC PARAMETERS ===================//
float LGN_GS = 5e-9
float LGN_DELAY_FACTOR = 1e-3/ 0.18

//============= LGN PARAMETERS FOR AMPA RECEPTORS ===============//
float LGN_TA = 3.0e-3
float LGN_TTA = 0.3e-3
float LGN_EA = 0.0e-3

//============= SYNAPSE COUNTS FOR DEBUGGING ===================//
int lgn_lat_count = 0 
int lgn_med_count = 0
int lgn_ste_count = 0
int lgn_sub_count = 0

/* ******************************************************************
               create_geniculate_synapses_for_group
     Create a synapse for each member of the root group. The synapse 
     contains an AMPA receptor that will sum the contributions 
     of all geniculate neuron sources that impinge on
     the neuron
     
     Parameters:
        root           root of the neuron group hierarchy
        target         target compartment for the group
        syn_name       base name of synapse for this group

****************************************************************** */  
function create_geniculate_synapses_for_group (root, target, syn_name)
     str root, target, syn_name                            

     	str name, dest
     	str syn_chan_a = {syn_name}@"_a"
	  	
     foreach name  ({el {{root}@"/cell"}#})
        dest = {name}@{target}          
        // AMPA receptor
        make_synapse {dest} {syn_chan_a} {LGN_GS} {LGN_EA} {LGN_TA} {LGN_TTA}
  	  end
end


/* ******************************************************************
                 create_geniculate_synapses_for_interval_group
     Create a synapse for each member of the root group. The synapse 
     contains an AMPA receptor that will sum the contributions 
     of all geniculate neuron sources that impinge on
     the neuron
     
     Parameters:
        root           root of the neuron group hierarchy
        target         target compartment for the group
        syn_name       base name of synapse for this group
        low            lowest index compartment to be connected
        high           highest index compartment to be connected

****************************************************************** */  
function create_geniculate_synapses_for_interval_group (root, target, \
                        syn_name, low, high)
     str root, target, syn_name
     int low, high                            
  
     str syn_chan_a = {syn_name}@"_a"
     str name, dest
     int i
     
		foreach name  ({el {{root}@"/cell"}#})
         for (i = low; i <= high; i = i + 1)
            dest = {name}@{{target}@{i}}
                 
            // AMPA receptor
            make_synapse {dest} {syn_chan_a} {LGN_GS} {LGN_EA} {LGN_TA} {LGN_TTA}
         end
     	end
end


/* ******************************************************************
                   connect_geniculate_synapse_group
     Connects synapses for each member of the root group within a 
     specified radius of the src varicosity.
     
     Parameters:
        root           root of the neuron group hierarchy
        src            lgn soma source
        syn_name       base name of synapse for this group
        target         target compartment for the group
        x_var          x coordinate for the varicosity
        y_var          y coordinate for the varicosity
        dist_var       distance from lgn src to varicosity
        radius         effective distance of synapse
        weight         synaptic weight

      Returns:  number of synapses created for this src and varicosity
****************************************************************** */  
function connect_geniculate_synapse_group(root, src, syn_name, target, \
                                x_var, y_var, dist_var, radius, weight)
   str root, src, syn_name, target
   float x_var, y_var, dist_lgn_var, radius, weight
   
   str dest, name
   str syn_chan_a = {syn_name}@"_a"
   int syn_count = 0
   float x, y, dist, tdelay
   foreach name  ({el {{root}@"/cell"}#})
      x = {getfield {name} x}
      y = {getfield {name} y}
      dist = {sqrt  {(x_var - x)**2 + (y_var - y)**2} }
      if (dist <= radius)
         tdelay = ({dist_var} + {dist}) * LGN_DELAY_FACTOR //sec
         dest = {name}@{target}
         connect_synapse {src} {dest} {syn_chan_a} {tdelay} {weight}
         syn_count = syn_count + 1
      end
   end 
   return syn_count
 end

 
 /* ******************************************************************
             connect_geniculate_synapse_interval_group
     Connects synapses for each member of the root group within a 
     specified radius of the src varicosity. Multiple synaptic 
     connections are made to each target neuron. In particular, all
     compartments with base name target and index in [low, high] are
     connected.
     
     Parameters:
        root           root of the neuron group hierarchy
        src            lgn soma source
        syn_name       base name of synapse for this group
        target         target compartment for the group
        x_var          x coordinate for the varicosity
        y_var          y coordinate for the varicosity
        dist_lgn_var   distance from lgn src to varicosity
        radius         effective distance of synapse
        weight         synaptic weight
        low            lowest index compartment to be connected
        high           highest index compartment to be connected

      Returns:  number of synapses created for this src and varicosity
****************************************************************** */ 
 function connect_geniculate_synapse_interval_group(root, src, syn_name, target, \
                            x_var, y_var, dist_lgn_var, radius, weight, low, high)
                              
   str root, src, syn_name, target
   int low, high
   float x_var, y_var, dist_lgn_var, radius, weight
 
   str syn_chan_a = {syn_name}@"_a"
   str dest, name
   int i
   int syn_count = 0
   float x, y, dist, tdelay
   foreach name  ({el {{root}@"/cell"}#})
      x = {getfield {name} x}
      y = {getfield {name} y}
      dist = {sqrt  {(x_var - x)**2 + (y_var - y)**2} }
      if (dist <= radius)
         tdelay = ({dist_lgn_var} + {dist}) * LGN_DELAY_FACTOR //sec
         for (i = low; i <= high; i = i + 1)
            dest = {name}@{{target}@{i}}
            connect_synapse {src} {dest} {syn_chan_a} {tdelay} {weight}  
            syn_count = syn_count + 1;
         end
      end
   end 
   return syn_count
 end

 
/* ******************************************************************
             connect_geniculate_lateral_synapses
     Connects the synapses from lgn to lateral neurons
     
     Parameters:
        root           root of lateral neuron hierarchy
        src            lgn soma source
        x_var          x coordinate of the varicosity
        y_var          y coordinate of the varicosity
        dist_var       distance of source lgn neuron to varicosity

     Synapses with weight LGN_LAT_W are created for lateral neurons 
     within distance LGN_LAT_R of a varicosity. The lateral target 
     compartment for the synapse is LGN_LAT_TARGET, and the synapse
     is stored in the object hierachy under the lateral target
     compartment under the name LGN_LAT_SYNAPSE#.
****************************************************************** */  
function connect_geniculate_lateral_synapses (root, src, x_var, \
                                    y_var, dist_var)
   str root, src
   float x_var, y_var, dist_var

   lgn_lat_count = lgn_lat_count + {connect_geniculate_synapse_group \
                   {root} {src} {LGN_LAT_SYNAPSE} {LGN_LAT_TARGET} \
                   {x_var} {y_var} {dist_var} {LGN_LAT_R} {LGN_LAT_W}}                            
end


/* ******************************************************************
                       connect_geniculate_medial_synapses
     Connects the synapses from lgn to medial neurons
     
     Parameters:
        root           root of medial neuron hierarchy
        src            lgn soma source
        x_var          x coordinate of the varicosity
        y_var          y coordinate of the varicosity
        dist_var       distance of source lgn neuron to varicosity
     
     Synapses with weight LGN_MED_W are created for medial neurons 
     within distance LGN_MED_R of a varicosity. The medial target 
     compartment for the synapse is LGN_MED_TARGET, and the synapse
     is stored in the object hierachy under the medial target
     compartment with the name LGN_MED_SYNAPSE@syn_index. 
****************************************************************** */  
function connect_geniculate_medial_synapses (root, src, x_var, \
                                   y_var, dist_var)
   str root, src
   float x_var, y_var, dist_var
   
   lgn_med_count = lgn_med_count + {connect_geniculate_synapse_group \
                   {root} {src} {LGN_MED_SYNAPSE} {LGN_MED_TARGET} \
                   {x_var} {y_var} {dist_var} {LGN_MED_R} {LGN_MED_W}}                            
end


/* ******************************************************************
                      connect_geniculate_stellate_synapses
     Connects the synapses from lgn to stellate neurons
     
     Parameters:
        root           root of stellate neuron hierarchy
        src            lgn soma source
        x_var          x coordinate of the varicosity
        y_var          y coordinate of the varicosity
        dist_var       distance of source lgn neuron to varicosity
     
     Synapses with weight LGN_STE_W are created for stellate neurons 
     within distance LGN_STE_R of a varicosity. The stellate target 
     compartment for the synapse is LGN_STE_TARGET, and the synapse
     is stored in the object hierachy under the stellate target
     compartment under the name LGN_STE_SYNAPSE#.
****************************************************************** */  
function connect_geniculate_stellate_synapses (root, src, x_var, \
                                     y_var, dist_var)
   str root, src
   float x_var, y_var, dist_var
   
   lgn_ste_count = lgn_ste_count +  {connect_geniculate_synapse_group \
                   {root} {src} {LGN_STE_SYNAPSE} {LGN_STE_TARGET} \
                   {x_var} {y_var}  {dist_var} {LGN_STE_R} {LGN_STE_W}}                      
end


/* ******************************************************************
              connect_geniculate_subpial_synapses
     Connects the synapses from lgn to subpial neurons
     
     Parameters:
        root           root of subpial neuron hierarchy
        src            lgn soma source
        x_var          x coordinate of the varicosity
        y_var          y coordinate of the varicosity
        dist_var       distance of source lgn neuron to varicosity
     
     Synapses with weight LGN_SUB_W are created for subpial neurons 
     within distance LGN_SUB_R of a varicosity. However, instead of
     targeting a single neuronal compartment, the synapse targets
     all subpial compartments of the form LGN_SUB_TARGET# where #
     ranges from LGN_SUB_TARGET_LO to LGN_SUB_TARGET_HI. The default
     specifies 28 compartments (#s 2 through 29). The synapses
     are stored in the object hierachy under the subpial target
     compartment under the name LGN_STE_SYNAPSE#.
****************************************************************** */  
function connect_geniculate_subpial_synapses (root, src, x_var, \
                                    y_var, dist_var)
   str root, src
   int var_index
   float x_var, y_var, dist_var
  
   lgn_sub_count = lgn_sub_count + {connect_geniculate_synapse_interval_group \
                   {root} {src} {LGN_SUB_SYNAPSE} {LGN_SUB_TARGET} \
                   {x_var} {y_var}  {dist_var} {LGN_SUB_R} {LGN_SUB_W} \        
                   {LGN_SUB_TARGET_LO} {LGN_SUB_TARGET_HI}}
end


/* ******************************************************************
                       make_lgn_synapses
     Creates the synapses from lgn in the NGU model
     
     Parameters:
        varicosity_coords   name of file containing varicosity coordinates
        lgn_root            root of the hierarchy for geniculate neurons
        lat_root            root of the hierarchy for lateral neurons
        med_root            root of the hierarchy for medial neurons
        ste_root            root of the hierarchy for stellate neurons
        sub_root            root of the hierarchy for subpial neurons                      
 
****************************************************************** */  
function make_lgn_synapses(varicosity_coords, lgn_root, lat_root, \
                           med_root, ste_root, sub_root)
   str varicosity_coords, lat_root, lgn_root, med_root, ste_root, sub_root
   
   //Start by creating a representative synapse for each potential target neuron
   create_geniculate_synapses_for_group {lat_root} {LGN_LAT_TARGET} {LGN_LAT_SYNAPSE} 
   create_geniculate_synapses_for_group {med_root} {LGN_MED_TARGET} {LGN_MED_SYNAPSE} 
   create_geniculate_synapses_for_group {ste_root} {LGN_STE_TARGET} {LGN_STE_SYNAPSE} 
   create_geniculate_synapses_for_interval_group {sub_root} {LGN_SUB_TARGET} \
                        {LGN_SUB_SYNAPSE} {LGN_SUB_TARGET_LO} {LGN_SUB_TARGET_HI}
   
   //Now create spikes from varicosities for geniculate source neurons
   openfile {varicosity_coords} r
   
   str name, src
   str line = {readfile {varicosity_coords} -linemode}
   float x_var, y_var, x_lgn, y_lgn, dist_lgn_var, lgn_index_temp
   int lgn_index
   int count = 0
   while (!{eof {varicosity_coords}})
      count = count + 1
      x_var = {getarg {arglist {line}} -arg 1}
      y_var = {getarg {arglist {line}} -arg 2}
      lgn_index_temp = {getarg {arglist {line}} -arg 3}
      lgn_index = lgn_index_temp
      name = {lgn_root}@{"/cell"@{lgn_index}}
      x_lgn = {getfield {name} x}
      y_lgn = {getfield {name} y}
      dist_lgn_var = {sqrt  {(x_var - x_lgn)**2 + (y_var - y_lgn)**2} }
      src = {name}@"/soma/spike"
      connect_geniculate_lateral_synapses {lat_root} {src} \
          {x_var} {y_var} {dist_lgn_var}
      connect_geniculate_medial_synapses {med_root} {src} \
          {x_var} {y_var} {dist_lgn_var}
      connect_geniculate_stellate_synapses {ste_root} {src} \
          {x_var} {y_var} {dist_lgn_var}
      connect_geniculate_subpial_synapses {sub_root} {src} \ 
          {x_var} {y_var} {dist_lgn_var}
      line = {readfile {varicosity_coords} -linemode}
   end

   closefile {varicosity_coords}
   
   if (ECHO_ON == 1)
      echo "Created lgn synapses for" {count} "varicosities:"
      echo "  " {lgn_lat_count} "synapses from lgn to lateral neurons"
      echo "  " {lgn_med_count} "synapses from lgn to medial neurons"
      echo "  " {lgn_ste_count} "synapses from lgn to stellate neurons"
      echo "  " {lgn_sub_count} "synapses from lgn to subpial neurons"
   end 
end

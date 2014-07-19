//==================== BASIC UTILITIES FOR OUTPUT ====================//
// This file contains functions output various model values to files. //
// For example, dump_neuron_soma_voltages writes the soma voltages of //
// the different neuronal populations to different files. To output   //
// other values of another variable, add another function using       //
// dump_neuron_soma_voltages as a model.                              //
//                                                                    //
// Available functions:                                               //
// 1. create_outfile - sets up specified file for output              //
// 2. dump_neuron_soma_voltages - output neuron soma voltage          //
//                                                                    //
//====================================================================//
include ../lib/global_constants.g
include ../lib/synapses_geniculate.g
include ../lib/synapses_horizontal.g
include ../lib/synapses_lateral.g
include ../lib/synapses_stellate.g
include ../lib/synapses_subpial.g

/* ******************************************************************
                       create_outfile                                 
     Creates an output file for the specified variable.                         

     Parameters:  
        directory      name of the directory to write the files
        filebase       prefix of the file name for all the files
        clock          clock that determines the interval for output      
        output_group   base name of neurons whose values are to be output
        element        compartment within output_troup neuron to be output
        variable       variable to be output

****************************************************************** */  
function create_outfile(directory, filename, clock, output_group, element, variable)
   str directory, filename, clock, output_group, element, variable

   str actual_name = {directory}@{"/"@{filename}}
   str object_name = "/output/"@{filename}
   create asc_file {object_name}
   setfield {object_name} filename {actual_name}
   setfield {object_name} flush 1 leave_open 1 append 1
   call {object_name} OUT_OPEN
   
   str name
   foreach name ({el {output_group}#})
      addmsg {{name}@{element}} {object_name} SAVE {variable}
   end
   
   useclock {object_name} {clock}
   
   if (ECHO_ON == 1)
       echo "   " {output_group} {element} "variable" {variable} "to" {actual_name}
   end
end


/* ******************************************************************
                       dump_neuron_soma_voltages                                  
    Writes the neuron soma voltages at the time interval specified by
    clock. The values for each population are written to a separate
    file. Each line of a file starts with the time and then gives the
    values for the neurons ordered by their names. The values are
    separated by blanks.                       

     Parameters:                                                                  
        directory      name of the directory to write the files
        filebase       prefix of the file name for all the files
        clock          clock that determines the interval for output      
        hor_root       root of the horizontal neuron hierarchy
        lat_root       root of the lateral neuron hierarchy
        lgn_root       root of the geniculate neuron hierarchy
        med_root       root of the medial neuron hierarchy
        ste_root       root of the stellate neuron hierarchy
        sub_root       root of the subpial neuron hierarchy

****************************************************************** */  
function dump_neuron_soma_voltages (directory, filebase, clock, \
             hor_root, lat_root, lgn_root, med_root, ste_root, sub_root)
   str directory, filebase, clock, \
       hor_root, lat_root, lgn_root, med_root, ste_root, sub_root
   
   if (ECHO_ON == 1)
      echo "Saving soma voltages:"
   end
     
   create_outfile {directory} {{filebase}@"LGNVoltage.dat"} {clock} \
         {{lgn_root}@"/cell"} /soma Vm 
   create_outfile {directory} {{filebase}@"LateralVoltage.dat"} {clock} \
         {{lat_root}@"/cell"} /soma Vm 
   create_outfile {directory} {{filebase}@"MedialVoltage.dat"} {clock} \
         {{med_root}@"/cell"} /soma Vm 
   create_outfile {directory} {{filebase}@"StellateVoltage.dat"} {clock} \
         {{ste_root}@"/cell"} /soma Vm  
   create_outfile {directory} {{filebase}@"HorizontalVoltage.dat"} {clock} \
         {{hor_root}@"/cell"} /soma Vm 
   create_outfile {directory} {{filebase}@"SubpialVoltage.dat"} {clock} \
         {{sub_root}@"/cell"} /soma Vm
end


/* ******************************************************************
                       dump_neuron_calcium_currents                                  
    Writes the calcium at the time interval specified by
    clock. The values for each population are written to a separate
    file. Each line of a file starts with the time and then gives the
    values for the neurons ordered by their names. The values are
    separated by blanks.                       

     Parameters:                                                                  
        directory      name of the directory to write the files
        filebase       prefix of the file name for all the files
        clock          clock that determines the interval for output      
        hor_root       root of the horizontal neuron hierarchy
        lat_root       root of the lateral neuron hierarchy
        lgn_root       root of the geniculate neuron hierarchy
        med_root       root of the medial neuron hierarchy
        ste_root       root of the stellate neuron hierarchy
        sub_root       root of the subpial neuron hierarchy

****************************************************************** */  
function dump_neuron_calcium_currents (directory, filebase, clock, \
             hor_root, lat_root, lgn_root, med_root, ste_root, sub_root)
   str directory, filebase, clock, \
       hor_root, lat_root, lgn_root, med_root, ste_root, sub_root
   
   if (ECHO_ON == 1)
      echo "Saving soma calcium currents:"
   end
     
   create_outfile {directory} {{filebase}@"LateralCalciumCurrent.dat"} {clock} \
         {{lat_root}@"/cell"} /soma/calcium_channel Ik 
   create_outfile {directory} {{filebase}@"MedialCalciumCurrent.dat"} {clock} \
         {{med_root}@"/cell"} /soma/calcium_channel Ik 
   create_outfile {directory} {{filebase}@"SubpialCalciumCurrent.dat"} {clock} \
         {{sub_root}@"/cell"} /soma/calcium_channel Ik 
end


/* ******************************************************************
                       dump_neuron_sodium_currents                                 
    Writes the sodium currents at the time interval specified by
    clock. The values for each population are written to a separate
    file. Each line of a file starts with the time and then gives the
    values for the neurons ordered by their names. The values are
    separated by blanks.                       

     Parameters:                                                                  
        directory      name of the directory to write the files
        filebase       prefix of the file name for all the files
        clock          clock that determines the interval for output      
        hor_root       root of the horizontal neuron hierarchy
        lat_root       root of the lateral neuron hierarchy
        lgn_root       root of the geniculate neuron hierarchy
        med_root       root of the medial neuron hierarchy
        ste_root       root of the stellate neuron hierarchy
        sub_root       root of the subpial neuron hierarchy

****************************************************************** */  
function dump_neuron_sodium_currents (directory, filebase, clock, \
             hor_root, lat_root, lgn_root, med_root, ste_root, sub_root)
   str directory, filebase, clock, \
       hor_root, lat_root, lgn_root, med_root, ste_root, sub_root
   
   if (ECHO_ON == 1)
      echo "Saving soma sodium currents:"
   end
     
   create_outfile {directory} {{filebase}@"LateralSodiumCurrent.dat"} {clock} \
         {{lat_root}@"/cell"} /soma/sodium_channel Ik 
   create_outfile {directory} {{filebase}@"MedialSodiumCurrent.dat"} {clock} \
         {{med_root}@"/cell"} /soma/sodium_channel Ik 
   create_outfile {directory} {{filebase}@"StellateSodiumCurrent.dat"} {clock} \
         {{ste_root}@"/cell"} /soma/sodium_channel Ik   
   create_outfile {directory} {{filebase}@"HorizontalSodiumCurrent.dat"} {clock} \
         {{hor_root}@"/cell"} /soma/sodium_channel Ik  
   create_outfile {directory} {{filebase}@"SubpialSodiumCurrent.dat"} {clock} \
         {{sub_root}@"/cell"} /soma/sodium_channel Ik 
end

/* ******************************************************************
                       dump_neuron_potassium_currents                                 
    Writes the potassium currents at the time interval specified by
    clock. The values for each population are written to a separate
    file. Each line of a file starts with the time and then gives the
    values for the neurons ordered by their names. The values are
    separated by blanks.                       

     Parameters:                                                                  
        directory      name of the directory to write the files
        filebase       prefix of the file name for all the files
        clock          clock that determines the interval for output      
        hor_root       root of the horizontal neuron hierarchy
        lat_root       root of the lateral neuron hierarchy
        lgn_root       root of the geniculate neuron hierarchy
        med_root       root of the medial neuron hierarchy
        ste_root       root of the stellate neuron hierarchy
        sub_root       root of the subpial neuron hierarchy

****************************************************************** */  
function dump_neuron_potassium_currents (directory, filebase, clock, \
             hor_root, lat_root, lgn_root, med_root, ste_root, sub_root)
   str directory, filebase, clock, \
       hor_root, lat_root, lgn_root, med_root, ste_root, sub_root
   
   if (ECHO_ON == 1)
      echo "Saving soma potassium currents:"
   end
     
   create_outfile {directory} {{filebase}@"LateralPotassiumCurrent.dat"} {clock} \
         {{lat_root}@"/cell"} /soma/potassium_channel Ik 
   create_outfile {directory} {{filebase}@"MedialPotassiumCurrent.dat"} {clock} \
         {{med_root}@"/cell"} /soma/potassium_channel Ik 
   create_outfile {directory} {{filebase}@"StellatePotassiumCurrent.dat"} {clock} \
         {{ste_root}@"/cell"} /soma/potassium_channel Ik   
   create_outfile {directory} {{filebase}@"HorizontalPotassiumCurrent.dat"} {clock} \
         {{hor_root}@"/cell"} /soma/potassium_channel Ik  
   create_outfile {directory} {{filebase}@"SubpialPotassiumCurrent.dat"} {clock} \
         {{sub_root}@"/cell"} /soma/potassium_channel Ik 
end


/* ******************************************************************
                       dump_neuron_kahp_currents                                 
    Writes the K_AHP currents at the time interval specified by
    clock. The values for each population are written to a separate
    file. Each line of a file starts with the time and then gives the
    values for the neurons ordered by their names. The values are
    separated by blanks.                       

     Parameters:                                                                  
        directory      name of the directory to write the files
        filebase       prefix of the file name for all the files
        clock          clock that determines the interval for output      
        hor_root       root of the horizontal neuron hierarchy
        lat_root       root of the lateral neuron hierarchy
        lgn_root       root of the geniculate neuron hierarchy
        med_root       root of the medial neuron hierarchy
        ste_root       root of the stellate neuron hierarchy
        sub_root       root of the subpial neuron hierarchy

****************************************************************** */  
function dump_neuron_kahp_currents (directory, filebase, clock, \
             hor_root, lat_root, lgn_root, med_root, ste_root, sub_root)
   str directory, filebase, clock, \
       hor_root, lat_root, lgn_root, med_root, ste_root, sub_root
   
   if (ECHO_ON == 1)
      echo "Saving soma K_AHP currents:"
   end
     
   create_outfile {directory} {{filebase}@"SubpialKAHPCurrent.dat"} {clock} \
         {{sub_root}@"/cell"} /soma/K_AHP Ik 
end

/* ******************************************************************
                       dump_synapse_lgn_currents                                   
    Writes the lgn currents at the time interval specified by
    clock. The values for each population are written to a separate
    file. Each line of a file starts with the time and then gives the
    values for the neurons ordered by their names. The values are
    separated by blanks.                     

     Parameters:                                                                  
        directory      name of the directory to write the files
        filebase       prefix of the file name for all the files
        clock          clock that determines the interval for output      
        hor_root       root of the horizontal neuron hierarchy
        lat_root       root of the lateral neuron hierarchy
        lgn_root       root of the geniculate neuron hierarchy
        med_root       root of the medial neuron hierarchy
        ste_root       root of the stellate neuron hierarchy
        sub_root       root of the subpial neuron hierarchy

   NOTE: Does not include current for subpial synapses
****************************************************************** */  
function dump_synapse_lgn_currents  (directory, filebase, clock, \
             hor_root, lat_root, lgn_root, med_root, ste_root, sub_root)
   str directory, filebase, clock, \
       hor_root, lat_root, lgn_root, med_root, ste_root, sub_root
   
   if (ECHO_ON == 1)
      echo "Saving lgn currents:"
   end
    
   str group = {LGN_LAT_TARGET}@{"/"@{{LGN_LAT_SYNAPSE}@"_a"}}    
   create_outfile {directory} {{filebase}@"LGN2LateralAMPACurrent.dat"} {clock} \
         {{lat_root}@"/cell"} {group} Ik 
         
   group = {LGN_MED_TARGET}@{"/"@{{LGN_MED_SYNAPSE}@"_a"}} 
   create_outfile {directory} {{filebase}@"LGN2MedialAMPACurrent.dat"} {clock} \
         {{med_root}@"/cell"} {group} Ik 
        
   group = {LGN_STE_TARGET}@{"/"@{{LGN_STE_SYNAPSE}@"_a"}} 
   create_outfile {directory} {{filebase}@"LGN2StellateAMPACurrent.dat"} {clock} \
         {{ste_root}@"/cell"} {group} Ik   
end


/* ******************************************************************
                       dump_synapse_ampa_currents                                 
    Writes the AMPA currents at the time interval specified by
    clock. The values for each combination of source and destination population  
    are written to a separate file. Each line of a file starts with the time and 
    then gives the values for the synapse ordered by destination neuron name. 
    The values are separated by blanks.                       

     Parameters:                                                                  
        directory      name of the directory to write the files
        filebase       prefix of the file name for all the files
        clock          clock that determines the interval for output      
        hor_root       root of the horizontal neuron hierarchy
        lat_root       root of the lateral neuron hierarchy
        lgn_root       root of the geniculate neuron hierarchy
        med_root       root of the medial neuron hierarchy
        ste_root       root of the stellate neuron hierarchy
        sub_root       root of the subpial neuron hierarchy

****************************************************************** */  
function dump_synapse_ampa_currents (directory, filebase, clock, \
             hor_root, lat_root, lgn_root, med_root, ste_root, sub_root)
   str directory, filebase, clock, \
       hor_root, lat_root, lgn_root, med_root, ste_root, sub_root
   
   str group, file
   if (ECHO_ON == 1)
      echo "Saving AMPA currents from lateral neurons:"
   end
   
   file = {filebase}@"Lateral2LateralAMPACurrent.dat" 
   group = {LAT_LAT_TARGET}@{"/"@{{LAT_LAT_SYNAPSE}@"_a"}} 
   create_outfile {directory} {file} {clock} {{lat_root}@"/cell"} {group} Ik 
   
   file = {filebase}@"Lateral2MedialAMPACurrent.dat" 
   group = {LAT_MED_TARGET}@{"/"@{{LAT_MED_SYNAPSE}@"_a"}} 
   create_outfile {directory} {file} {clock} {{med_root}@"/cell"} {group} Ik       
   
   file = {filebase}@"Lateral2StellateAMPACurrent.dat" 
   group = {LAT_STE_TARGET}@{"/"@{{LAT_STE_SYNAPSE}@"_a"}} 
   create_outfile {directory} {file} {clock} {{ste_root}@"/cell"} {group} Ik       
   
   file = {filebase}@"Lateral2HorizontalAMPACurrent.dat" 
   group = {LAT_HOR_TARGET}@{"/"@{{LAT_HOR_SYNAPSE}@"_a"}} 
   create_outfile {directory} {file} {clock} {{hor_root}@"/cell"} {group} Ik       
 
   file = {filebase}@"Lateral2SubpialAMPACurrent.dat" 
   group = {LAT_SUB_TARGET}@{"/"@{{LAT_SUB_SYNAPSE}@"_a"}} 
   create_outfile {directory} {file} {clock} {{sub_root}@"/cell"} {group} Ik    
   
   if (ECHO_ON == 1)
      echo "Saving AMPA currents from medial neurons:"
   end
   
   file = {filebase}@"Medial2LateralAMPACurrent.dat" 
   group = {MED_LAT_TARGET}@{"/"@{{MED_LAT_SYNAPSE}@"_a"}} 
   create_outfile {directory} {file} {clock} {{lat_root}@"/cell"} {group} Ik 
   
   file = {filebase}@"Medial2MedialAMPACurrent.dat" 
   group = {MED_MED_TARGET}@{"/"@{{MED_MED_SYNAPSE}@"_a"}} 
   create_outfile {directory} {file} {clock} {{med_root}@"/cell"} {group} Ik       
   
   file = {filebase}@"Medial2StellateAMPACurrent.dat" 
   group = {MED_STE_TARGET}@{"/"@{{MED_STE_SYNAPSE}@"_a"}} 
   create_outfile {directory} {file} {clock} {{ste_root}@"/cell"} {group} Ik       
   
   file = {filebase}@"Medial2HorizontalAMPACurrent.dat" 
   group = {MED_HOR_TARGET}@{"/"@{{MED_HOR_SYNAPSE}@"_a"}} 
   create_outfile {directory} {file} {clock} {{hor_root}@"/cell"} {group} Ik    
   
   file = {filebase}@"Medial2SubpialAMPACurrent.dat" 
   group = {MED_SUB_TARGET}@{"/"@{{MED_SUB_SYNAPSE}@"_a"}} 
   create_outfile {directory} {file} {clock} {{sub_root}@"/cell"} {group} Ik    
end

/* ******************************************************************
                       dump_synapse_nmda_currents                                 
    Writes the NMDA currents at the time interval specified by
    clock. The values for each combination of source and destination population  
    are written to a separate file. Each line of a file starts with the time and 
    then gives the values for the synapse ordered by destination neuron name. 
    The values are separated by blanks.                       

     Parameters:                                                                  
        directory      name of the directory to write the files
        filebase       prefix of the file name for all the files
        clock          clock that determines the interval for output      
        hor_root       root of the horizontal neuron hierarchy
        lat_root       root of the lateral neuron hierarchy
        lgn_root       root of the geniculate neuron hierarchy
        med_root       root of the medial neuron hierarchy
        ste_root       root of the stellate neuron hierarchy
        sub_root       root of the subpial neuron hierarchy

****************************************************************** */  
function dump_synapse_nmda_currents (directory, filebase, clock, \
             hor_root, lat_root, lgn_root, med_root, ste_root, sub_root)
   str directory, filebase, clock, \
       hor_root, lat_root, lgn_root, med_root, ste_root, sub_root
   
   str group, file
   if (ECHO_ON == 1)
      echo "Saving NMDA currents from lateral neurons:"
   end
   
   file = {filebase}@"Lateral2LateralNMDACurrent.dat" 
   group = {LAT_LAT_TARGET}@{"/"@{{LAT_LAT_SYNAPSE}@"_n"}} 
   create_outfile {directory} {file} {clock} {{lat_root}@"/cell"} {group} Ik 
   
   file = {filebase}@"Lateral2MedialNMDACurrent.dat" 
   group = {LAT_MED_TARGET}@{"/"@{{LAT_MED_SYNAPSE}@"_n"}} 
   create_outfile {directory} {file} {clock} {{med_root}@"/cell"} {group} Ik       
   
   file = {filebase}@"Lateral2StellateNMDACurrent.dat" 
   group = {LAT_STE_TARGET}@{"/"@{{LAT_STE_SYNAPSE}@"_n"}} 
   create_outfile {directory} {file} {clock} {{ste_root}@"/cell"} {group} Ik       
   
   file = {filebase}@"Lateral2HorizontalNMDACurrent.dat" 
   group = {LAT_HOR_TARGET}@{"/"@{{LAT_HOR_SYNAPSE}@"_n"}} 
   create_outfile {directory} {file} {clock} {{hor_root}@"/cell"} {group} Ik       
 
   file = {filebase}@"Lateral2SubpialNMDACurrent.dat" 
   group = {LAT_SUB_TARGET}@{"/"@{{LAT_SUB_SYNAPSE}@"_n"}} 
   create_outfile {directory} {file} {clock} {{sub_root}@"/cell"} {group} Ik    
   
   if (ECHO_ON == 1)
      echo "Saving NMDA currents from medial neurons:"
   end
   
   file = {filebase}@"Medial2LateralNMDACurrent.dat" 
   group = {MED_LAT_TARGET}@{"/"@{{MED_LAT_SYNAPSE}@"_n"}} 
   create_outfile {directory} {file} {clock} {{lat_root}@"/cell"} {group} Ik 
   
   file = {filebase}@"Medial2MedialNMDACurrent.dat" 
   group = {MED_MED_TARGET}@{"/"@{{MED_MED_SYNAPSE}@"_n"}} 
   create_outfile {directory} {file} {clock} {{med_root}@"/cell"} {group} Ik       
   
   file = {filebase}@"Medial2StellateNMDACurrent.dat" 
   group = {MED_STE_TARGET}@{"/"@{{MED_STE_SYNAPSE}@"_n"}} 
   create_outfile {directory} {file} {clock} {{ste_root}@"/cell"} {group} Ik       
   
   file = {filebase}@"Medial2HorizontalNMDACurrent.dat" 
   group = {MED_HOR_TARGET}@{"/"@{{MED_HOR_SYNAPSE}@"_n"}} 
   create_outfile {directory} {file} {clock} {{hor_root}@"/cell"} {group} Ik    
   
   file = {filebase}@"Medial2SubpialNMDACurrent.dat" 
   group = {MED_SUB_TARGET}@{"/"@{{MED_SUB_SYNAPSE}@"_n"}} 
   create_outfile {directory} {file} {clock} {{sub_root}@"/cell"} {group} Ik    
end


/* ******************************************************************
                       dump_synapse_gaba_a_currents                                 
    Writes the GABA_A currents at the time interval specified by
    clock. The values for each combination of source and destination population  
    are written to a separate file. Each line of a file starts with the time and 
    then gives the values for the synapse ordered by destination neuron name. 
    The values are separated by blanks.                       

     Parameters:                                                                  
        directory      name of the directory to write the files
        filebase       prefix of the file name for all the files
        clock          clock that determines the interval for output      
        hor_root       root of the horizontal neuron hierarchy
        lat_root       root of the lateral neuron hierarchy
        lgn_root       root of the geniculate neuron hierarchy
        med_root       root of the medial neuron hierarchy
        ste_root       root of the stellate neuron hierarchy
        sub_root       root of the subpial neuron hierarchy

****************************************************************** */  
function dump_synapse_gaba_a_currents (directory, filebase, clock, \
             hor_root, lat_root, lgn_root, med_root, ste_root, sub_root)
   str directory, filebase, clock, \
       hor_root, lat_root, lgn_root, med_root, ste_root, sub_root
   
   str group, file
   if (ECHO_ON == 1)
      echo "Saving GABA_A currents from stellate neurons:"
   end
   
   file = {filebase}@"Stellate2LateralGabaACurrent.dat" 
   group = {STE_LAT_TARGET}@{"/"@{{STE_LAT_SYNAPSE}@"_a"}} 
   create_outfile {directory} {file} {clock} {{lat_root}@"/cell"} {group} Ik 
   
   file = {filebase}@"Stellate2MedialGabaACurrent.dat" 
   group = {STE_MED_TARGET}@{"/"@{{STE_MED_SYNAPSE}@"_a"}} 
   create_outfile {directory} {file} {clock} {{med_root}@"/cell"} {group} Ik       
   
   file = {filebase}@"Stellate2StellateGabaACurrent.dat" 
   group = {STE_STE_TARGET}@{"/"@{{STE_STE_SYNAPSE}@"_a"}} 
   create_outfile {directory} {file} {clock} {{ste_root}@"/cell"} {group} Ik       
   
   if (ECHO_ON == 1)
      echo "Saving GABA_A currents from horizontal neurons:"
   end
   
   file = {filebase}@"Horizontal2LateralGabaACurrent.dat" 
   group = {HOR_LAT_TARGET}@{"/"@{{HOR_LAT_SYNAPSE}@"_a"}} 
   create_outfile {directory} {file} {clock} {{lat_root}@"/cell"} {group} Ik 
   
   file = {filebase}@"Horizontal2MedialGabaACurrent.dat" 
   group = {HOR_MED_TARGET}@{"/"@{{HOR_MED_SYNAPSE}@"_a"}} 
   create_outfile {directory} {file} {clock} {{med_root}@"/cell"} {group} Ik   
   
   if (ECHO_ON == 1)
      echo "Saving GABA_A currents from subpial neurons:"
   end
   
   file = {filebase}@"Subpial2LateralGabaACurrent.dat" 
   group = {SUB_LAT_TARGET}@{"/"@{{SUB_LAT_SYNAPSE}@"_a"}} 
   create_outfile {directory} {file} {clock} {{lat_root}@"/cell"} {group} Ik 
   
   file = {filebase}@"Subpial2MedialGabaACurrent.dat" 
   group = {SUB_MED_TARGET}@{"/"@{{SUB_MED_SYNAPSE}@"_a"}} 
   create_outfile {directory} {file} {clock} {{med_root}@"/cell"} {group} Ik       
   
   file = {filebase}@"Subpial2SubpialGabaACurrent.dat" 
   group = {SUB_SUB_TARGET}@{"/"@{{SUB_SUB_SYNAPSE}@"_a"}} 
   create_outfile {directory} {file} {clock} {{sub_root}@"/cell"} {group} Ik  
   
end

/* ******************************************************************
                       dump_synapse_gaba_b_currents                                 
    Writes the GABA_B currents at the time interval specified by
    clock. The values for each combination of source and destination population  
    are written to a separate file. Each line of a file starts with the time and 
    then gives the values for the synapse ordered by destination neuron name. 
    The values are separated by blanks.                       

     Parameters:                                                                  
        directory      name of the directory to write the files
        filebase       prefix of the file name for all the files
        clock          clock that determines the interval for output      
        hor_root       root of the horizontal neuron hierarchy
        lat_root       root of the lateral neuron hierarchy
        lgn_root       root of the geniculate neuron hierarchy
        med_root       root of the medial neuron hierarchy
        ste_root       root of the stellate neuron hierarchy
        sub_root       root of the subpial neuron hierarchy

****************************************************************** */  
function dump_synapse_gaba_b_currents (directory, filebase, clock, \
             hor_root, lat_root, lgn_root, med_root, ste_root, sub_root)
   str directory, filebase, clock, \
       hor_root, lat_root, lgn_root, med_root, ste_root, sub_root
   
   str group, file
   
   if (ECHO_ON == 1)
      echo "Saving GABA_B currents from stellate neurons:"
   end
   
   file = {filebase}@"Stellate2LateralGabaBCurrent.dat" 
   group = {STE_LAT_TARGET}@{"/"@{{STE_LAT_SYNAPSE}@"_b"}} 
   create_outfile {directory} {file} {clock} {{lat_root}@"/cell"} {group} Ik 
   
   file = {filebase}@"Stellate2MedialGabaBCurrent.dat" 
   group = {STE_MED_TARGET}@{"/"@{{STE_MED_SYNAPSE}@"_b"}} 
   create_outfile {directory} {file} {clock} {{med_root}@"/cell"} {group} Ik       
   
   file = {filebase}@"Stellate2StellateGabaBCurrent.dat" 
   group = {STE_STE_TARGET}@{"/"@{{STE_STE_SYNAPSE}@"_b"}} 
   create_outfile {directory} {file} {clock} {{ste_root}@"/cell"} {group} Ik       
   
   if (ECHO_ON == 1)
      echo "Saving GABA_A currents from horizontal neurons:"
   end
   
   file = {filebase}@"Horizontal2LateralGabaBCurrent.dat" 
   group = {HOR_LAT_TARGET}@{"/"@{{HOR_LAT_SYNAPSE}@"_b"}} 
   create_outfile {directory} {file} {clock} {{lat_root}@"/cell"} {group} Ik 
   
   file = {filebase}@"Horizontal2MedialGabaBCurrent.dat" 
   group = {HOR_MED_TARGET}@{"/"@{{HOR_MED_SYNAPSE}@"_b"}} 
   create_outfile {directory} {file} {clock} {{med_root}@"/cell"} {group} Ik   
   
   if (ECHO_ON == 1)
      echo "Saving GABA_A currents from subpial neurons:"
   end
   
   file = {filebase}@"Subpial2LateralGabaBCurrent.dat" 
   group = {SUB_LAT_TARGET}@{"/"@{{SUB_LAT_SYNAPSE}@"_b"}} 
   create_outfile {directory} {file} {clock} {{lat_root}@"/cell"} {group} Ik 
   
   file = {filebase}@"Subpial2MedialGabaBCurrent.dat" 
   group = {SUB_MED_TARGET}@{"/"@{{SUB_MED_SYNAPSE}@"_b"}} 
   create_outfile {directory} {file} {clock} {{med_root}@"/cell"} {group} Ik       
   
   file = {filebase}@"Subpial2SubpialGabaBCurrent.dat" 
   group = {SUB_SUB_TARGET}@{"/"@{{SUB_SUB_SYNAPSE}@"_b"}} 
   create_outfile {directory} {file} {clock} {{sub_root}@"/cell"} {group} Ik  
end

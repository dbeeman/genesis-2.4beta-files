//================ BASIC UTILITIES FOR BUILDING NEURONS ==============//
// This file contains functions to read neuron coordinate positions   // 
// and to create and connect the compartments that make up individual //
// neurons.                                                           //
//                                                                    //
// Available functions:                                               //
// 1. connect_compartments - connect adjacent cylindrical compartments//
//    coordinates for the neurons, one neuron per line.               //
// 2. make_cylind_compartment - create a cylindrical compartment      //
// 3. make_sphere_compartment - create a spherical compartment        //
// 4. make_spike - create a spike train                               //
// 5. read_coords - read neuron coordinates from a file and create    //
//                    corresponding neurons                           //
//                                                                    //
//====================================================================//
include ../lib/global_constants.g


/* ******************************************************************
                      connect_compartments
     Connect compartments electrically
     
     Parameters:
        first           name of the first compartment
        second          name of the second compartment

****************************************************************** */  
function connect_compartments(first, second)
   str first, second

   addmsg {second} {first} RAXIAL Ra previous_state
   addmsg {first} {second} AXIAL previous_state
end


/* ******************************************************************
                      make_cylind_compartment
     Create a cylindrical compartment
     
     Parameters:
        path            name of the compartment
        len             length of the compartment
        dia             diameter of the compartment
        area            effective membrane surface area
        eleak           membrane leakage potential
        rm              membrane resistance
        cm              membrane capacitance
        ra              axial resistance

****************************************************************** */  
function make_cylind_compartment(path, len, dia, area, eleak, rm, cm, ra)
   str path
   float len, dia, area, eleak, rm, cm, ra

   create compartment {path}
   setfield {path} Em {eleak} Rm {rm/area} Cm {cm*area} \
      Ra {4.0*ra*len/(dia*dia*PI)}
end


/* ******************************************************************
                      make_sphere_compartment
     Create a spherical compartment
     
     Parameters:
        path            name of the compartment
        dia             diameter of the compartment
        area            effective membrane surface area
        eleak           membrane leakage potential
        rm              membrane resistance
        cm              membrane capacitance
        ra              axial resistance

****************************************************************** */  
function make_sphere_compartment(path, dia, area, eleak, rm, cm, ra)
   str path
   float dia, area, eleak, rm, cm, ra

   create compartment {path}
   setfield {path} Em {eleak} Rm {rm/area} Cm {cm*area} Ra {8.0*ra/(dia*PI)}
end


/* ******************************************************************
                      make_spike
     Generates a spike train from spike membrane potential Vm using
     a spikegen mechanism named {path}/spike
     
     Parameters:
        path           name of the compartment
        dia             diameter of the compartment
        area            effective membrane surface area
        eleak           membrane leakage potential
        rm              membrane resistance
        cm              membrane capacitance
        ra              axial resistance

****************************************************************** */  
function make_spike(path, thresh, refract, amp)
   str path
   float thresh, refract, amp

   create spikegen {path}/spike
   setfield ^ thresh {thresh} abs_refract {refract} output_amp {amp}
   addmsg {path} {path}/spike INPUT Vm
end


/* ******************************************************************
                       read_coords                                  
   Read x, y, z coordinates of a set of elements from file filepath  
   and create numbered elements parent0, ....                         

     Parameters:                                                                  
        filepath       name of the file which stores the coordinates
        parent         address of the parent of cells to be created 

****************************************************************** */  
function read_coords (filepath, parent)
   str filepath, parent
    
   openfile {filepath} r

   str xt, yt, zt  
   str line = {readfile {filepath} -linemode}
   int count = 0;
   while (!{eof {filepath}})
      count = count + 1
      create neutral {parent}{count}
      xt = {getarg {arglist {line}} -arg 1}
      yt = {getarg {arglist {line}} -arg 2}
      zt = {getarg {arglist {line}} -arg 3}
      setfield ^ x {xt} y {yt} z {zt}
      line = {readfile {filepath} -linemode}
   end

	// calculate total LGN neurons
	if ({parent} == "/network_lgn/cell")
		TOTAL_LGN_NEURONS = count
	end
   
   closefile {filepath}
   
   if (ECHO_ON == 1)
      echo "Created" {count} {parent} "neurons"
   end
end

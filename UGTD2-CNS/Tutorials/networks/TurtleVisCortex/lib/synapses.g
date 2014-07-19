//================== BASIC FUNCTIONS TO CREATE SYNAPSES ==============//
// This file contains functions to create different types of synapses //
//====================================================================//
include ../lib/global_constants.g

//================ SYNAPSE   PARAMETER DEFINITIONS ===================//
float NMDA_CMG = 2
float NMDA_ETA = 0.33
float NMDA_GAMMA = 60


/* ******************************************************************
                       make_synapse
     Creates a synapse called {path}/{syn_channel}.
     
     Parameters:
        path           name of the compartment containing synapse
        syn_channel    name of channel type
        gmax           peak channel conductance
        revpot         reversal potential
        tau1           time constant 1
        tau2           time constant 2 
                
****************************************************************** */  
function make_synapse(path, syn_channel, gmax, revpot, tau1, tau2)
   str path, syn_channel
   float gmax, revpot, tau1, tau2

   create synchan {path}/{syn_channel}
   setfield ^ Ek {revpot} tau1 {tau1} tau2 {tau2} gmax {gmax}
   addmsg {path}/{syn_channel} {path} CHANNEL Gk Ek
   addmsg {path} {path}/{syn_channel} VOLTAGE Vm
end


/* ******************************************************************
                       make_synapse_nmda
     Creates a synapse called {path}/{syn_channel}.
     
     Parameters:
        path           name of the compartment containing synapse
        syn_channel    name of channel type
        gmax           peak channel conductance
        revpot         reversal potential
        tau1           time constant 1
        tau2           time constant 2 
                
****************************************************************** */  
function make_synapse_nmda(path, syn_channel, gmax, revpot, tau1, tau2)
   str path, syn_channel
   float gmax, revpot, tau1, tau2

   create synchan {path}/{syn_channel}
   setfield ^ Ek {revpot} tau1 {tau1} tau2 {tau2} gmax {gmax}
   create Mg_block {path}/{syn_channel}/block
   setfield ^ CMg {NMDA_CMG} KMg_A {1.0/NMDA_ETA} KMg_B {1.0/NMDA_GAMMA}
   addmsg {path}/{syn_channel} {path}/{syn_channel}/block \
      CHANNEL Gk Ek
   addmsg {path}/{syn_channel}/block {path} CHANNEL Gk Ek
   addmsg {path} {path}/{syn_channel}/block VOLTAGE Vm
   addmsg {path} {path}/{syn_channel} VOLTAGE Vm
end


/* ******************************************************************
                       connect_synapse
     Connects a synapse between src and dest
     
     Parameters:
        src            pre-synaptic source
        dest           post-synaptic target
        chan           synapse object name
        tdelay         synaptic delay
        weight         synaptic weight
                
****************************************************************** */  
function connect_synapse (src, dest, chan, tdelay, weight)
   str src, dest, chan
   float tdelay, weight
   
   str dest_syn = {dest}@{"/"@{chan}}
   addmsg {src} {dest_syn} SPIKE
   int this_syn = {getfield {dest_syn} nsynapses} - 1
   setfield {dest_syn} \
      synapse[{this_syn}].delay {tdelay} \
      synapse[{this_syn}].weight {weight}
end


/* ******************************************************************
                              gauss
     Computes the gaussian of the distance between pre and post, given
     the variance. This is used to model gaussian fall-off of synaptic
     coupling as a function of distance.
     
     Parameters:
        x_pre           x coordinate of the presynaptic neuron
        x_post          x coordinate of the postsynaptic neuron
        y_pre           y coordinate of the presynaptic neuron
        y_post          y coordinate of the postsynaptic neuron
        var             variance of the gaussian distribution
       
****************************************************************** */  
function gauss(x_pre, x_post, y_pre, y_post, var)
   float x_pre, y_pre, x_post, y_post, var

   float f
   f = {exp {-0.5/(var * var)*((x_pre-x_post)**2 + (y_pre-y_post)**2)}}
   return f
end



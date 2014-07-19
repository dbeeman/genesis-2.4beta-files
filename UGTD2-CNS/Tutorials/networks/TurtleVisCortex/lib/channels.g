//================= ACTIVE CHANNELS NGU MODEL ========================//
// Parameters determined by Phil Ulinski, University of Chicago       //
// This file contains the functions for making the active channels    //
//====================================================================//
 include ../lib/global_constants.g
 
int EXPONENTIAL =   1  // Exponential form of voltage-dependent rate
int SIGMOID     =   2  // Sigmoidal form of voltage-dependent rate
int LINOID      =   3  // Linoidal form of voltage-dependent rate


/* ******************************************************************
                       make_calcium_channel
     Creates a hh-type calcium channel {parent_path}/calcium_channel
     
     Parameters:
        parent_path    parent location for channel object
        gmax           (maximum channel conductance)/area
        revpot         channel reversal potential
        area           area of containing compartment in m^2
        
****************************************************************** */                 
function make_calcium_channel (parent_path, gmax, revpot, area)
   str parent_path   
   float gmax, revpot, area
                    
   str channel_path = {parent_path}@"/calcium_channel"  // full path to channel
   create hh_channel {channel_path}
   setfield  ^ \
      Ek            {revpot} \      // V
      Gbar          {gmax * area} \ // S
      Xpower        2.0 \
      Ypower        1.0 \
      X_alpha_FORM {LINOID} \
      X_alpha_A     -0.075e6 \      // 1/V-sec
      X_alpha_B     -7.500e-3 \     // V
      X_alpha_V0    -20.00e-3  \    // V
      X_beta_FORM {LINOID} \
      X_beta_A      0.0101e6 \      // 1/sec
      X_beta_B      4.4e-3 \        // V
      X_beta_V0     -21.00e-3 \     // V
      Y_alpha_FORM {LINOID} \
      Y_alpha_A     0.000344e6 \    // 1/sec
      Y_alpha_B     4.45e-3 \       // V
      Y_alpha_V0    -54.00e-3 \     // V
      Y_beta_FORM {LINOID} \
      Y_beta_A      -0.0003093e6 \  // 1/sec
      Y_beta_B      -4.00e-3 \      // V
      Y_beta_V0     -60.00e-3       // V
      addmsg {channel_path} {parent_path} CHANNEL Gk Ek
      addmsg {parent_path} {channel_path} VOLTAGE Vm
end


/* ******************************************************************
                       make_calcium_conc
     Creates single shell model of calcium concentration at
     {parent_path}/Ca_conc with resting or base level of 0
     
     Parameters:
        parent_path    parent location for concentration object
        tau            time constant of decay
        b              value of 1/(ion_charge*Faraday*volume)
        
****************************************************************** */  
function make_calcium_conc (parent_path, tau, b)
   float tau, b
   str parent_path                    // where to place the channel
   str channel_path = {parent_path}@"/Ca_conc"  // full path to channel
   
   create Ca_concen {channel_path}
   setfield ^ tau {tau} B {b} Ca_base 0.0
 end


/* ******************************************************************
                       make_calcium_dep_K_AHP
     Creates a tabulated Ca-dependent K AHP channel at {parent_path}/K_AHP
     
     Parameters:
        parent_path    parent location for channel object
        gkmax          potassium (maximum channel conductance)/area
        gcmax          potassium (maximum channel conductance)/area
        krevpot        potassium channel reversal potential
        crevpot        calcium channel reversal potential
        tau            time constant of decay for calcium concentration
        b              value of 1/(ion_charge*Faraday*volume)
        area           area of containing compartment in m^2
        
   This is a tabchannel that gets the calcium concentration from Ca_conc
   in order to calculate the activation of its Z gate.  It is set up much
   like the Ca channel, except that the A and B tables have values which are
   functions of concentration, instead of voltage.  This function creates
   a calcium channel and a calcium concentration with the same parent as
   itself. 
****************************************************************** */  
function make_calcium_dep_K_AHP (parent_path, gkmax, gcmax, krevpot, crevpot, area, tau, b)
   str parent_path     
   float gkmax, gcmax, krevpot, crevpot, area, tau, b
                  
   str channel_path = {parent_path}@"/K_AHP"            // full path to K_AHP channel
   str calcium_path = {parent_path}@"/calcium_channel"  // full path to calcium channel
   str caconc_path = {parent_path}@"/Ca_conc"  // full path to calcium concentration
   
   // Create a calcium channel
   make_calcium_channel {parent_path} {gcmax} {crevpot} {area}
   // Create a mechanism for getting calcium from calcium channel
   make_calcium_conc {parent_path} {tau} {b}
   addmsg {calcium_path} {caconc_path} I_Ca Ik

   create tabchannel {channel_path}
   setfield ^ Ek {krevpot} Gbar {gkmax * area} Ik 0  Gk 0
   setfield ^  Xpower 0 Ypower  0 Zpower  1

   // Allocate space in the Z gate A and B tables, covering a concentration
   // range from xmin = 0 to xmax = 1000, with 50 divisions
   float   xmin = 0.0
   float   xmax = 1000.0
   int     xdivs = 50

   call {channel_path} TABCREATE Z {xdivs} {xmin} {xmax}
   int i
   float x, dx, y
   dx = (xmax - xmin)/xdivs
   x = xmin
   for (i = 0; i <= {xdivs}; i = i + 1)
      if (x < 500.0)
         y = 0.02*x
      else
         y = 10.0
      end
      setfield {channel_path} Z_A->table[{i}] {y}
      setfield {channel_path} Z_B->table[{i}] {1.0}
      x = x + dx
   end
   setfield {channel_path} Z_A->calc_mode 0 Z_B->calc_mode 0
   call {channel_path} TABFILL Z 3000 0

   addmsg {channel_path} {parent_path} CHANNEL Gk Ek
   addmsg {parent_path} {channel_path} VOLTAGE Vm
   addmsg {caconc_path} {channel_path} CONCEN Ca
end


/* ******************************************************************
                       make_potassium_channel
     Creates a hh-type potassium channel {parent_path}/potassium_channel
     
     Parameters:
        parent_path    parent location for channel object
        gmax           (maximum channel conductance)/area
        revpot         channel reversal potential
        area           area of containing compartment in m^2
        
****************************************************************** */  
function make_potassium_channel(parent_path, gmax, revpot, area)
   str parent_path  
   float gmax, revpot, area 
                   
   str channel_path = {parent_path}@"/potassium_channel"  // full path to channel
   create hh_channel {channel_path}
   setfield ^ \
      Ek           {revpot} \           // V
      Gbar         {gmax * area} \      // S
      Xpower       4.0 \
      Ypower       0.0 \
      X_alpha_FORM {LINOID} \
      X_alpha_A    -0.032e6 \           // 1/V-sec
      X_alpha_B    -3.5e-3 \            // V
      X_alpha_V0   -36.00e-3 \          // V
      X_beta_FORM {EXPONENTIAL} \
      X_beta_A     0.50e3 \             // 1/sec
      X_beta_B     -40.0e-3 \           // V
      X_beta_V0    -41.00e-3            // V
    addmsg {channel_path} {parent_path} CHANNEL Gk Ek
    addmsg {parent_path} {channel_path} VOLTAGE Vm
end


/* ******************************************************************
                       make_sodium_channel
     Creates a hh-type fast sodium channel {parent_path}/sodium_channel
     
     Parameters:
        parent_path    parent location for channel object
        gmax           (maximum channel conductance)/area
        revpot         channel reversal potential
        area           area of containing compartment in m^2
        
****************************************************************** */  
function make_sodium_channel (parent_path, gmax, revpot, area)
   str parent_path  
   float gmax, revpot, area

   str channel_path = {parent_path}@"/sodium_channel"  // full path to channel
   create hh_channel {channel_path}
   setfield  ^ \
      Ek          {revpot} \           // V
      Gbar        {gmax * area} \      // S
      Xpower      3.0 \
      Ypower      1.0 \
      X_alpha_FORM {LINOID} \
      X_alpha_A   -0.32e6 \           // 1/V-sec
      X_alpha_B   -4.00e-3 \          // V
      X_alpha_V0  -34.67e-3  \        // V
      X_beta_FORM {LINOID} \
      X_beta_A    0.28e6 \            // 1/sec
      X_beta_B    5.00e-3 \           // V
      X_beta_V0   -6.67e-3 \          // V
      Y_alpha_FORM {EXPONENTIAL} \
      Y_alpha_A   0.128e3 \           // 1/sec
      Y_alpha_B   -18.00e-3 \         // V
      Y_alpha_V0 -34.00e-3 \          // V
      Y_beta_FORM {SIGMOID} \
      Y_beta_A    4.00e3 \            // 1/sec
      Y_beta_B    -5.00e-3 \          // V
      Y_beta_V0   -11.00e-3           // V
    addmsg {channel_path} {parent_path} CHANNEL Gk Ek
    addmsg {parent_path} {channel_path} VOLTAGE Vm
end



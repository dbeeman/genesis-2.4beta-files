//======================== TurtleVisCortex Model =======================//
//                                                                      //
// This is the large scale model of turtle visual cortex described in   //
//                                                                      //
// Nenadic, Z, Ghosh, BK and Ulinski, P (2002) Modeling and             //
// Estimation Problems in the Turtle Visual Cortex,                     //
// IEEE Trans. Bio-Med. Eng., 49:753-762                                //
//                                                                      //
// Nenadic, Z, Ghosh, BK and Ulinski, P  (2003) Propagating Waves       //
// in Visual Cortex: A Large Scale Model of Turtle Visual               //
// Cortex", J. Computational Neuroscience 14:161-184.                   //
//                                                                      //
// The model proceeds as follows                                        //
// 1. Create the 6 neuronal populations                                 //
// 2. Create the synapses for the populations                           //
// 3. Set the clocks to control the time step for the simulation        //
// 4. Set up the monitoring and control panel                           //
// 5. Set up the input stimulus                                         //
// 6. Create the desired output files                                   //
// 7. Start the simulation                                              //
//                                                                      //
// Setup:                                                               //
// 1. Must provide coordinate files for neuron positions for the 6      //  
//      populations of neurons                                          //
// 2. Must set the hierarchy root name for each neuron population       //
//                                                                      //
// Notes:                                                               //
// 1. To create a different number of neurons or to locate neurons in   //
//    different positions, modify the corresponding coordinate file     //
// 2. To change the input stimulus, set the appropiate flag(s) and      //
//    and modify the stimulation parameters in this file                //
//    stimulus.g and call it in place of make_diffuse_flash             //
// 3. To output different variables, add an appropriate function to     //
//    utilities_output.g and call it in place of or in addition to      //
//    dump_neuron_soma_voltages                                         //
// 4. To prevent overwriting of the output data when starting a new     //
//    run, change the value of the string variable "responseName"       //
//                                                                      //
//======================================================================//                                                         

include ../lib/global_constants.g

// ==================== INITIAL EXPERIMENTAL SETUP ==================== //
// ==================================================================== //
// IMPORTANT -- Don't forget to change the responseName or your
//              old datafiles will be overwritten!!

str responseName  = "TurtleVisCortex_diffuse_" 

// == Set stimulation type(s) ========================================== //
int DIFFUSE_LIGHT_FLASH = 1
int STATIONARY_LIGHT_SPOT = 0
int MOVING_LIGHT_SPOT = 0
int DIRECT_NEURON_STIM_REC = 0
int DIRECT_NEURON_STIM_CIR = 0

// == Select data type(s) to save ===================================== //
int voltage_flag = 1
int AMPA_flag = 1
int NMDA_flag = 1
int GABA_A_flag = 1
int GABA_B_flag = 1
int sodium_flag = 1
int calcium_flag = 1
int potassium_flag = 1
int KAHP_flag = 1	
int LGN_flag = 1

// ====================================================================  //
// =================== END INITIAL EXPERIMENTAL SETUP =================  //


//================INPUT FILES FOR NEURONAL COORDINATES ==================//
str horizontal_coords = "../coords/horizontal.dat"
str lateral_coords = "../coords/lateral.dat"
str lgn_coords = "../coords/lgn.dat"
str medial_coords = "../coords/medial.dat"
str stellate_coords = "../coords/stellate.dat"
str subpial_coords = "../coords/subpial.dat"
str varicosity_coords = "../coords/varicosities.dat"

//==========ROOT HIERARCHY NAMES FOR NEURONAL POPULATIONS ================//
str HOR_ROOT = "/network_horizontal"
str LAT_ROOT = "/network_lateral"
str LGN_ROOT = "/network_lgn"
str MED_ROOT = "/network_medial"
str STE_ROOT = "/network_stellate"
str SUB_ROOT = "/network_subpial"

//==========ROOT HIERARCHY NAMES FOR NEURONAL STIMULATIONS ===============//
str INPUT_ROOT1 = "/input1/funky"
str INPUT_ROOT2 = "/input2/funky"
str INPUT_ROOT3 = "/input3/funky"
str INPUT_ROOT4 = "/input4/funky"
str INPUT_ROOT5 = "/input5/funky"

//==================== CREATING GENICULATE CELLS =========================//

int TOTAL_LGN_NEURONS = 0
include ../lib/neurons_geniculate.g
make_geniculate_cells {lgn_coords} {LGN_ROOT}

//======================= CREATING LATERAL CELLS =========================//
include ../lib/neurons_lateral.g
make_lateral_cells {lateral_coords} {LAT_ROOT}

//======================= CREATING MEDIAL CELLS ==========================//
include ../lib/neurons_medial.g
make_medial_cells {medial_coords} {MED_ROOT}

//===================== CREATING STELLATE CELLS ==========================//
include ../lib/neurons_stellate.g
make_stellate_cells {stellate_coords} {STE_ROOT}

//===================== CREATING HORIZONTAL CELLS ========================//
include ../lib/neurons_horizontal.g
make_horizontal_cells {horizontal_coords} {HOR_ROOT}

//===================== CREATING SUBPIAL CELLS ===========================//
include ../lib/neurons_subpial.g
make_subpial_cells {subpial_coords} {SUB_ROOT}

//================== CREATING SYNAPSES FROM GENICULATE CELLS =============//
include ../lib/synapses_geniculate.g
make_lgn_synapses {varicosity_coords} {LGN_ROOT} {LAT_ROOT}  \
    {MED_ROOT} {STE_ROOT} {SUB_ROOT}

//================== CREATING SYNAPSES FROM LATERAL CELLS ================//
include ../lib/synapses_lateral.g
make_lateral_synapses {LAT_ROOT} {HOR_ROOT} {MED_ROOT} \
    {STE_ROOT} {SUB_ROOT}

//================= CREATING SYNAPSES FROM MEDIAL CELLS ==================//
include ../lib/synapses_medial.g
make_medial_synapses {MED_ROOT} {HOR_ROOT} {LAT_ROOT} \
    {STE_ROOT} {SUB_ROOT}

//================= CREATING SYNAPSES FROM STELLATE CELLS ================//
include ../lib/synapses_stellate.g
make_stellate_synapses {STE_ROOT} {LAT_ROOT} {MED_ROOT}

//================ CREATING SYNAPSES FROM HORIZONTAL CELLS ===============//
include ../lib/synapses_horizontal.g
make_horizontal_synapses {HOR_ROOT} {LAT_ROOT} {MED_ROOT}

//================= CREATING SYNAPSES FROM SUBPIAL CELLS =================//
include ../lib/synapses_subpial.g
make_subpial_synapses {SUB_ROOT} {LAT_ROOT} {MED_ROOT}


//======================== SET CLOCK AND STEPSIZE ========================//
float tmax = 1.50   // Time in seconds for the simulation to run
float dt = 0.00005  // Internal time stepsize
setclock 0 {dt}     // Clock for controlling internal integration step
setclock 1 {0.001}  // Clock for controlling dump values display
setclock 2 {2*tmax} // Clock set larger than the simulation running time


//====================== SET THE INPUT STIMULUS ==========================//
// To stimulate the model, set one or more of the flags below to true (1) //
//                                                                        //
// Available stimulation modes are:                                       //
//    DIFFUSE_LIGHT_STIM simultaneously stimulate all LGN neurons         //
//    STATIONARY_LIGHT_SPOT stimulate a contiguous subset of LGN neurons  //
//    MOVING_LIGHT_SPOT sequentially stimulate LGN neurons at a specified //
//       speed. A positive speed means the light spot is moving in a      //
//			nasal-to-temporal direction; a negative speed means the spot     //
//       is moving in a temporal-to-nasal direction                       //
//    DIRECT_NEURON_STIM_REC apply a current to a target population       //
//      of neurons (e.g. lateral cells) in a specified rectangular area   //
//    DIRECT_NEURON_STIM_CIR apply a current to a target population       //
//      of neurons (e.g. lateral cells) in a specified circular area      //
//========================================================================//

include ../lib/stimulus.g

// Change parameters below for each stimulus type

if (DIFFUSE_LIGHT_FLASH == 1)
	float FLASH_DUR = 0.150				// Duration of flash in sec
	float INPUT_LEVEL = 0.2e-9			// Injected current in amps
	float STIM_DELAY = 0.0				// Stim onset delay in sec
	
	make_diffuse_flash {INPUT_ROOT1} {{LGN_ROOT}@"/cell"} \
		{INPUT_LEVEL} {FLASH_DUR} {tmax} {STIM_DELAY} 
end

if (STATIONARY_LIGHT_SPOT == 1)
	int FIRST_LGN = 1						// First LGN cell stimulated
	int LAST_LGN = 20						// Last LGN cell stimulated
	float FLASH_DUR = 0.150   			// Duration of flash in sec
	float INPUT_LEVEL = 0.2e-9 		// Injected current in amps
	float STIM_DELAY = 0.0				// Stim onset delay in sec
	
	make_stationary_spot {FIRST_LGN} {LAST_LGN} \ 
		{INPUT_ROOT2} {{LGN_ROOT}@"/cell"} {INPUT_LEVEL} \
		{FLASH_DUR} {tmax} {STIM_DELAY} 
end

if (MOVING_LIGHT_SPOT == 1)
	int SPOT_SPEED = -1.0          	// Speed in LGN neurons per ms 
												//   sign of speed determines
												//   the movement direction
	float FLASH_DUR = 0.150   			// Duration of flash in sec
	float INPUT_LEVEL = 0.2e-9 		// Injected current in amps
	float STIM_DELAY = 0.0				// Stim onset delay in sec
	
	make_moving_spot {SPOT_SPEED} {INPUT_ROOT3} \
      {{LGN_ROOT}@"/cell"} {INPUT_LEVEL} {FLASH_DUR} \
      {tmax} {STIM_DELAY} 
end

if (DIRECT_NEURON_STIM_REC == 1)
	float X1 = 0.0							// Left x coordinate of rectangle
	float X2 = 5.0e-002					// Right x coordinate of rectangle
	float Y1 = 0.0							// Bottom y coordinate of rectangle
	float Y2 = 1.0							// Top y coordinate of rectangle
	str NEURON_TARGET						// Neuron target
	str TARGET_EREST						// Target resting membrane potential
	float STIM_DUR = 0.05   			// Stim duration in sec
	float INPUT_LEVEL = 1.0e-9 		// Injected current in amps
	float STIM_DELAY = 0.0				// Stim onset delay in sec
	
	//Set target neurons
	NEURON_TARGET = {LAT_ROOT}
	TARGET_EREST = {LAT_EREST}
	
	make_neuron_stim_rec {X1} {X2} {Y1} {Y2} \ 
		{INPUT_ROOT4} {{NEURON_TARGET}@"/cell"} \ 
		{INPUT_LEVEL} {TARGET_EREST} {STIM_DUR} {tmax} {STIM_DELAY} 
end

if (DIRECT_NEURON_STIM_CIR == 1)
	float X1 = 1.0							// Stim center x 
	float Y1 = 0.5							// Stim center y 
	float STIM_RAD = 0.100				// Radius of stimulation
	str NEURON_TARGET						// Neuron target
	str TARGET_EREST						// Target resting membrane potential
	float STIM_DUR = 0.150   			// Stim duration in sec
	float INPUT_LEVEL = 0.2e-9 		// Injected current in amps
	float STIM_DELAY = 0.0				// Stim onset delay in sec
	
	//Set target neurons
	NEURON_TARGET = {LAT_ROOT}
	TARGET_EREST = {LAT_EREST}
	
	make_neuron_stim_cir {X1} {Y1} {STIM_RAD} \ 
		{INPUT_ROOT5} {{NEURON_TARGET}@"/cell"} \ 
		{INPUT_LEVEL} {TARGET_EREST} {STIM_DUR} {tmax} {STIM_DELAY} 
end

//=======================SETUP OUTPUT FILES===============================//
include ../lib/utilities_output.g
echo "Creating output directories if necessary..."

str responseDirectoryBase = {"../output/"@{responseName}}
mkdir {responseDirectoryBase}
str responseDir = {{responseDirectoryBase}@"/data"}
mkdir {responseDir}
str dataClock = "1"

// Dump data if flag is set
if (voltage_flag == 1)
	dump_neuron_soma_voltages {responseDir} {responseName} {dataClock} \
     	{HOR_ROOT} {LAT_ROOT} {LGN_ROOT} {MED_ROOT} {STE_ROOT} {SUB_ROOT}
end

if (calcium_flag == 1)
dump_neuron_calcium_currents {responseDir} {responseName} {dataClock} \
     {HOR_ROOT} {LAT_ROOT} {LGN_ROOT} {MED_ROOT} {STE_ROOT} {SUB_ROOT}
end

if (sodium_flag == 1)
dump_neuron_sodium_currents {responseDir} {responseName} {dataClock} \
     {HOR_ROOT} {LAT_ROOT} {LGN_ROOT} {MED_ROOT} {STE_ROOT} {SUB_ROOT} 
end

if (potassium_flag == 1)
dump_neuron_potassium_currents {responseDir} {responseName} {dataClock} \
     {HOR_ROOT} {LAT_ROOT} {LGN_ROOT} {MED_ROOT} {STE_ROOT} {SUB_ROOT} 
end

if (KAHP_flag == 1)
dump_neuron_kahp_currents {responseDir} {responseName} {dataClock} \
     {HOR_ROOT} {LAT_ROOT} {LGN_ROOT} {MED_ROOT} {STE_ROOT} {SUB_ROOT}
end

if (LGN_flag == 1)
dump_synapse_lgn_currents  {responseDir} {responseName} {dataClock} \
     {HOR_ROOT} {LAT_ROOT} {LGN_ROOT} {MED_ROOT} {STE_ROOT} {SUB_ROOT}
end

if (AMPA_flag == 1)
dump_synapse_ampa_currents {responseDir} {responseName} {dataClock} \
     {HOR_ROOT} {LAT_ROOT} {LGN_ROOT} {MED_ROOT} {STE_ROOT} {SUB_ROOT}
end

if (NMDA_flag == 1)
dump_synapse_nmda_currents {responseDir} {responseName} {dataClock} \
     {HOR_ROOT} {LAT_ROOT} {LGN_ROOT} {MED_ROOT} {STE_ROOT} {SUB_ROOT}
end

if (GABA_A_flag == 1)
dump_synapse_gaba_a_currents {responseDir} {responseName} {dataClock} \
     {HOR_ROOT} {LAT_ROOT} {LGN_ROOT} {MED_ROOT} {STE_ROOT} {SUB_ROOT}
end

if (GABA_B_flag == 1)
dump_synapse_gaba_b_currents {responseDir} {responseName} {dataClock} \
     {HOR_ROOT} {LAT_ROOT} {LGN_ROOT} {MED_ROOT} {STE_ROOT} {SUB_ROOT}  
end
       
//=========== RUN SIMULATION WHILE MONITORING PROGRESS ===================//
include ../lib/utilities_control.g
int num_steps = tmax/dt + 1
int view_flag = 1         // 1 = show 4 plots for monitoring, 0 = don't show
run_simulation {tmax} -0.1 0.05 {num_steps} {view_flag}

check
reset


//genesis

/*
 * Elliot D. Menschik
 *   Medical Scientist Training Program
 *   Institute of Neurological Sciences
 *   University of Pennsylvania
 *   School of Medicine
 *   menschik@neuroengineering.upenn.edu
 *
 *
 *
 * Stratum pyramidale interneuron - prototypes
 *
 * Traub RD, Miles R: Pyramidal Cell-toInhibitory Cell Spike 
 * Transduction Explicable by Active Dendritic Conductances in
 * Inhibitory Cell. JourNa_intl of Computational Neuroscience
 * 1995, 2:291-298
 *
 * Modified from Traub 91 & 94 prototypes.
 *
 */

// CONSTANTS
/* hippocampal cell resting potl */

float EREST_ACT = -0.060
float E_NA = 0.115 + EREST_ACT // 0.055
float E_K = -0.025 + EREST_ACT // -0.075
float E_CA = 0.140 + EREST_ACT // 0.080

float INT_SOMA_A = .94247e-9 // soma area in square meters


/*
For these channels, the maximum channel conductance (Gbar) has been
calculated using the CA3 soma channel conductance densities and soma
area.  Typically, the functions which create these channels will be used
to create a library of prototype channels.  When the cell reader creates
copies of these channels in various compartments, it will set the actual
value of Gbar by calculating it from the cell parameter file.
*/

//========================================================================
//                      Tabulated Ca Channel
//========================================================================

function make_Ca_int
        if (({exists Ca_int}))
                return
        end

        create tabchannel Ca_int
	setfield ^ 				\
		Ek 	{E_CA} 			\
		Gbar 	{40*INT_SOMA_A}		\
		Ik 	0 			\
		Gk 	0 			\
		Xpower 	2  			\
		Ypower 	0 			\
		Zpower 	0

// Converting Traub's expressions for the gCa/s alpha and beta functions
// to SI units and entering the A, B, C, D and F parameters, we get:

	setupalpha	Ca_int			\
		X 				\ // gate
		1.6e3 				\ // AA
		0 				\ // AB
		1.0 				\ // AC
		{-1.0*(0.065 + EREST_ACT)}  	\ // AD
		-0.01389 			\ // AF
		{-20e3*(0.0511 + EREST_ACT)} 	\ // BA
		20e3 				\ // BB
		-1.0  				\ // BC
		{-1.0*(0.0511 + EREST_ACT)} 	\ // BD
		5.0e-3				  // BF

end

/***********************************************************************
Next, we need an element to take the Calcium current calculated by the Ca
channel and convert it to the Ca concentration.  The "Ca_concen" object
solves the equation dC/dt = B* \
    I_Ca - C/tau, and sets Ca = Ca_base + C.  As
it is easy to make mistakes in units when using this Calcium diffusion
equation, the units used here merit some discussion.

With Ca_base = 0, this corresponds to Traub's diffusion equation for
concentration, except that the sign of the current term here is positive, as
GENESIS uses the convention that I_Ca is the current flowing INTO the
compartment through the channel.  In SI units, the concentration is usually
expressed in moles/m^3 (which equals millimoles/liter), and the units of B
are chosen so that B = 1/(ion_charge * Faraday * volume). Current is
expressed in amperes and one Faraday = 96487 coulombs.  However, in this
case, Traub expresses the concentration in arbitrary units, current in
microamps and uses tau = 13.33 msec.  If we use the same concentration units,
but express current in amperes and tau in seconds, our B constant is then
10^12 times the constant (called "phi") used in the paper.  The actual value
used will be typically be determined by the cell reader from the cell
parameter file.  However, for the prototype channel we will use Traub's
corrected value for the soma.  (An error in the paper gives it as 17,402
rather than 17.402.)  In our units, this will be 17.402e12.

***************************************************************************/

//========================================================================
//                      Ca concentration
//========================================================================

function make_Ca_conc_int
        if (({exists Ca_conc_int}))
                return
        end
        create Ca_concen Ca_conc_int
        setfield Ca_conc_int		\
		tau	333e-3 		\ // sec  ** new value for interneuron
		B 	17.402e12 	\ // Amps to mM
		Ca_base 0.0

        if (!{exists Ca_conc_int sendmsg1})
            addfield Ca_conc_int sendmsg1
        end

        setfield  Ca_conc_int sendmsg1 "../Ca_int . I_Ca Ik"
end

/*
This Ca_concen element should receive an "I_Ca" message from the calcium
channel, accompanied by the value of the calcium channel current.  As we
will ordinarily use the cell reader to create copies of these prototype
elements in one or more compartments, we need some way to be sure that the
needed messages are established.  Although the cell reader has enough
information to create the messages which link compartments to their channels
and to other adjacent compartments, it most be provided with the information
needed to establish additional messages.  This is done by placing the
message string in an environment variable of one of the elements which is
involved in the message.  The cell reader recognizes the environment
variables "sendmsg1", "sendmsg2", etc. as indicating that they are to be
evaluated and used to set up messages.  The paths are relative to the
element which contains the message in its environment.  Thus, "../Ca" refers
to the sibling element Ca and "."  refers to the Ca_conc element itself.
*/

//========================================================================
//             Tabulated Ca-dependent K AHP Channel
//========================================================================

/* \
     This is a tabchannel which gets the calcium concentration from Ca_conc
   in order to calculate the activation of its Z gate.  It is set up much
   like the Ca channel, except that the A and B tables have values which are
   functions of concentration, instead of voltage.
*/

function make_K_AHP_int
        if (({exists K_AHP_int}))
                return
        end

        create tabchannel K_AHP_int
	setfield ^ 				\
		Ek	{E_K} 			\
		Gbar 	{8*INT_SOMA_A} 		\
		Ik 	0 			\
		Gk 	0 			\
		Xpower 	0  			\
		Ypower 	0 			\
		Zpower 	1

                // Allocate space in the Z gate A and B tables, covering a concentration
                // range from xmin = 0 to xmax = 1000, with 50 divisions
        float xmin = 0.0
        float xmax = 1000.0
        int xdivs = 50

        call K_AHP_int TABCREATE Z {xdivs} {xmin} {xmax}
        int i
        float x, dx, y
        dx = (xmax - xmin)/xdivs
        x = xmin
        for (i = 0; i <= (xdivs); i = i + 1)
            if (x < 500.0)
                y = 0.02*x
            else
                y = 10.0
            end
            setfield K_AHP_int Z_A->table[{i}] {y}
            setfield K_AHP_int Z_B->table[{i}] {y + 1.0}
            x = x + dx
        end
        // For speed during execution, set the calculation mode to "no interpolation"
        // and use TABFILL to expand the table to 3000 entries.
        setfield K_AHP_int Z_A->calc_mode 0 Z_B->calc_mode 0
        call K_AHP_int TABFILL Z 3000 0
        // Use an environment variable to tell the cell reader to set up the
        // CONCEN message from the Ca_concen element
        if (!{exists K_AHP_int sendmsg1})
            addfield K_AHP_int sendmsg1
        end
        setfield  K_AHP_int sendmsg1 "../Ca_conc_int . CONCEN Ca"
end


//========================================================================
//  Ca-dependent K Channel - K(C) - (vdep_channel with table and tabgate)
//========================================================================
/*
The expression for the conductance of the potassium C-current channel has a
typical voltage and time dependent activation gate, where the time
dependence arises from the solution of a differential equation containing
the rate parameters alpha and beta.  It is multiplied by a function of
calcium concentration which is given explicitly rather than being obtained
from a differential equation.  Therefore, we need a way to multiply the
activation by a concentration dependent value which is determined from a
lookup table.  GENESIS 1.3 doesn't have a way to implement this with a
tabchannel, so we use the "vdep_channel" object here.  These channels
contain no gates and get their activation gate values from external gate
elements, via a "MULTGATE" message.  These gates are usually created with
"tabgate" objects, which are similar to the internal gates of the
tabchannels.  However, any object which can send the value of one of its
fields to the vdep_channel can be used as the gate.  Here, we use the
"table" object.  This generality makes the vdep_channel very useful, but it
is slower than the tabchannel because of the extra message passing involved.
*/

function make_K_C_int
        if (({exists K_C_int}))
                return
        end

        create vdep_channel K_C_int
                //      V
                //      S
                //      A
                //      S
                setfield ^ Ek {E_K} gbar {100.0*INT_SOMA_A} Ik 0 Gk 0
        float xmin = 0.0
        float xmax = 1000.0
        int xdivs = 50
        create table K_C_int/tab
        call K_C_int/tab TABCREATE {xdivs} {xmin} {xmax}
        int i
        float x, dx, y
        dx = (xmax - xmin)/xdivs
        x = xmin
        for (i = 0; i <= (xdivs); i = i + 1)
            if (x < 250.0)
                y = x/250.0
            else
                y = 1.0
            end
            setfield K_C_int/tab table->table[{i}] {y}
            x = x + dx
        end
	setfield K_C_int/tab table->calc_mode 0
	call K_C_int/tab TABFILL 3000 0
        float xmin = -0.1
        float xmax = 0.05
        int xdivs = 49
        create tabgate K_C_int/X
        call K_C_int/X TABCREATE alpha {xdivs} {xmin} {xmax}
        call K_C_int/X TABCREATE beta {xdivs} {xmin} {xmax}

        int i
        float x, dx, alpha, beta
        dx = (xmax - xmin)/xdivs
        x = xmin
        for (i = 0; i <= (xdivs); i = i + 1)
            if (x < EREST_ACT + 0.05)
                alpha = ({exp {53.872*(x - EREST_ACT) - 0.66835}})/0.018975
		beta = 2000*({exp {(EREST_ACT + 0.0065 - x)/0.027}}) - alpha
            else
		alpha = 2000*({exp {(EREST_ACT + 0.0065 - x)/0.027}})
		beta = 0.0
            end
            setfield K_C_int/X alpha->table[{i}] {alpha}
            setfield K_C_int/X beta->table[{i}] {beta}
            x = x + dx
        end

	setfield K_C_int/X alpha->calc_mode 0 beta->calc_mode 0
	call K_C_int/X TABFILL alpha 3000 0
	call K_C_int/X TABFILL beta 3000 0

        addmsg K_C_int/tab K_C_int MULTGATE output 1
        addmsg K_C_int/X K_C_int MULTGATE m 1
        if (!{exists K_C_int sendmsg1})
            addfield K_C_int sendmsg1
        end
        if (!{exists K_C_int sendmsg2})
            addfield K_C_int sendmsg2
        end
        setfield  K_C_int sendmsg1 "../Ca_conc_int  tab INPUT Ca"  \
            sendmsg2 "..  X  VOLTAGE Vm"
end



/*
The MULTGATE message is used to give the vdep_channel the value of the
activation variable and the power to which it should be raised.  As the
tabgate and table are sub-elements of the channel, they and their messages
to the channel will accompany it when copies are made.  However, we also
need to provide for messages which link to external elements.  The message
which sends the Ca concentration to the table and the one which sends the
compartment membrane potential to the tabgate are stored in environment
variables of the channel, so that they may be found by the cell reader.
*/

// The remaining channels are straightforward tabchannel implementations

//========================================================================
//                Tabchannel Na Hippocampal cell channel--soma-dend
//========================================================================
function make_Na_int
        if (({exists Na_int}))
                return
        end

        create tabchannel Na_int
                //      V
                //      S
                //      A
                //      S
                setfield ^ Ek {E_NA} Gbar {300*INT_SOMA_A} Ik 0 Gk 0 Xpower 2 \
                     Ypower 1 Zpower 0

        setupalpha Na_int X {320e3*(0.0131 + EREST_ACT)} -320e3 -1.0  \
            {-1.0*(0.0131 + EREST_ACT)} -0.004  \
            {-280e3*(0.0401 + EREST_ACT)} 280e3 -1.0  \
            {-1.0*(0.0401 + EREST_ACT)} 5.0e-3

        setupalpha Na_int Y 128.0 0.0 0.0 {-1.0*(0.017 + EREST_ACT)}  \
            0.018 4.0e3 0.0 1.0 {-1.0*(0.040 + EREST_ACT)} -5.0e-3
end

//========================================================================
//                Tabchannel K(DR) Hippocampal cell channel--soma-dend
//========================================================================
function make_K_DR_int
        if (({exists K_DR_int}))
                return
        end

        create tabchannel K_DR_int
                //      V
                //      S
                //      A
                //      S
                setfield ^ Ek {E_K} Gbar {150*INT_SOMA_A} Ik 0 Gk 0 Xpower 2  \
                    Ypower 0 Zpower 0

        setupalpha K_DR_int X {16e3*(0.0351 + EREST_ACT)} -16e3 -1.0  \
            {-1.0*(0.0351 + EREST_ACT)} -0.005 250 0.0 0.0  \
            {-1.0*(0.02 + EREST_ACT)} 0.04
end

//========================================================================
//                Tabchannel K(A) Hippocampal cell channel
//========================================================================
function make_K_A_int
        if (({exists K_A_int}))
                return
        end

        create tabchannel K_A_int
 	setfield ^ 					\
		Ek	{E_K} 				\
		Gbar 	{50*INT_SOMA_A} 		\
		Ik 	0 				\
		Gk 	0 				\
		Xpower 	1  				\
 		Ypower 	1 				\
		Zpower 	0

        setupalpha K_A_int X {20e3*(0.0131 + EREST_ACT)} -20e3 -1.0  \
            {-1.0*(0.0131 + EREST_ACT)} -0.01  \
            {-17.5e3*(0.0401 + EREST_ACT)} 17.5e3 -1.0  \
            {-1.0*(0.0401 + EREST_ACT)} 0.01

        setupalpha K_A_int Y 1.6 0.0 0.0 {0.013 - EREST_ACT} 0.018 50.0  \
            0.0 1.0 {-1.0*(0.0101 + EREST_ACT)} -0.005
end


//========================================================================
//                Tabchannel Na_int Hippocampal cell channel--axon IS
//========================================================================
function make_Na_int_axon
        if (({exists Na_intA}))
                return
        end

        create tabchannel Na_intA
                //      V
                //      S
                //      A
                //      S
                setfield ^ Ek {E_NA} Gbar {300*INT_SOMA_A} Ik 0 Gk 0 Xpower 3 \
                     Ypower 1 Zpower 0

        setupalpha Na_intA X {800e3*(0.0172 + EREST_ACT)} -800e3 -1.0  \
            {-1.0*(0.0172 + EREST_ACT)} -0.004  \
            {-700e3*(0.0422 + EREST_ACT)} 700e3 -1.0  \
            {-1.0*(0.0422 + EREST_ACT)} 5.0e-3

        setupalpha Na_intA Y 320.0 0.0 0.0 {-1.0*(0.042 + EREST_ACT)}  \
            0.018 10.0e3 0.0 1.0 {-1.0*(0.042 + EREST_ACT)} -5.0e-3
end


//========================================================================
//                Tabchannel K(DR) Hippocampal cell channel--axon IS
//========================================================================
function make_K_DR_int_axon
        if (({exists K_DR_intA}))
                return
        end

        create tabchannel K_DR_intA
                //      V
                //      S
                //      A
                //      S
                setfield ^ Ek {E_K} Gbar {150*INT_SOMA_A} Ik 0 Gk 0 Xpower 4  \
                    Ypower 0 Zpower 0

        setupalpha K_DR_intA X {30e3*(0.0172 + EREST_ACT)} -30e3 -1.0  \
            {-1.0*(0.0172 + EREST_ACT)} -0.005 450 0.0 0.0  \
            {-1.0*(0.012 + EREST_ACT)} 0.04
end




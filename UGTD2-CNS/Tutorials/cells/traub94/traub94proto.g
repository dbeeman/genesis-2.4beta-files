//genesis

/* FILE INFORMATION
** The 1991 Traub set of voltage and concentration dependent channels
** Implemented as tabchannels by : Dave Beeman
**      R.D.Traub, R. K. S. Wong, R. Miles, and H. Michelson
**	Journal of Neurophysiology, Vol. 66, p. 635 (1991)
**
** This file depends on functions and constants defined in defaults.g
** As it is also intended as an example of the use of the tabchannel
** object to implement concentration dependent channels, it has extensive
** comments.  Note that the original units used in the paper have been
** converted to SI (MKS) units.  Also, we define the ionic equilibrium 
** potentials relative to the resting potential, EREST_ACT.  In the
** paper, this was defined to be zero.  Here, we use -0.060 volts, the
** measured value relative to the outside of the cell.
**
** Modified September 1995 by Pulin Sampat (Brandeis University) to
** incorporate the channels used in Traub, et. al. (1994)
** [Journal of Physiology, Vol. 481.1, p. 79 (1994)].
** (pulin@eliza.cc.brandeis.edu)
*/

// CONSTANTS
/* hippocampal cell resting potl */
float EREST_ACT = -0.060
float ENA = 0.115 + EREST_ACT // 0.055
float EK = -0.015 + EREST_ACT // -0.075
float ECA = 0.140 + EREST_ACT // 0.080

float SOMA_A = 3.320e-9 // soma area in square meters

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

function make_Ca
        if (({exists Ca}))
                return
        end

        create tabchannel Ca
                //      V
                //      S
                //      A
                //      S
                setfield ^ Ek {ECA} Gbar {40*SOMA_A} Ik 0 Gk 0 Xpower 2  \
                    Ypower 0 Zpower 0
// Converting Traub's expressions for the gCa/s alpha and beta functions
// to SI units and entering the A, B, C, D and F parameters, we get:

        setupalpha Ca X 1.6e3 0 1.0 {-1.0*(0.065 + EREST_ACT)}  \
            -0.01389 {-20e3*(0.0511 + EREST_ACT)} 20e3 -1.0  \
            {-1.0*(0.0511 + EREST_ACT)} 5.0e-3

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

function make_Ca_conc
        if (({exists Ca_conc}))
                return
        end
        create Ca_concen Ca_conc
        // 0.01333 sec
        // Curr to conc for soma
        setfield Ca_conc tau 0.020 B 17.402e12 Ca_base 0.0
        if (!{exists Ca_conc sendmsg1})
            addfield Ca_conc sendmsg1
        end
        setfield  Ca_conc sendmsg1 "../Ca . I_Ca Ik"
end

function make_Ca_conc_soma
        if (({exists Ca_concs}))
                return
        end
        create Ca_concen Ca_concs
        // 0.01333 sec
        // Curr to conc for soma
        setfield Ca_concs tau 1.0 B 17.402e12 Ca_base 0.0
        if (!{exists Ca_concs sendmsg1})
            addfield Ca_concs sendmsg1
        end
        setfield  Ca_concs sendmsg1 "../Ca . I_Ca Ik"
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

function make_K_AHP
        if (({exists K_AHP}))
                return
        end

        create tabchannel K_AHP
                //      V
                //      S
                //      A
                //      S
                setfield ^ Ek {EK} Gbar {8*SOMA_A} Ik 0 Gk 0 Xpower 0  \
                    Ypower 0 Zpower 1

                // Allocate space in the Z gate A and B tables, covering a concentration
                // range from xmin = 0 to xmax = 1000, with 50 divisions
        float xmin = 0.0
        float xmax = 1000.0
        int xdivs = 50

        call K_AHP TABCREATE Z {xdivs} {xmin} {xmax}
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
            setfield K_AHP Z_A->table[{i}] {y}
            setfield K_AHP Z_B->table[{i}] {y + 1.0}
            x = x + dx
        end
        // For speed during execution, set the calculation mode to "no interpolation"
        // and use TABFILL to expand the table to 3000 entries.
        setfield K_AHP Z_A->calc_mode 0 Z_B->calc_mode 0
        call K_AHP TABFILL Z 3000 0
        // Use an environment variable to tell the cell reader to set up the
        // CONCEN message from the Ca_concen element
        if (!{exists K_AHP sendmsg1})
            addfield K_AHP sendmsg1
        end
        setfield  K_AHP sendmsg1 "../Ca_conc . CONCEN Ca"
end


function make_K_AHP_soma
        if (({exists K_AHPs}))
                return
        end

        create tabchannel K_AHPs
                //      V 
                //      S 
                //      A 
                //      S 
                setfield ^ Ek {EK} Gbar {8*SOMA_A} Ik 0 Gk 0 Xpower 0  \
                    Ypower 0 Zpower 1

                // Allocate space in the Z gate A and B tables, covering a concentration
                // range from xmin = 0 to xmax = 1000, with 50 divisions
        float xmin = 0.0
        float xmax = 1000.0
        int xdivs = 50

        call K_AHPs TABCREATE Z {xdivs} {xmin} {xmax}
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
            setfield K_AHPs Z_A->table[{i}] {y}
            setfield K_AHPs Z_B->table[{i}] {y + 1.0}
            x = x + dx
        end
        // For speed during execution, set the calculation mode to "no interpolation"
        // and use TABFILL to expand the table to 3000 entries.
        setfield K_AHPs Z_A->calc_mode 0 Z_B->calc_mode 0
        call K_AHPs TABFILL Z 3000 0
        // Use an environment variable to tell the cell reader to set up the
        // CONCEN message from the Ca_concen element
        if (!{exists K_AHPs sendmsg1})
            addfield K_AHPs sendmsg1
        end
        setfield  K_AHPs sendmsg1 "../Ca_concs . CONCEN Ca"
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

function make_K_C
        if (({exists K_C}))
                return
        end

        create vdep_channel K_C
                //      V
                //      S
                //      A
                //      S
                setfield ^ Ek {EK} gbar {100.0*SOMA_A} Ik 0 Gk 0
        float xmin = 0.0
        float xmax = 1000.0
        int xdivs = 50
        create table K_C/tab
        call K_C/tab TABCREATE {xdivs} {xmin} {xmax}
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
            setfield K_C/tab table->table[{i}] {y}
            x = x + dx
        end
	setfield K_C/tab table->calc_mode 0
	call K_C/tab TABFILL 3000 0
        float xmin = -0.1
        float xmax = 0.05
        int xdivs = 49
        create tabgate K_C/X
        call K_C/X TABCREATE alpha {xdivs} {xmin} {xmax}
        call K_C/X TABCREATE beta {xdivs} {xmin} {xmax}

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
            setfield K_C/X alpha->table[{i}] {alpha}
            setfield K_C/X beta->table[{i}] {beta}
            x = x + dx
        end

	setfield K_C/X alpha->calc_mode 0 beta->calc_mode 0
	call K_C/X TABFILL alpha 3000 0
	call K_C/X TABFILL beta 3000 0

        addmsg K_C/tab K_C MULTGATE output 1
        addmsg K_C/X K_C MULTGATE m 1
        if (!{exists K_C sendmsg1})
            addfield K_C sendmsg1
        end
        if (!{exists K_C sendmsg2})
            addfield K_C sendmsg2
        end
        setfield  K_C sendmsg1 "../Ca_conc  tab INPUT Ca"  \
            sendmsg2 "..  X  VOLTAGE Vm"
end


function make_K_C_soma
        if (({exists K_Cs}))
                return
        end

        create vdep_channel K_Cs
                //      V
                //      S
                //      A
                //      S
                setfield ^ Ek {EK} gbar {100.0*SOMA_A} Ik 0 Gk 0
        float xmin = 0.0
        float xmax = 1000.0
        int xdivs = 50
        create table K_Cs/tab
        call K_Cs/tab TABCREATE {xdivs} {xmin} {xmax}
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
            setfield K_Cs/tab table->table[{i}] {y}
            x = x + dx
        end
        setfield K_Cs/tab table->calc_mode 0
        call K_Cs/tab TABFILL 3000 0
        float xmin = -0.1
        float xmax = 0.05
        int xdivs = 49
        create tabgate K_Cs/X
        call K_Cs/X TABCREATE alpha {xdivs} {xmin} {xmax}
        call K_Cs/X TABCREATE beta {xdivs} {xmin} {xmax}

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
            setfield K_Cs/X alpha->table[{i}] {alpha}
            setfield K_Cs/X beta->table[{i}] {beta}
            x = x + dx
        end

        setfield K_Cs/X alpha->calc_mode 0 beta->calc_mode 0
        call K_Cs/X TABFILL alpha 3000 0
        call K_Cs/X TABFILL beta 3000 0

        addmsg K_Cs/tab K_Cs MULTGATE output 1
        addmsg K_Cs/X K_Cs MULTGATE m 1
        if (!{exists K_Cs sendmsg1})
            addfield K_Cs sendmsg1
        end
        if (!{exists K_Cs sendmsg2})
            addfield K_Cs sendmsg2
        end
        setfield  K_Cs sendmsg1 "../Ca_concs  tab INPUT Ca"  \
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
function make_Na
        if (({exists Na}))
                return
        end

        create tabchannel Na
                //      V
                //      S
                //      A
                //      S
                setfield ^ Ek {ENA} Gbar {300*SOMA_A} Ik 0 Gk 0 Xpower 2 \
                     Ypower 1 Zpower 0

        setupalpha Na X {320e3*(0.0131 + EREST_ACT)} -320e3 -1.0  \
            {-1.0*(0.0131 + EREST_ACT)} -0.004  \
            {-280e3*(0.0401 + EREST_ACT)} 280e3 -1.0  \
            {-1.0*(0.0401 + EREST_ACT)} 5.0e-3

        setupalpha Na Y 128.0 0.0 0.0 {-1.0*(0.017 + EREST_ACT)}  \
            0.018 4.0e3 0.0 1.0 {-1.0*(0.040 + EREST_ACT)} -5.0e-3
end

//========================================================================
//                Tabchannel K(DR) Hippocampal cell channel--soma-dend
//========================================================================
function make_K_DR
        if (({exists K_DR}))
                return
        end

        create tabchannel K_DR
                //      V
                //      S
                //      A
                //      S
                setfield ^ Ek {EK} Gbar {150*SOMA_A} Ik 0 Gk 0 Xpower 2  \
                    Ypower 0 Zpower 0

        setupalpha K_DR X {16e3*(0.0351 + EREST_ACT)} -16e3 -1.0  \
            {-1.0*(0.0351 + EREST_ACT)} -0.005 250 0.0 0.0  \
            {-1.0*(0.02 + EREST_ACT)} 0.04
end

//========================================================================
//                Tabchannel K(A) Hippocampal cell channel
//========================================================================
function make_K_A
        if (({exists K_A}))
                return
        end

        create tabchannel K_A
                //      V
                //      S
                //      A
                //      S
                setfield ^ Ek {EK} Gbar {50*SOMA_A} Ik 0 Gk 0 Xpower 1  \
                    Ypower 1 Zpower 0

        setupalpha K_A X {20e3*(0.0131 + EREST_ACT)} -20e3 -1.0  \
            {-1.0*(0.0131 + EREST_ACT)} -0.01  \
            {-17.5e3*(0.0401 + EREST_ACT)} 17.5e3 -1.0  \
            {-1.0*(0.0401 + EREST_ACT)} 0.01

        setupalpha K_A Y 1.6 0.0 0.0 {0.013 - EREST_ACT} 0.018 50.0  \
            0.0 1.0 {-1.0*(0.0101 + EREST_ACT)} -0.005
end


//========================================================================
//                Tabchannel Na Hippocampal cell channel--axon IS
//========================================================================
function make_Na_axon
        if (({exists NaA}))
                return
        end

        create tabchannel NaA
                //      V
                //      S
                //      A
                //      S
                setfield ^ Ek {ENA} Gbar {300*SOMA_A} Ik 0 Gk 0 Xpower 3 \
                     Ypower 1 Zpower 0

        setupalpha NaA X {800e3*(0.0172 + EREST_ACT)} -800e3 -1.0  \
            {-1.0*(0.0172 + EREST_ACT)} -0.004  \
            {-700e3*(0.0422 + EREST_ACT)} 700e3 -1.0  \
            {-1.0*(0.0422 + EREST_ACT)} 5.0e-3

        setupalpha NaA Y 320.0 0.0 0.0 {-1.0*(0.042 + EREST_ACT)}  \
            0.018 10.0e3 0.0 1.0 {-1.0*(0.042 + EREST_ACT)} -5.0e-3
end


//========================================================================
//                Tabchannel K(DR) Hippocampal cell channel--axon IS
//========================================================================
function make_K_DR_axon
        if (({exists K_DRA}))
                return
        end

        create tabchannel K_DRA
                //      V
                //      S
                //      A
                //      S
                setfield ^ Ek {EK} Gbar {150*SOMA_A} Ik 0 Gk 0 Xpower 4  \
                    Ypower 0 Zpower 0

        setupalpha K_DRA X {30e3*(0.0172 + EREST_ACT)} -30e3 -1.0  \
            {-1.0*(0.0172 + EREST_ACT)} -0.005 450 0.0 0.0  \
            {-1.0*(0.012 + EREST_ACT)} 0.04
end

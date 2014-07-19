/*  Channels defined in:

S. Jones, D. J. Pinto, T. J. Kaper and N. Koppel (2000)
Alpha-Frequency Rhythms Desynchronize over Long Cortical Distances: A
Modeling Study. JCNS 9:

*/

// check these!

float ECA = 0.125
float EH  = -0.043

float SOMA_A = 1e-9 // soma area in square meters - only a placeholder


//========================================================================
//                      Tabulated low threshold Ca Channel
//========================================================================

function make_CaT_pyr_jones
    str chanpath = "CaT_pyr_jones"
    if ({argc} == 1)
       chanpath = {argv 1}
    end
    if ({exists {chanpath}})
       return
    end

    create tabchannel {chanpath}
                setfield        ^       \
                Ek              {ECA}   \               //      V
                Gbar            { 40 * SOMA_A }      \  //      S
                Ik              0       \               //      A
                Gk              0       \               //      S
                Xpower  2       \
                Ypower  1       \
                Zpower  0
// Allocate space in the A and B tables with room for xdivs+1 = 100 entries,
// covering the range xmin = -0.125 to xmax = 0.075.
// The large range is to allow shifting of activation curves

        float   xmin = -0.125
        float   xmax = 0.075
        int     xdivs = 99

       call {chanpath}  TABCREATE X {xdivs} {xmin} {xmax}

// Fill the X_A table with tau values and the X_B table with minf
        int i
        float x,dx, tau, minf
        dx = (xmax - xmin)/xdivs
	x = xmin
        for (i = 0 ; i <= {xdivs} ; i = i + 1)
            tau = 0.44e-3 + 0.15e-3 /( {exp {(x + 0.027)/0.010}} + \
                  {exp {(-0.102 - x)/0.015}})
            minf = 1.0 / ( 1 + {exp {(-0.052 - x)/0.0074}})
            setfield {chanpath} X_A->table[{i}] {tau}
            setfield {chanpath}  X_B->table[{i}] {minf}
            x = x + dx
        end
        tweaktau {chanpath}  X

// For speed during execution, set the calculation mode to "no interpolation"
// and use TABFILL to expand the table to 3000 entries.
        setfield  {chanpath} X_A->calc_mode 0 X_B->calc_mode 0
        call {chanpath} TABFILL X 3000 0
// now do it for the Y gate

        call {chanpath}  TABCREATE Y {xdivs} {xmin} {xmax}
	x = xmin
        for (i = 0 ; i <= {xdivs} ; i = i + 1)
            tau = 0.0227 + 0.027e-3 /( {exp {(x + 0.048)/0.004} } + \
                  {exp {(-0.407 -x)/0.050}})
            minf = 1.0/(1.0 + {exp {(x + 0.080)/0.005}})
            setfield {chanpath} Y_A->table[{i}] {tau}
            setfield {chanpath} Y_B->table[{i}] {minf}
            x = x + dx
        end
        tweaktau {chanpath}  Y
        setfield  {chanpath} Y_A->calc_mode 0 Y_B->calc_mode 0
        call {chanpath} TABFILL Y 3000 0
end


//========================================================================
//            Tabulated hyperpolarization-activated H current
//========================================================================

function make_KNaH_pyr_jones
    str chanpath = "KNaH_pyr_jones"
    if ({argc} == 1)
       chanpath = {argv 1}
    end
    if ({exists {chanpath}})
       return
    end

    create tabchannel {chanpath}
                setfield        ^       \
                Ek              {EH}   \               //      V
                Gbar            { 40 * SOMA_A }      \  //      S
                Ik              0       \               //      A
                Gk              0       \               //      S
                Xpower  1       \
                Ypower  0       \
                Zpower  0
// Allocate space in the A and B tables with room for xdivs+1 = 100 entries,
// covering the range xmin = -0.125 to xmax = 0.075.
// The large range is to allow shifting of activation curves

        float   xmin = -0.125
        float   xmax = 0.075
        int     xdivs = 99

       call {chanpath}  TABCREATE X {xdivs} {xmin} {xmax}

// Fill the X_A table with tau values and the X_B table with minf
        int i
        float x,dx, tau, minf
        dx = (xmax - xmin)/xdivs
        x = xmin
        for (i = 0 ; i <= {xdivs} ; i = i + 1)
            tau = 0.001 / ({exp {-14.9 - 86*x}} + {exp {-1.87 + 70.1*x}})
            minf = 1.0 / (1.0 + {exp {(x + 0.075)/0.0055}})

            setfield {chanpath} X_A->table[{i}] {tau}
            setfield {chanpath}  X_B->table[{i}] {minf}
            x = x + dx
        end
        tweaktau {chanpath}  X
        setfield  {chanpath} X_A->calc_mode 0 X_B->calc_mode 0
        call {chanpath} TABFILL X 3000 0
end

/* persistant sodium current, similar to that studied in guinea pig
   CA1 pyramidal cells by  C. R. French., P. Sah, K. J. Buckket, and
   P. W. Gage, J. Gen. Physiol. 95:1139-1157 (1990)
 */
function make_Nap_pyr_bdk
    float ENA = 0.050

    str chanpath = "Nap_pyr_bdk"
    if ({argc} == 1)
       chanpath = {argv 1}
    end
    if ({exists {chanpath}})
       return
    end
    float V0, K
    float tau
    create tabchannel {chanpath}
    setfield {chanpath} Ek {ENA} Gbar {10*SOMA_A}  \
    Xpower 2 Ypower 0 Zpower 0
    V0 = -0.040
    K = -0.007
    tau = 0.002
    setuptau {chanpath} X \
        {tau} {tau*1e-6} 0 0 1e6 \
        1 0 1 {-1.0*V0} {K}
end // make_Nap_pyr_bdk


/* FILE INFORMATION - last update: Feb. 7, 1998
   Channels for the neocortical pyramidal cell model by
   O. Bernander, R. Douglas, and C. Koch (1992)
   Caltech CNS Memo 18

   Converted to GENESIS by D. Beeman, January 1998
*/

EREST_ACT = -0.066
float ENA = 0.050
float EK = -0.095
float ECA = 0.115

float SOMA_A = 1.233e-9  // m^2 - Area of layer5 pyramidal cell soma

// synaptically activated channels - parameters from Bush and Sejnowski (1993)

float EGlu = 0.0 // Ex_channel reversal potential
float GGlu = 0.5e-9
float EGABA = -0.07 // Inh_channel reversal potential
float GGABA = 0.5e-9

/* These channels use sigmoidal activation functions of the form
   1/(1 + exp((V-V0)/K)), where V0 is the voltage for 50% activation,
   and K determines the steepness of the activation.  The time constant
   tau for activation was taken to be independent of voltage.

   These were implemented using the GENESIS setuptau function, which fits
   the activation and tau to the form  (A + B * x) / (C + exp((x + D) / F)).
   For the sigmoidal activation functions, A=1, B=0, C=1, D=-V0, and F=K.
   To give an essentially constant value of tau, I used A=tau, B=tau/F, C=0,
   D=0, and F=1e6.
*/

/*  Fast sodium channel using parameters modified from B. Frankenhaeuser and
    A. F. Huxley, J. Physiol. 117:303-315 (1964).  The time constants were
    Q10 adjusted and the activation curves were steepened and shifted to
    the midpoint voltages given below.
*/

function make_Na_pyr_bdk
    str chanpath = "Na_pyr_bdk"
    if ({argc} == 1)
       chanpath = {argv 1}
    end
    if ({exists {chanpath}})
       return
    end
    float V0, K
    float tau
    create tabchannel {chanpath}
    setfield {chanpath} Ek {ENA} Gbar {2000*SOMA_A}  \
    Xpower 2 Ypower 1 Zpower 0
    V0 = -0.040
    K = -0.003
    tau = 0.00005
    setuptau {chanpath} X \
	{tau} {tau*1e-6} 0 0 1e6 \
	1 0 1 {-1.0*V0} {K}
    // inactivation
    V0 = -0.045
    K = 0.003
    tau = 0.0005
    setuptau {chanpath} Y \
	{tau} {tau*1e-6} 0 0 1e6 \
	1 0 1 {-1.0*V0} {K}
end // Na_pyr_bdk

/* Potassium delayed rectifier, modified from Frankenhaeuser and
   Huxley (1964).
*/
function make_Kdr_pyr_bdk
    str chanpath = "Kdr_pyr_bdk"
    if ({argc} == 1)
       chanpath = {argv 1}
    end
    if ({exists {chanpath}})
       return
    end
    float V0, K
    float tau
    create tabchannel {chanpath}
    setfield {chanpath} Ek {EK} Gbar {1200*SOMA_A}  \
    Xpower 2 Ypower 0 Zpower 0
    V0 = -0.040
    K = -0.003
    tau = 0.002
    setuptau {chanpath} X \
	{tau} {tau*1e-6} 0 0 1e6 \
	1 0 1 {-1.0*V0} {K}
end // make_Kdr_pyr_bdk

/* Transient potassium A-current */
function make_Ka_pyr_bdk
    str chanpath = "Ka_pyr_bdk"
    if ({argc} == 1)
       chanpath = {argv 1}
    end
    if ({exists {chanpath}})
       return
    end
    float V0, K
    float tau
    create tabchannel {chanpath}
    setfield {chanpath} Ek {EK} Gbar {10*SOMA_A}  \
    Xpower 2 Ypower 1 Zpower 0
    V0 = -0.065
    K = -0.002
    tau = 0.020
    setuptau {chanpath} X \
	{tau} {tau*1e-6} 0 0 1e6 \
	1 0 1 {-1.0*V0} {K}
    //inactivation
    V0 = -0.060
    K = 0.004
    tau = 0.1
    setuptau {chanpath} Y \
	{tau} {tau*1e-6} 0 0 1e6 \
	1 0 1 {-1.0*V0} {K}
end // Ka_pyr_bdk


/* High threshold Ca channel (L type) was taken from
   O. Bernander, R. Douglas, and C. Koch (1992)
   Caltech CNS Memo 18
*/
function make_Ca_pyr_bdk
    str chanpath = "Ca_pyr_bdk"
    if ({argc} == 1)
       chanpath = {argv 1}
    end
    if ({exists {chanpath}})
       return
    end
    float V0, K
    float tau
    create tabchannel {chanpath}
    setfield {chanpath} Ek {ECA} Gbar {6*SOMA_A}  \
    Xpower 2 Ypower 0 Zpower 0
    V0 = -0.025
    K = -0.004
    tau = 0.002
    setuptau {chanpath} X \
	{tau} {tau*1e-6} 0 0 1e6 \
	1 0 1 {-1.0*V0} {K}
end // Ca_pyr_bdk

/* Ca concentration model was taken from
   O. Bernander, R. Douglas, and C. Koch (1992)
   Caltech CNS Memo 18
*/
function make_Ca_conc
        if ({exists Ca_conc})
                return
        end
        create Ca_concen Ca_conc
        setfield Ca_conc \
                tau     0.05   \      // sec
                B       1.0e10 \      // M/Coul
                Ca_base 5e-5 // mM
        addfield Ca_conc addmsg1
        // Source path depends on name of the Ca channel
        setfield Ca_conc \
                addmsg1        "../Ca . I_Ca Ik"
end

/* AHP potassium current depends only on Ca concentration
   This is a special case, where m_inf = [Ca]/([Ca] + 0.04 mM)
   We provide for a range of [Ca] = 0 to 0.5 mM.
*/

function make_Kahp_pyr_bdk
    str chanpath = "Kahp_pyr_bdk"
    if ({argc} == 1)
       chanpath = {argv 1}
    end
    if ({exists {chanpath}})
       return
    end
    int xdivs = 199
    int i
    float x, xmin, xmax, dx
    float minf, tau
    create tabchannel {chanpath}
    setfield {chanpath} Ek {EK} Gbar {450*SOMA_A}  \
    Xpower 0 Ypower 0 Zpower 2
    tau = 0.002
    xmin = 0.0
    xmax = 0.5 // mM
    dx = {xmax/xdivs}
    call {chanpath} TABCREATE Z {xdivs} {xmin} {xmax}
    x = xmin
    for (i = 0; i <= {xdivs}; i = i + 1)
        minf = x/(x + 0.040)
        setfield {chanpath} Z_A->table[{i}] {tau}
        setfield {chanpath} Z_B->table[{i}] {minf}
        x = x + dx
    end
    tweaktau {chanpath} Z
    setfield {chanpath} Z_A->calc_mode 0 Z_B->calc_mode 0
    call {chanpath} TABFILL Z 3000 0
    addfield  {chanpath} addmsg1
    setfield  {chanpath} \
        addmsg1        "../Ca_conc . CONCEN Ca"
end

/* persistant sodium current, similar to that studied in guinea pig
   CA1 pyramidal cells by  C. R. French., P. Sah, K. J. Buckket, and
   P. W. Gage, J. Gen. Physiol. 95:1139-1157 (1990)
 */
function make_Nap_pyr_bdk
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

/* Non-inactivating muscarinic potassium M-current
   modified from the bullfrog sympathetic ganglion M-current,
   W. M. Yamada, C. Koch, and P. R> Adams, Methods in Neuronal
   Modeling,  MIT press, ed C. Koch and I. Segev (1989).
*/
function make_Km_pyr_bdk
    str chanpath = "Km_pyr_bdk"
    if ({argc} == 1)
       chanpath = {argv 1}
    end
    if ({exists {chanpath}})
       return
    end
    float V0, K
    float tau
    create tabchannel {chanpath}
    setfield {chanpath} Ek {EK} Gbar {6*SOMA_A}  \
    Xpower 1 Ypower 0 Zpower 0
    V0 = -0.055
    K = -0.010
    tau = 0.020
    setuptau {chanpath} X \
	{tau} {tau*1e-6} 0 0 1e6 \
	1 0 1 {-1.0*V0} {K}
end // make_Km_pyr_bdk

/* Anomalous rectifier (mixed Na and K current) "AR" is composed of two
   separate currents AR1 and AR2, that are nearly identical, but have
   diferent time constants.  The conductances should be weighted by
   0.8*G(AR1 = 0.2*G(AR2).  The parameters were taken from
   measurements on brain slices from cat sensorimotor cortex by
   W. J. Spain, P. C. Schwindt and W. E. Crill, J. Neurophysiol.
   57:1555-1576 (1987).
*/
function make_AR1_pyr_bdk
    str chanpath = "AR1_pyr_bdk"
    if ({argc} == 1)
       chanpath = {argv 1}
    end
    if ({exists {chanpath}})
       return
    end
    float V0, K
    float tau
    create tabchannel {chanpath}
    setfield {chanpath} Ek -0.050 Gbar {0.8*10*SOMA_A}  \
        Xpower 1 Ypower 0 Zpower 0
    V0 = -0.082
    K = 0.007
    tau = 0.040
    setuptau {chanpath} X \
	{tau} {tau*1e-6} 0 0 1e6 \
	1 0 1 {-1.0*V0} {K}
end // make_AR1_pyr_bdk

function make_AR2_pyr_bdk
    str chanpath = "AR2_pyr_bdk"
    if ({argc} == 1)
       chanpath = {argv 1}
    end
    if ({exists {chanpath}})
       return
    end
    float V0, K
    float tau
    create tabchannel {chanpath}
    setfield {chanpath} Ek -0.050 Gbar {0.2*10*SOMA_A}  \
    Xpower 1 Ypower 0 Zpower 0
    V0 = -0.082
    K = 0.007
    tau = 0.300
    setuptau {chanpath} X \
	{tau} {tau*1e-6} 0 0 1e6 \
	1 0 1 {-1.0*V0} {K}
end // make_AR2_pyr_bdk

/* Additional synaptically activated channels from Bush and Sejnowski 1993 */

function make_Ex_channel
        if ({exists Ex_channel})
                return
        end

        create          synchan Ex_channel
        setfield                Ex_channel \
                Ek                      {EGlu} \
                tau1            { 1e-3 } \    // sec
                tau2            { 1e-3 } \    // sec
                gmax            0 // Siemens
//                gmax            {GGlu} // Siemens

end

function make_Inh_channel
        if ({exists Inh_channel})
                return
        end

        create          synchan Inh_channel
        setfield                Inh_channel \
        Ek                      { EGABA } \
        tau1            { 1e-3 } \   // sec
        tau2            { 1e-3 } \   // sec
        gmax            {GGABA}         // Siemens
end

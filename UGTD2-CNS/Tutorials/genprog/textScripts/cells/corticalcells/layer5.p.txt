// layer5.p - Cell parameter file for the Bush and Sejnowski (1993)
// reduced 9 compartment layer 5 (deep) cortical pyramidal cell.
// This version is the passive cell without ionic conductances

*relative
*cartesian
*symmetric

// membrane constants (SI units)
*set_global        RM      0.7042     // ohm*m^2
*set_global        RA      2.0        // ohm*m
*set_global        CM      0.0284     // farad/m^2
*set_global     EREST_ACT  -0.066     // volts (leakage potential)

// Area of the soma compartment
// SOMA_A = 1.233e-9 m^2

soma    none    0  17 0 23
apical0 soma    0   60  0   6
apical2 apical0 0  400  0   4.4
apical3 apical2 0  400  0   2.9
apical4 apical3 0  250  0   2
apical1 apical0 -150 0  0 3
basal0  soma    0  -50 0 4
basal1  basal0 106.07 -106.07 0 5
basal2  basal0 -106.07 -106.07 0 5

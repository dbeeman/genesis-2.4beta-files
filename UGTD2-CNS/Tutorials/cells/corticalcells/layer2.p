// layer2.p - Cell parameter file Bush and Sejnowski (1993) passive
// 8 compartment reduced layer 2 (superficial) cortical pyramidal cell

*relative
*cartesian
*symmetric

// membrane constants (SI units)
*set_global        RM      0.678     // ohm*m^2
*set_global        RA      2.0     // ohm*m
*set_global        CM      0.0295    // farad/m^2
*set_global     EREST_ACT  -0.065

soma    none    0  15.3 0 21
apical0 soma    0   35  0   2.5
apical2 apical0 0  180  0   2.4
apical3 apical2 0  140  0   2.0  
apical1 apical0 -200 0  0   2.3
basal0  soma    0  -50 0 2.5
basal1  basal0 106.07 -106.07 0 1.6
basal2  basal0 -106.07 -106.07 0 1.6

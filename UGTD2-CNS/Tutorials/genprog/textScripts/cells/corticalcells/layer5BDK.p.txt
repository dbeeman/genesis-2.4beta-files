// layer5BDK.p - Cell parameter file for the Bush and Sejnowski (1993)
// reduced 9 compartment layer 5 (deep) cortical pyramidal cell.

/* This uses ionic conductances taken from Bernander, Douglas and Koch (1992).
   The channel conductance densities are these given in their report.
   The channels are defined and described in the file BDKchan.g.
*/

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

soma    none    0  17 0 23 Na 2000 Kdr 1200 Ca 6 Ka 10 Km 6 Nap 10 \
    AR1 8 AR2 2 Ca_conc -1.0e10 Kahp 450 spike 0.0
apical0 soma    0   60  0   6
apical2 apical0 0  400  0   4.4
apical3 apical2 0  400  0   2.9
apical4 apical3 0  250  0   2
apical1 apical0 -150 0  0 3 Ex_channel 2.6526
basal0  soma    0  -50 0 4
basal1  basal0 106.07 -106.07 0 5
basal2  basal0 -106.07 -106.07 0 5

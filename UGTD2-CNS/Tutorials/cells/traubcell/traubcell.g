// genesis - "Stand-alone" version of the traub91 tutorial
setclock  0  0.00005            // set the simulation clock

/* file for 1991 Traub model channels */
include traub91proto.g

// Create a library of prototype elements to be used by the cell reader
create neutral /library
pushe /library
create symcompartment symcompartment
make_Na
make_Ca
make_K_DR
make_K_AHP
make_K_C
make_K_A
make_Ca_conc
pope

// Build the cell from a parameter file using the cell reader
readcell CA3.p /cell 
setfield /cell/soma inject 0.2e-9  // Provide 0.2 nA injection current

include graphics.g  // You create this file to provide a GUI
reset

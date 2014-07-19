// genesis

/*
 * Elliot D. Menschik
 *   Medical Scientist Training Program
 *   Institute of Neurologica Sciences
 *   University of Pennsylvania
 *   School of Medicine
 *   menschik@neuroengineering.upenn.edu
 *
 *
 *
 * Stratum pyramidale interneuron
 *
 * Traub RD, Miles R: Pyramidal Cell-to-Inhibitory Cell Spike 
 * Transduction Explicable by Active Dendritic Conductances in
 * Inhibitory Cell. JourNa_intl of Computational Neuroscience
 * 1995, 2:291-298
 *
 */


*cartesian
*relative
*asymmetric
*set_global RM 5.0	//ohm*m^2
*set_global RA 2.0	//ohm*m
*set_global CM 0.0075   //F/m^2
*set_global EREST_ACT	-0.06	// volts

// The format for each compartment parameter line is :
// name  parent  x       y       z       d       ch      dens ...
// For channels, "dens" =  maximum conductance per unit area of compartment (S/m^2)

soma	none	0  0      20	 15   Ca_conc_int -61e12 Ca_int 10 Na_int 1000 K_DR_int 1350 K_C_int 200 K_A_int 5 K_AHP_int 0.1	
a5_1	soma	0  -25    43.30  3    Ca_conc_int -60e12 Ca_int 10 Na_int 250  K_DR_int 250  K_C_int 80  K_A_int 5 K_AHP_int 0.1	
a5_2	soma	0  -17.1  46.98  3    Ca_conc_int -60e12 Ca_int 10 Na_int 250  K_DR_int 250  K_C_int 80  K_A_int 5 K_AHP_int 0.1	
a5_3	soma	0  -8.682 49.24  3    Ca_conc_int -60e12 Ca_int 10 Na_int 250  K_DR_int 250  K_C_int 80  K_A_int 5 K_AHP_int 0.1	
a5_4	soma	0   8.682 49.24  3    Ca_conc_int -60e12 Ca_int 10 Na_int 250  K_DR_int 250  K_C_int 80  K_A_int 5 K_AHP_int 0.1	
a5_5	soma	0  17.1   46.98  3    Ca_conc_int -60e12 Ca_int 10 Na_int 250  K_DR_int 250  K_C_int 80  K_A_int 5 K_AHP_int 0.1	
a5_6	soma	0  25     43.30  3    Ca_conc_int -60e12 Ca_int 10 Na_int 250  K_DR_int 250  K_C_int 80  K_A_int 5 K_AHP_int 0.1	
a6_1	a5_3	0  -8.682 49.24  1.88 Ca_conc_int -97e12 Ca_int 10 Na_int 250  K_DR_int 250  K_C_int 80  K_A_int 5 K_AHP_int 0.1 
a6_2	a5_4	0   8.682 49.24  1.88 Ca_conc_int -97e12 Ca_int 10 Na_int 250  K_DR_int 250  K_C_int 80  K_A_int 5 K_AHP_int 0.1	
a6_3	a5_5	0  17.1   46.98  1.88 Ca_conc_int -97e12 Ca_int 10 Na_int 250  K_DR_int 250  K_C_int 80  K_A_int 5 K_AHP_int 0.1	
a6_4	a5_6	0  25     43.30  1.88 Ca_conc_int -97e12 Ca_int 10 Na_int 250  K_DR_int 250  K_C_int 80  K_A_int 5 K_AHP_int 0.1	
a7_1	a6_1	0  -8.682 49.24  1.88 Ca_conc_int -98e12 Ca_int 10 Na_int 500  K_DR_int 500  K_C_int 40            K_AHP_int 0.1	
a7_2	a6_2	0  8.682  49.24  1.88 Ca_conc_int -98e12 Ca_int 10 Na_int 500  K_DR_int 500  K_C_int 40            K_AHP_int 0.1	
a7_3	a6_3	0  17.1   46.98  1.2  Ca_conc_int -154e12 Ca_int 10 Na_int 500  K_DR_int 500  K_C_int 40            K_AHP_int 0.1	
a7_4	a6_3	0  25	  43.30  1.2  Ca_conc_int -154e12 Ca_int 10 Na_int 500  K_DR_int 500  K_C_int 40            K_AHP_int 0.1	
a7_5	a6_4	0  25	  43.30  1.88 Ca_conc_int -98e12 Ca_int 10 Na_int 500  K_DR_int 500  K_C_int 40            K_AHP_int 0.1	
a8_1	a7_1	0  -8.682 49.24  1.88 Ca_conc_int -26e12 Ca_int 10 Na_int 250  K_DR_int 250  K_C_int 40            K_AHP_int 0.1	
a8_2	a7_2	0  8.682  49.24  1.88 Ca_conc_int -26e12 Ca_int 10 Na_int 250  K_DR_int 250  K_C_int 40            K_AHP_int 0.1	
a8_3	a7_3	0  17.1   46.98  1.2  Ca_conc_int -41e12 Ca_int 10 Na_int 250  K_DR_int 250  K_C_int 40            K_AHP_int 0.1	
a8_4	a7_4	0  25     43.30  1.2  Ca_conc_int -41e12 Ca_int 10 Na_int 250  K_DR_int 250  K_C_int 40            K_AHP_int 0.1	
a8_5	a7_5	0  25	  43.30  1.88 Ca_conc_int -26e12 Ca_int 10 Na_int 250  K_DR_int 250  K_C_int 40            K_AHP_int 0.1	
a9_1	a8_1	0  -8.682 49.24  1.88 Ca_conc_int -26e12 Ca_int 10                           K_C_int 40            K_AHP_int 0.1	
a9_2	a8_2	0  8.682  49.24  1.88 Ca_conc_int -26e12 Ca_int 10                           K_C_int 40            K_AHP_int 0.1	
a9_3	a8_3	0  4.35   49.80  0.76 Ca_conc_int -63e12 Ca_int 10                           K_C_int 40            K_AHP_int 0.1	
a9_4	a8_3	0  17.1   46.98	 0.76 Ca_conc_int -63e12 Ca_int 10                           K_C_int 40            K_AHP_int 0.1	
a9_5	a8_4	0  25     43.30  1.2  Ca_conc_int -40e12 Ca_int 10                           K_C_int 40            K_AHP_int 0.1	
a9_6	a8_5	0  25     43.30  1.88 Ca_conc_int -26e12 Ca_int 10                           K_C_int 40            K_AHP_int 0.1	
a10_1	a9_1	0  -17.1  46.98	 1.2  Ca_conc_int -40e12 Ca_int 10                           K_C_int 40            K_AHP_int 0.1	
a10_2	a9_1	0  17.1   46.98	 1.2  Ca_conc_int -40e12 Ca_int 10                           K_C_int 40            K_AHP_int 0.1	
a10_3	a9_2	0  8.682  49.24	 1.88 Ca_conc_int -26e12 Ca_int 10                           K_C_int 40            K_AHP_int 0.1	
a10_4	a9_3	0  4.35   49.80	 0.76 Ca_conc_int -63e12 Ca_int 10                           K_C_int 40            K_AHP_int 0.1	
a10_5	a9_4	0  17.1   46.98	 0.76 Ca_conc_int -63e12 Ca_int 10                           K_C_int 40            K_AHP_int 0.1	
a10_6	a9_5	0  25	  43.30  1.2  Ca_conc_int -40e12 Ca_int 10                           K_C_int 40            K_AHP_int 0.1	
a10_7	a9_6	0  25     43.30  1.88 Ca_conc_int -26e12 Ca_int 10                           K_C_int 40            K_AHP_int 0.1	
a11_1	a10_1	0  -17.1  46.98	 1.2  Ca_conc_int -40e12 Ca_int 10                           K_C_int 40            K_AHP_int 0.1	
a11_2	a10_2	0  17.1   46.98	 1.2  Ca_conc_int -40e12 Ca_int 10                           K_C_int 40            K_AHP_int 0.1	
a11_3	a10_3	0  8.682  49.24	 1.88 Ca_conc_int -26e12 Ca_int 10                           K_C_int 40            K_AHP_int 0.1	
a11_4	a10_4	0  4.35	  49.8   0.76 Ca_conc_int -63e12 Ca_int 10                           K_C_int 40            K_AHP_int 0.1	
a11_5	a10_5	0  17.1   46.98	 0.76 Ca_conc_int -63e12 Ca_int 10                           K_C_int 40            K_AHP_int 0.1	
a11_6	a10_6	0  25     43.30  1.2  Ca_conc_int -40e12 Ca_int 10                           K_C_int 40            K_AHP_int 0.1	
a11_7	a10_7	0  25	  43.30  1.88 Ca_conc_int -26e12 Ca_int 10                           K_C_int 40            K_AHP_int 0.1	

b3	soma	0  0      -50	 3    Ca_conc_int -61e12  Ca_int 10 Na_int 50   K_DR_int 150  K_C_int 80 K_A_int 5  K_AHP_int 0.1	
b2_1	b3	0  -25	  -43.3  1.88 Ca_conc_int -219e12 Ca_int 10                           K_C_int 40 K_A_int 5  K_AHP_int 0.1	
b2_2	b3	0  25	  -43.3	 1.88 Ca_conc_int -219e12 Ca_int 10                           K_C_int 40 K_A_int 5  K_AHP_int 0.1	
b1_1	b2_1	0  -25	  -43.3	 1.2  Ca_conc_int -345e12 Ca_int 10                           K_C_int 40            K_AHP_int 0.1	
b1_2	b2_1	0  25	  -43.3	 1.2  Ca_conc_int -345e12 Ca_int 10                           K_C_int 40            K_AHP_int 0.1	

*set_global RM 0.1	//ohm*m^2
*set_global RA 1.0	//ohm*m
*set_global CM 0.0075   //F/m^2

axonIS	soma	0	-75	0	2.0           Na_intA 5000 K_DR_intA 2500 spike 0.0
axon2	axonIS	0	-75	0	1.0           Na_intA 5000 K_DR_intA 2500	
axon3	axon2	0	-53.033	-53.033	1.0           Na_intA 5000 K_DR_intA 2500
axon4	axon3	0	-53.055	53.033	1.0           Na_intA 5000 K_DR_intA 2500
axon5	axon4	0	0	75	1.0           Na_intA 5000 K_DR_intA 2500








// genesis 2.2
// Kerstin Menne
// Medical University of Luebeck, 17.12.2001
// cell parameter file for the 1994 Traub CA3 hippocampal cell
// "phi" parameter reduced by e-3
// addition of synaptically activated channels;
// distribution of synapses taken from
// Cellular mechanisms of 4-aminopyridine-induced synchronized after-
// discharge in the rat hippocampal slice, Traub et al., 1995, Journal of
// Physiology, 489.1, pp.127-140

*cartesian
*relative     
*asymmetric

*set_compt_param RM 5.0		// ohm*m^2
*set_compt_param RA 2.0		// ohm*m
*set_compt_param CM 0.0075      // F/m^2

     
// The format for each compartment parameter line is :
// name  parent  x       y       z       d       ch      dens ...
// For channels, "dens" =  maximum conductance per unit area of compartment

// The compartment numbering corresponds to that in the paper, with soma = 4

*spherical
   soma	none	     0    0   25.5  30.0  Ca_concs -24.0e12 Na 1000 Ca 10 K_DR 1350 K_AHPs 8 K_Cs 200 K_A 5  GABA_A 70.0  AMPA 0 NMDA 0 GABA_B 0 

*set_compt_param RM 2.5 		// ohm*m^2
*set_compt_param CM 0.0150 	        // F/m^2
*cylindrical
ap5	soma	     0    0   50   10.0  Ca_conc -18.0e12 Na   60 Ca 20 K_DR  100 K_AHP 16 K_C  160 K_A 10	AMPA 100.0   NMDA 20.0   GABA_A 70.0 GABA_B 0 
   
ap6_1   ap5	   -35.36 0     35.36 6.30  Ca_conc -29.0e12 Na   60 Ca 20 K_DR  400 K_AHP 16 K_C  160 K_A 10	AMPA 100.0   NMDA 20.0  GABA_A 0 GABA_B 0 
ap6_2   ap5	     35.36  0    35.36 6.30  Ca_conc -29.0e12 Na   60 Ca 20 K_DR  400 K_AHP 16 K_C  160 K_A 10	AMPA 100.0   NMDA 20.0   GABA_A 0 GABA_B 0

ap7_1   ap6_1      0    15     68.37   2.78  Ca_conc -47.0e12 Na    0 Ca 40 K_DR    0 K_AHP 16 K_C  80 K_A 0 AMPA 0 NMDA 0 GABA_B 0 GABA_A 20 
ap7_4   ap6_2       0  -15     68.37   2.78  Ca_conc -47.0e12 Na    0 Ca 40 K_DR    0 K_AHP 16 K_C  80 K_A 0	AMPA 0 NMDA 0 GABA_B 0 GABA_A 20
ap7_2   ap6_1      0    -20   45.83  5.00  Ca_conc -37.0e12 Na    0 Ca 40 K_DR    0 K_AHP 16 K_C  80 K_A 0	AMPA 0 NMDA 0 GABA_B 0 GABA_A 20
ap7_3   ap6_2        0   20  45.83   5.00  Ca_conc -37.0e12 Na    0 Ca 40 K_DR    0 K_AHP 16 K_C  80 K_A 0	AMPA 0 NMDA 0 GABA_B 0 GABA_A 20

ap8_1   ap7_2      0    -13    58.57   3.14  Ca_conc -13.0e12 Na    0 Ca 60 K_DR    0 K_AHP 16 K_C 240 K_A 0	AMPA 100.0   NMDA 20.0  GABA_B 0 GABA_A 0  
ap8_2   ap7_2        -13   0  58.57   3.14  Ca_conc -13.0e12 Na    0 Ca 60 K_DR    0 K_AHP 16 K_C 240 K_A 0	AMPA 100.0   NMDA 20.0  GABA_B 0 GABA_A 0  
ap8_3   ap7_3      0 13    58.57   3.14  Ca_conc -13.0e12 Na    0 Ca 60 K_DR    0 K_AHP 16 K_C 240 K_A 0	AMPA 100.0   NMDA 20.0   GABA_B 0 GABA_A 0
ap8_4   ap7_3        13   0     58.57   3.14  Ca_conc -13.0e12 Na    0 Ca 60 K_DR    0 K_AHP 16 K_C 240 K_A 0	AMPA 100.0   NMDA 20.0   GABA_B 0 GABA_A 0   

ap9_1   ap8_1      0    -35.36     35.36   1.40  Ca_conc -34.0e12 Na    0 Ca 60 K_DR    0 K_AHP 16 K_C 240 K_A 0	AMPA 100.0   NMDA 20.0     GABA_B 20.0 GABA_A 0  
ap9_4   ap8_2        -35.36   0     35.36   1.40  Ca_conc -34.0e12 Na    0 Ca 60 K_DR    0 K_AHP 16 K_C 240 K_A 0	AMPA 100.0   NMDA 20.0     GABA_B 20.0 GABA_A 0  
ap9_5   ap8_3      0    35.36     35.36   1.40  Ca_conc -34.0e12 Na    0 Ca 60 K_DR    0 K_AHP 16 K_C 240 K_A 0	AMPA 100.0   NMDA 20.0    GABA_B 20.0 GABA_A 0  
ap9_8   ap8_4     0   35.36        35.36   1.40  Ca_conc -34.0e12 Na    0 Ca 60 K_DR    0 K_AHP 16 K_C 240 K_A 0	AMPA 100.0   NMDA 20.0    GABA_B 20.0 GABA_A 0  
ap9_2   ap8_1      0    -40   44.72 2.50  Ca_conc -16.0e12 Na    0 Ca 60 K_DR    0 K_AHP 16 K_C 240 K_A 0	AMPA 100.0   NMDA 20.0   GABA_B 20.0 GABA_A 0  
ap9_3   ap8_2      0    40     44.72   2.50  Ca_conc -16.0e12 Na    0 Ca 60 K_DR    0 K_AHP 16 K_C 240 K_A 0	AMPA 100.0   NMDA 20.0   GABA_B 20.0 GABA_A 0  
ap9_6   ap8_3        0   0     60   2.50  Ca_conc -16.0e12 Na    0 Ca 60 K_DR    0 K_AHP 16 K_C 240 K_A 0	AMPA 100.0   NMDA 20.0  GABA_B 20.0 GABA_A 0  
ap9_7   ap8_4        0   -40   44.72 2.50  Ca_conc -16.0e12 Na    0 Ca 60 K_DR    0 K_AHP 16 K_C 240 K_A 0	AMPA 100.0   NMDA 20.0   GABA_B 20.0 GABA_A 0    

ap10_1  ap9_2      -42.43    0     42.43   1.60  Ca_conc -25.0e12 Na    0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 0	AMPA 100.0   NMDA 20.0   GABA_B 20.0 GABA_A 0  
ap10_2  ap9_2        42.43   0     42.43   1.60  Ca_conc -25.0e12 Na    0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 0	AMPA 100.0   NMDA 20.0  GABA_B 20.0 GABA_A 0  
ap10_3  ap9_3      -42.43    0     42.43   1.60  Ca_conc -25.0e12 Na    0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 0	AMPA 100.0   NMDA 20.0   GABA_B 20.0 GABA_A 0  
ap10_4  ap9_3        42.43   0     42.43   1.60  Ca_conc -25.0e12 Na    0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 0	AMPA 100.0   NMDA 20.0   GABA_B 20.0 GABA_A 0  
ap10_5  ap9_6      0    -42.43     42.43   1.60  Ca_conc -25.0e12 Na 0    Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 0	AMPA 100.0   NMDA 20.0   GABA_B 20.0 GABA_A 0  
ap10_6  ap9_6        0   42.43     42.43   1.60  Ca_conc -25.0e12 Na    0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 0	AMPA 100.0   NMDA 20.0  GABA_B 20.0 GABA_A 0
ap10_7  ap9_7      -42.43    0     42.43   1.60  Ca_conc -25.0e12 Na    0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 0	AMPA 100.0   NMDA 20.0    GABA_B 20.0 GABA_A 0
ap10_8  ap9_7        42.43   0     42.43   1.60  Ca_conc -25.0e12 Na    0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 0	AMPA 100.0   NMDA 20.0   GABA_B 20.0 GABA_A 0
                                                            
ap11_1  ap10_1       0    0    60   1.60  Ca_conc -25.0e12 Na    0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 0	AMPA 0 NMDA 0 GABA_A 0 GABA_B 0
ap11_2  ap10_2       0    0    60   1.60  Ca_conc -25.0e12 Na    0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 0	AMPA 0 NMDA 0 GABA_A 0 GABA_B 0
ap11_3  ap10_3       0    0    60   1.60  Ca_conc -25.0e12 Na    0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 0	AMPA 0 NMDA 0 GABA_A 0 GABA_B 0
ap11_4  ap10_4       0    0    60   1.60  Ca_conc -25.0e12 Na    0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 0	AMPA 0 NMDA 0 GABA_A 0 GABA_B 0
ap11_5  ap10_5       0    0    60   1.60  Ca_conc -25.0e12 Na    0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 0	AMPA 0 NMDA 0 GABA_A 0 GABA_B 0
ap11_6  ap10_6       0    0    60   1.60  Ca_conc -25.0e12 Na    0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 0	AMPA 0 NMDA 0 GABA_A 0 GABA_B 0
ap11_7  ap10_7       0    0    60   1.60  Ca_conc -25.0e12 Na    0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 0	AMPA 0 NMDA 0 GABA_A 0 GABA_B 0
ap11_8  ap10_8       0    0    60   1.60  Ca_conc -25.0e12 Na    0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 0	AMPA 0 NMDA 0 GABA_A 0 GABA_B 0

bas3_1  soma         -15  0      0   5.00  Ca_conc -123.0e12 Na  20 Ca 20 K_DR  300 K_AHP 16 K_C  160 K_A 10	AMPA 100.0   NMDA 20.0    GABA_A 70.0 GABA_B 0
bas3_2  soma         0  -11.18 -10   5.00  Ca_conc -123.0e12 Na  20 Ca 20 K_DR  300 K_AHP 16 K_C  160 K_A 10	AMPA 100.0   NMDA 20.0     GABA_A 70.0 GABA_B 0
bas3_3  soma       0  11.18    -10   5.00  Ca_conc -123.0e12 Na  20 Ca 20 K_DR  300 K_AHP 16 K_C  160 K_A 10	AMPA 100.0   NMDA 20.0     GABA_A 70.0 GABA_B 0    
bas3_4  soma        15    0      0   5.00  Ca_conc -123.0e12 Na  20 Ca 20  K_DR  300 K_AHP 16 K_C  160 K_A 10	AMPA 100.0   NMDA 20.0     GABA_A 70.0  GABA_B 0

bas2_1  bas3_1      0   -19.37      -35   3.14  Ca_conc -164.0e12 Na   0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 10	AMPA 100.0 NMDA 0  GABA_A 0 GABA_B 0
bas2_2  bas3_1      0   35  -19.37  3.14  Ca_conc -164.0e12 Na   0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 1	AMPA 100.0 NMDA 0  GABA_A 0 GABA_B 0
bas2_3  bas3_2      0 -19.37   -35   3.14  Ca_conc -164.0e12 Na   0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 10	AMPA 100.0 NMDA 0  GABA_A 0 GABA_B 0
bas2_4  bas3_2      0     0    -40   3.14  Ca_conc -164.0e12 Na   0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 10	AMPA 100.0 NMDA 0  GABA_A 0 GABA_B 0 
bas2_5  bas3_3      0     0    -40   3.14  Ca_conc -164.0e12 Na   0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 10	AMPA 100.0  NMDA 0  GABA_A 0 GABA_B 0
bas2_6  bas3_3  0     19.37    -35   3.14  Ca_conc -164.0e12 Na   0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 10	AMPA 100.0 NMDA 0  GABA_A 0 GABA_B 0
bas2_7  bas3_4     0     35  -19.37  3.14  Ca_conc -164.0e12 Na   0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 10	AMPA 100.0 NMDA 0  GABA_A 0 GABA_B 0
bas2_8  bas3_4     0     -35 -19.37   3.14  Ca_conc -164.0e12 Na   0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 10	AMPA 100.0 NMDA 0  GABA_A 0 GABA_B 0

bas1_1   bas2_1   -36.06 0      -60   2.00  Ca_conc -148.0e12 Na   0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 0	AMPA 0 NMDA 0  GABA_A 0 GABA_B 0
bas1_2   bas2_1      0   0      -70   2.00  Ca_conc -148.0e12 Na   0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 0	AMPA 0 NMDA 0  GABA_A 0 GABA_B 0
bas1_3   bas2_2      0   0      -70   2.00  Ca_conc -148.0e12 Na   0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 0	AMPA 0 NMDA 0  GABA_A 0 GABA_B 0
bas1_4   bas2_2      0   -60 -36.06   2.00  Ca_conc -148.0e12 Na   0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 0	AMPA 0 NMDA 0  GABA_A 0 GABA_B 0
bas1_5   bas2_3      0   60 -36.06   2.00  Ca_conc -148.0e12 Na   0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 0	AMPA 0 NMDA 0  GABA_A 0 GABA_B 0
   bas1_6   bas2_3      0   0    -43.6   2.00  Ca_conc -148.0e12 Na   0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 0	AMPA 0 NMDA 0  GABA_A 0 GABA_B 0
bas1_7   bas2_4      0   26    -35   2.00  Ca_conc -148.0e12 Na   0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 0	AMPA 0 NMDA 0  GABA_A 0 GABA_B 0
   bas1_8   bas2_4      0     0    -70   2.00  Ca_conc -148.0e12 Na   0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 0	AMPA 0 NMDA 0  GABA_A 0 GABA_B 0
   bas1_9   bas2_5      0     36.06    -60   2.00  Ca_conc -148.0e12 Na   0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 0	AMPA 0 NMDA 0  GABA_A 0 GABA_B 0
bas1_10  bas2_5     -26     0    -35   2.00  Ca_conc -148.0e12 Na   0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 0	AMPA 0 NMDA 0  GABA_A 0 GABA_B 0
bas1_11  bas2_6     -26     0    -35   2.00  Ca_conc -148.0e12 Na   0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 0	AMPA 0 NMDA 0  GABA_A 0 GABA_B 0
bas1_12  bas2_6     60     0  -36.06  2.00  Ca_conc -148.0e12 Na   0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 0	AMPA 0 NMDA 0  GABA_A 0 GABA_B 0
bas1_13  bas2_7     60     0  -36.06  2.00  Ca_conc -148.0e12 Na   0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 0	AMPA 0 NMDA 0  GABA_A 0 GABA_B 0
bas1_14  bas2_7     0     0      -70   2.00  Ca_conc -148.0e12 Na   0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 0	AMPA 0 NMDA 0  GABA_A 0 GABA_B 0
bas1_15  bas2_8     0     0      -70   2.00  Ca_conc -148.0e12 Na   0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 0	AMPA 0 NMDA 0  GABA_A 0 GABA_B 0
bas1_16  bas2_8     0   -36.06    -60   2.00  Ca_conc -148.0e12 Na   0 Ca 20 K_DR    0 K_AHP 16 K_C  80 K_A 0	AMPA 0 NMDA 0  GABA_A 0 GABA_B 0

*set_compt_param  CM 0.0075     //F/m^2
*set_compt_param  RM 0.1       	//ohm*m^2
*set_compt_param  RA 1.0
   axonIS   soma  0      53         53   4.00      NaA  5000 K_DRA 2500  GABA_A 20.0

*set_compt_param  CM 0.0075     //F/m^2
*set_compt_param  RM 0.1 	//ohm*m^2
*set_compt_param  RA 1.0
   ax       axonIS     40     0     63.44   1.00      NaA  5000 K_DRA 2500	pyr_spikegen -0.03


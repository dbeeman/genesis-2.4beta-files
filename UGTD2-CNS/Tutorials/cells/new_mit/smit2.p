//	PARAMETER FILE FOR NEURON 'mit' : highly simplified version of cell
//	Author : Upi Bhalla , Caltech, Aug 1991
//	simplified model of mit cell with experimental averages for
//		cell geometry.
//	
//	Some Na channel thresholds are lower due to higher axial resistance of
//	longer compartments. Also, the compartments are fatter. These two effs
//	should nearly cancel. 
//
//	The requirement for antidromic stimulation even when the cell is being
//	inhibited makes it difficult to reduce the number of axonal segments
//	without being very lavish with channel densities to prevent spike failure.
//
//	A major effect, corrected in this version of the simple cell, is the 
//	spike rebound due to delayed propagation of the glomerular spike to
//	the soma. This is very dependent on the el. length of the primary dend
//	compartment near the soma. Likewise, the behaviour of the glom region
//	depends on the el. length of the end of the primary dendrite near the
//  glomerulus.

//		Coordinate mode
*cartesian
*relative

//		Specifying constants
*set_global	RA	2.0
*set_global	CM	0.01
*set_global	EREST_ACT	-0.065

// Use this value of RM to give the soma an Rm of 120e6 - (electrode damage)
*set_global     RM      0.386

soma	none	32	0	0	32	LCa3_mit_usb	100	K_mit_usb	20	KA_bsg_yka	30	K2_mit_usb	1917	Na_mit_usb	3760	Ca_mit_conc	5.2e-6	Kca_mit_usb	70

*set_global	RM	10


axon	soma	0	0	-10	10	K2_mit_usb	1540	Na_mit_usb	3760	LCa3_mit_usb	100	Ca_mit_conc	5.2e-6	Kca_mit_usb	70	K_mit_usb	20	KA_bsg_yka	20

axon[1]	.	0	0	-10	7	K2_mit_usb	1540	Na_mit_usb	3760	LCa3_mit_usb	100	Ca_mit_conc	5.2e-6	Kca_mit_usb	70	K_mit_usb	20	KA_bsg_yka	20	
axon[2]	.	0	0	-10	5	K2_mit_usb	1200	Na_mit_usb	2820
axon[3]	.	0	0	-20	4	K2_mit_usb	1200	Na_mit_usb	2820
axon[4]	.	0	0	-50	3	K2_mit_usb	1200	Na_mit_usb	1880
axon[5]	.	0	0	-120	3	K2_mit_usb	1200	Na_mit_usb	1880
axon[6]	.	0	0	-320	3	K2_mit_usb	1200	Na_mit_usb	1880

primary_dend	soma	0	0	40	7.9	LCa3_mit_usb	22	K_mit_usb	17	Na_mit_usb	13	K2_mit_usb	22
primary_dend[1]	.	0	0	100	7.0	LCa3_mit_usb	22	K_mit_usb	17	Na_mit_usb	13	K2_mit_usb	22
primary_dend[2]	.	0	0	220	6.0	LCa3_mit_usb	22	K_mit_usb	17	Na_mit_usb	13	K2_mit_usb	22
primary_dend[3]	.	0	0	140	5.0	LCa3_mit_usb	22	K_mit_usb	17	Na_mit_usb	13	K2_mit_usb	22
primary_dend[4]	.	0	0	70	4.7	LCa3_mit_usb	22	K_mit_usb	17	Na_mit_usb	13	K2_mit_usb	22

*polar
glom1		primary_dend[4]	60	0	50	1.5	LCa3_mit_usb	100	K_mit_usb	30
glom11		glom1		70	-120	50	1.0	LCa3_mit_usb	100	K_mit_usb	30
glom12		glom1		60	135	40	0.8	LCa3_mit_usb	100	K_mit_usb	30

glom2		primary_dend[4]	60	90	50	1.5	LCa3_mit_usb	100	K_mit_usb	30
glom21		glom2		70	-45	35	1.0	LCa3_mit_usb	100	K_mit_usb	30
glom22		glom2		60	-140	50	0.8	LCa3_mit_usb	100	K_mit_usb	30

glom3		primary_dend[4]	65	170	45	1.4	LCa3_mit_usb	100	K_mit_usb	30
glom31		glom3		70	40	35	1.0	LCa3_mit_usb	100	K_mit_usb	30
glom32		glom3		60	-50	50	0.8	LCa3_mit_usb	100	K_mit_usb	30

glom4		primary_dend[4]	55	290	55	1.4	LCa3_mit_usb	100	K_mit_usb	30
glom41		glom4		70	135	55	1.0	LCa3_mit_usb	100	K_mit_usb	30
glom42		glom4		60	50	40	0.8	LCa3_mit_usb	100	K_mit_usb	30


sec_dend1	soma		200	0	60	5.5	LCa3_mit_usb	14	K_mit_usb	8.5	K2_mit_usb	226	Na_mit_usb	317
sec_dend1[1]	sec_dend1	252	30	85	3.5	LCa3_mit_usb	14	K_mit_usb	8.5	K2_mit_usb	226	Na_mit_usb	317
sec_dend11	sec_dend1[1]	460	60	75	2.8	K2_mit_usb	180	Na_mit_usb	222
sec_dend12	sec_dend1[1]	300	-20	80	2.7	K2_mit_usb	180	Na_mit_usb	222
sec_dend12[1]	.		300	-20	85	2.7	K2_mit_usb	180	Na_mit_usb	222
sec_dend121	sec_dend12[1]	450	-5	85	2.3	K2_mit_usb	180	Na_mit_usb	222
sec_dend122	sec_dend12[1]	450	-45	75	2.3	K2_mit_usb	180	Na_mit_usb	222


sec_dend2	soma		200	90	60	5.5	LCa3_mit_usb	14	K_mit_usb	8.5	K2_mit_usb	226	Na_mit_usb	317
sec_dend2[1]	sec_dend2	252	120	85	3.5	LCa3_mit_usb	14	K_mit_usb	8.5	K2_mit_usb	226	Na_mit_usb	317
sec_dend21	sec_dend2[1]	460	150	75	2.4	K2_mit_usb	180	Na_mit_usb	222
sec_dend22	sec_dend2[1]	300	105	80	2.8	K2_mit_usb	180	Na_mit_usb	222
sec_dend22[1]	.		300	105	85	2.7	K2_mit_usb	180	Na_mit_usb	222
sec_dend221	sec_dend22[1]	450	135	75	2.4	K2_mit_usb	180	Na_mit_usb	222
sec_dend222	sec_dend22[1]	450	40	80	2.3	K2_mit_usb	180	Na_mit_usb	222


sec_dend3	soma		200	180	60	5.5	LCa3_mit_usb	14	K_mit_usb	8.5	K2_mit_usb	226	Na_mit_usb	317
sec_dend3[1]	sec_dend3	255	180	85	3.5	LCa3_mit_usb	14	K_mit_usb	8.5	K2_mit_usb	226	Na_mit_usb	317
sec_dend31	sec_dend3[1]	300	260	80	2.9	K2_mit_usb	180	Na_mit_usb	222
sec_dend31[1]	.		300	260	85	2.9	K2_mit_usb	180	Na_mit_usb	222
sec_dend311	sec_dend31[1]	420	285	75	1.9	K2_mit_usb	180	Na_mit_usb	222
sec_dend312	sec_dend31[1]	250	240	80	2.7	K2_mit_usb	180	Na_mit_usb	222
sec_dend312[1]	.		250	240	80	2.6	K2_mit_usb	180	Na_mit_usb	222
sec_dend3121	sec_dend312[1]	400	220	85	2.2	K2_mit_usb	180	Na_mit_usb	222
sec_dend3122	sec_dend312[1]	400	150	80	2.1	K2_mit_usb	180	Na_mit_usb	222
sec_dend32	sec_dend3[1]	460	160	85	2.5	K2_mit_usb	180	Na_mit_usb	222


sec_dend4	soma		200	270	60	5.5	LCa3_mit_usb	14	K_mit_usb	8.5	K2_mit_usb	226	Na_mit_usb	317
sec_dend4[1]	sec_dend4	260	-45	85	3.3	LCa3_mit_usb	14	K_mit_usb	8.5	K2_mit_usb	226	Na_mit_usb	317
sec_dend41	sec_dend4[1]	460	-45	80	2.6	K2_mit_usb	180	Na_mit_usb	222
sec_dend42	sec_dend4[1]	460	-134	75	2.5	K2_mit_usb	180	Na_mit_usb	222


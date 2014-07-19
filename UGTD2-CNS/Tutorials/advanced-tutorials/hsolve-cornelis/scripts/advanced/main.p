// Morphology file for Purkinje cell
// (c) Erik De Schutter, Caltech 1991-1992
// Original data provided by Rapp, Yarom and Segev, Hebrew University Jerusalem
// Active membrane model with 1 spine on every spiny compartment
// References: Rapp, M., Segev, I., and Yarom, Y. (1994) Physiology,
//   morphology and detailed passive models of cerebellar Purkinje cells.
//   J.  Physiol. (London), 471: 87-99.
//             De Schutter, E. and Bower, J. M. (1994) An active membrane
//   model of the cerebellar Purkinje cell: I. Simulation of current
//   clamps in slice. J. Neurophysiol., 71: 375-400.
//   http://www.bbf.uia.ac.be/TNB/TNB_pub8.html
//             De Schutter, E. and Bower, J. M. (1994) An active membrane
//   model of the cerebellar Purkinje cell: II. Simulation of synaptic
//   responses. J. Neurophysiol., 71: 401-419.
//   http://www.bbf.uia.ac.be/TNB/TNB_pub7.html

*relative

*set_compt_param RM	{RMs}
*set_compt_param RA	{RA}
*set_compt_param CM	{CM}
*set_compt_param ELEAK {ELEAK}	
*set_compt_param EREST_ACT {EREST_ACT}
*compt /library/soma
soma		none		0.000	0.000	0.000	29.80

*set_compt_param RA	{RA}
*set_compt_param CM	{CM}
*set_compt_param ELEAK {ELEAK}	
*set_compt_param EREST_ACT {EREST_ACT}
*set_compt_param RM	{RMd}
*compt /library/maind
main[0]		soma		5.557	9.447	9.447	7.72
main[1]		main[0]		8.426	1.124	21.909	8.22
main[2]		main[1]		1.666	1.111	6.666	8.50
main[3]		main[2]		-2.779	2.223	1.667	9.22
main[4]		main[3]		-1.111	6.109	5.553	8.89
main[5]		main[4]		-1.111	-0.555	4.998	8.44
main[6]		main[5]		-1.749	0.583	3.498	8.61
main[7]		main[6]		-3.890	3.334	6.669	7.78
main[8]		main[7]		-6.665	-1.111	9.441	8.44


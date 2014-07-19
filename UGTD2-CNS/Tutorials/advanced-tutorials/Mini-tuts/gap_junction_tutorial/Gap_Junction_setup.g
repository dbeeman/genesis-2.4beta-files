//genesis 2.3 Script

/********************************************************************
 ** Gap_Junction_setup.g:  This creates the synapse between cells 
 ** 1 and 2, based on an initial Gap Junction created in the library.
 ** Include this script in the main run script after setting up the 
 ** Hines Solvers for the two cells to be coupled.  In General, 
 ** they should be set up as hsolve objects named "{cellpath}" 
 ** and "{cellpath2}" (otherwise the "GapJ.g" code won't work).
 **
 ** This code has been tested to work with hsolve "chanmode 4".  
 ** It should work with any hsolve mode that requires the 
 ** "finsdolvefield" command to get component values.
 **
 ** As with any implementation of a "fast" neuronal structure like a
 ** Gap Junction, the integration timestep should be adjusted to be 
 ** small enough that the solution does not "blow up".  For the cell
 ** models used in the development of this code, a timestep of 1e-5 
 ** seconds works well for conductances on the order of 10.0e-9 
 ** (10 nanoSiemens), while values on the order of 100 nS need a 
 ** timestep of 1e-6 sec.  
 ** Gap Junction Conductance values as high as 50,000 nS have been
 ** succesfully simulated with this code, but required a timestep of
 ** 1e-8 (10 nanoseconds).
 **
 ** Written 12/2006 by Carson B Roberts <carson_roberts@yahoo.com>
 ********************************************************************/

setfield /library/Gap_Junction Cell_1 {cellpath}
setfield /library/Gap_Junction Cell_2 {cellpath2}
     /*****************************************************************
      ** Set up the prototype Gap Junction to know the names of the
      ** two hsolve elements in this particular simulation.
      *****************************************************************/

str GapJPath = "/inputs/GapJ1"
     /****************************************************************
      ** This sets up the location where this particular Gap Junction 
      ** will be created.
      ****************************************************************/
copy /library/Gap_Junction {GapJPath}
     /************************************************************************
      ** Copy the prototype Gap Junction from the library to the place where 
      ** it will be used.  It can be referred to by "{GapJPath}" from now on.
      *************************************************************************/
str GapJ_compt1 = "p1b2[1]"
str GapJ_compt2 = "p1b2[1]"
     /*************************************************************
      ** These two strings define the Pre- and Post- Synaptic 
      ** compartments for the Gap Junction.  {GapJ_compt1} should
      ** refer to a compartment in {cellpath} and {GapJ_compt2}
      ** should refer to a compartment in {cellpath2}
      *************************************************************/
setfield {GapJPath} Comp_1 {GapJ_compt1}
setfield {GapJPath} Comp_2 {GapJ_compt2}
setfield {GapJPath} Gbar {G_Gap}
     /**************************************************************
      ** Tell the newly-created object what its location and
      ** parameters are.  The variable "{G_Gap}" needs to have been
      ** given a value previously.  
      **************************************************************/

/***********************************************************************
 ** Below is an example of how a second Gap Junction can be made from 
 ** the prototype in the library.
 **********************************************************************/

// str GapJPath2 = "/inputs/GapJ2"
// copy /library/Gap_Junction {GapJPath2}
// str GapJ2_compt1 = "p1[1]"
// str GapJ2_compt2 = "p1[1]"
// setfield {GapJPath2} Comp_1 {GapJ2_compt1}
// setfield {GapJPath2} Comp_2 {GapJ2_compt2}
// setfield {GapJPath2} Gbar {G_Gap}


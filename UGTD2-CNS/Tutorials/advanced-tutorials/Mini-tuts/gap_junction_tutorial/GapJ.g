// genesis 2.3 Script

/***********************************************************************
 ** GapJ:  Primitive Object to define an electrical synapse, or "Gap 
 ** Junction" between two cells.  This code is meant to be used with
 ** two or more cells that have been set up with the Genesis Hines 
 ** Solver, in hsolve chanmode 3 or higher.  The following code assumes
 ** that the two connected cells have been set up as hsolve objects called
 ** {cellpath} and {cellpath2}.
 **
 ** Written 12/2006 by Carson B. Roberts <carson_roberts@yahoo.com>
 ** based on code for rectifying electrical synapses by 
 ** Mariano Rodriguez <rodrigue74@yahoo.com>
 ************************************************************************/

ce /
  /**********************************************************************
   ** The following code will not work unless exectuted in the root of
   ** the element paths.
   **********************************************************************/
create neutral /GapJ
  
addfield /GapJ Gbar
addfield /GapJ Cell_1
addfield /GapJ Cell_2
addfield /GapJ Comp_1
addfield /GapJ Comp_2
  /********************************************************************* 
   **   Create fields for the Gap Junction object to be set in each 
   ** individual instance of this object.
   **********************************************************************/

addaction /GapJ PROCESS GapJPROCESS
addclass /GapJ device
  /*************************************************************************
   ** Required code to set up the Gap Junction Object 
   *************************************************************************/

  /*************************************************************************
   ** PROCESS action definition:  The following block of code  is where to 
   ** modify the properties of the gap junction
   **************************************************************************/
function GapJPROCESS(action)

    str Cell_1 = {getfield . Cell_1}
    str Cell_2 = {getfield . Cell_2}
    str Comp_1 = {getfield . Comp_1}
    str Comp_2 = {getfield . Comp_2}
            /***************************************************************
             ** First, copy the fields naming the two hsolve objects and the
             ** Pre- and Post-Synaptic compartments into local variables, 
             ** to make later commands more simple.
             ***************************************************************/
    hstr ={findsolvefield {Cell_1} {Cell_1}/{Comp_1} Vm}  
           float V1 = {getfield {Cell_1} {hstr}}
             /********************************************************* 
              ** Ask the Hines Solver what the Pre-synaptic Compartment 
              ** membrane potential is and write it to the local 
              ** variable "V1" for use in calculating Gap Current.
                 *********************************************************/
    hstr ={findsolvefield {Cell_2} {Cell_2}/{Comp_2} Vm}            
            float V2 = {getfield {Cell_2} {hstr}}
             /********************************************************* 
              ** Ask the Hines Solver what the Post-synaptic Compartment 
              ** membrane potential is and write it to the local 
              ** variable "V2" for use in calculating Gap Current.
              *********************************************************/
    float r = 1
             /*************************************************************
              ** A variable to represent the "rectification" property of an
              ** electrical synapse.  For a non-rectifying synapse, leave
              ** "r = 1".  For rectification, define r as a function of
              ** the compartment membrane potentials {V1} and {V2}
              ** Example: 
              **           float r = 1/{1+{exp{100*{{V1}-{V2}}}}}
              *************************************************************/
    float I = { getfield . Gbar}*{r}*{{V2}-{V1}}
             /*************************************************************
              ** Calculate the Gap Junction Current as the product of the 
              ** local field "{Gbar}" and the difference in membrane 
              ** potential between the two compartments.
              *************************************************************/
    hstr ={findsolvefield {Cell_1} {Cell_1}/{Comp_1} inject}  
            setfield {Cell_1} {hstr} {I}
	      /***************************************************************
               ** Tell the Hines Solver to update the "inject" 
               ** (injected current) value for the Pre-Synaptic compartment.
               ***************************************************************/
    hstr ={findsolvefield {Cell_2} {Cell_2}/{Comp_2} inject}  
            setfield {Cell_2} {hstr} {-1*{I}}
              /***************************************************************
               ** Tell the Hines Solver to update the "inject" 
               ** (injected current) value for the Post-Synaptic compartment
               ** This should be the negative of the Pre-Synaptic current.
               ***************************************************************/
    return 1
	    // No idea what this does, but it seems necessary.
  end // of function GapJPROCESS

  // create the GapJ object
addobject GapJ GapJ -author "Carson B Roberts" \
   -description "hsolvable electrical synapse"
resched
   /*********************************************************************
    ** "run resched so that the new object will be made known to the 
    ** simulator... resched is called in order to reread the simulation 
    ** schedule and schedule the listed element types for simulation."
    ** (From Genesis Command Reference for "resched" command)
    *********************************************************************/

/**************************************************************************
 ** Now, the basic Extended Object has been set up, and can be created and
 ** set up, and multiple copies made for later use.  The actual creation of
 ** the object to be used is done in the following block of code, which 
 ** should be called in the main run script, after the Hines Solvers have
 ** been set up, and after this file (GapJ.g) has been included.
 **************************************************************************/

function create_Gap_Junction
   ce /library
      /**************************************************************** 
       ** This function should be called in "/library", and then can 
       ** copied multiple times to be used in various places.  
       ****************************************************************/
   if (!{exists Gap_Junction})
        create GapJ Gap_Junction
         /****************************************************************
          ** This sets up a specific instance of the Gap Junction object
          ****************************************************************/
   end // of ifloop for creating GapJ.

end // of function create_Gap_Junction

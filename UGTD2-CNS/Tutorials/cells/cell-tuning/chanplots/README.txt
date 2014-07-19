This utility for plotting tabchannel activation curves and taus uses
code taken from the channel edit mode of the genesis/Scripts/neurokit
simulation.  (For more details, see genesis/Scripts/neurokit/README or
run Neurokit within the genesis/Scripts/traub91 directory.)

The main script, chantest.g, should be modified to create the channels
to be plotted under the neutral element "/library".  This example uses
the channels for the hippocampal pyramidal cell model of Traub,
et. al. [R.D.Traub, R. K.  S.  Wong, R. Miles, and H. Michelson,
Journal of Neurophysiology, Vol. 66, p. 635 (1991)], as implemented in
genesis/Scripts/traub91. 

In order to run the demo, your .simrc file should set the SIMPATH to
include neurokit and neurokit/prototypes.

To plot activations and taus for other channels, replace the included
files for the traub91 model prototypes with files defining the
functions for creating the other channels, and invoke the functions in
/library.

Use the "gate" dialog to enter the gate (X, Y, or Z) to be plotted, or
click on it to plot the default X gate.  The channel_path dialog can
be used to select a different channel from the list of channels created
in chantest.g.

Main simulation script:  simplecell2.g

Model description:

This uses the cell reader to create a simple two-compartment neuron with a
dendrite compartment, a soma, and an axon. The dendrite contains
synaptically activated excitatory and inhibitory channels and the soma
contains "squid-like" voltage-activated Hodgkin-Huxley sodium and potassium
channels, plus a spikegen element that acts like the intial part of an
axon.  This may be used to provide synaptic input to another cell.

The simulation is based on a sample script to create a neuron from a
specified cell parameter file, with channels taken from the prototypes
created by the file protodefs.g.  It can be customized for another cell by
changing strings that are defined in the main script. When used with the
GUI functions defined in graphics.g, it allows a variety of pulsed current
injection and synaptic inputs to be applied.

The CONTROL PANEL of the GUI (defined in graphics.g) allows injection
current pulses to be applied to the cell, and/or synaptic activation to be
applied to the synchan that is specified in the string variable 'synpath'.
If the value of synpath is '' (empty), then the synaptic input form does
not appear.  The injection may be turned on and off by clicking on the
'Current Injection ON/OFF' toggle.

In the synaptic input form, 'gmax' is used to set the gmax field of the
specied synchan.  Poisson-distributed background activation can be applied
to the synchan by setting the 'Frequency' (the average activation
frequency) to a non-zero value.  This sets the frequency field of the
synchan to that value.  The 'Spike input ON/OFF' toggle turns on and off
the application of trains of spikes at the specified 'Spike interval'.

The scripts in this directory are:

Files in this directory:

README          This file.

simplecell2.g	The main simulation script to start the simulation.

cell.p          The cell parameter file for the model

protodefs.f     File to create the library of prototype channels and other
		elements used by the cell parameter file.

graphics.g	A generic GUI to control the simulation. It can be somewhat
		customized by setting the value of parameters and strings
		the main simulation script.

userprefs.g     Used to run the model under Neurokit.  Simply type
		'genesis Neurokit' when in this directory, and then click
		on 'file' when the title bar appears.  Then click on
		'Load from file', and then select 'run cell' from the
		title bar.  For help with Neurokit, run it from the
		genesis/Scripts/neurokit directory.

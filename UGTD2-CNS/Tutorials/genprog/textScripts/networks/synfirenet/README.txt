This simulation was developed by Dieter Jaeger (djaeger@emory.edu) as
as an exercise in script programming of networks, using a synfire
chain network as an example.

A synfire chain network is a feedforward network consisting of several
parallel chains of cells.  Each cell has excitatory connections to cells on
the next chain, with no connections within the chain, or to the previous
chain.  This network has the interesting property that desynchronized spike
trains at the input chain can become synchronized at the final chain.

The main script is netsim.g.  It creates 10 columns, with 10 cells in each
column.  These are displayed with labels in the "viewform", which comes up
when the simulation is run.  Each of the 100 cells has Na and K channels as
well as an excitatory and an inhibitory synapse.  The pattern of
connections is set in the script connections.g, which may be modified to
experiment with other network topologies.  In this version, each cell in a
column makes an excitatory connection to every cell in the column to the
right.  The first column receives no input connections, and the last one
has no outgoing connections.  Desynchronization is provided by adding a
random component to the propagation delays, which are set to 5 msec, with a
+/- 2 msec variation.

The synaptically activated channels are implemented with hebbsynchan
objects, which are initialized to have no learning, making them equivalent
to synchans.  To turn learning on or off, give the commands "learnon" or
"learnoff" at the genesis prompt.  See the documentation for hebbsynchan,
and the example script Scripts/examples/hebb/hebb.g in the GENESIS
distribution for further information on implementing Hebbian learning.

Typically, one starts the simulation by clicking on one or more cells in
the first one or two (left) columns of the viewform, to provide 1 nA
injection to the cell.  The "Graphs" form is used to select which graphs
will be displayed.  Clicking on "STEP" in the main control panel runs the
simulation for the indicated amount of time.  Changes in injection can then
be made before stepping it again.  For further information on running the
simulation or suggested ways to modify the simulation, click on "HELP".

Modified for the GENESIS Tutorials package by D. Beeman Feb 28, 2006

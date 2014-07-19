par-RSnet - a version of RSnet for parallel GENESIS
---------------------------------------------------

RSnet is a demonstration of a simple network, consisting of a grid of
simplified neocortical regular spiking pyramidal cells, each one coupled with
excitory synaptic connections to its four nearest neighbors.  This might model
the connections due to local association fibers in a cortical network.

The example RSnet simulation was designed to be easily modified to allow
you to use other cell models, implement other patterns of connectivity, or
to augment with a population of inhibitory interneurons and the several
other types of connections in a cortical network.  Details of running the
simulation and understanding the scripts are in the "Creating large
networks with GENESIS" section of the GENESIS Modeling Tutorial,
Tutorials/genprog/net-tut.html.

The serial genesis version may be run from the networks/RSnet directory
with the command "genesis RSnet.g".

par-RSnet.g is the main script of the parallel version, which was written
as an example for the GENESIS Modeling Tutorial "Converting large network
simulations to PGENESIS".  It may be run in its default configuration from
the networks/par-RSnet directory with the command

pgenesis -nodes 4 par-RSnet.g

after installing MPI and PGENESIS. The Mini-tutorial "Using Parallel
GENESIS on PCs with Multicore Processors" gives further details.  This
version of the script has been tested on a PC with a 2.4 GHz Intel Q6600
quad core processor, running GENESIS 2.3 and PGENESIS 2.3.1 under Fedora
Linux.  A typical execution time for a similarly configured version of
RSnet.g was about 3.1 times longer than for par-RSnet.g.  Because of the
lack of inhibition, the network fires rapdily, generating many internode
SPIKE messages.  Thus, a speedup closer to the number of processor cores
would likely be obtained in a network with more balanced inhibition
and excitation.

This script has the default definitions:
int graphics = 1 // display control panel, graphs, optionally net view
int output = 1   // send simulation output to a file
int batch = 0    // if (batch) do a run with default params and quit
int netview = 0  // show network activity view (very slow, but pretty)

These may be changed to show the network view widget to visualize the
propagation of network activity.  This can be useful for understanding the
behavior of the network, but is much slower, due to the large number of
messages sent to the view from remote nodes..  If the batch flag is changed
to 1 and graphics to 0, it produces the output file Vm.dat.  This contains
the Vm of each of the 1024 cells at 1001 time steps.  It is large - about
11 MB, but can be compressed with bzip2 to about 12 KB.

Further details are given in the tutorial.

Dave Beeman
Wed Jun 10 16:41:07 MDT 2009

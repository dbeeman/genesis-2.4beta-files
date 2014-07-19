Gap Junctions with hsolve  (by Carson B. Roberts)

Dendrodendritic connections between interneurons via gap junctions
("electical synapses") are believed to facilitate synchronized firing in
networks.  (For example, see the 2009 Hjorth et al striatal interneuron
network model on the genesis-sim web site.)  In GENESIS, a gap junction
between compartments in two different cells can be implemented by passing
an RAXIAL message directly from each compartment to the other, with the Ra
field replaced by a number representing the resistance of the gap junction.
The simple example "gapdemo" included with this tutorial demonstrates this
method with a README file and a simulation with a GUI.

However, this simple approach cannot be used with the hsolve method,
normally making it necessary to use a very small time step when
implementing gap junctions on a detailed cell model with many small
compartments.  Carson B. Roberts has contributed this tutorial
(gap_junctions.html) and the example scripts (GapJ.g and
Gap_Junction_setup.g) to illustrate a method for implementing gap junctions
with hsolve.

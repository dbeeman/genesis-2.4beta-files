Manual parameter search example
===============================

The script 'AC_pyrcell-tuning.g' and the accompanying scripts
provide an example of a custom XODUS GUI for adjusting channel
parameters.  The example cell model is a version of the
layer 4 pyramidal cell from the ACnet2 network model. It has
some extra channels (Nap, CaT, and H) that were not used in the
final model.  This example allows experimenting with the effects
of adding these conductances and modifying parameters of others.

The 'chanplots' directory contains modifiable scripts to plot
tabchannel activation curves and taus.  The description can be
found in the `chanplots/README.txt <chanplots/README.txt>`_ file.

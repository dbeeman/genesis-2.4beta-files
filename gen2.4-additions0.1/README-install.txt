Installing the GENESIS 2.4 beta 'replacements'
==============================================

During the initial development of additions and changes to GENESIS 2.3
that will result in the November 2014 release of GENESIS 2.4, the
changed files will be distributed as replacement files, rather than
as patches, or a new GENESIS distribution.

In order to use these files,

  * Begin with clean GENESIS 2.3 distribution, from genesis-2.3-src.tar.gz

  * Rename the top directory 'genesis-2.3' to something else, such as
    'genesis-2.4beta-0'

  * Copy the files from these 'replacement directories' into the
    appropriate subdirectories of 'genesis-2.4beta-0/genesis'.  For
    example, 'genesis-Doc-replacements' contains files to be copied into
    'genesis/Doc' to augment or update the documentation files.
    Note that some of the new documentation may exist in HTML form,
    as well as plain text. Likewise, genesis/Scripts-additions contains
    directories that should be copied into the genesis/Scripts directory,
    and genesis-replacements contains replacement README and Changelog
    information for the main 'genesis' directory. Any exceptions are
    listed below.

  * Then make genesis as usual, following the instructions in src/README.
    Please report any compilation problems, or needed Makefile changes
    to me (dbeeman@colordo.edu) or to the genesis-sim-users mailing list.

Currently, the directory 'genesis-src-replacements/newconn/' contains
these files to be copied into src/newconn::

  Makefile   -- adds stdp_rules.o to OBJECTS
  newconnlib.g -- adds section for 'object stdp_rules stdp_rules_type StdpRules'
  newconn_struct.h -- added '#include "stdp_rules_struct.h"'; changed SYNAPSE_TYPE
  stdp_rules_struct.h -- defines struct stdp_rules_type for the object fields
  stdp_rules.c -- the source code for StdpRules() and functions
  synchan.c -- has additions to the 'EVENT' and 'RESET' cases

synchan.c was modified to add the 'last_spike_time' field to each
synapse and set it to the time of the last presynaptic spike plus
delay in order to get the arrival time. This was done within the
'EVENT' case, where spike events are processed outside of hsolve.
Aplus and Aminus fields were added for use by stdp_rules or another
synapse modification object. The added field 'lastupdate' can be used
to store the time that the synapse weight, Aplus, and Aminus
fields were last updated. Other than initialization on RESET, these
three fields are not directly used by the synchan.

For more details on the implementation of hsolvable synaptic plasticity, see
genesis-Doc-replacements/NewPlasticityObjects.txt and
genesis-Doc-replacements/stdp_rules.txt.  HTML versions are in
genesis-Hyperdoc-replacements. At present, the new additions have
not yet been indexed.

See genesis-Scripts-replacements for other new tutorial simulations.

See src/ChangeLog for the latest additions and changes.

Some exceptions:

  * The original Scripts/purkinje directory should be removed before copying
    in the new one.


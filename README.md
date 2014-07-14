GENESIS 2.4 beta release development files
------------------------------------------

The 'genesis-2.4beta-files' project is a github repository of
files that are being developed for the November 2014 GENESIS 2.4
release. The final release (and possibly a public beta release)
will be available on the GENESIS 2 website (http://genesis-sim.org/GENESIS)
and the Sourceforge GENESIS development site
http://sourceforge.net/projects/genesis-sim.

During the initial development of additions and changes to the GENESIS
neural simulator, the changed files will be distributed as replacement
files, rather than as patches, or a new GENESIS distribution.

The current files and directories that replace or add to one in the
GENESIS 'genesis' directory are in 'gen2.4-additions0.1'.
The complete collection may be downloaded by clicking on "Download ZIP".
See README-install.txt (or .html) for instructions for installing or
upgrading to the latest GENESIS 2.4 beta release.

By helping us with testing, you will not only help make a better
final release, but have a chance to preview these additions:

* The new 'stdp_rules' object for efficiently implementing spike timing
  dependent plasticity in large networks of hsolved multicompartmental cells.

* A new version of the chemesis library for modeling second messengers
  and calcium dynamics is now installed by default.

* New tutorial Scripts and Doc entries were added for:

  o chemesis

  o the gpython-tools Python utility collection

  o An updated Purkinje tutorial

  o stdp_rules, including 'NewPlasticityObjects' documentation for
    implementing similar objects.

  o An improved hsolved implementation of the dual exponential
    conductance version of the Vogels-Abbott network model.  It serves
    as a tutorial on how to achieve a speed improvement of 10 to 20
    times when using hsolve with network models.

* Bug fixes and Makefile improvements to ease installation.

These have been tested on recent Fedora and Ubuntu Linux installations.
I would appreciate reports of success or failure to compile on
other Linux versions, and in particular, for MacOS.

Dave Beeman
dbeeman@colorado.edu

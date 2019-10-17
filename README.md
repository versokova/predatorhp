
Instructions for SV-COMP 2019
=============================

(0) Install the dependencies (please note: we use old GCC 5):

    # apt-get install cmake git g++-5-multilib gcc-5-plugin-dev libboost-dev make python

(1) Build PredatorHP from sources. (Skip this step if you have binary version compiled
    for your system -- Predator checks this and predatorHP.py script
    produces "UNKNOWN" in the case of version mismatch. This is very important when
    Ubuntu has not installed required dependencies.)
    In the "predatorHP-2019/" directory, run the following script:

    $ ./build-all.sh

(2) Use benchexec tool to run the tests or use predatorHP.py
    note: if witness-graphml-file is needed,
          add "--witness" option (as specified in predatorHP.py usage)

(DISCLAIMER)
    "predatorhp.py" refers to benchexec python plugin/module.
    This module is a mere wrapper around "predatorHP.py",
    the main running script of Predator Hunting Party.

(predatorHP.py usage)
    You can use the "predatorHP.py" script to verify each single test-case.

  $ predatorHP.py --propertyfile PROPERTYFILE --witness WITNESS TASK

    PROPERTYFILE: Path to a file containing the property to be verified
                  (in SV-COMP LTL specification)
    WITNESS:      Path to a file, where the witness trace in XML will be written
    TASK:         Path to a C program to be verified

Instructions for SV-COMP 2020
=============================

0. Install the dependencies:

        # apt-get install cmake git g++-7-multilib gcc-7-plugin-dev libboost-dev make python

1. Build PredatorHP from sources. (Skip this step if you have binary version compiled
   for your system -- Predator checks this and predatorHP.py script
   produces "UNKNOWN" in the case of version mismatch. This is very important when
   Ubuntu has not installed required dependencies.)
   In the `PredatorHP-2020/` directory, run the following script:

        $ ./build-all.sh

2. Use benchexec tool to run the tests or use `predatorHP.py`
   note: if witness-graphml-file is needed,
   add `--witness` option (as specified in `predatorHP.py` usage)

### DISCLAIMER
   [predatorhp.py](https://github.com/sosy-lab/benchexec/blob/master/benchexec/tools/predatorhp.py)
   refers to benchexec python plugin/module.
   This module is a mere wrapper around `predatorHP.py`,
   the main running script of Predator Hunting Party.

### Usage
   You can use the `predatorHP.py` script to verify each single test-case.

    $ predatorHP.py --propertyfile PROPERTYFILE --witness WITNESS [--compiler-options CFLAGS] TASK

    PROPERTYFILE: Path to a file containing the property to be verified
                  (in SV-COMP LTL specification)
    WITNESS:      Path to a file, where the witness trace in XML will be written
    CFLAGS:       Compiler options (e.g. --compiler-options="-m32 -g")
    TASK:         Path to a C program to be verified
    

#!/usr/bin/python

# This is the driver for predator hunting party (PredatorHP).
# It runs 4 predators in parallel (general, BFS, DFS/limit1, DFS/limit2).
# During run we test results of all predators each 1 second
# and if decision is reached, we kill all other running predators.
# There is no internal limitation of CPU time or memory.

# Script returns "TRUE" or "FALSE[(classification)]" or "UNKNOWN".

import subprocess
import time
import shlex
import sys
import os
import signal
import argparse
import tempfile
import shutil

predators = None        # list of all 4 predators running in paralllel

witness_dfs_200 = None
witness_dfs_900 = None
witness_bfs = None
witness_p = None

def onSIGKILL(signal, frame):
  if predators:
    predators.kill()
  sys.exit(0) # TODO: why 0?

signal.signal(signal.SIGINT, onSIGKILL)
signal.signal(signal.SIGTERM, onSIGKILL)

class PredatorProcess:
  def __init__(self, executable, title, witness=None):
    self.executable = executable
    self.answer = None
    self.title = title
    self.process = None
    self.witness = witness

  def execute(self):
    if self.process is None:
        self.process = subprocess.Popen(self.executable, stdout=subprocess.PIPE, preexec_fn=os.setpgrp)

  def answered(self):
    if not self.terminated():
      return False
    if self.answer is not None:
      return True
    output = self.process.communicate()[0]
    if output is not None:
      self.answer = output.split()[0]
      return True
    return False

  def getAnswer(self):
    if self.answered():
        return (self.answer, self.witness)
    else:
        return (None, self.witness)

  def terminated(self):
    return self.process.poll() is not None

  def kill(self):
    if not self.terminated():
      os.kill(-self.process.pid, signal.SIGKILL)
      self.process.wait()

class PredatorBatch:
  def __init__(self, predator_list):
    self.predators = predator_list

  def launch(self):
    for predator in self.predators:
      predator.execute()

  def kill(self):
    for predator in self.predators:
      predator.kill()
    self.predators = []

  def get_all_answers(self):
    state=[]
    self.running_count=0
    for predator in self.predators[:]:
      if predator.terminated():
         state.append(predator.getAnswer())
      else:
         state.append((None,None))
         self.running_count=self.running_count+1
    return state

  def running(self):
    return self.running_count

# main()
if __name__ == "__main__":

  # get path to this script
  script_dir = os.path.dirname(os.path.realpath(__file__))

  # parse commandline arguments
  parser = argparse.ArgumentParser()
  parser.add_argument("-v","--version", action='version', version='3.14')
  parser.add_argument("--propertyfile", dest="propertyfile")
  parser.add_argument("--witness", dest="witness")
  parser.add_argument("testcase")
  args = parser.parse_args()

  # create temporary files for witness
  witness_dfs_200 = tempfile.mkstemp()[1]
  witness_dfs_900 = tempfile.mkstemp()[1]
  witness_bfs = tempfile.mkstemp()[1]
  witness_p = tempfile.mkstemp()[1]

  # create all Predators
  predator_accelerated = PredatorProcess(shlex.split("%s/predator/sl_build/check-property.sh --trace=/dev/null --propertyfile %s --xmltrace %s -- %s -m32" % (script_dir, args.propertyfile, witness_p, args.testcase)), "Accelerated", witness_p)
  predator_bfs = PredatorProcess(shlex.split("%s/predator-bfs/sl_build/check-property.sh --trace=/dev/null --propertyfile %s --xmltrace %s -- %s -m32" % (script_dir, args.propertyfile, witness_bfs, args.testcase)), "BFS", witness_bfs)
  predator_dfs_200 = PredatorProcess(shlex.split("%s/predator-dfs/sl_build/check-property.sh --trace=/dev/null --propertyfile %s --xmltrace %s --depth 200 -- %s -m32" % (script_dir, args.propertyfile, witness_dfs_200, args.testcase)), "DFS 200", witness_dfs_200)
  predator_dfs_900 = PredatorProcess(shlex.split("%s/predator-dfs/sl_build/check-property.sh --trace=/dev/null --propertyfile %s --xmltrace %s --depth 900 -- %s -m32" % (script_dir, args.propertyfile, witness_dfs_900, args.testcase)), "DFS 900", witness_dfs_900)

  # create container of Predators, predator_accelerated should be first and dfs last
  predators = PredatorBatch([predator_accelerated, predator_bfs, predator_dfs_200, predator_dfs_900])

  # start all Predators
  predators.launch()

  # check results periodically
  answer = None
  while True:
    state = predators.get_all_answers()          ## list of tuples (answer,witness)
    truecount=0
    falseXFScount=0
    whichXFS=0
    i=0
    for rw in state:
        r = rw[0]
        if i<2 and r == "TRUE":                 ## not from dfs
            truecount = truecount+1
            whichXFS=i
        if i>0 and (r is not None) and r[0] == "F": ## FALSE check (not for base predator)
            falseXFScount = falseXFScount+1
            if falseXFScount == 1:              ## get first
                whichXFS=i
        i=i+1

    if truecount>0:                             ## any TRUE
        answer="TRUE"
        witness = state[whichXFS][1]
        if witness and args.witness:
           shutil.copyfile(witness, args.witness)
           # unlink postponed to end of script
        break

    if falseXFScount>0:                         ## any FALSE* variant
        answer = state[whichXFS][0]
        witness = state[whichXFS][1]
        if witness and args.witness:
           shutil.copyfile(witness, args.witness)
           # unlink postponed to end of script
        break

    if predators.running() == 0:                ## all tasks terminated
        answer="UNKNOWN"
        break

    time.sleep(0.25)
    # end while

  predators.kill()                              ## kill all remaining predators if any

  print(answer)

  # clean up
  os.unlink(witness_bfs)
  os.unlink(witness_dfs_200)
  os.unlink(witness_dfs_900)
  os.unlink(witness_p)

  # end main()

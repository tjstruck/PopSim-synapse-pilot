#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

inputs:
  install_demes.sh:
     type: File?
     default: install_demes.sh
     inputBinding:
        position: 1


  # other inputs go here

baseCommand: sh

outputs: []

#Usage ./steps/install_demes.cwl --install_demes.sh install_demes.sh
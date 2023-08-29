#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow

inputs: {}
outputs: {}
steps:
  install
    run: install_demes.sh
    input: []
    output: []

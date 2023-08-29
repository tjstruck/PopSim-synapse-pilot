#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

run: install_demes.cwl
   - id: install_demes.sh
      type: File
   outputs: []

#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
label: Validate predictions file

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
    - entryname: validate.py
      entry: |
        #!/usr/bin/env python
        import argparse
        import json
        import math
        pip install demes
        parser = argparse.ArgumentParser()
        parser.add_argument("-r", "--results", required=True, help="validation results")
        parser.add_argument("-e", "--entity_type", required=True, help="synapse entity type downloaded")
        parser.add_argument("-s", "--submission_file", help="Submission File")

        args = parser.parse_args()

        if args.submission_file is None:
            prediction_file_status = "INVALID"
            invalid_reasons = ['Expected FileEntity type but found ' + args.entity_type]
        else:
            with open(args.submission_file,"r") as sub_file:
                message = sub_file.read()
            invalid_reasons = []
            prediction_file_status = "VALIDATED"
            # Look through the contents of prediction file to ensure it is formated correctly
            for i, col in enumerate(','.join(message.split()).split(",")):
                if i == 0 and col != "ll":
                    invalid_reasons.append("Submission must have the first column as ll")
                    prediction_file_status = "INVALID"
                if i == 1 and col != "theta":
                    invalid_reasons.append("Submission must have the second column as theta")
                    prediction_file_status = "INVALID"
                if i > 1 and col != "theta":
                    try:
                        if math.isnan(float(col)):
                            invalid_reasons.append("Submission must have no NaNs as a value")
                            prediction_file_status = "INVALID"
                    except ValueError:
                        invalid_reasons.append("Submission must have integer or float as a value")
                        prediction_file_status = "INVALID"
        #
        ### The keys are considered annotations
        #
        result = {'submission_errors': "\n".join(invalid_reasons),
                  'submission_status': prediction_file_status}
        with open(args.results, 'w') as o:
            o.write(json.dumps(result))

inputs:
  - id: input_file
    type: File?
  - id: entity_type
    type: string

outputs:
  - id: results
    type: File
    outputBinding:
      glob: results.json
  - id: status
    type: string
    outputBinding:
      glob: results.json
      outputEval: $(JSON.parse(self[0].contents)['submission_status'])
      loadContents: true
  - id: invalid_reasons
    type: string
    outputBinding:
      glob: results.json
      outputEval: $(JSON.parse(self[0].contents)['submission_errors'])
      loadContents: true

baseCommand: python
arguments:
  - valueFrom: validate.py
  - prefix: -s
    valueFrom: $(inputs.input_file)
  - prefix: -e
    valueFrom: $(inputs.entity_type)
  - prefix: -r
    valueFrom: results.json

hints:
  DockerRequirement:
    dockerPull: python:3.9.1-slim-buster

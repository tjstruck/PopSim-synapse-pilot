#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
label: Score predictions file

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
    - entryname: score.py
      entry: |
        #!/usr/bin/env python
        import argparse
        import json
        parser = argparse.ArgumentParser()
        parser.add_argument("-f", "--submissionfile", required=True, help="Submission File")
        parser.add_argument("-r", "--results", required=True, help="Scoring results")
        parser.add_argument("-g", "--goldstandard", required=True, help="Goldstandard for scoring")

        args = parser.parse_args()

        import demes
        from sklearn.metrics import mean_squared_error
        import math

        submission = demes.load(args.submissionfile)
        goldstandard = demes.load(args.goldstandard)

        sub_time = submission.demes[0].epochs[1].time_span
        gold_time = goldstandard.demes[0].epochs[1].time_span

        # score = -1.0 * abs(gold_time - sub_time)
        MSE = mean_squared_error([gold_time], [sub_time])
        RMSE = math.sqrt(MSE)
        # score = -1.0 * abs(RMSE)
        prediction_file_status = "SCORED"

        result = {'rmse': RMSE,
                  'submission_status': prediction_file_status}
        with open(args.results, 'w') as o:
          o.write(json.dumps(result))

inputs:
  - id: input_file
    type: File
  - id: goldstandard
    type: File
  - id: check_validation_finished
    type: boolean?

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

baseCommand: python
arguments:
  - valueFrom: score.py
  - prefix: -f
    valueFrom: $(inputs.input_file.path)
  - prefix: -g
    valueFrom: $(inputs.goldstandard.path)
  - prefix: -r
    valueFrom: results.json

hints:
  DockerRequirement:
    dockerPull: tjstruck/popsim-pilot-slim:1.2

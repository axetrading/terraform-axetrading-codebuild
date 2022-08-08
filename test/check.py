import boto3
import datetime
import json
import os
import re
import sys
import time

outputs = json.loads(os.environ['TF_OUTPUTS'])

project_name = outputs['project_name']['value']
project_arn = outputs['project_arn']['value']

codebuild = boto3.client('codebuild')

build = codebuild.start_build(
    projectName=project_name,
    sourceTypeOverride='NO_SOURCE',
    artifactsOverride={ 'type': 'NO_ARTIFACTS' }
)['build']

build_id = build['id']

# doesn't seem to be a waiter available: https://stackoverflow.com/a/53784522

success = None

counter = 0
while counter < 60:
    build = codebuild.batch_get_builds(ids=[ build_id ])['builds'][0]
    status = build['buildStatus']

    if status == 'SUCCEEDED':
        success = True
        break
    elif status in ('FAILED', 'FAULT', 'STOPPED', 'TIMED_OUT'):
        success = False
        break
    now = datetime.datetime.now().strftime('%H:%M:%S')
    print(f'build status {status} {now}, waiting...', file=sys.stderr)
    time.sleep(10)
    counter = counter + 1

if success is None:
    assert False, 'timed out'

assert success, 'build failure'

log_group, log_stream = re.search(
    ':log-group:(.+):log-stream:(.+)$',
    build['logs']['cloudWatchLogsArn']
).groups()

logs = boto3.client('logs')
build_log = ''.join([
    event['message']
    for event
    in logs.get_log_events(logGroupName=log_group, logStreamName=log_stream)['events']
])

assert '\nhello world\n' in build_log, 'simple message'
assert ':assumed-role/build-role' in build_log, 'assumed role'

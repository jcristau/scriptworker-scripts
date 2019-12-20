#!/bin/bash
set -o errexit -o pipefail

test_var_set() {
  local varname=$1

  if [[ -z "${!varname}" ]]; then
    echo "error: ${varname} is not set"
    exit 1
  fi
}

case $COT_PRODUCT in
  firefox|mobile)
    export TASKCLUSTER_SCOPE_PREFIX="project:releng:ship-it:"
    ;;
  thunderbird)
    export TASKCLUSTER_SCOPE_PREFIX="project:comm:thunderbird:releng:ship-it:"
    ;;
  *)
    exit 1
    ;;
esac


case $ENV in
  dev|fake-prod)
    export API_ROOT_V2="https://api.shipit.staging.mozilla-releng.net"
    export TASKCLUSTER_SCOPE="${TASKCLUSTER_SCOPE_PREFIX}server:staging"
    ;;
  prod)
    export API_ROOT_V2="https://shipit-api.mozilla-releng.net"
    export TASKCLUSTER_SCOPE="${TASKCLUSTER_SCOPE_PREFIX}server:production"
    ;;
  *)
    exit 1
    ;;
esac


export MARK_AS_SHIPPED_SCHEMA_FILE="/app/shipitscript/src/shipitscript/data/mark_as_shipped_task_schema.json"
export CREATE_NEW_RELEASE_SCHEMA_FILE="/app/shipitscript/src/shipitscript/data/create_new_release_task_schema.json"

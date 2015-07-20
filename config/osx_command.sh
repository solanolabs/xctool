#!/bin/bash

set -e
set -x # Useful for debugging

# Load any needed environment variables
source solano-env-set.sh 

# Run arbitrary command on osx worker
# `source /etc/profile` since full $PATH may be needed, even though it is a non-interactive shell
# `source $OSX_REMOTE_DIR/osx-env-set.sh loads env vars that might be needed for the command
echo "Running on OS X: $@"
ssh -A $OSX_HOST -p $OSX_SSH_PORT "source /etc/profile && cd $OSX_REMOTE_DIR && source osx-env-set.sh && $@"


#!/bin/bash

set -e
set -x # Useful for debugging

# Load extra environment variables
source solano-env-set.sh 

# Start secondary sshd
ssh -A $OSX_HOST -p $OSX_SSH_PORT "launchctl load -wF $OSX_REMOTE_DIR/.solano-ssh/com.solanolabs.custom_sshd.plist"

sleep 5 # Give the secondary sshd time to start

# Run test on osx worker
# `source /etc/profile` since full $PATH may be needed, even though it is a non-interactive shell
# `source $OSX_REMOTE_DIR/osx-env-set.sh loads env vars that might be needed for the command

function post_test {
  # Stop secondary sshd
  ssh -A $OSX_HOST -p $OSX_SSH_PORT "launchctl unload $OSX_REMOTE_DIR/.solano-ssh/com.solanolabs.custom_sshd.plist"

  # Collect log and attach it to the test results 
  scp -P $OSX_SSH_PORT $OSX_HOST:$OSX_REMOTE_DIR/osx-$TDDIUM_TEST_EXEC_ID.log $HOME/results/$TDDIUM_SESSION_ID/$TDDIUM_TEST_EXEC_ID/
}

echo "Running on OS X: $@"
echo "Test results saved to osx-$TDDIUM_TEST_EXEC_ID.log"

trap post_test EXIT

ssh -A $OSX_HOST -p $SOLANO_SSH_PORT "source /etc/profile && cd $OSX_REMOTE_DIR && source osx-env-set.sh && $@ 2>&1 > osx-$TDDIUM_TEST_EXEC_ID.log"


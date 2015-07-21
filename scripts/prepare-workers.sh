#!/bin/bash

set -e
set -x # Useful for debugging

# Solano CI pre_setup hook
# Runs once on the Solano master after repository is checked out and dependencies are installed.

# Get the remote path
OSX_REMOTE_HOME=`ssh -A $OSX_HOST -p $OSX_SSH_PORT 'echo \$HOME'`
repo_name=`basename $TDDIUM_REPO_ROOT`
OSX_REMOTE_DIR=$OSX_REMOTE_HOME/SolanoCI/$repo_name/$TDDIUM_CURRENT_BRANCH

# Ensure the remote directory exists
ssh -A $OSX_HOST -p $OSX_SSH_PORT "mkdir -p $OSX_REMOTE_DIR"

# Create osx-env-set.sh for OSX worker usage
echo "#!/bin/bash" > osx-env-set.sh
echo "# Sets local environment variables on OS X" >> osx-env-set.sh
echo "export TDDIUM=1" >> osx-env-set.sh
echo "export TDDIUM_REPO_ROOT=$OSX_REMOTE_DIR" >> osx-env-set.sh
echo "export TDDIUM_REPO_CONFIG_DIR=$OSX_REMOTE_DIR/config" >> osx-env-set.sh
echo "export TDDIUM_CURRENT_BRANCH=$TDDIUM_CURRENT_BRANCH" >> osx-env-set.sh
echo "export TDDIUM_CURRENT_COMMIT=$TDDIUM_CURRENT_COMMIT" >> osx-env-set.sh
echo "export TDDIUM_TID=$TDDIUM_TID" >> osx-env-set.sh
echo "export TDDIUM_SESSION_ID=$TDDIUM_SESSION_ID" >> osx-env-set.sh
echo "export SOLANO_PROFILE_NAME=$SOLANO_PROFILE_NAME" >> osx-env-set.sh

# Only potentially used if pull requests are built
echo "export TDDIUM_PR_REPO=$TDDIUM_PR_REPO" >> osx-env-set.sh
echo "export TDDIUM_PR_ID=$TDDIUM_PR_ID" >> osx-env-set.sh
echo "export TDDIUM_PR_URL=\"$TDDIUM_PR_URL\"" >> osx-env-set.sh
echo "export TDDIUM_PR_BRANCH=$TDDIUM_PR_BRANCH" >> osx-env-set.sh
echo "export TDDIUM_PR_COMMIT=$TDDIUM_PR_COMMIT" >> osx-env-set.sh
echo "export TDDIUM_LAST_BRANCH_PASSED_SESSION_ID=$TDDIUM_LAST_BRANCH_PASSED_SESSION_ID" >> osx-env-set.sh

# Secondary SSH port if iOS simulator tests are needed
if [ -n "$SOLANO_SSH_PORT" ]; then
  echo "export SOLANO_SSH_PORT=\"$SOLANO_SSH_PORT\"" >> osx-env-set.sh
fi

chmod +x osx-env-set.sh

# Setup solano-ssh for simulator usage (see README in config/solano-sshd)
./config/solano-sshd/setup.sh $OSX_REMOTE_DIR

# Collect relevant ~/.ssh/known_hosts entries
grep -v ^"localhost" $HOME/.ssh/known_hosts | grep -v ^"127.0.0.1" > .solano-known_hosts

# Sync files from linux worker to OSX worker (--delete to ensure a clean workspace)
rsync -az --delete -e "ssh -p $OSX_SSH_PORT" ./ $USER@$OSX_HOST:$OSX_REMOTE_DIR

# Create solano-env-set.sh for linux worker usage
echo "#!/bin/bash" > solano-env-set.sh
echo "# Sets additional local environment variables on Solano CI" >> solano-env-set.sh
echo "export OSX_REMOTE_HOME=$OSX_REMOTE_HOME" >> solano-env.set.sh
echo "export OSX_REMOTE_DIR=$OSX_REMOTE_DIR" >> solano-env-set.sh
chmod +x solano-env-set.sh


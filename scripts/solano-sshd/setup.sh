#!/bin/bash
# Setup solano-ssh (see README)

set -e
set -x # Useful for debugging

if [ -z "$SOLANO_SSH_PORT" ]; then
  SOLANO_SSH_PORT=2222
fi

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

mkdir -p $TDDIUM_REPO_ROOT/.solano-ssh
chmod 700 $TDDIUM_REPO_ROOT/.solano-ssh

# Copy authorized_keys
cp $HOME/.ssh/authorized_keys $TDDIUM_REPO_ROOT/.solano-ssh/authorized_keys
chmod 600 $TDDIUM_REPO_ROOT/.solano-ssh/authorized_keys

# Set paths/ports 
sed "s#__REPO_ROOT__#$1#g" $DIR/com.solanolabs.custom_sshd.plist > $TDDIUM_REPO_ROOT/.solano-ssh/com.solanolabs.custom_sshd.plist
sed "s#__SOLANO_SSH_PORT__#$SOLANO_SSH_PORT#g" $DIR/sshd.sh | \
  sed "s#__SOLANO_SSH_PATH__#$1/.solano-ssh#g" > \
  $TDDIUM_REPO_ROOT/.solano-ssh/sshd.sh
chmod +x $TDDIUM_REPO_ROOT/.solano-ssh/sshd.sh

# Create host keys
$(cd $TDDIUM_REPO_ROOT/.solano-ssh && ssh-keygen -q -t rsa -f solano_sshd_host_key_rsa -N "" -C "" < /dev/null > /dev/null 2> /dev/null)
$(cd $TDDIUM_REPO_ROOT/.solano-ssh && ssh-keygen -q -t rsa1 -f solano_sshd_host_key_rsa1 -N "" -C "" < /dev/null > /dev/null 2> /dev/null)
$(cd $TDDIUM_REPO_ROOT/.solano-ssh && ssh-keygen -q -t dsa -f solano_sshd_host_key_dsa -N "" -C "" < /dev/null > /dev/null 2> /dev/null)




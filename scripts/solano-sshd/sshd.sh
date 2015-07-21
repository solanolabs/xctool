#!/bin/bash

# Solano Labs custom sshd
# Allows connecting to this worker through a LaunchAgent context (default OS X is LaunchDaemon)

/usr/sbin/sshd -D \
  -p __SOLANO_SSH_PORT__ \
  -h __SOLANO_SSH_PATH__/solano_sshd_host_key_rsa \
  -h __SOLANO_SSH_PATH__/solano_sshd_host_key_rsa1 \
  -h __SOLANO_SSH_PATH__/solano_sshd_host_key_dsa \
  -o UsePam=yes \
  -o Protocol=1,2 \
  -o PubkeyAuthentication=yes \
  -o RSAAuthentication=yes \
  -o AuthorizedKeysFile=__SOLANO_SSH_PATH__/authorized_keys \
  -o PidFile=__SOLANO_SSH_PATH__/sshd.pid

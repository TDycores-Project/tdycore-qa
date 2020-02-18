#!/bin/bash

echo -e $PRIVATE_SSH_KEY >> /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa
echo 'transfering tarball'
scp -P 2222 -oStrictHostKeyChecking=no /tmp/tdycore.tar.gz pflotran@108.167.189.107:~



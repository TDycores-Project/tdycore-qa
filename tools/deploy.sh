#!/bin/bash

echo 'beginning deployment'

echo 'setting up ssh'
echo -e $PRIVATE_SSH_KEY >> /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa
echo 'transfering tarball'
scp -P 2222 -oStrictHostKeyChecking=no /tmp/tdycore.tar.gz pflotran@108.167.189.107:~
exit_status=$?
if [ $exit_status -eq 0 ]; then
  echo 'transfer successful'
  echo 'extracting tarball'
  ssh -p 2222 -oStrictHostKeyChecking=no pflotran@108.167.189.107 "/bin/rm -Rf public_html/tdycore/* && tar -xzvf tdycore.tar.gz -C public_html/tdycore/. && /bin/rm tdycore.tar.gz"
  exit_status=$?
  if [ $exit_status -eq 0 ]; then
    echo 'extraction successful'
    echo 'successful deployment'
  else
    echo 'extraction failed'
  fi
else
  echo 'transfer failed'
fi
exit $exit_status


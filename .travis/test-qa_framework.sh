#!/bin/sh

git clone git@github.com:TDycores-Project/qa-toolbox.git
make all QA_TOOLBOX_DIR=./qa_toolbox

EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ]; then
  echo "QA Framework tests failed" >&2
  exit 1
else
  echo "QA Framework tests succeeded" >&2
  exit 0
fi



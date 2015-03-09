#!/bin/bash

C=2
GREP='.'
if [ $# -eq 1 ]
then
C=$1
GREP='WORKS'
fi

./wiki-tests.sh Pending bg mk  | grep -C $C "$GREP"

echo ""

./wiki-tests.sh Pending mk bg  | grep -C $C "$GREP"



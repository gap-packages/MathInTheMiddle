#!/usr/bin/env bash
set -ex

GAPROOT=${GAPROOT-$HOME/gap}
COVDIR=${COVDIR-coverage}

# start GAP with custom GAP root, to ensure correct package version is loaded
GAP="$GAPROOT/bin/gap.sh -l $PWD/gaproot; --quitonbreak"

# TODO: As soon as coverage for forking stuff works, we should be forking
#       inside a tst file.
sudo pip install --upgrade pip
pip install --user openmath
pip install --user scscp

mkdir -p $COVDIR

echo "Starting GAP Server"
$GAP --cover $COVDIR/test-server.coverage -q -A tst/scscp/server.g --nointeract &
sleep 5
echo "Testing GAP SCSCP Client"
$GAP --cover $COVDIR/test-client.coverage -q -A tst/scscp/client.g --nointeract
echo "Testing GAP MitM Client"
$GAP --cover $COVDIR/test-mitm-client.coverage -q -A tst/scscp/mitm-client.g --nointeract
echo "Testing Python Client"
python tst/scscp/client.py
echo "Quitting Server"
$GAP -A tst/scscp/quit.g --nointeract
kill %%

exit 0

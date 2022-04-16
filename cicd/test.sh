#!/bin/bash
# ------------------------------------------------------------------------
set -eux

yell() { echo "$0: $*" >&2; }
die() { yell "$*"; exit 111; }
try() { "$@" || die "cannot $*"; }


#
# Run all commands from the repository root!
# (That's the directory above the current one :)
# ------------------------------------------------------------------------
#
SCRIPT_PATH="${BASH_SOURCE[0]}"
if ([ -h "${SCRIPT_PATH}" ]); then
  while([ -h "${SCRIPT_PATH}" ]); do cd "$(dirname "$SCRIPT_PATH")";
  SCRIPT_PATH=$(readlink "${SCRIPT_PATH}"); done
fi
cd "$(dirname ${SCRIPT_PATH})" > /dev/null
cd ..

export VERSION=${GITHUB_REF##*/v}
echo ${VERSION}


#
# Check which env variables are defined
# ------------------------------------------------------------------------
printenv


#
# Create some dummy artifacts
# ------------------------------------------------------------------------

mkdir -p artifacts
rm -f artifacts/*.*

echo "Hello" > artifacts/something-${VERSION}.zip
echo "World" > artifacts/another-${VERSION}.zip
ls -al artifacts


#
# Release
# ------------------------------------------------------------------------

hub release create v${VERSION} --message="Release v${VERSION}" \
   -a artifacts/something-${VERSION}.zip
   -a artifacts/another-${VERSION}.zip

# eof

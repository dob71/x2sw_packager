#!/bin/bash

MSGFILE="/tmp/movetag_$$.txt"
EDITOR=vi

if [ "$1" == "" ] || [ "$2" == "" ]; then
   echo "Usage: $0 <commit_from> <commit_to>"
   echo "Moves existent tag from one commit to another locally and in origin."
   exit 1
fi

THETAG=`git describe --exact-match $1`
if [ $? -ne 0 ]; then
  echo "Commit '$1' has no tag pointing to it."
  exit 2
fi                            

git tag -n100 -l $1 | sed -e "s~^\($THETAG\)\? *~~" > $MSGFILE
if [ $? -ne 0 ]; then
  echo "Failed to retriev the tag '$THETAG' message."
  exit 3
fi                            

$EDITOR $MSGFILE
if [ $? -ne 0 ] || [ ! -s "$MSGFILE" ]; then
  echo "The message file '$MSGFILE' is either empty or editor has failed."
  exit 4
fi                            

git tag -d $THETAG
git tag -a -F $MSGFILE $THETAG $2
if [ $? -ne 0 ]; then
  echo "Failed to move tag '$THETAG' to '$2', aborting."
  exit 5
fi                            

git push origin :refs/tags/$THETAG
if [ $? -ne 0 ]; then
  echo "Failed to remove tag '$THETAG' on the remote, aborting."
  echo "Note: it was moved locally."
  exit 6
fi                            

git push origin $THETAG


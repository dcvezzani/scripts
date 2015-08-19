#!/bin/sh
# kudos: http://alvinabad.wordpress.com/2013/03/23/how-to-specify-an-ssh-key-file-with-the-git-command/

if [ -z "$PKEY" ]; then
# if PKEY is not specified, run ssh using default keyfile
ssh "$@"
else
ssh -i "$PKEY" "$@"
fi

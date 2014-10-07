#! /bin/bash
# Apply dynamic patches to support programming N64 with GameShark
# This file is executed from inside the libdragon source tree directory

# This file is wget from the main build script so that any changes made
# will be updated without updating the main script. This should basically
# sit inside of the libdragon folder before it is built, and get/copy/etc
# any file over the libdragon source tree in order to create a working
# GameShark programming environment. -ppcasm

echo "Applying GameShark development related patches to libdragon source tree"

# Get patches from Github
wget -c https://raw.githubusercontent.com/ppcasm/gsdevkit/master/drgnpatch/entr$
wget -c  https://raw.githubusercontent.com/ppcasm/gsdevkit/master/drgnpatch/ent$

cp -a entrypoint.S ./src
cp -a entrypoint_2.S ./src


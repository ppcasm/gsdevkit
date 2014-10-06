#! /bin/bash
# Nintendo64 GameShark DevKit install script by ppcasm. (10-5-2014)

# Based off of install script by Shaun Taylor
# GSUploader by HCS
# Libdragon by Dragonminded
# Tested working on Ubuntu 14.04 x86_64

# This build script will build a cross compile toolchain targeted
# for MIPS vr4300, as well as various other tools to assist in the development
# of homebrew for N64 utilizing a GameShark Pro with a parallel port (ex v3.3)

# A list of these tools include:
# gsuploader (Parallel-Port and USB Versions)
# libdragon with diff patches for gameshark specific functionality

u="$USER"
if (( EUID ==0 )); then
     echo "Do not start this script as root"
     exit -1;
fi

sudo bash <<"EOF"
(( EUID )) && { echo 'Could not get root priviliges.'; exit 1; } || echo 'Running as root, starting service...'

# If NOT on a Debian based OS, comment the lines below

# Dependencies:
sudo apt-get install build-essential
sudo apt-get install git
sudo apt-get install libusb-1.0-0-dev
sudo apt-get install libgmp-dev
sudo apt-get install libmpfr-dev
sudo apt-get install libmpc-dev
sudo apt-get install texinfo
sudo apt-get install gcc-multilib
sudo apt-get install g++-multilib
sudo apt-get install zlib1g-dev
sudo apt-get install libncurses5-dev

# EDIT THIS LINE TO CHANGE YOUR INSTALL PATH!
export INSTALL_PATH=/usr/mips64-elf

# Set up path for newlib to compile later
export PATH=$PATH:$INSTALL_PATH/bin

# Versions - Current Stable as of 10/5/2014
export BINUTILS_V=2.24.51
export GCC_V=4.9.1
export NEWLIB_V=2.1.0

# Download stage
wget -c ftp://sourceware.org/pub/binutils/snapshots/binutils-$BINUTILS_V.tar.bz2
wget -c http://mirror.anl.gov/pub/gnu/gcc/gcc-$GCC_V/gcc-$GCC_V.tar.gz
wget -c ftp://sources.redhat.com/pub/newlib/newlib-$NEWLIB_V.tar.gz

# libdragon
mkdir -p libdragon
rm -rf libdragon
git clone https://github.com/DragonMinded/libdragon.git

# gsuploader (USB)
mkdir -p gs_libusb
rm -rf gs_libusb
git clone https://github.com/hcs64/gs_libusb.git

# Extract stage
echo Extracting Binutils...
tar -xjf binutils-$BINUTILS_V.tar.bz2
echo Extracting GCC...
tar -xzf gcc-$GCC_V.tar.gz
echo Extracting Newlib...
tar -xzf newlib-$NEWLIB_V.tar.gz

# Binutils and newlib support compiling in source directory, GCC does not
mkdir -p gcc_compile

# Compile binutils
cd binutils-$BINUTILS_V
./configure --prefix=${INSTALL_PATH} --target=mips64-elf --with-cpu=mips64vr4300 --disable-werror
make
make install || sudo make install || su -c "make install"

# Compile gcc (pass 1)
cd ../gcc_compile
../gcc-$GCC_V/configure --prefix=${INSTALL_PATH} --target=mips64-elf --enable-languages=c --without-headers --with-gnu-ld --with-gnu-as --with-system-zlib --disable-shared --disable-threads --disable-libmudflap --disable-libgomp --disable-libssp --disable-libquadmath --disable-libatomic
make
make install || sudo make install || su -c "make install"

# Compile newlib
cd ../newlib-$NEWLIB_V
CFLAGS="-O2" CXXFLAGS="-O2" ./configure --target=mips64-elf --prefix=${INSTALL_PATH} --with-cpu=mips64vr4300 --disable-threads --disable-libssp  --disable-werror
make
make install || sudo env PATH="$PATH" make install || su -c "env PATH=$PATH make install"

# Compile gcc (pass 2)
cd ..
rm -rf gcc_compile
mkdir gcc_compile
cd gcc_compile
CFLAGS_FOR_TARGET="-G0 -O2" CXXFLAGS_FOR_TARGET="-G0 -O2" ../gcc-$GCC_V/configure --prefix=${INSTALL_PATH} --target=mips64-elf --enable-languages=c,c++ --with-newlib --with-gnu-ld --with-gnu-as --enable-multilib --disable-shared --disable-threads --disable-libmudflap --disable-libgomp --disable-libssp --disable-libquadmath --disable-libatomic
make
make install || sudo make install || su -c "make install"

# Apply GameShark diff patches and build libdragon
cd ..
cd ./libdragon/
# Get and execute libdragon GameShark patch script from GitHub
wget -c https://github.com/ppcasm/gsdevkit/blob/master/drgnpatch/patchdrgn.sh
chmod a+x patchdrgn.sh
./patchdrgn.sh
export N64_INST=/usr/mips64-elf
make
export N64_INST=/usr/mips64-elf/mips64-elf
make install || sudo make install || su -c "make install"
export N64_INST=/usr/mips64-elf
cd ..

# Patch some tools we don't need
echo Patching n64tool...
echo "echo N64Tool not need for GameShark programming!" >> n64tool
chmod a+x n64tool
mv n64tool /usr/mips64-elf/bin/

echo Patching chksum64...
echo "echo CHKSUM64 not needed for GameShark programming!" >> chksum64
chmod a+x chksum64
mv chksum64 /usr/mips64-elf/bin/

# Build gsuploader
cd ./gs_libusb
make
cp ./gsuploader/gsuploader /usr/bin/
cd ..

# Do a lazy sanity check on build
if [ -f /usr/bin/gsuploader ]
then
     echo "gsuploader seems to be working"
else
     echo "gsuploader not installed - something went wrong?"
     EOF
     exit
fi

if [ -f /usr/mips64-elf/bin/mips64-elf-gcc ]
then
     echo "mips64-elf-gcc seems to be working"
else
     echo "mips64-elf-gcc not installed - something went wrong?"
     EOF
     exit
fi

if [ -f /usr/mips64-elf/mips64-elf/lib/libdragon.a ]
then
     echo "libdragon seems to be working"
else
     echo "libdragon not installed - something went wrong?"
     EOF
     exit
fi

# If we got this far then we should be okay to clean up
find . -type f ! -wholename $0 -delete && find . -type d ! -wholename $0 -delete

# Get back to normal user
EOF

# Get libdragon examples only
git clone https://github.com/DragonMinded/libdragon.git
cd ./libdragon/
cp -r ./examples/ ../
cd ..
rm -rf libdragon/
export N64_INST=/usr/mips64-elf

# Set up environment vars
echo "Adding toolchain environment variables for user" $u
echo "export N64_INST=/usr/mips64-elf" >> ~/.bashrc

echo "DONE! You should have a working environment!"

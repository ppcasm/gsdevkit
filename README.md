gsdevkit
========

Nintendo64 GameShark DevKit install script (MUST READ)

WARNING: I've only tested this on a system running a fresh install of Ubuntu 14.04LTS and I've certainly not tested 
every possible scenario that could happen with this script. It runs under root for a period of time as well, so I can't be held responsible for any loss of data. Make sure you have appropriate backups before attempting to use this script. You've been warned. 

Now, with that out of the way...

Q: What is gsdevkit?

A: gsdevkit is a buildscript that pulls together multiple tools to assist in the development of N64 homebrew using nothing more than a parallel port enabled gameshark, a memory expansion pack, and a USB adapter (more on this later.)

The tools:

  The tools consist of gsuploader, which was written by HCS ( http://www.hcs64.com ) and libdragon ( www.dragonminded.com ) as well as other various tools.
  
  There exists a parallel port version of gsuploader in my repository @ https://github.com/ppcasm/gsuploader and it's possible this could work for you with this buildscript by building the source seperate, and then copying the binary to the appropriate place, but the best means by far is to pick up a MOSCHIP 7705 based USB to parallel port adapter and use it with the gs_libusb version of gsuploader. As such, since the version in my repository is deprecated as far as I'm concerned, I don't include it in the buildscript.

Q: I really like NES... Do you like NES?

A: YES! Which his exactly why I've made the buildscript copy out the examples from HCS's gsuploader, which include neon64gs.bin which is an NES emulator written by HCS himself!!! It works great, all you have to do is after the buildscript is finished executing type in sudo gsuploader /usr/bin/neon64gs.bin /path/to/rom and voila... NES on N64! :D There is even an NES demo rom included that you can access by typing in sudo gsuploader /usr/bin/neon64gs.bin /usr/bin/flames.bin as well as a few other demos. 

Q: How do I run this script?

A: Very simple. Copy the build.sh script anywhere on your system, or even run it from place by typing something along the lines of ./build.sh and then it'll ask for your root password and after that it takes a long while but everything should be automated and you should end up with a message letting you know when it's finished. At that point you should have a complete and ready toolchain to start programming for N64 using a GameShark! 

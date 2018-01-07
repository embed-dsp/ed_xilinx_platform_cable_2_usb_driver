
Compile and Install of Xilinx Platform Cable II USB Driver for Linux
====================================================================

FIXME: iMPACT: Platform Cable USB II

emulates Jungo Windrvr USB and parallel port functions in userspace 
which are required by XILINX impact to access 
the Platform cable USB and Parallel Cable III.

[Link](http://www.rmdir.de/~michael/xilinx)

Prerequisites
=============

## Fedora-27
```bash
# Used by /etc/udev/rules.d/xusbdfwu.rules to download firmware to USB device.
dnf install fxload.x86_64

# For building 64-bit version of USB Driver
dnf install libusb.x86_64
dnf install libusb-devel.x86_64

# For building 32-bit version of USB Driver
dnf install libusb.i686
dnf install libusb-devel.i686
```

Get Source Code
===============

## ed_xilinx_platform_cable_2_usb_driver
```bash
git clone https://github.com/embed-dsp/ed_xilinx_platform_cable_2_usb_driver.git
```

## USB Driver
```bash
# Enter the ed_xilinx_platform_cable_2_usb_driver directory.
cd ed_xilinx_platform_cable_2_usb_driver

# Clone the USB Driver git repository.
make clone

# Pull latest updates from the USB Driver git repository.
make pull

# Edit the Makefile for selecting the Xilinx installation directory.
vim Makefile
XILINX = /opt/Xilinx/14.7
```

Build
=====
```bash
# Checkout specific version and rebuild configure.
make prepare

# Compile 64-bit version (Default: M=64)
make compile
make compile M=64

# Compile 32-bit version.
make compile M=32
```

Install
=======
```bash
# Install 64-bit build products (Default: M=64)
sudo make install
sudo make install M=64

# Install 32-bit build products.
sudo make install M=32
```

Uninstall
=========
```bash
# Uninstall 64-bit build products (Default: M=64)
sudo make uninstall
sudo make uninstall M=64

# Uninstall 32-bit build products.
sudo make uninstall M=32
```

The build products are installed in the following locations:
```bash
FIXME: ...
```

Notes
=====

This has been testes with the following Linux distributions and compilers:
* `Fedora-27 (64-bit)` and `gcc-7.2.1`

FIXME: ...
```bash
# ...
export LD_PRELOAD=/usr/local/lib64/libusb-driver.so

# ...
export LD_PRELOAD=/usr/local/lib/libusb-driver.so
```

FIXME: iMPACT Clean Cable Lock
```bash
# ...
impact -batch impact/clean_cable_lock.cmd
```

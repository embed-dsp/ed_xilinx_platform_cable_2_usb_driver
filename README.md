
# Compile and Install of Xilinx Platform Cable II USB Driver for Linux

When using XILINX JTAG software like Impact, Chipscope and XMD on Linux, 
the proprietary kernel module **windrvr** from **Jungo** is needed to access the 
parallel- or usb-cable.
As this module does not work with current linux kernel versions (> **2.6.18**) 
a library was developed, which emulates the module in userspace and allows the 
tools to access the JTAG cable without the need for a proprietary kernel module.
This is described [here](http://www.rmdir.de/~michael/xilinx).


# Prerequisites

## Fedora-27 64-bit
```bash
dnf install gcc-c++

# Used by /etc/udev/rules.d/xusbdfwu.rules to download firmware to USB device.
dnf install fxload

# For building 64-bit version of the Xilinx Platform Cable II USB Driver
dnf install libusb
dnf install libusb-devel

# For building 32-bit version of the Xilinx Platform Cable II USB Driver
dnf install libusb.i686
dnf install libusb-devel.i686
```


# Get Source Code

## ed_xilinx_platform_cable_2_usb_driver
```bash
git clone https://github.com/embed-dsp/ed_xilinx_platform_cable_2_usb_driver.git
```

## USB Driver
```bash
# Enter the ed_xilinx_platform_cable_2_usb_driver directory.
cd ed_xilinx_platform_cable_2_usb_driver

# FIXME: Only first time
# Clone the USB Driver git repository.
make clone

# FIXME: Any other time
# Pull latest updates from the USB Driver git repository.
make pull
```

```bash
# Edit the Makefile for selecting the Xilinx installation directory.
vim Makefile
XILINX = /opt/Xilinx/14.7
```


# Build

```bash
# Checkout specific version and rebuild configure.
make prepare
```

```bash
# Compile 64-bit version (Default: M=64)
make compile
make compile M=64

# Compile 32-bit version.
make compile M=32
```


# Install

```bash
# Install 64-bit build products (Default: M=64)
sudo make install
sudo make install M=64

# Install 32-bit build products.
sudo make install M=32
```

The build products are installed in the following locations:

```bash
usr/
└── local/
    ├── lib64/
    |   └── libusb-driver.so    # 64-bit USB driver
    └── lib/
        └── libusb-driver.so    # 32-bit USB driver

usr/
└── share/                      # Xilinx firmware
    ├── xusbdfwu.hex
    ├── xusb_emb.hex
    ├── xusb_xlp.hex
    ├── xusb_xp2.hex
    ├── xusb_xpr.hex
    ├── xusb_xse.hex
    └── xusb_xup.hex

etc/
└── udev/
    └── rules.d/
        ├── libusb-driver.rules # usb-driver udev rules
        └── xusbdfwu.rules      # Xilinx udev rules
```

# Uninstall

```bash
# Uninstall 64-bit build products (Default: M=64)
sudo make uninstall
sudo make uninstall M=64

# Uninstall 32-bit build products.
sudo make uninstall M=32
```


# Functional Check

## Status LED

If everything is working as expected after installing the USB driver then the
Status LED on the **Xilinx Platform Cable II** unit should light up when 
connected with a USB cable to the computer.

## Kernel Message Buffer

If things are working as expected:
```bash
# Display kernel message buffer
dmesg

# The output should be something like this ...
[16770.468654] usb 1-1: new high-speed USB device number 8 using ehci-pci
[16770.597715] usb 1-1: New USB device found, idVendor=03fd, idProduct=0013
[16770.597717] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[16770.635750] usb 1-1: USB disconnect, device number 8
[16772.634762] usb 3-1: new full-speed USB device number 4 using ohci-pci
[16772.789809] usb 3-1: not running at top speed; connect to a high speed hub
[16772.799799] usb 3-1: New USB device found, idVendor=03fd, idProduct=0008
[16772.799801] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[16772.799803] usb 3-1: Product: XILINX    
[16772.799804] usb 3-1: Manufacturer: XILINX
```

If things are **NOT** working as expected:
```bash
# Display kernel message buffer
dmesg

# The output should be something like this ...
[17544.539381] usb 1-1: new high-speed USB device number 12 using ehci-pci
[17544.668515] usb 1-1: New USB device found, idVendor=03fd, idProduct=0013
[17544.668517] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
```

## USB Device List

If things are working as expected:
```bash
# List USB devices
lsusb

# The output list should contain a line like this ...
Bus 001 Device 010: ID 03fd:0008 Xilinx, Inc. Platform Cable USB II
```

If things are **NOT** working as expected:
```bash
# List USB devices
lsusb

# The output list should contain a line like this ...
Bus 001 Device 012: ID 03fd:0013 Xilinx, Inc.
```


# Usage

## Start Xilinx impact tool

To use this library you have to preload the library before starting the
Xilinx **impact** tool.

### 64-bit Installation

Start **impact** like this:
```bash
LD_PRELOAD=/usr/local/lib64/libusb-driver.so impact
```

or like this:
```bash
export LD_PRELOAD=/usr/local/lib64/libusb-driver.so
impact
```

### 32-bit Installation

Start **impact** like this:
```bash
LD_PRELOAD=/usr/local/lib/libusb-driver.so impact
```

or like this:
```bash
export LD_PRELOAD=/usr/local/lib/libusb-driver.so
impact
```

## Clean Cable Lock

If you get the message '**The cable is being used by another application.**'
from impact, try running the following command:

```bash
impact -batch impact/clean_cable_lock.cmd
```


# Notes

This has been testes with the following Linux distributions and compilers:
* `Fedora-27 (64-bit)`
    * `gcc-7.2.1`
    * `gcc-7.3.1`

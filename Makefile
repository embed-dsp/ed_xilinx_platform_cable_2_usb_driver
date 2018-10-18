
# Copyright (c) 2018 embed-dsp
# All Rights Reserved

# $Author:   Gudmundur Bogason <gb@embed-dsp.com> $
# $Date:     $
# $Revision: $


# Xilinx installation directory.
XILINX = /opt/Xilinx/14.7

# USB Driver.
PACKAGE_NAME = usb-driver
PACKAGE_VERSION = master
PACKAGE = $(PACKAGE_NAME)-$(PACKAGE_VERSION)

# ==============================================================================

# Compiler.
CC = /usr/bin/gcc

# Build for 32-bit or 64-bit (Default)
ifeq ($(M),)
	M = 64
endif

ifeq ($(M), 64)
	XILINX_XUSB = $(XILINX)/ISE_DS/ISE/bin/lin64
	CFLAGS = -Wall -O2 -m64 -fPIC
	LINKFLAGS = -m64 -shared
	LIBDIR = /usr/local/lib64
else
	XILINX_XUSB = $(XILINX)/ISE_DS/ISE/bin/lin
	CFLAGS = -Wall -O2 -m32 -fPIC
	LINKFLAGS = -m32 -shared
	LIBDIR = /usr/local/lib
endif

CPPDEFINES = -DUSB_DRIVER_VERSION=\"$(PACKAGE_VERSION)\"
LIBS = -ldl -lusb -lpthread

SRC = usb-driver.c xpcu.c parport.c config.c jtagmon.c
OBJ = usb-driver.o xpcu.o parport.o config.o jtagmon.o


all:
	@echo "XILINX_XUSB = $(XILINX_XUSB)"
	@echo ""
	@echo "## Get Source Code"
	@echo "make clone"
	@echo "make pull"
	@echo ""
	@echo "## Build"
	@echo "make prepare"
	@echo "make compile [M=...]"
	@echo ""
	@echo "## Install"
	@echo "sudo make install [M=...]"
	@echo ""
	@echo "## Uninstall"
	@echo "sudo make uninstall [M=...]"
	@echo ""
	@echo "## Cleanup"
	@echo "make clean"
	@echo ""


.PHONY: clone
clone:
	git clone git://git.zerfleddert.de/usb-driver


.PHONY: pull
pull:
	# Discard any local changes
	cd $(PACKAGE_NAME) && git checkout -- .
	
	# Checkout master branch
	cd $(PACKAGE_NAME) && git checkout master
	
	# ...
	cd $(PACKAGE_NAME) && git pull


.PHONY: prepare
prepare:
	# Checkout specific version
	cd $(PACKAGE_NAME) && git checkout $(PACKAGE_VERSION)


.PHONY: compile
compile:
	# Compile
	cd $(PACKAGE_NAME) && $(CC) $(CFLAGS) $(CPPDEFINES) -c $(SRC)
	# Link
	cd $(PACKAGE_NAME) && $(CC) $(LINKFLAGS) $(OBJ) $(LIBS) -o libusb-driver.so


.PHONY: install
install:
	# Install usb-driver
	cp $(PACKAGE_NAME)/libusb-driver.so $(LIBDIR)

	# Install Xilinx firmware.
	cp $(XILINX_XUSB)/xusb*.hex /usr/share

	# Update and install Xilinx udev rules.
	sed -e 's/BUS/SUBSYSTEMS/' -e 's/SYSFS/ATTRS/g' -e 's/TEMPNODE/tempnode/' $(XILINX_XUSB)/xusbdfwu.rules > /etc/udev/rules.d/xusbdfwu.rules

	# Install usb-driver udev rules.
	cp etc/udev/rules.d/libusb-driver.rules /etc/udev/rules.d

	# Reload udev rules.
	udevadm control --reload-rules


.PHONY: uninstall
uninstall:
	# Remove usb-driver
	-rm -f $(LIBDIR)/libusb-driver.so

	# Remove Xilinx firmware.
	-rm -rf /usr/share/xusb*.hex

	# Remove Xilinx udev rules.
	-rm -f /etc/udev/rules.d/xusbdfwu.rules

	# Remove usb-driver udev rules.
	-rm -f /etc/udev/rules.d/libusb-driver.rules

	# Reload udev rules.
	udevadm control --reload-rules


.PHONY: clean
clean:
	-cd $(PACKAGE_NAME) && rm *.o
	-cd $(PACKAGE_NAME) && rm libusb-driver.so

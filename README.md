# Final Cartridge III with GEOS

This project replaces the Final Cartridge III "Desktop" UI with the GEOS 2.0 KERNAL.

![](fc3-geos.gif)

* Booting with C= held down will boot into GEOS.
* The BASIC instruction `DESKTOP` will boot into GEOS.

All of bank 2 of the FC3 ROM is occupied by GEOS. This does not include the deskTop file manager, which it then has to load from disk.

## Building

You need to put this repository, the GEOS source and the original FC3 `.CRT` image into the same directory and run build.sh:

	mkdir fc3
	cd fc3
	cp /path/to/Final_Cartridge_3_1988-12.crt .
	git clone https://github.com/mist64/geos
	git clone https://github.com/mist64/fc3-geos
	cd fc3-geos
	./build.sh

`fc3-geos.crt` is the resulting `.CRT` image. `fc3-geos-basic.crt` is a patched version that boots into BASIC instead of GEOS.

By default, the image includes the 1541 disk driver and the joystick input driver. You can change this through the options for the GEOS build. See the README in the `geos` repository for more information.

## Author, License

Michael Steil <mist64@mac.com>, Public Domain.


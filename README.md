# Final Cartridge III with GEOS

This project replaces the Final Cartridge III "Desktop" UI with the GEOS 2.0 KERNAL.

![](fc3-geos.gif)

* Booting with C= held down will boot into GEOS.
* The BASIC instruction `DESKTOP` will boot into GEOS.

It takes about 5 seconds until GEOS initializes. The ROM contents do not include the "deskTop" file manager, which it then has to load from disk.

## Building

You need to put this repository, the GEOS source and the [original FC3 `.CRT` image](http://ar.c64.org/wiki/Final_Cartridge) into the same directory and run build.sh:

	mkdir fc3
	cd fc3
	cp /path/to/Final_Cartridge_3_1988-12.crt .
	git clone https://github.com/mist64/geos
	git clone https://github.com/mist64/fc3-geos
	cd fc3-geos
	./build.sh

`fc3-geos.crt` is the resulting `.CRT` image. `fc3-geos-basic.crt` is a patched version that boots into BASIC instead of GEOS.

By default, the image includes the 1541 disk driver and the joystick input driver. You can change this through the options for the GEOS build. See the README in the `geos` repository for more information.

## Binaries

Binaries are available here: https://www.pagetable.com/?p=1180

## Internals

The inner workings are quite straightforward. The default build of the GEOS repository produces a [pucrunch](https://github.com/mist64/pucrunch)-compressed `PRG` executable that is just below 16 KB. A small loader that copies the ROM contents to $0801 is added to it, and the 16 KB bank 2 of the FC3 ROM are replaced with the resulting data.

During the 5 seconds decompression phase, "BOOTING GEOS ..." is displayed on the screen. An optional codepath in `fc3-geos.s` can instead show the GEOS background pattern during this time.

If the data in ROM was uncompressed, the 5 seconds could be reduced to a quarter second, but this would require more of the FC3 ROM contents to be sacrificed, since the total uncompressed size of the GEOS KERNAL is a little over 20 KB:

| Component        | Size (bytes) |
|------------------|--------------|
| LOKERNAL ($9D80) | 640          |
| KERNAL ($BF40)   | 16192        |
| 1541 driver      | 3339         |
| Input driver     | 384          |

## Author, License

Michael Steil <mist64@mac.com>, Public Domain.


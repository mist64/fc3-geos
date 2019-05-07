set -e

# the input image
IN_CRT=../Final_Cartridge_3_1988-12.crt

# build GEOS
(cd ../geos; make clean all)

# build loader
ca65 -o fc3-geos.o fc3-geos.s
ld65 -C fc3-geos.cfg fc3-geos.o -o fc3-geos.bin

# remove start address
dd if=../geos/build/bsw/kernal_compressed.prg of=kernal_compressed.bin bs=1 skip=2

# combine loader and GEOS into bank 2 image
size=$(wc -c < fc3-geos.bin)
cat fc3-geos.bin > bank2.bin
dd if=kernal_compressed.bin bs=1 count=1 skip=$(expr 7684 - $size - 1) >> bank2.bin
dd if=kernal_compressed.bin bs=1 count=$(expr 7684 - $size - 1) >> bank2.bin
echo -n -e '\x60' >> bank2.bin
dd if=kernal_compressed.bin bs=1 skip=$(expr 7684 - $size) >> bank2.bin
cat bank2.bin /dev/zero | dd bs=1 count=16384 > bank2.bin.tmp
mv bank2.bin.tmp bank2.bin

# inject bank 2 into CRT file
dd if=$IN_CRT bs=1 count=32880 > fc3-geos.crt
cat bank2.bin >> fc3-geos.crt
dd if=$IN_CRT bs=1 skip=49264 >> fc3-geos.crt

# create the boot-to-basic version
dd if=fc3-geos.crt bs=1 count=225 of=fc3-geos-basic.crt
echo -n -e '\xd0' >> fc3-geos-basic.crt
dd if=fc3-geos.crt bs=1 skip=226 >> fc3-geos-basic.crt

echo \*\*\* Created fc3-geos.crt and fc3-geos-basic.crt.

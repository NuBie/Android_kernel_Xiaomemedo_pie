#!/bin/bash
# Edited By : Guzzo
# Copyright © 2018, "Guzzo" <758bb87a@gmail.com>
# Thanks to Vipul Jha for zip creator
# Android Kernel Compilation Script
#

tput reset
echo -e "==============================================="
echo    "         Compiling Guzzo Kernel             "
echo -e "==============================================="

LC_ALL=C date +%Y-%m-%d
date=`date +"%Y%m%d-%H%M"`
BUILD_START=$(date +"%s")
KERNEL_DIR=$PWD
REPACK_DIR=$KERNEL_DIR/zip
OUT=$KERNEL_DIR/out
ZIP_NAME="$VERSION"-"$DATE"
VERSION="Pie-9"
DATE=`date +"%Y%m%d-(%X)"`

export ARCH=arm64 && export SUBARCH=arm64
export USE_CCACHE=1
#export KBUILD_BUILD_USER="Sinz-Laura"
export KBUILD_BUILD_HOST="lineageos.org"
export TCHAIN_PATH="/home/cemplug/g_gcc/aarch64-linux-android-4.9/bin/aarch64-linux-android-"
export CROSS_COMPILE="${TCHAIN_PATH}"

git branch -a

make_zip()
{
 cd $REPACK_DIR
 cp $KERNEL_DIR/out/arch/arm64/boot/Image.gz-dtb $REPACK_DIR
		FINAL_ZIP="3.18.131-${VERSION}-${DATE}.zip"
        zip -r9 "${FINAL_ZIP}" *
		cp *.zip $OUT
		rm *.zip
		rm Image.gz-dtb
		
		cd $KERNEL_DIR
		rm out/arch/arm64/boot/Image.gz-dtb
		
}

rm -rf out
mkdir -p out
make O=out clean
make O=out mrproper
make O=out mido_defconfig
make O=out menuconfig
make O=out -j$(nproc --all)
make_zip

BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."

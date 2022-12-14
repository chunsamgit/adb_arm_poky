#         CONFIG
# -------------------------

#TODO change to your toolchain path
#source /opt/poky/3.1/environment-setup-aarch64-poky-linux
source /opt/fsl-imx-fb/3.14.52-1.1.1/environment-setup-cortexa9hf-vfp-neon-poky-linux-gnueabi

# Branch to checkout from Android source code repo
branch=android-5.0.1_r1
# Makefile to use (will be automatically copied into system/core/adb)
makefile=makefile.sample

function git-clone {
    git clone --single-branch -b "$branch" "$1"
}

# DOWNLOAD necessary files
# -------------------------
echo -e "\n>> >>> ADB for ARM <<< \n"
echo -e "\n>> Downloading necessay files ($branch branch)\n"
mkdir -p src/system
cd src/system #|| exit 1
git-clone https://android.googlesource.com/platform/system/core
cd core #|| exit 1
# Add include to avoid the following error:
patch -p1 < ../../../core.patch
cd ..
git-clone https://android.googlesource.com/platform/system/extras
cd ..
mkdir -p external
cd external #|| exit 1
git-clone https://android.googlesource.com/platform/external/zlib
git-clone https://android.googlesource.com/platform/external/openssl
cd ..

# MAKE
# -------------------------
echo -e "\n>> Copying makefile into system/core/adb...\n"
cp ../$makefile system/core/adb/makefile -f
cd system/core/adb/ || exit 1
echo -e "\n>> Make clean... \n"
make clean
echo -e "\n>> Make... \n"
make 1> /dev/null
echo -e "\n>> Copying adb back into current dir...\n"
rm -rf ../../../../bin/
mkdir ../../../../bin/
cp adb ../../../../bin/
echo -e "\n>> FINISH!\n"

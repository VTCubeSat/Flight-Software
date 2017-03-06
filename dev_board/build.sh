#!/bin/bash
set -euo pipefail

cd $(dirname $0)

# build for the host system
echo "Building with host platform"
mkdir -p build-host
cd build-host
cmake ../ && make
./dev_board
cd ../

# build for the msp430
toolchain_file=$(realpath $(pwd)/../cmake/custom_toolchains/msp430.cmake)
echo
echo "********************************************************************************"
echo "    Building using toolchain ${toolchain_file}"
echo "********************************************************************************"
echo

mkdir -p build-msp430
cd build-msp430
cmake -DCMAKE_TOOLCHAIN_FILE:FILEPATH=${toolchain_file} -DMSP430_MCU=msp430fr5969 ../
make
cd ../

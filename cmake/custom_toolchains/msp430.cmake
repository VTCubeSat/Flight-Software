# Based on the KuBOS MSP 430 target file
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/../cmake")

set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_VERSION 1)
set(CMAKE_SYSTEM_PROCESSOR msp430)

# get the root of the toolchain
find_program(K_GCC "msp430-elf-gcc")
if (NOT K_GCC)
  message("================================================================================")
  message(" ERROR: Unable to find the MSP430 toolchain")
  message("================================================================================")
endif()

# compute the toolchain root from the location of the compiler
get_filename_component(_MSP430_TOOLCHAIN_ROOT ${K_GCC} DIRECTORY)
get_filename_component(MSP430_TOOLCHAIN_ROOT ${_MSP430_TOOLCHAIN_ROOT} DIRECTORY CACHE STRING "MSP430 GCC toolchain root")

# assume that mspgcc is setup like a normal GCC install
set(K_GPP "${MSP430_TOOLCHAIN_ROOT}/bin/msp430-elf-g++")
set(K_OBJCOPY "${MSP430_TOOLCHAIN_ROOT}/bin/msp430-elf-objcopy")
set(K_AS "${MSP430_TOOLCHAIN_ROOT}/bin/msp430-elf-as")

# target build environment root directory
set(CMAKE_FIND_ROOT_PATH ${MSP430_TOOLCHAIN_ROOT})

# expose the MCU as a cmake variable
if(NOT MSP430_MCU)
  set(MSP430_MCU "msp430fr5969" CACHE STRING "MCU to target")
endif()

# Disable C/C++ features that are inefficient or impossible to implement on a microcontroller
set(_DISABLE_EXCEPTIONS_FLAGS "-fno-exceptions -fno-unwind-tables ")
#Options for large code/data model:
set(_M_OPTIONS "-mmcu=${MSP430_MCU} -mrelax -mlarge -D__LARGE_DATA_MODEL__ -D__LARGE_CODE_MODEL__")
#Regular 16 bit operation:
# set(_M_OPTIONS "-mmcu=${MSP430_MCU} -mrelax")
set(_C_FAMILY_FLAGS_INIT "${_DISABLE_EXCEPTIONS_FLAGS} -ffunction-sections -fdata-sections ${_M_OPTIONS}")

if(CMAKE_BUILD_TYPE MATCHES Debug)
  set(_C_FAMILY_FLAGS_INIT "${_C_FAMILY_FLAGS_INIT} -gstrict-dwarf")
endif()

# set some default flags
set(CMAKE_C_FLAGS_INIT   "${_C_FAMILY_FLAGS_INIT}")

set(CMAKE_ASM_FLAGS_INIT "${_DISABLE_EXCEPTIONS_FLAGS} ${_M_OPTIONS}")

set(LINKER_FLAGS_COMMON "-Wl,--gc-sections -Wl,--sort-common -Wl,--sort-section=alignment")

set(CMAKE_CXX_FLAGS_INIT "--std=gnu++11 ${_C_FAMILY_FLAGS_INIT} -fno-rtti -fno-threadsafe-statics")
set(CMAKE_MODULE_LINKER_FLAGS_INIT
  "${DISABLE_EXCEPTIONS_FLAGS} ${LINKER_FLAGS_COMMON}"
)
set(CMAKE_EXE_LINKER_FLAGS_INIT "${LINKER_FLAGS_COMMON} -L ${MSP430_TOOLCHAIN_ROOT}/include" CACHE STRING "")

link_directories("${MSP430_TOOLCHAIN_ROOT}/include")

# and add the system include directory for the compiler
include_directories(SYSTEM "${MSP430_TOOLCHAIN_ROOT}/include")

# force the C/C++ compilers
if(CMAKE_VERSION VERSION_LESS "3.6.0")
  include(CMakeForceCompiler)
  cmake_force_c_compiler("${K_GCC}" GNU)
  cmake_force_cxx_Compiler("${K_GPP}" GNU)
  cmake_force_asm_compiler("${K_GCC}" GNU)
else()
  set(CMAKE_C_COMPILER ${K_GCC})
  set(CMAKE_CXX_COMPILER ${K_GPP})
  set(CMAKE_ASM_COMPILER ${K_GCC})
endif()

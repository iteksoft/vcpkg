# original from 
# https://github.com/Neumann-A/my-vcpkg-triplets
message(STATUS "-->INIT TRIPLET ${CMAKE_CURRENT_SOURCE_DIR};; cmakefile: ${CMAKE_CURRENT_LIST_FILE} ")

if(DEFINED ENV{VCPKG_TRACE_TOOLCHAIN})
  set(VCPKG_TRACE_TOOLCHAIN $ENV{VCPKG_TRACE_TOOLCHAIN})
endif()

if (DEFINED VCPKG_TRACE_TOOLCHAIN)
    message(STATUS "-->ENTER VCPKG Toolchain triplet ${CMAKE_CURRENT_SOURCE_DIR};; cmakefile: ${CMAKE_CURRENT_LIST_FILE} ")
endif()



# use LLVM_ROOT instead
set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_LIBRARY_LINKAGE static)
set(VCPKG_CRT_LINKAGE static)
set(VCPKG_ENV_PASSTHROUGH "LLVM_ROOT;LLVM_VERSION")
set(VCPKG_QT_TARGET_MKSPEC win32-clang-msvc) # For Qt5

message(STATUS " 000port is  ${PORT}")

# Get Program Files root to lookup possible LLVM installation
if (DEFINED ENV{ProgramW6432})
    file(TO_CMAKE_PATH "$ENV{ProgramW6432}" PROG_ROOT)
else()
    file(TO_CMAKE_PATH "$ENV{PROGRAMFILES}" PROG_ROOT)
endif()

if (DEFINED ENV{LLVM_ROOT})
    file(TO_CMAKE_PATH "${LLVM_ROOT}/bin" POSSIBLE_LLVM_BIN_DIR)
else()
    file(TO_CMAKE_PATH "${PROG_ROOT}/LLVM/bin" POSSIBLE_LLVM_BIN_DIR)
endif()

if(NOT PORT MATCHES "(boost|hwloc|libpq|icu|harfbuzz|qt*|benchmark|gtest)")

    # VCPKG_CHAINLOAD_TOOLCHAIN_FILE already defined, running in cmake cmdline mode by cmake -DCMAKE_TOOLCHAIN_FILE=vcpkg.cmake mode
    # in cmake cmdline mode, VCPKG_CHAINLOAD_TOOLCHAIN_FILE will be included in vcpkg.cmake
    # in port mode, (vcpkg install mode), it will load triplet file first (in triplets/...cmake), these variables will be passed into cmake cmdline which is called by vcpkg
    #
    if(DEFINED VCPKG_CHAINLOAD_TOOLCHAIN_FILE)
        # if VCPKG_CHAINLOAD_TOOLCHAIN_FILE == current triplet file, load our default toolchain. called by cmake direct cmdline mode vcpkg.cmake
        # if defined, it shall be called from CMake cmdline with
        #  VCPKG_CHAINLOAD_TOOLCHAIN_FILE="G:\vcpkg/triplets/x64-windows-clangcl-static.cmake"
        #  VCPKG_TARGET_TRIPLET="x64-windows-clangcl-static"
        set(Z_VCPKG_LOAD_TOOLCHAIN_FILE_FROM_TRIPLET "${CMAKE_CURRENT_LIST_DIR}/toolchains/x64-windows-toolchain.clang-cl.cmake")
    else()
        # not defined, worked as a triplet in vcpkg port mode, set the vcpkg toolchain file, which will be included in vcpkg.cmake
        set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE "${CMAKE_CURRENT_LIST_DIR}/toolchains/x64-windows-toolchain.clang-cl.cmake")
    endif()

    if(DEFINED VCPKG_PLATFORM_TOOLSET)
        set(VCPKG_PLATFORM_TOOLSET ClangCL)
    endif()
    if(EXISTS "${POSSIBLE_LLVM_BIN_DIR}")
        set(ENV{PATH} "${POSSIBLE_LLVM_BIN_DIR};$ENV{PATH}")
    endif()
# elseif(PORT MATCHES "(qt*)")
#     set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE "${CMAKE_CURRENT_LIST_DIR}/x64-windows-llvm.toolchain.cl.cmake")
elseif(PORT MATCHES "(benchmark|gtest|qt*)")

    # Cannot have LTO enabled in gtest or benchmark since this eliminates/remove main from (gtest|benchmark)_main
    set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE "${CMAKE_CURRENT_LIST_DIR}/toolchains/x64-windows-toolchain.clang-cl.cmake")
    if(DEFINED VCPKG_PLATFORM_TOOLSET)
        set(VCPKG_PLATFORM_TOOLSET ClangCL)
    endif()
    if(EXISTS "${POSSIBLE_LLVM_BIN_DIR}")
        set(ENV{PATH} "${POSSIBLE_LLVM_BIN_DIR};$ENV{PATH}")
    endif()
endif()

set(VCPKG_POLICY_SKIP_ARCHITECTURE_CHECK enabled)
set(VCPKG_POLICY_SKIP_DUMPBIN_CHECKS enabled)
set(VCPKG_LOAD_VCVARS_ENV ON)

#set(VCPKG_C_FLAGS "-arch:AVX")
set(VCPKG_C_FLAGS "")
set(VCPKG_CXX_FLAGS "${VCPKG_C_FLAGS} -EHsc -GR")

if(DEFINED Z_VCPKG_LOAD_TOOLCHAIN_FILE_FROM_TRIPLET)
    include("${Z_VCPKG_LOAD_TOOLCHAIN_FILE_FROM_TRIPLET}")
endif()

#include_directories("C:/temp/inc")
#link_directories("C:/temp/lib")

if(DEFINED VCPKG_TRACE_TOOLCHAIN)
    message(STATUS "<--LEAVE vcpkg trilet!!! info:: ${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER} ")
    message(STATUS "more info:: comiler id ${CMAKE_CXX_COMPILER_ID} sim id  ${CMAKE_CXX_SIMULATE_ID}  frontend::${CMAKE_CXX_COMPILER_FRONTEND_VARIANT} msvc::${MSVC_TOOLSET_VERSION}")
endif()
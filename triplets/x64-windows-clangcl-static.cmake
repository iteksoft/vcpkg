# original from 
# https://github.com/Neumann-A/my-vcpkg-triplets

# use LLVM_ROOT instead
set(VCPKG_TARGET_ARCHITECTURE x64)
set(VCPKG_LIBRARY_LINKAGE static)
set(VCPKG_CRT_LINKAGE static)
set(VCPKG_ENV_PASSTHROUGH "LLVM_ROOT;LLVM_VERSION")
set(VCPKG_QT_TARGET_MKSPEC win32-clang-msvc) # For Qt5

# Get Program Files root to lookup possible LLVM installation
if (DEFINED ENV{ProgramW6432})
    file(TO_CMAKE_PATH "$ENV{ProgramW6432}" PROG_ROOT)
else()
    file(TO_CMAKE_PATH "$ENV{PROGRAMFILES}" PROG_ROOT)
endif()
if (DEFINED ENV{LLVMInstallDir})
    file(TO_CMAKE_PATH "${LLVM_ROOT}/bin" POSSIBLE_LLVM_BIN_DIR)
else()
    file(TO_CMAKE_PATH "${PROG_ROOT}/LLVM/bin" POSSIBLE_LLVM_BIN_DIR)
endif()

if(NOT PORT MATCHES "(boost|hwloc|libpq|icu|harfbuzz|qt*|benchmark|gtest)")
    if(DEFINED VCPKG_CHAINLOAD_TOOLCHAIN_FILE)
        set(VCPKG_PLUGINITEK_LOAD_TOOLCHAIN_FILE "${CMAKE_CURRENT_LIST_DIR}/toolchains/x64-windows-clangcl.toolchain.cmake")
    else()
        set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE "${CMAKE_CURRENT_LIST_DIR}/toolchains/x64-windows-clangcl.toolchain.cmake")
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
    set(VCPKG_CHAINLOAD_TOOLCHAIN_FILE "${CMAKE_CURRENT_LIST_DIR}/x64-windows-clangcl.toolchain-no-lto.cmake")
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

set(VCPKG_C_FLAGS "-arch:AVX")
set(VCPKG_CXX_FLAGS "${VCPKG_C_FLAGS} -EHsc -GR")


if(DEFINED VCPKG_PLUGINITEK_LOAD_TOOLCHAIN_FILE)
    include("${VCPKG_PLUGINITEK_LOAD_TOOLCHAIN_FILE}")
endif()

message(STATUS "IN vcpkg trilet last line !!! info:: ${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER} ")
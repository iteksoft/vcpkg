include_guard(GLOBAL)
#include("${CMAKE_CURRENT_LIST_DIR}/config.cmake")
#include("${CMAKE_CURRENT_LIST_DIR}/${VCPKG_TARGET_TRIPLET}.cmake")

include("${CMAKE_CURRENT_LIST_DIR}/x64-windows-findvc.cmake")
#[[
# triplet or toolchain does not support these settings?
# from testing no effects by CMake toolchain
# but it seems working by vcpkg install or so??

# Set C standard.
set(CMAKE_C_STANDARD 11 CACHE STRING "")
set(CMAKE_C_STANDARD_REQUIRED ON CACHE STRING "")
set(CMAKE_C_EXTENSIONS ON CACHE STRING "")

# Set C++ standard.
set(CMAKE_CXX_STANDARD 20 CACHE STRING "")
set(CMAKE_CXX_STANDARD_REQUIRED ON CACHE STRING "")
set(CMAKE_CXX_EXTENSIONS OFF CACHE STRING "")

]]#

# Set compiler.
find_program(CLANG-CL_EXECUTBALE NAMES "clang-cl" "clang-cl.exe" PATHS ENV LLVM_ROOT PATH_SUFFIXES "bin" NO_DEFAULT_PATH)
find_program(CLANG-CL_EXECUTBALE NAMES "clang-cl" "clang-cl.exe" PATHS ENV LLVM_ROOT PATH_SUFFIXES "bin" )

if (${CMAKE_HOST_SYSTEM_PROCESSOR} MATCHES "^AMD64|^amd64|^x64|^X64|^x86_x64|^X86_X64")
    if(${VCPKG_TARGET_ARCHITECTURE} MATCHES "^x64|^X64")
        set(MSVC_TOOLSET_BIN "${CMAKE_VCToolsInstallDir}/bin")
        set(MSVC_TOOLSET_BIN_HOSTX64_X64 "${CMAKE_VCToolsInstallDir}/bin/Hostx64/x64")
    endif()
else()

endif()


find_program(CLANG-CL-MTEXE
    NAMES "mt.exe"
    NAMES_PER_DIR
    PATHS ${CMAKE_WINDOWS_KITS_BINDIR}
    PATH_SUFFIXES "x64"
    DOC "msvc manifest compiler"
    NO_PACKAGE_ROOT_PATH NO_CMAKE_PATH NO_CMAKE_ENVIRONMENT_PATH NO_CMAKE_SYSTEM_PATH
)
message(STATUS "vc bin ${CLANG-CL-MTEXE}")

if(NOT CLANG-CL_EXECUTBALE)
  message(SEND_ERROR "clang-cl was not found!") # Not a FATAL_ERROR due to being a toolchain!
endif()

get_filename_component(LLVM_BIN_DIR "${CLANG-CL_EXECUTBALE}" DIRECTORY)
list(INSERT CMAKE_PROGRAM_PATH 0 "${LLVM_BIN_DIR}")

set(CMAKE_C_COMPILER "${CLANG-CL_EXECUTBALE}" CACHE STRING "" FORCE)
set(CMAKE_CXX_COMPILER "${CLANG-CL_EXECUTBALE}" CACHE STRING "" FORCE)
set(CMAKE_AR "${LLVM_BIN_DIR}/llvm-lib.exe" CACHE STRING "" FORCE)
set(CMAKE_LINKER "${LLVM_BIN_DIR}/lld-link.exe" CACHE STRING "" FORCE) 
#set(CMAKE_LINKER "link.exe" CACHE STRING "" FORCE)
set(CMAKE_ASM_MASM_COMPILER "${LLVM_BIN_DIR}/llvm-ml.exe" CACHE STRING "" FORCE)
set(CMAKE_RC_COMPILER "${LLVM_BIN_DIR}/llvm-rc.exe" CACHE STRING "" FORCE)
set(CMAKE_MT ${CLANG-CL-MTEXE} CACHE STRING "" FORCE)


# ######################################################################################
# skip compiler id test
#set(CMAKE_CXX_COMPILER_ID_RUN TRUE) # for skipping compiler id check

set(CMAKE_CXX_COMPILER_ID Clang)  #for 
# for clang-cl mode
set(CMAKE_CXX_SIMULATE_ID MSVC)
set(CMAKE_CXX_COMPILER_FRONTEND_VARIANT MSVC) # for clang-cl mode


set(CMAKE_C_COMPILER_ID Clang)  #for 
# for clang-cl mode
set(CMAKE_C_SIMULATE_ID MSVC)
set(CMAKE_C_COMPILER_FRONTEND_VARIANT MSVC) # for clang-cl mode


# ######################################################################################
get_property( _CMAKE_IN_TRY_COMPILE GLOBAL PROPERTY IN_TRY_COMPILE )
if(NOT _CMAKE_IN_TRY_COMPILE)
    # Set runtime library.
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>$<$<STREQUAL:${VCPKG_CRT_LINKAGE},dynamic>:DLL>" CACHE STRING "")
    if(VCPKG_CRT_LINKAGE STREQUAL "dynamic")
      set(VCPKG_CRT_FLAG "/MD")
      set(VCPKG_DBG_FLAG "/Zi")
    elseif(VCPKG_CRT_LINKAGE STREQUAL "static")
      set(VCPKG_CRT_FLAG "/MT")
      set(VCPKG_DBG_FLAG "/Zi")
    else()
      message(FATAL_ERROR "Invalid VCPKG_CRT_LINKAGE: \"${VCPKG_CRT_LINKAGE}\".")
    endif()

    # Set charset flag.
    set(CHARSET_FLAG "/utf-8")
    if(DEFINED VCPKG_SET_CHARSET_FLAG AND NOT VCPKG_SET_CHARSET_FLAG)
      set(CHARSET_FLAG)
    endif()

    # Set compiler flags.
    set(CLANG_FLAGS "/clang:-fasm /clang:-fopenmp-simd")
    # Disable logo for compiler and linker.
    set(CMAKE_CL_NOLOGO "/nologo" CACHE STRING "")

    set(CMAKE_C_FLAGS "${CMAKE_CL_NOLOGO} /DWIN32 /D_WINDOWS /FC ${VCPKG_C_FLAGS} ${CLANG_FLAGS} ${CHARSET_FLAG}" CACHE STRING "")
    set(CMAKE_C_FLAGS_DEBUG "/Od /Ob0 /GS /RTC1 ${VCPKG_C_FLAGS_DEBUG} ${VCPKG_CRT_FLAG}d ${VCPKG_DBG_FLAG}" CACHE STRING "")
    set(CMAKE_C_FLAGS_RELEASE "/O2 /Oi /Ob2 /GS- ${VCPKG_C_FLAGS_RELEASE} ${VCPKG_CRT_FLAG} /clang:-flto=full ${VCPKG_DBG_FLAG} /DNDEBUG" CACHE STRING "")
    set(CMAKE_C_FLAGS_MINSIZEREL "/O1 /Oi /Ob1 /GS- ${VCPKG_C_FLAGS_RELEASE} ${VCPKG_CRT_FLAG} /clang:-flto=full /DNDEBUG" CACHE STRING "")
    set(CMAKE_C_FLAGS_RELWITHDEBINFO "/O2 /Oi /Ob1 /GS- ${VCPKG_C_FLAGS_RELEASE} ${VCPKG_CRT_FLAG} /clang:-flto=full ${VCPKG_DBG_FLAG} /DNDEBUG" CACHE STRING "")

    set(CMAKE_CXX_FLAGS "${CMAKE_CL_NOLOGO} /DWIN32 /D_WINDOWS /FC /permissive- ${VCPKG_CXX_FLAGS} ${CLANG_FLAGS} ${CHARSET_FLAG}" CACHE STRING "")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} ${VCPKG_CXX_FLAGS_DEBUG}" CACHE STRING "")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} ${VCPKG_CXX_FLAGS_RELEASE} /clang:-fwhole-program-vtables" CACHE STRING "")
    set(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_C_FLAGS_MINSIZEREL} ${VCPKG_CXX_FLAGS_RELEASE} /clang:-fwhole-program-vtables" CACHE STRING "")
    set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_C_FLAGS_RELWITHDEBINFO} ${VCPKG_CXX_FLAGS_RELEASE} /clang:-fwhole-program-vtables" CACHE STRING "")

    #[[
    # Set linker flags.
    foreach(LINKER SHARED_LINKER MODULE_LINKER EXE_LINKER)
      set(CMAKE_${LINKER}_FLAGS_INIT "${VCPKG_LINKER_FLAGS}")
      set(CMAKE_${LINKER}_FLAGS_DEBUG "/INCREMENTAL /DEBUG:FULL" CACHE STRING "")
      set(CMAKE_${LINKER}_FLAGS_RELEASE "/OPT:REF /OPT:ICF" CACHE STRING "")
      set(CMAKE_${LINKER}_FLAGS_MINSIZEREL "/OPT:REF /OPT:ICF" CACHE STRING "")
      set(CMAKE_${LINKER}_FLAGS_RELWITHDEBINFO "/OPT:REF /OPT:ICF /DEBUG:FULL" CACHE STRING "")
    endforeach()

    ]]#
    # Set assembler flags.
    set(CMAKE_ASM_MASM_FLAGS_INIT "${CMAKE_CL_NOLOGO}")

    # Set resource compiler flags.
    set(CMAKE_RC_FLAGS_INIT "${CMAKE_CL_NOLOGO} -c65001 -DWIN32")
    set(CMAKE_RC_FLAGS_DEBUG_INIT "-D_DEBUG")

    # Add windows defines.
    add_compile_definitions(_WIN64 _WIN32_WINNT=0x0A00 WINVER=0x0A00)
    add_compile_definitions(_CRT_SECURE_NO_DEPRECATE _CRT_SECURE_NO_WARNINGS _CRT_NONSTDC_NO_DEPRECATE)
    add_compile_definitions(_ATL_SECURE_NO_DEPRECATE _SCL_SECURE_NO_WARNINGS)

    if(${VCPKG_TARGET_ARCHITECTURE} MATCHES "^x64|^X64")
        set(CMAKE_VCIncludeDir "${CMAKE_VCToolsInstallDir}/include")   
        set(CMAKE_VCLibDir "${CMAKE_VCToolsInstallDir}/lib/${VCPKG_TARGET_ARCHITECTURE}")   
    else()
    endif()
    
    #CMAKE_HOST_SYSTEM_PROCESSOR
    message(STATUS "The current host sys is " ${CMAKE_SYSTEM_PROCESSOR} "winkit lib path is ${CMAKE_WINDOWS_KITS_LIBDIR}/um vc lib ${CMAKE_VCLibDir}")
    message(STATUS "The current host arch is " ${CMAKE_HOST_SYSTEM_PROCESSOR} "msvc version ${MSVC_VERSION}")
    
    # ENV variable has no CACHE
    set(ENV{LIB} "${CMAKE_VCLibDir};${CMAKE_WINDOWS_KITS_LIBDIR}/um/${VCPKG_TARGET_ARCHITECTURE};${CMAKE_WINDOWS_KITS_LIBDIR}/ucrt/${VCPKG_TARGET_ARCHITECTURE}")
    
endif()
include_guard(GLOBAL)
#include("${CMAKE_CURRENT_LIST_DIR}/config.cmake")
#include("${CMAKE_CURRENT_LIST_DIR}/${VCPKG_TARGET_TRIPLET}.cmake")

include("${CMAKE_CURRENT_LIST_DIR}/x64-windows-util.findvc.cmake")
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
# find_program(CLANGCL_EXECUTABLE NAMES "clang-cl.exe" PATHS ENV LLVM_ROOT PATH_SUFFIXES "bin" NO_DEFAULT_PATH)
# find_program(CLANG-CL_EXECUTBALE NAMES "clang-cl.exe" PATHS ENV LLVM_ROOT PATH_SUFFIXES "bin" )


if(NOT MSVC_CXX_COMPILER)
    message(SEND_ERROR "MSVC_CXX_COMPILER was not found!") # Not a FATAL_ERROR due to being a toolchain!
else()
    if(DEFINED VCPKG_TRACE_TOOLCHAIN)
        message("clang-cl path is ${MSVC_CXX_COMPILER} !!")
    endif()
endif()


set(CMAKE_C_COMPILER "${MSVC_CXX_COMPILER}" CACHE STRING "" FORCE)
set(CMAKE_CXX_COMPILER "${MSVC_CXX_COMPILER}" CACHE STRING "" FORCE)
set(CMAKE_AR "${MSVC_TOOLSET_BIN}/lib.exe" CACHE STRING "" FORCE)
set(CMAKE_LINKER "${MSVC_TOOLSET_BIN}/link.exe" CACHE STRING "" FORCE)
#set(CMAKE_LINKER "link.exe" CACHE STRING "" FORCE)
set(CMAKE_ASM_MASM_COMPILER "${MSVC_MASM_COMPILER}" CACHE STRING "" FORCE)
set(CMAKE_RC_COMPILER "${MSVC_WINDOWS_KITS_RCEXE}" CACHE STRING "" FORCE)
set(CMAKE_MT "${MSVC_WINDOWS_KITS_MTEXE}" CACHE STRING "" FORCE)

# ######################################################################################
# skip compiler id test
#set(CMAKE_CXX_COMPILER_ID_RUN TRUE) # for skipping compiler id check

set(CMAKE_CXX_COMPILER_ID MSVC)  # for MSVC cl.exe
# for clang-cl mode
set(CMAKE_CXX_SIMULATE_ID "")
set(CMAKE_CXX_COMPILER_FRONTEND_VARIANT "") # for clang-cl mode


set(CMAKE_C_COMPILER_ID MSVC)  #for
# for clang-cl mode
set(CMAKE_C_SIMULATE_ID "")
set(CMAKE_C_COMPILER_FRONTEND_VARIANT "") # for clang-cl mode


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

    # Add windows defines.
    if (WIN32)
        if(${VCPKG_TARGET_ARCHITECTURE} MATCHES "^x64|^X64")
            set(VCPKG_C_DEF "/D_WIN64")
        endif()
        set(VCPKG_C_DEF "/D_WIN32_WINNT=0x0A00 /DWINVER=0x0A00 ${VCPKG_C_DEF}")
        set(VCPKG_C_DEF "/D_CRT_SECURE_NO_DEPRECATE /D_CRT_SECURE_NO_WARNINGS /D_CRT_NONSTDC_NO_DEPRECATE ${VCPKG_C_DEF}")
        set(VCPKG_C_DEF "/D_ATL_SECURE_NO_DEPRECATE /D_SCL_SECURE_NO_WARNINGS ${VCPKG_C_DEF}")
    endif()

    # Set compiler flags.
    # set(CLANG_FLAGS "/clang:-fasm /clang:-fopenmp-simd")
    set(CLANG_FLAGS "")
    # Disable logo for compiler and linker.
    set(CMAKE_CL_NOLOGO "/nologo" CACHE STRING "")


    set(CMAKE_C_FLAGS "${CMAKE_CL_NOLOGO} /DWIN32 /D_WINDOWS ${VCPKG_C_DEF} /FC ${VCPKG_C_FLAGS} ${CLANG_FLAGS} ${CHARSET_FLAG}" CACHE STRING "")
    set(CMAKE_C_FLAGS_DEBUG "/Od /Ob0 /GS /RTC1 ${VCPKG_C_FLAGS_DEBUG} ${VCPKG_CRT_FLAG}d ${VCPKG_DBG_FLAG}" CACHE STRING "")
    set(CMAKE_C_FLAGS_RELEASE "/O2 /Oi /Ob2 /GS- ${VCPKG_C_FLAGS_RELEASE} ${VCPKG_CRT_FLAG} ${VCPKG_DBG_FLAG} /DNDEBUG" CACHE STRING "")
    set(CMAKE_C_FLAGS_MINSIZEREL "/O1 /Oi /Ob1 /GS- ${VCPKG_C_FLAGS_RELEASE} ${VCPKG_CRT_FLAG} /DNDEBUG" CACHE STRING "")
    set(CMAKE_C_FLAGS_RELWITHDEBINFO "/O2 /Oi /Ob1 /GS- ${VCPKG_C_FLAGS_RELEASE} ${VCPKG_CRT_FLAG} ${VCPKG_DBG_FLAG} /DNDEBUG" CACHE STRING "")

    set(CMAKE_CXX_FLAGS "${CMAKE_CL_NOLOGO} /DWIN32 /D_WINDOWS ${VCPKG_C_DEF} /FC /permissive- ${VCPKG_CXX_FLAGS} ${CLANG_FLAGS} ${CHARSET_FLAG}" CACHE STRING "")
    set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} ${VCPKG_CXX_FLAGS_DEBUG}" CACHE STRING "")
    set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} ${VCPKG_CXX_FLAGS_RELEASE}" CACHE STRING "")
    set(CMAKE_CXX_FLAGS_MINSIZEREL "${CMAKE_C_FLAGS_MINSIZEREL} ${VCPKG_CXX_FLAGS_RELEASE}" CACHE STRING "")
    set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_C_FLAGS_RELWITHDEBINFO} ${VCPKG_CXX_FLAGS_RELEASE}" CACHE STRING "")


    set(CMAKE_CXX_FLAGS " /nologo /DWIN32 /D_WINDOWS /W3 ${CHARSET_FLAG} /GR /EHsc /MP ${VCPKG_CXX_FLAGS}" CACHE STRING "")
    set(CMAKE_C_FLAGS " /nologo /DWIN32 /D_WINDOWS /W3 ${CHARSET_FLAG} /MP ${VCPKG_C_FLAGS}" CACHE STRING "")

    set(CMAKE_CXX_FLAGS_DEBUG "/D_DEBUG ${VCPKG_CRT_LINK_FLAG_PREFIX}d /Z7 /Ob0 /Od /RTC1 ${VCPKG_CXX_FLAGS_DEBUG}" CACHE STRING "")
    set(CMAKE_C_FLAGS_DEBUG "/D_DEBUG ${VCPKG_CRT_LINK_FLAG_PREFIX}d /Z7 /Ob0 /Od /RTC1 ${VCPKG_C_FLAGS_DEBUG}" CACHE STRING "")
    set(CMAKE_CXX_FLAGS_RELEASE "${VCPKG_CRT_LINK_FLAG_PREFIX} /O2 /Oi /Gy /DNDEBUG /Z7 ${VCPKG_CXX_FLAGS_RELEASE}" CACHE STRING "")
    set(CMAKE_C_FLAGS_RELEASE "${VCPKG_CRT_LINK_FLAG_PREFIX} /O2 /Oi /Gy /DNDEBUG /Z7 ${VCPKG_C_FLAGS_RELEASE}" CACHE STRING "")

    # llvm-rc /C must be capital?
    set(CMAKE_RC_FLAGS "/C1252 /DWIN32" CACHE STRING "")
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
    # set(CMAKE_RC_FLAGS_INIT "${CMAKE_CL_NOLOGO} -c65001 -DWIN32")
    set(CMAKE_RC_FLAGS_INIT "${CMAKE_CL_NOLOGO} -C1252 /DWIN32")
    set(CMAKE_RC_FLAGS_DEBUG_INIT "/D_DEBUG")

    if(${VCPKG_TARGET_ARCHITECTURE} MATCHES "^x64|^X64")
        set(CMAKE_VCIncludeDir "${MSVC_VCTOOLS_INSTALLDIR}/include")
        set(CMAKE_VCLibDir "${MSVC_VCTOOLS_INSTALLDIR}/lib/${VCPKG_TARGET_ARCHITECTURE}")
    else()
    endif()

    #CMAKE_HOST_SYSTEM_PROCESSOR
    if(DEFINED VCPKG_TRACE_TOOLCHAIN)
        message(STATUS "=> The current host sys is " ${CMAKE_SYSTEM_PROCESSOR} "winkit lib path is ${CMAKE_WINDOWS_KITS_LIBDIR}/um vc lib ${CMAKE_VCLibDir}")
        message(STATUS "=> The current host arch is " ${CMAKE_HOST_SYSTEM_PROCESSOR} "msvc version ${MSVC_VERSION}")
    endif()

    # ENV variable has no CACHE

    #     set_property(DIRECTORY PROPERTY LINK_DIRECTORIES "${CMAKE_VCLibDir}" "${CMAKE_WINDOWS_KITS_LIBDIR}/um/${VCPKG_TARGET_ARCHITECTURE}" "${CMAKE_WINDOWS_KITS_LIBDIR}/ucrt/${VCPKG_TARGET_ARCHITECTURE}")

    #    set(ENV{LIB} "${CMAKE_VCLibDir};${CMAKE_WINDOWS_KITS_LIBDIR}/um/${VCPKG_TARGET_ARCHITECTURE};${CMAKE_WINDOWS_KITS_LIBDIR}/ucrt/${VCPKG_TARGET_ARCHITECTURE}")
    #    link_directories("${CMAKE_VCLibDir}" "${CMAKE_WINDOWS_KITS_LIBDIR}/um/${VCPKG_TARGET_ARCHITECTURE}" "${CMAKE_WINDOWS_KITS_LIBDIR}/ucrt/${VCPKG_TARGET_ARCHITECTURE}")

    set(CMAKE_EXE_LINKER_FLAGS "-LIBPATH:\"${CMAKE_VCLibDir}\" -LIBPATH:\"${MSVC_WINDOWS_KITS_LIBDIR}/um/${VCPKG_TARGET_ARCHITECTURE}\" -LIBPATH:\"${MSVC_WINDOWS_KITS_LIBDIR}/ucrt/${VCPKG_TARGET_ARCHITECTURE}\"" CACHE STRING "" FORCE)

    #
    # for ninja, we have to manually add the include path
    set(CMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES "${CMAKE_VCIncludeDir};${MSVC_WINDOWS_KITS_INCDIR}/ucrt" CACHE STRING "" FORCE)

endif()

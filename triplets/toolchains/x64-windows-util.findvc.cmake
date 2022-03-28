
#
# MSVC_WINDOWS_KITS_DIR
# MSVC_WINDOWS_KITS_VERSION
# MSVC_VS_INSTALLDIR
#
# VC related variables

# CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION      10.0.19041.0
# CMAKE_WINDOWS_KITS_10_DIR     "C:\Program Files (x86)\Windows Kits\10\"

# MSVC_WINDOWS_KITS_DIR
# MSVC_WINDOWS_KITS_VERMAJOR
# MSVC_WINDOWS_KITS_INCDIR
# MSVC_WINDOWS_KITS_LIBDIR
# MSVC_WINDOWS_KITS_BINDIR
#
# MSVC_TOOLSET_VERNAME "2019"
# MSVC_TOOLSET_VERSION 142
# MSVC_TOOLSET_VERMAJOR
# MSVC_TOOLSET_VERMINOR
# MSVC_TOOLSET_VERSION
#
# MSVC_VS_INSTALLDIR
# MSVC_VCTOOLS_VERSION "14.29.30133"
# MSVC_VCTOOLS_INSTALLDIR
# MSVC_VCTOOLS_INCDIR
# MSVC_VCTOOLS_LIBDIR
#
# MSVC_CXX_COMPILER full path of cl.exe
# 

# VCPKG_TARGET_ARCHITECTURE x64

# VCPKG_LOAD_VCVARS_ENV false
# VCPKG_VISUAL_STUDIO_PATH
# VCPKG_PLATFORM_TOOLSET

MACRO(SUBDIRLIST result curdir)
  FILE(GLOB children RELATIVE ${curdir} ${curdir}/*)
  SET(dirlist "")
  FOREACH(child ${children})
    IF(IS_DIRECTORY ${curdir}/${child})
      LIST(APPEND dirlist ${child})
    ENDIF()
  ENDFOREACH()
  SET(${result} ${dirlist})
ENDMACRO()
#
# have to delcare as a function for pattern string containing backslash escape char
#
function(SUBDIRMATCH result pattern curdir)
  FILE(GLOB children RELATIVE ${curdir} ${curdir}/*)
  SET(dirlist "")
  #message(STATUS "cur ${curdir} has :: ${children}")
  FOREACH(child ${children})
    IF(IS_DIRECTORY ${curdir}/${child})

        set(__tmpMatchedRe "")
        string(REGEX MATCH ${pattern} __tmpMatchedRe ${child})

        if(NOT ${__tmpMatchedRe} STREQUAL "")
            # because we are in a function, set the out with specifying PARENT_SCOPE
            set(${result} ${__tmpMatchedRe} PARENT_SCOPE)
            # message(STATUS "STATUS:: ${result} cur subdir is ${__tmpMatchedRe} ==> ${child}" ${pattern})
            break()
        endif()
    ENDIF()
  ENDFOREACH()
endfunction()

# WindowsSDKVersion

# $ENV{WindowsSdkDir}
# set(MSVC_WINDOWS_KITS_VERMAJOR "10")

# message(STATUS "host os :: "  ${CMAKE_HOST_SYSTEM_NAME} ${CMAKE_SYSTEM_VERSION} " sys:: " ${CMAKE_SYSTEM_NAME})
if (WIN32)
    # message(STATUS " we are in Windows!!")
endif()

file(TO_CMAKE_PATH "$ENV{ProgramFiles} (x86)" programfilesx86)

if (NOT DEFINED ENV{WindowsSdkDir})
    if (NOT DEFINED MSVC_WINDOWS_KITS_VERMAJOR)
        set(MSVC_WINDOWS_KITS_VERMAJOR "10")
    endif()
    set(MSVC_WINDOWS_KITS_DIR "${programfilesx86}/Windows Kits/${MSVC_WINDOWS_KITS_VERMAJOR}")

else()
    cmake_path(SET MSVC_WINDOWS_KITS_DIR NORMALIZE $ENV{WindowsSdkDir})
    #set (MSVC_WINDOWS_KITS_DIR $ENV{WindowsSdkDir})

endif()

# set()WindowsSDKVersion
if (NOT DEFINED ENV{WindowsSDKVersion})
    set(CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION "")

    SUBDIRLIST(ztmp_dirlist "${MSVC_WINDOWS_KITS_DIR}/Lib")
    # message(STATUS "list of winkits vers :: " "${MSVC_WINDOWS_KITS_DIR}/Lib" " ==> " ${ztmp_dirlist})
    list(SORT ztmp_dirlist COMPARE NATURAL ORDER DESCENDING)
    list(GET ztmp_dirlist 0 MSVC_WINDOWS_KITS_VERSION)

    set(CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION ${MSVC_WINDOWS_KITS_VERSION})
    set(ENV{WindowsSDKVersion} ${MSVC_WINDOWS_KITS_VERSION})
    # set(MSVC_WINDOWS_KITS_VERSION )
    # message(STATUS "list of winkits vers :: " ${MSVC_WINDOWS_KITS_VERSION} "   ==> " $ENV{WindowsSDKVersion})


else()
    cmake_path(SET ztmp_sdkver NORMALIZE $ENV{WindowsSDKVersion})
    cmake_path(GET ztmp_sdkver PARENT_PATH CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION)
    set(MSVC_WINDOWS_KITS_VERSION ${CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION})

    # get the major version
    string(REGEX MATCH "([0-9]+)(\\.[0-9]+)*" ztmp_re ${ztmp_sdkver})
    set(MSVC_WINDOWS_KITS_VERMAJOR ${CMAKE_MATCH_1})

    if (NOT DEFINED ENV{WindowsSdkDir})
        set(MSVC_WINDOWS_KITS_DIR "${programfilesx86}/Windows Kits/${MSVC_WINDOWS_KITS_VERMAJOR}")        
    endif()

endif()

# set LibDir and IncludeDir for Windows Kits
set(MSVC_WINDOWS_KITS_INCDIR "${MSVC_WINDOWS_KITS_DIR}/Include/${MSVC_WINDOWS_KITS_VERSION}")
set(MSVC_WINDOWS_KITS_LIBDIR "${MSVC_WINDOWS_KITS_DIR}/Lib/${MSVC_WINDOWS_KITS_VERSION}")
set(MSVC_WINDOWS_KITS_BINDIR "${MSVC_WINDOWS_KITS_DIR}/bin/${MSVC_WINDOWS_KITS_VERSION}")

#cmake_path(GET newversion PARENT_PATH newver1)
message(STATUS "sdkversion:: " ${MSVC_WINDOWS_KITS_VERSION} " envvar " $ENV{WindowsSDKVersion} "  new ver1:: " ${CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION})


# VCINSTALLDIR VCToolsInstallDir VCToolsVersion 
# VSINSTALLDIR 
# C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional
# MSVC_TOOLSET_VERSION 142
# CMAKE_VS_PLATFORM_TOOLSET v142
# VisualStudioVersion 16.0

#     set(MSVC_VS_INSTALLDIR "${programfilesx86}/Microsoft Visual Studio/2019/Professional")   

# set()WindowsSDKVersion

# set()WindowsSDKVersion

if (NOT DEFINED ENV{VCToolsInstallDir})

    if (NOT DEFINED ENV{VisualStudioVersion})
        if (DEFINED MSVC_TOOLSET_VERNAME_INIT)
            set(MSVC_TOOLSET_VERNAME ${MSVC_TOOLSET_VERNAME_INIT})
            set(MSVC_TOOLSET_VERSION_INIT "142")
        else()
            set(MSVC_TOOLSET_VERNAME "2019")
            set(MSVC_TOOLSET_VERSION_INIT "142")
        endif()

        set(MSVC_TOOLSET_VERSION ${MSVC_TOOLSET_VERSION_INIT})
    else()
        if ($ENV{VisualStudioVersion} STREQUAL "16.0")
            set(MSVC_TOOLSET_VERNAME "2019")
            set(MSVC_TOOLSET_VERSION_INIT "142")
        elseif($ENV{VisualStudioVersion} STREQUAL "17.0")
            set(MSVC_TOOLSET_VERNAME "2022")
            set(MSVC_TOOLSET_VERSION_INIT "143")
        elseif($ENV{VisualStudioVersion} STREQUAL "15.0")
            set(MSVC_TOOLSET_VERNAME "2017")
            set(MSVC_TOOLSET_VERSION_INIT "141")
        elseif($ENV{VisualStudioVersion} STREQUAL "14.0")
            set(MSVC_TOOLSET_VERNAME "2015")
            set(MSVC_TOOLSET_VERSION_INIT "140")
        elseif($ENV{VisualStudioVersion} STREQUAL "12.0")
            set(MSVC_TOOLSET_VERNAME "2013")
            set(MSVC_TOOLSET_VERSION_INIT "120")
        else()
            set(MSVC_TOOLSET_VERNAME "2019")
            set(MSVC_TOOLSET_VERSION_INIT "142")
        endif()

        #
        set(MSVC_TOOLSET_VERSION ${MSVC_TOOLSET_VERSION_INIT})
    endif()

    if (NOT DEFINED ENV{VSINSTALLDIR})
        set(MSVC_VS_INSTALLDIR "${programfilesx86}/Microsoft Visual Studio/${MSVC_TOOLSET_VERNAME}/Professional")
    else()
        # use the ENV{VSINSTALLDIR}
        cmake_path(SET MSVC_VS_INSTALLDIR NORMALIZE $ENV{VSINSTALLDIR})
    endif()

    #
    # MSVC_TOOLSET_VERSION like 14.29.30133
    if (NOT DEFINED ENV{VCToolsVersion})

        string(SUBSTRING ${MSVC_TOOLSET_VERSION} 0 2 MSVC_TOOLSET_VERMAJOR)
        string(SUBSTRING ${MSVC_TOOLSET_VERSION} 2 1 MSVC_TOOLSET_VERMINOR)

        #  string(REGEX MATCH "^${MSVC_TOOLSET_VERMAJOR}\\.${MSVC_TOOLSET_VERMINOR}([0-9])*(\\.[0-9]+)*" ztmp_re ${ztmp_sdkver})
        SUBDIRMATCH(MSVC_VCTOOLS_VERSION "^(${MSVC_TOOLSET_VERMAJOR}\\.${MSVC_TOOLSET_VERMINOR})([0-9])*(\\.[0-9]+)*" "${MSVC_VS_INSTALLDIR}/VC/Tools/MSVC")
        SUBDIRLIST(ztmp_dirlist "${MSVC_VS_INSTALLDIR}/VC/Tools/MSVC")

        #set(CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION ${MSVC_WINDOWS_KITS_VERSION})
        #set(ENV{WindowsSDKVersion} ${MSVC_WINDOWS_KITS_VERSION})

        set(MSVC_VCTOOLS_INSTALLDIR "${MSVC_VS_INSTALLDIR}/VC/Tools/MSVC/${MSVC_VCTOOLS_VERSION}")
    else()
        set(MSVC_VCTOOLS_VERSION $ENV{VCToolsVersion})
        set(MSVC_VCTOOLS_INSTALLDIR "${MSVC_VS_INSTALLDIR}/VC/Tools/MSVC/$ENV{VCToolsVersion}")
    endif()

    if (DEFINED VCPKG_TRACE_TOOLCHAIN)
        message(STATUS "${MSVC_TOOLSET_VERMAJOR}.${MSVC_TOOLSET_VERMINOR}"  "match :: " "${MSVC_VCTOOLS_VERSION} in  ${MSVC_VCTOOLS_INSTALLDIR}")
    endif()
    
else()

    #
    cmake_path(SET MSVC_VCTOOLS_INSTALLDIR NORMALIZE $ENV{VCToolsInstallDir})

    string(FIND ${MSVC_VCTOOLS_INSTALLDIR} "/VC/Tools/MSVC/" ztmp_findpos)
    if(NOT ztmp_findpos EQUAL -1)
        string(SUBSTRING ${MSVC_VCTOOLS_INSTALLDIR} 0 ztmp_findpos MSVC_VS_INSTALLDIR)
        string(SUBSTRING ${MSVC_VCTOOLS_INSTALLDIR} ztmp_findpos+15 -1 MSVC_VCTOOLS_VERSION)
    endif()
    
    string(REGEX MATCH "([0-9]+)(\\.[0-9]+)+" ztmp_re ${MSVC_VCTOOLS_VERSION})
    set(MSVC_VCTOOLS_VERSION ${ztmp_re})

    string(REGEX MATCH "([0-9]+)\\.([0-9])" ztmp_re ${MSVC_VCTOOLS_VERSION})
    set(MSVC_TOOLSET_VERMAJOR ${CMAKE_MATCH_1})
    set(MSVC_TOOLSET_VERMINOR ${CMAKE_MATCH_2})
    set(MSVC_TOOLSET_VERSION "${MSVC_TOOLSET_VERMAJOR}${MSVC_TOOLSET_VERMINOR}")

    #string(REGEX MATCH "^[a-zA-Z]/"MSVC_VS_INSTALLDIR ${MSVC_VCTOOLS_INSTALLDIR})

    if (DEFINED VCPKG_TRACE_TOOLCHAIN)
        message(STATUS "${MSVC_TOOLSET_VERMAJOR}.${MSVC_TOOLSET_VERMINOR}"  "match :: " "${MSVC_VCTOOLS_VERSION} in  ${MSVC_VS_INSTALLDIR}")
    endif()

endif()



if (NOT DEFINED ENV{VSINSTALLDIR})
    # set(CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION "")

    if (NOT DEFINED ENV{VCToolsInstallDir})

        if (NOT DEFINED ENV{VisualStudioVersion})
            if (DEFINED MSVC_TOOLSET_VERNAME_INIT)
                set(MSVC_TOOLSET_VERNAME ${MSVC_TOOLSET_VERNAME_INIT})
                set(MSVC_TOOLSET_VERSION_INIT "142")
            else()
                set(MSVC_TOOLSET_VERNAME "2019")
                set(MSVC_TOOLSET_VERSION_INIT "142")
            endif()

            set(MSVC_TOOLSET_VERSION ${MSVC_TOOLSET_VERSION_INIT})
        else()
            if ($ENV{VisualStudioVersion} STREQUAL "16.0")
                set(MSVC_TOOLSET_VERNAME "2019")
                set(MSVC_TOOLSET_VERSION_INIT "142")
            elseif($ENV{VisualStudioVersion} STREQUAL "17.0")
                set(MSVC_TOOLSET_VERNAME "2022")
                set(MSVC_TOOLSET_VERSION_INIT "143")
            elseif($ENV{VisualStudioVersion} STREQUAL "15.0")
                set(MSVC_TOOLSET_VERNAME "2017")
                set(MSVC_TOOLSET_VERSION_INIT "141")
            elseif($ENV{VisualStudioVersion} STREQUAL "14.0")
                set(MSVC_TOOLSET_VERNAME "2015")
                set(MSVC_TOOLSET_VERSION_INIT "140")
            elseif($ENV{VisualStudioVersion} STREQUAL "12.0")
                set(MSVC_TOOLSET_VERNAME "2013")
                set(MSVC_TOOLSET_VERSION_INIT "120")
            else()
                set(MSVC_TOOLSET_VERNAME "2019")
                set(MSVC_TOOLSET_VERSION_INIT "142")
            endif()

            #
            set(MSVC_TOOLSET_VERSION ${MSVC_TOOLSET_VERSION_INIT})
        endif()

        set(MSVC_VS_INSTALLDIR "${programfilesx86}/Microsoft Visual Studio/${MSVC_TOOLSET_VERNAME}/Professional")   

        if (NOT DEFINED ENV{VCToolsVersion})
      
            string(SUBSTRING ${MSVC_TOOLSET_VERSION} 0 2 MSVC_TOOLSET_VERMAJOR)
            string(SUBSTRING ${MSVC_TOOLSET_VERSION} 2 1 MSVC_TOOLSET_VERMINOR)

            #  string(REGEX MATCH "^${MSVC_TOOLSET_VERMAJOR}\\.${MSVC_TOOLSET_VERMINOR}([0-9])*(\\.[0-9]+)*" ztmp_re ${ztmp_sdkver})            
            SUBDIRMATCH(MSVC_VCTOOLS_VERSION "^(${MSVC_TOOLSET_VERMAJOR}\\.${MSVC_TOOLSET_VERMINOR})([0-9])*(\\.[0-9]+)*" "${MSVC_VS_INSTALLDIR}/VC/Tools/MSVC")
            SUBDIRLIST(ztmp_dirlist "${MSVC_VS_INSTALLDIR}/VC/Tools/MSVC")

            #set(CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION ${MSVC_WINDOWS_KITS_VERSION})
            #set(ENV{WindowsSDKVersion} ${MSVC_WINDOWS_KITS_VERSION})

            set(MSVC_VCTOOLS_INSTALLDIR "${MSVC_VS_INSTALLDIR}/VC/Tools/MSVC/${MSVC_VCTOOLS_VERSION}")   
        else()
            set(MSVC_VCTOOLS_VERSION $ENV{VCToolsVersion})
            set(MSVC_VCTOOLS_INSTALLDIR "${MSVC_VS_INSTALLDIR}/VC/Tools/MSVC/$ENV{VCToolsVersion}")   
        endif()

        if (DEFINED VCPKG_TRACE_TOOLCHAIN)
            message(STATUS "${MSVC_TOOLSET_VERMAJOR}.${MSVC_TOOLSET_VERMINOR}"  "match :: " "${MSVC_VCTOOLS_VERSION} in  ${MSVC_VCTOOLS_INSTALLDIR}")
        endif()

    else()
        #
        cmake_path(SET MSVC_VCTOOLS_INSTALLDIR NORMALIZE $ENV{VCToolsInstallDir})
       
        string(FIND ${MSVC_VCTOOLS_INSTALLDIR} "/VC/Tools/MSVC/" ztmp_findpos)
        if(NOT ztmp_findpos EQUAL -1)
            string(SUBSTRING ${MSVC_VCTOOLS_INSTALLDIR} 0 ztmp_findpos MSVC_VS_INSTALLDIR)
            string(SUBSTRING ${MSVC_VCTOOLS_INSTALLDIR} ztmp_findpos+15 -1 MSVC_VCTOOLS_VERSION)
        endif()


        string(REGEX MATCH "([0-9]+)(\\.[0-9]+)+" ztmp_re ${MSVC_VCTOOLS_VERSION})
        set(MSVC_VCTOOLS_VERSION ${ztmp_re})

        string(REGEX MATCH "([0-9]+)\\.([0-9])" ztmp_re ${MSVC_VCTOOLS_VERSION})
        set(MSVC_TOOLSET_VERMAJOR ${CMAKE_MATCH_1})
        set(MSVC_TOOLSET_VERMINOR ${CMAKE_MATCH_2})
        set(MSVC_TOOLSET_VERSION "${MSVC_TOOLSET_VERMAJOR}${MSVC_TOOLSET_VERMINOR}")

        #string(REGEX MATCH "^[a-zA-Z]/"MSVC_VS_INSTALLDIR ${MSVC_VCTOOLS_INSTALLDIR})

        message(STATUS "${MSVC_TOOLSET_VERMAJOR}.${MSVC_TOOLSET_VERMINOR}"  "match :: " "${MSVC_VCTOOLS_VERSION} in  ${MSVC_VS_INSTALLDIR}")
    endif()


else()
    cmake_path(SET MSVC_VS_INSTALLDIR NORMALIZE $ENV{VSINSTALLDIR})

    if (NOT DEFINED ENV{VCToolsInstallDir})

        if (NOT DEFINED ENV{VisualStudioVersion})

            string(REGEX MATCH "([0-9]+)/" ztmp_re ${MSVC_VS_INSTALLDIR})
            set(MSVC_TOOLSET_VERNAME ${CMAKE_MATCH_1})

            if (${MSVC_TOOLSET_VERNAME} STREQUAL "2022")
                set(MSVC_TOOLSET_VERSION_INIT "143")
            elseif(${MSVC_TOOLSET_VERNAME} STREQUAL "2019")
                set(MSVC_TOOLSET_VERSION_INIT "142")
            elseif(${MSVC_TOOLSET_VERNAME} STREQUAL "2017")
                set(MSVC_TOOLSET_VERSION_INIT "141")
            elseif(${MSVC_TOOLSET_VERNAME} STREQUAL "2015")
                set(MSVC_TOOLSET_VERSION_INIT "140")
            elseif(${MSVC_TOOLSET_VERNAME} STREQUAL "2013")
                set(MSVC_TOOLSET_VERSION_INIT "120")
            else()
                set(MSVC_TOOLSET_VERNAME "2019")
                set(MSVC_TOOLSET_VERSION_INIT "142")
            endif()

            set(MSVC_TOOLSET_VERSION ${MSVC_TOOLSET_VERSION_INIT})

        else()
            if ($ENV{VisualStudioVersion} STREQUAL "16.0")
                set(MSVC_TOOLSET_VERNAME "2019")
                set(MSVC_TOOLSET_VERSION_INIT "142")
            elseif($ENV{VisualStudioVersion} STREQUAL "17.0")
                set(MSVC_TOOLSET_VERNAME "2022")
                set(MSVC_TOOLSET_VERSION_INIT "143")
            elseif($ENV{VisualStudioVersion} STREQUAL "15.0")
                set(MSVC_TOOLSET_VERNAME "2017")
                set(MSVC_TOOLSET_VERSION_INIT "141")
            elseif($ENV{VisualStudioVersion} STREQUAL "14.0")
                set(MSVC_TOOLSET_VERNAME "2015")
                set(MSVC_TOOLSET_VERSION_INIT "140")
            elseif($ENV{VisualStudioVersion} STREQUAL "12.0")
                set(MSVC_TOOLSET_VERNAME "2013")
                set(MSVC_TOOLSET_VERSION_INIT "120")
            else()
                set(MSVC_TOOLSET_VERNAME "2019")
                set(MSVC_TOOLSET_VERSION_INIT "142")
            endif()

            if (NOT DEFINED MSVC_TOOLSET_VERSION)
                set(MSVC_TOOLSET_VERSION ${MSVC_TOOLSET_VERSION_INIT})
            endif()

        endif()


        if (NOT DEFINED ENV{VCToolsVersion})
      
            string(SUBSTRING ${MSVC_TOOLSET_VERSION} 0 2 MSVC_TOOLSET_VERMAJOR)
            string(SUBSTRING ${MSVC_TOOLSET_VERSION} 2 1 MSVC_TOOLSET_VERMINOR)

            #  string(REGEX MATCH "^${MSVC_TOOLSET_VERMAJOR}\\.${MSVC_TOOLSET_VERMINOR}([0-9])*(\\.[0-9]+)*" ztmp_re ${ztmp_sdkver})            
            SUBDIRMATCH(MSVC_VCTOOLS_VERSION "^(${MSVC_TOOLSET_VERMAJOR}\\.${MSVC_TOOLSET_VERMINOR})([0-9])*(\\.[0-9]+)*" "${MSVC_VS_INSTALLDIR}/VC/Tools/MSVC")
            SUBDIRLIST(ztmp_dirlist "${MSVC_VS_INSTALLDIR}/VC/Tools/MSVC")

            #set(CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION ${MSVC_WINDOWS_KITS_VERSION})
            #set(ENV{WindowsSDKVersion} ${MSVC_WINDOWS_KITS_VERSION})

            set(MSVC_VCTOOLS_INSTALLDIR "${MSVC_VS_INSTALLDIR}/VC/Tools/MSVC/$ENV{MSVC_VCTOOLS_VERSION}")   
        else()
            set(MSVC_VCTOOLS_VERSION $ENV{VCToolsVersion})
            set(MSVC_VCTOOLS_INSTALLDIR "${MSVC_VS_INSTALLDIR}/VC/Tools/MSVC/$ENV{VCToolsVersion}")   
        endif()


        message(STATUS "${MSVC_TOOLSET_VERMAJOR}.${MSVC_TOOLSET_VERMINOR}"  "match :: " "${MSVC_VCTOOLS_VERSION} in  ${MSVC_VS_INSTALLDIR}")

    else()
        #
        cmake_path(SET MSVC_VCTOOLS_INSTALLDIR NORMALIZE $ENV{VCToolsInstallDir})
       
        string(FIND ${MSVC_VCTOOLS_INSTALLDIR} "/VC/Tools/MSVC/" ztmp_findpos)
        if(NOT ztmp_findpos EQUAL -1)
            string(SUBSTRING ${MSVC_VCTOOLS_INSTALLDIR} 0 ztmp_findpos MSVC_VS_INSTALLDIR)
            string(SUBSTRING ${MSVC_VCTOOLS_INSTALLDIR} ztmp_findpos+15 -1 MSVC_VCTOOLS_VERSION)
        endif()


        string(REGEX MATCH "([0-9]+)(\\.[0-9]+)+" ztmp_re ${MSVC_VCTOOLS_VERSION})
        set(MSVC_VCTOOLS_VERSION ${ztmp_re})

        string(REGEX MATCH "([0-9]+)\\.([0-9])" ztmp_re ${MSVC_VCTOOLS_VERSION})
        set(MSVC_TOOLSET_VERMAJOR ${CMAKE_MATCH_1})
        set(MSVC_TOOLSET_VERMINOR ${CMAKE_MATCH_2})
        set(MSVC_TOOLSET_VERSION "${MSVC_TOOLSET_VERMAJOR}${MSVC_TOOLSET_VERMINOR}")

        #string(REGEX MATCH "^[a-zA-Z]/"MSVC_VS_INSTALLDIR ${MSVC_VCTOOLS_INSTALLDIR})

        message(STATUS "VSINSTALLDIR defined ${MSVC_TOOLSET_VERMAJOR}.${MSVC_TOOLSET_VERMINOR}"  "match :: " "${MSVC_VCTOOLS_VERSION} in  ${MSVC_VS_INSTALLDIR}")
    endif()


    set(MSVC_VCTOOLS_INCDIR "${MSVC_VCTOOLS_INSTALLDIR}/include")   
    set(MSVC_VCTOOLS_LIBDIR "${MSVC_VCTOOLS_INSTALLDIR}/lib/x64")   

endif()


# check MSVC_VCTOOLS_VERSION to determine msvc compiler version
string(REGEX MATCH "([0-9]+)\\.([0-9][0-9])" ztmp_re ${MSVC_VCTOOLS_VERSION})
set(MSVC_TOOLSET_VERMAJOR ${CMAKE_MATCH_1})
set(MSVC_TOOLSET_VERMINOR2 ${CMAKE_MATCH_2})

if (${MSVC_TOOLSET_VERMAJOR} STREQUAL "14")
    set(MSVC_VERSION "19${MSVC_TOOLSET_VERMINOR2}" CACHE STRING "MSVC_VERSION")
elseif(${MSVC_TOOLSET_VERMAJOR} STREQUAL "13")
    set(MSVC_VERSION "19${MSVC_TOOLSET_VERMINOR2}" CACHE STRING "MSVC_VERSION")
elseif(${MSVC_TOOLSET_VERMAJOR} STREQUAL "12")
    set(MSVC_VERSION "1800" CACHE STRING "MSVC_VERSION")
elseif(${MSVC_TOOLSET_VERMAJOR} STREQUAL "11")
    set(MSVC_VERSION "1700" CACHE STRING "MSVC_VERSION")
elseif(${MSVC_TOOLSET_VERMAJOR} STREQUAL "10")
    set(MSVC_VERSION "1600" CACHE STRING "MSVC_VERSION")
    elseif(${MSVC_TOOLSET_VERMAJOR} STREQUAL "9")
    set(MSVC_VERSION "1500" CACHE STRING "MSVC_VERSION")        
else()
endif()

# VCPKG_LOAD_VCVARS_ENV false
# VCPKG_VISUAL_STUDIO_PATH
# VCPKG_PLATFORM_TOOLSET

if (${CMAKE_HOST_SYSTEM_PROCESSOR} MATCHES "^AMD64|^amd64|^x64|^X64|^x86_x64|^X86_X64")
    if(${VCPKG_TARGET_ARCHITECTURE} MATCHES "^x64|^X64")
        set(MSVC_TOOLSET_BIN "${CMAKE_VCToolsInstallDir}/bin")
        set(MSVC_TOOLSET_BIN_HOSTX64_X64 "${CMAKE_VCToolsInstallDir}/bin/Hostx64/x64")
    endif()
else()

endif()


# VCToolsVersion
find_program(MSVC_CXX_COMPILER
        NAMES "cl.exe"
        NAMES_PER_DIR
        PATHS ${MSVC_VS_INSTALLDIR}
        PATH_SUFFIXES "x64"
        DOC "MSVC CXX compiler"
        NO_PACKAGE_ROOT_PATH
        NO_CMAKE_PATH
        NO_CMAKE_ENVIRONMENT_PATH
        NO_CMAKE_SYSTEM_PATH
        )


# get sub directories
# SUBDIRLIST(LISTOFDIR ${MSVC_WINDOWS_KITS_DIR})
# message(STATUS "cmake_winkits_dir:: " ${MSVC_WINDOWS_KITS_DIR},, "list of win kits subdirs::" ${LISTOFDIR})


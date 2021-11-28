
#
# CMAKE_WINDOWS_KITS_DIR
# CMAKE_WINDOWS_KITS_VERSION
# CMAKE_VSINSTALLDIR
#
# VC related variables
# CMAKE_VCToolsVersion
# CMAKE_VCToolsInstallDir
# CMAKE_VCIncludeDir
# CMAKE_VCLibDir

# VCPKG_TARGET_ARCHITECTURE x64

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
# set(CMAKE_WINDOWS_KITS_MAJORVER "10")

# message(STATUS "host os :: "  ${CMAKE_HOST_SYSTEM_NAME} ${CMAKE_SYSTEM_VERSION} " sys:: " ${CMAKE_SYSTEM_NAME})
if (WIN32)
    # message(STATUS " we are in Windows!!")
endif()

FILE(TO_CMAKE_PATH "$ENV{ProgramFiles} (x86)" programfilesx86)

if (NOT DEFINED ENV{WindowsSdkDir})
    if (NOT DEFINED CMAKE_WINDOWS_KITS_MAJORVER)
        set(CMAKE_WINDOWS_KITS_MAJORVER "10")
    endif()
    set(CMAKE_WINDOWS_KITS_DIR "${programfilesx86}/Windows Kits/${CMAKE_WINDOWS_KITS_MAJORVER}")

else()
    cmake_path(SET CMAKE_WINDOWS_KITS_DIR NORMALIZE $ENV{WindowsSdkDir})
    #set (CMAKE_WINDOWS_KITS_DIR $ENV{WindowsSdkDir})

endif()

# set()WindowsSDKVersion
if (NOT DEFINED ENV{WindowsSDKVersion})
    set(CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION "")

    SUBDIRLIST(__tmpdirlist "${CMAKE_WINDOWS_KITS_DIR}/Lib")
    # message(STATUS "list of winkits vers :: " "${CMAKE_WINDOWS_KITS_DIR}/Lib" " ==> " ${__tmpdirlist})
    list(SORT __tmpdirlist COMPARE NATURAL ORDER DESCENDING)
    list(GET __tmpdirlist 0 CMAKE_WINDOWS_KITS_VERSION)

    set(CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION ${CMAKE_WINDOWS_KITS_VERSION})
    set(ENV{WindowsSDKVersion} ${CMAKE_WINDOWS_KITS_VERSION})
    # set(CMAKE_WINDOWS_KITS_VERSION )
    # message(STATUS "list of winkits vers :: " ${CMAKE_WINDOWS_KITS_VERSION} "   ==> " $ENV{WindowsSDKVersion})


else()
    cmake_path(SET __tmpsdkver NORMALIZE $ENV{WindowsSDKVersion})
    cmake_path(GET __tmpsdkver PARENT_PATH CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION)
    set(CMAKE_WINDOWS_KITS_VERSION ${CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION})

    # get the major version
    string(REGEX MATCH "([0-9]+)(\\.[0-9]+)*" __tmpre ${__tmpsdkver})
    set(CMAKE_WINDOWS_KITS_MAJORVER ${CMAKE_MATCH_1})

    if (NOT DEFINED ENV{WindowsSdkDir})
        set(CMAKE_WINDOWS_KITS_DIR "${programfilesx86}/Windows Kits/${CMAKE_WINDOWS_KITS_MAJORVER}")        
    endif()

endif()

# set LibDir and IncludeDir for Windows Kits
set(CMAKE_WINDOWS_KITS_INCLUDEDIR "${CMAKE_WINDOWS_KITS_DIR}/Include/${CMAKE_WINDOWS_KITS_VERSION}")
set(CMAKE_WINDOWS_KITS_LIBDIR "${CMAKE_WINDOWS_KITS_DIR}/Lib/${CMAKE_WINDOWS_KITS_VERSION}")
set(CMAKE_WINDOWS_KITS_BINDIR "${CMAKE_WINDOWS_KITS_DIR}/bin/${CMAKE_WINDOWS_KITS_VERSION}")

#cmake_path(GET newversion PARENT_PATH newver1)
message(STATUS "sdkversion:: " ${CMAKE_WINDOWS_KITS_VERSION} " envvar " $ENV{WindowsSDKVersion} "  new ver1:: " ${CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION})


# VCINSTALLDIR VCToolsInstallDir VCToolsVersion 
# VSINSTALLDIR 
# C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional
# MSVC_TOOLSET_VERSION 142
# CMAKE_VS_PLATFORM_TOOLSET v142
# VisualStudioVersion 16.0

#     set(CMAKE_VSINSTALLDIR "${programfilesx86}/Microsoft Visual Studio/2019/Professional")   

# set()WindowsSDKVersion
if (NOT DEFINED ENV{VSINSTALLDIR})
    # set(CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION "")

    if (NOT DEFINED ENV{VCToolsInstallDir})

        if (NOT DEFINED ENV{VisualStudioVersion})
            if (DEFINED CMAKE_VSVERNAME_INIT)
                set(CMAKE_VSVERNAME ${CMAKE_VSVERNAME_INIT})
                set(MSVC_TOOLSET_VERSION_INIT "142")
            else()
                set(CMAKE_VSVERNAME "2019")
                set(MSVC_TOOLSET_VERSION_INIT "142")
            endif()

            set(MSVC_TOOLSET_VERSION ${MSVC_TOOLSET_VERSION_INIT})
            # message(STATUS "VS version: $ENV{VisualStudioVersion}" )
        else()
            if ($ENV{VisualStudioVersion} STREQUAL "16.0")
                set(CMAKE_VSVERNAME "2019")
                set(MSVC_TOOLSET_VERSION_INIT "142")
            elseif($ENV{VisualStudioVersion} STREQUAL "17.0")
                set(CMAKE_VSVERNAME "2022")
                set(MSVC_TOOLSET_VERSION_INIT "143")
            elseif($ENV{VisualStudioVersion} STREQUAL "15.0")
                set(CMAKE_VSVERNAME "2017")
                set(MSVC_TOOLSET_VERSION_INIT "141")
            elseif($ENV{VisualStudioVersion} STREQUAL "14.0")
                set(CMAKE_VSVERNAME "2015")
                set(MSVC_TOOLSET_VERSION_INIT "140")
            elseif($ENV{VisualStudioVersion} STREQUAL "12.0")
                set(CMAKE_VSVERNAME "2013")
                set(MSVC_TOOLSET_VERSION_INIT "120")
            else()
                set(CMAKE_VSVERNAME "2019")
                set(MSVC_TOOLSET_VERSION_INIT "142")
            endif()

            if (NOT DEFINED MSVC_TOOLSET_VERSION)
                set(MSVC_TOOLSET_VERSION ${MSVC_TOOLSET_VERSION_INIT})
            endif()

        endif()

        set(CMAKE_VSINSTALLDIR "${programfilesx86}/Microsoft Visual Studio/${CMAKE_VSVERNAME}/Professional")   

        if (NOT DEFINED ENV{VCToolsVersion})
      
            string(SUBSTRING ${MSVC_TOOLSET_VERSION} 0 2 MSVC_TOOLSET_VERMAJOR)
            string(SUBSTRING ${MSVC_TOOLSET_VERSION} 2 1 MSVC_TOOLSET_VERMINOR)

            #  string(REGEX MATCH "^${MSVC_TOOLSET_VERMAJOR}\\.${MSVC_TOOLSET_VERMINOR}([0-9])*(\\.[0-9]+)*" __tmpre ${__tmpsdkver})            
            SUBDIRMATCH(CMAKE_VCToolsVersion "^(${MSVC_TOOLSET_VERMAJOR}\\.${MSVC_TOOLSET_VERMINOR})([0-9])*(\\.[0-9]+)*" "${CMAKE_VSINSTALLDIR}/VC/Tools/MSVC")
            SUBDIRLIST(__tmpdirlist "${CMAKE_VSINSTALLDIR}/VC/Tools/MSVC")

            #set(CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION ${CMAKE_WINDOWS_KITS_VERSION})
            #set(ENV{WindowsSDKVersion} ${CMAKE_WINDOWS_KITS_VERSION})

            set(CMAKE_VCToolsInstallDir "${CMAKE_VSINSTALLDIR}/VC/Tools/MSVC/${CMAKE_VCToolsVersion}")   
        else()
            set(CMAKE_VCToolsVersion $ENV{VCToolsVersion})
            set(CMAKE_VCToolsInstallDir "${CMAKE_VSINSTALLDIR}/VC/Tools/MSVC/$ENV{VCToolsVersion}")   
        endif()


        message(STATUS "${MSVC_TOOLSET_VERMAJOR}.${MSVC_TOOLSET_VERMINOR}"  "match :: " "${CMAKE_VCToolsVersion} in  ${CMAKE_VSINSTALLDIR}")
        # VCToolsVersion
        find_program(CMAKE_VSCXX_COMPILER
        NAMES "cl.exe"
        NAMES_PER_DIR
        PATHS ${CMAKE_VSINSTALLDIR}
        PATH_SUFFIXES "x64"
        DOC "VCCXX compiler"
        NO_PACKAGE_ROOT_PATH
        NO_CMAKE_PATH
        NO_CMAKE_ENVIRONMENT_PATH
        NO_CMAKE_SYSTEM_PATH
        )
    else()
        #
        cmake_path(SET CMAKE_VCToolsInstallDir NORMALIZE $ENV{VCToolsInstallDir})
       
        string(FIND ${CMAKE_VCToolsInstallDir} "/VC/Tools/MSVC/" __findpos)
        if(NOT __findpos EQUAL -1)
            string(SUBSTRING ${CMAKE_VCToolsInstallDir} 0 __findpos CMAKE_VSINSTALLDIR)
            string(SUBSTRING ${CMAKE_VCToolsInstallDir} __findpos+15 -1 CMAKE_VCToolsVersion)
        endif()


        string(REGEX MATCH "([0-9]+)(\\.[0-9]+)+" __tmpre ${CMAKE_VCToolsVersion})
        set(CMAKE_VCToolsVersion ${__tmpre})

        string(REGEX MATCH "([0-9]+)\\.([0-9])" __tmpre ${CMAKE_VCToolsVersion})
        set(MSVC_TOOLSET_VERMAJOR ${CMAKE_MATCH_1})
        set(MSVC_TOOLSET_VERMINOR ${CMAKE_MATCH_2})
        set(MSVC_TOOLSET_VERSION "${MSVC_TOOLSET_VERMAJOR}${MSVC_TOOLSET_VERMINOR}")

        #string(REGEX MATCH "^[a-zA-Z]/"CMAKE_VSINSTALLDIR ${CMAKE_VCToolsInstallDir})

        message(STATUS "${MSVC_TOOLSET_VERMAJOR}.${MSVC_TOOLSET_VERMINOR}"  "match :: " "${CMAKE_VCToolsVersion} in  ${CMAKE_VSINSTALLDIR}")
    endif()


else()
    cmake_path(SET CMAKE_VSINSTALLDIR NORMALIZE $ENV{VSINSTALLDIR})

    if (NOT DEFINED ENV{VCToolsInstallDir})

        if (NOT DEFINED ENV{VisualStudioVersion})

            string(REGEX MATCH "([0-9]+)/" __tmpre ${CMAKE_VSINSTALLDIR})
            set(CMAKE_VSVERNAME ${CMAKE_MATCH_1})

            if (${CMAKE_VSVERNAME} STREQUAL "2022")
                set(MSVC_TOOLSET_VERSION_INIT "143")
            elseif(${CMAKE_VSVERNAME} STREQUAL "2019")
                set(MSVC_TOOLSET_VERSION_INIT "142")
            elseif(${CMAKE_VSVERNAME} STREQUAL "2017")
                set(MSVC_TOOLSET_VERSION_INIT "141")
            elseif(${CMAKE_VSVERNAME} STREQUAL "2015")
                set(MSVC_TOOLSET_VERSION_INIT "140")
            elseif(${CMAKE_VSVERNAME} STREQUAL "2013")
                set(MSVC_TOOLSET_VERSION_INIT "120")
            else()
                set(CMAKE_VSVERNAME "2019")
                set(MSVC_TOOLSET_VERSION_INIT "142")
            endif()

            set(MSVC_TOOLSET_VERSION ${MSVC_TOOLSET_VERSION_INIT})

        else()
            if ($ENV{VisualStudioVersion} STREQUAL "16.0")
                set(CMAKE_VSVERNAME "2019")
                set(MSVC_TOOLSET_VERSION_INIT "142")
            elseif($ENV{VisualStudioVersion} STREQUAL "17.0")
                set(CMAKE_VSVERNAME "2022")
                set(MSVC_TOOLSET_VERSION_INIT "143")
            elseif($ENV{VisualStudioVersion} STREQUAL "15.0")
                set(CMAKE_VSVERNAME "2017")
                set(MSVC_TOOLSET_VERSION_INIT "141")
            elseif($ENV{VisualStudioVersion} STREQUAL "14.0")
                set(CMAKE_VSVERNAME "2015")
                set(MSVC_TOOLSET_VERSION_INIT "140")
            elseif($ENV{VisualStudioVersion} STREQUAL "12.0")
                set(CMAKE_VSVERNAME "2013")
                set(MSVC_TOOLSET_VERSION_INIT "120")
            else()
                set(CMAKE_VSVERNAME "2019")
                set(MSVC_TOOLSET_VERSION_INIT "142")
            endif()

            if (NOT DEFINED MSVC_TOOLSET_VERSION)
                set(MSVC_TOOLSET_VERSION ${MSVC_TOOLSET_VERSION_INIT})
            endif()

        endif()


        if (NOT DEFINED ENV{VCToolsVersion})
      
            string(SUBSTRING ${MSVC_TOOLSET_VERSION} 0 2 MSVC_TOOLSET_VERMAJOR)
            string(SUBSTRING ${MSVC_TOOLSET_VERSION} 2 1 MSVC_TOOLSET_VERMINOR)

            #  string(REGEX MATCH "^${MSVC_TOOLSET_VERMAJOR}\\.${MSVC_TOOLSET_VERMINOR}([0-9])*(\\.[0-9]+)*" __tmpre ${__tmpsdkver})            
            SUBDIRMATCH(CMAKE_VCToolsVersion "^(${MSVC_TOOLSET_VERMAJOR}\\.${MSVC_TOOLSET_VERMINOR})([0-9])*(\\.[0-9]+)*" "${CMAKE_VSINSTALLDIR}/VC/Tools/MSVC")
            SUBDIRLIST(__tmpdirlist "${CMAKE_VSINSTALLDIR}/VC/Tools/MSVC")

            #set(CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION ${CMAKE_WINDOWS_KITS_VERSION})
            #set(ENV{WindowsSDKVersion} ${CMAKE_WINDOWS_KITS_VERSION})

            set(CMAKE_VCToolsInstallDir "${CMAKE_VSINSTALLDIR}/VC/Tools/MSVC/$ENV{CMAKE_VCToolsVersion}")   
        else()
            set(CMAKE_VCToolsVersion $ENV{VCToolsVersion})
            set(CMAKE_VCToolsInstallDir "${CMAKE_VSINSTALLDIR}/VC/Tools/MSVC/$ENV{VCToolsVersion}")   
        endif()


        message(STATUS "${MSVC_TOOLSET_VERMAJOR}.${MSVC_TOOLSET_VERMINOR}"  "match :: " "${CMAKE_VCToolsVersion} in  ${CMAKE_VSINSTALLDIR}")

    else()
        #
        cmake_path(SET CMAKE_VCToolsInstallDir NORMALIZE $ENV{VCToolsInstallDir})
       
        string(FIND ${CMAKE_VCToolsInstallDir} "/VC/Tools/MSVC/" __findpos)
        if(NOT __findpos EQUAL -1)
            string(SUBSTRING ${CMAKE_VCToolsInstallDir} 0 __findpos CMAKE_VSINSTALLDIR)
            string(SUBSTRING ${CMAKE_VCToolsInstallDir} __findpos+15 -1 CMAKE_VCToolsVersion)
        endif()


        string(REGEX MATCH "([0-9]+)(\\.[0-9]+)+" __tmpre ${CMAKE_VCToolsVersion})
        set(CMAKE_VCToolsVersion ${__tmpre})

        string(REGEX MATCH "([0-9]+)\\.([0-9])" __tmpre ${CMAKE_VCToolsVersion})
        set(MSVC_TOOLSET_VERMAJOR ${CMAKE_MATCH_1})
        set(MSVC_TOOLSET_VERMINOR ${CMAKE_MATCH_2})
        set(MSVC_TOOLSET_VERSION "${MSVC_TOOLSET_VERMAJOR}${MSVC_TOOLSET_VERMINOR}")

        #string(REGEX MATCH "^[a-zA-Z]/"CMAKE_VSINSTALLDIR ${CMAKE_VCToolsInstallDir})

        message(STATUS "VSINSTALLDIR defined ${MSVC_TOOLSET_VERMAJOR}.${MSVC_TOOLSET_VERMINOR}"  "match :: " "${CMAKE_VCToolsVersion} in  ${CMAKE_VSINSTALLDIR}")
    endif()


    set(CMAKE_VCIncludeDir "${CMAKE_VCToolsInstallDir}/include")   
    set(CMAKE_VCLibDir "${CMAKE_VCToolsInstallDir}/lib/x64")   

endif()


# check CMAKE_VCToolsVersion to determine msvc compiler version
string(REGEX MATCH "([0-9]+)\\.([0-9][0-9])" __tmpre ${CMAKE_VCToolsVersion})
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

# get sub directories
# SUBDIRLIST(LISTOFDIR ${CMAKE_WINDOWS_KITS_DIR})
# message(STATUS "cmake_winkits_dir:: " ${CMAKE_WINDOWS_KITS_DIR},, "list of win kits subdirs::" ${LISTOFDIR})


# Install script for directory: /home/rime/apache-parquet-cpp-1.0.0/src/parquet/column

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "DEBUG")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

if(NOT CMAKE_INSTALL_COMPONENT OR "${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified")
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/parquet/column" TYPE FILE FILES
    "/home/rime/apache-parquet-cpp-1.0.0/src/parquet/column/levels.h"
    "/home/rime/apache-parquet-cpp-1.0.0/src/parquet/column/page.h"
    "/home/rime/apache-parquet-cpp-1.0.0/src/parquet/column/properties.h"
    "/home/rime/apache-parquet-cpp-1.0.0/src/parquet/column/reader.h"
    "/home/rime/apache-parquet-cpp-1.0.0/src/parquet/column/scan-all.h"
    "/home/rime/apache-parquet-cpp-1.0.0/src/parquet/column/scanner.h"
    "/home/rime/apache-parquet-cpp-1.0.0/src/parquet/column/writer.h"
    "/home/rime/apache-parquet-cpp-1.0.0/src/parquet/column/statistics.h"
    )
endif()


# Install script for directory: /home/rime/apache-parquet-cpp-1.0.0/src/parquet/util

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
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include/parquet/util" TYPE FILE FILES
    "/home/rime/apache-parquet-cpp-1.0.0/src/parquet/util/bit-stream-utils.h"
    "/home/rime/apache-parquet-cpp-1.0.0/src/parquet/util/bit-stream-utils.inline.h"
    "/home/rime/apache-parquet-cpp-1.0.0/src/parquet/util/bit-util.h"
    "/home/rime/apache-parquet-cpp-1.0.0/src/parquet/util/buffer-builder.h"
    "/home/rime/apache-parquet-cpp-1.0.0/src/parquet/util/compiler-util.h"
    "/home/rime/apache-parquet-cpp-1.0.0/src/parquet/util/cpu-info.h"
    "/home/rime/apache-parquet-cpp-1.0.0/src/parquet/util/hash-util.h"
    "/home/rime/apache-parquet-cpp-1.0.0/src/parquet/util/logging.h"
    "/home/rime/apache-parquet-cpp-1.0.0/src/parquet/util/macros.h"
    "/home/rime/apache-parquet-cpp-1.0.0/src/parquet/util/memory.h"
    "/home/rime/apache-parquet-cpp-1.0.0/src/parquet/util/rle-encoding.h"
    "/home/rime/apache-parquet-cpp-1.0.0/src/parquet/util/stopwatch.h"
    "/home/rime/apache-parquet-cpp-1.0.0/src/parquet/util/sse-util.h"
    "/home/rime/apache-parquet-cpp-1.0.0/src/parquet/util/visibility.h"
    )
endif()


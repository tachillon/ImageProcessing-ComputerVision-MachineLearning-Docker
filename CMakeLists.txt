cmake_minimum_required(VERSION 3.2)

project(hello_world VERSION 1.0.0)

# Be nice to visual studio
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# Be nice and export compile commands by default, this is handy for clang-tidy
# and for other tools.
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

if(NOT CMAKE_BUILD_TYPE)
  SET(CMAKE_BUILD_TYPE Release)
endif()

OPTION(WITH_CUDA "Enable CUDA support" OFF) # Disabled by default
IF(WITH_CUDA)
    ADD_DEFINITIONS(-DUSE_CUDA)
ENDIF()

SET(CMAKE_CXX_FLAGS "-Wall -Wextra")
SET(CMAKE_CXX_FLAGS_DEBUG "-g -O0")
SET(CMAKE_CXX_FLAGS_RELEASE "-O3 -msse -msse2 -msse3")
SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -pthread -fopenmp")

set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

add_subdirectory(src)

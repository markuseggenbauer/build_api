![build](https://github.com/markuseggenbauer/build_api/actions/workflows/build.yaml/badge.svg)

# build_api
Packages supporting ([CMake](https://cmake.org)-based) C++ building.

CMake is a versatile build configuration generator 
providing a rich but low-level feature set
which leaves the user 
a high degree of control 
on the build process. 


Large projects require consistency 
within their code base. 
This covers management of build dependencies as well. 
This repository contains packages 
which provide a higher level descriptive API (CMake functions) 
for defining your C++ build dependencies.

## me_find_package
Advanced package dependency resolution - a CMake find_package() wrapper.

## me_build
Package for descriptive definition of build artifacts for component-based software projects.

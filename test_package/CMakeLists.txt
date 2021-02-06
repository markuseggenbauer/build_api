cmake_minimum_required(VERSION 3.1)
project(PackageTest CXX)

find_package(build_api)

me_add_implementation_unit(example)
me_add_unittest(example SOURCES example.cpp)

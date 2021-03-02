import os

from conans import ConanFile, CMake, tools

class MePackageTestConan(ConanFile):
    generators = "cmake_find_package"

    def build(self):
        cmake = CMake(self)
        cmake.configure()
        cmake.build()

    def test(self):
        return True

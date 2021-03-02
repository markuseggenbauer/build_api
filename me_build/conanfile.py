from conans import ConanFile, CMake, tools


class MeBuildConan(ConanFile):
    name = "me_build"
    version = "1.0"
    license = "MIT License"
    author = "Markus Eggenbauer markus.eggenbauer@gmail.com"
    url = "https://github.com/markuseggenbauer/build_api"
    description = "A cmake adapter for component based C++ software building"
    topics = ("C++", "build", "component", "cmake")
    exports_sources = "cmake/*"

    def package(self):
        self.copy("*.*", dst="cmake", src="cmake")

    def package_info(self):
        self.cpp_info.builddirs = ["cmake"]

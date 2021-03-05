from conans import ConanFile, CMake, tools


class MePackageConan(ConanFile):
    name = "me_package"
    version = "main"
    license = "MIT License"
    author = "Markus Eggenbauer markus.eggenbauer@gmail.com"
    url = "https://github.com/markuseggenbauer/build_api.git", "me_package"
    description = "Enhanced cmake find_package feature."
    topics = ("C++", "build", "component", "cmake")
    exports_sources = "cmake/*"

    def package(self):
        self.copy("*.*", dst="cmake", src="cmake")

    def package_info(self):
        self.cpp_info.builddirs = ["cmake"]

from conans import ConanFile, CMake, tools


class BuildApiConan(ConanFile):
    name = "build_api"
    version = "0.1"
    license = "MIT License"
    author = "Markus Eggenbauer markus.eggenbauer@gmail.com"
    url = "https://github.com/markuseggenbauer/build_api"
    description = "A cmake adapter for component based C++ software building"
    topics = ("C++", "build", "component")

    def source(self):
        git = tools.Git(folder="build_api")
        git.clone("https://github.com/markuseggenbauer/build_api.git", "main")

    def package(self):
        self.copy("*.cmake", dst="cmake", src="cmake")
        self.copy("*.cpp", dst="cmake", src="cmake")

    def package_info(self):
        self.cpp_info.libs = ["build_api"]
        self.cpp_info.includedirs = ['.']
        self.cpp_info.build_modules.append("me_build_api.cmake")
        self.cpp_info.builddirs = ["cmake"]

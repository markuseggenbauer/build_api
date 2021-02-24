from conans import ConanFile, CMake, tools


class BuildApiConan(ConanFile):
    name = "build_api"
    version = "1.0"
    license = "MIT License"
    author = "Markus Eggenbauer markus.eggenbauer@gmail.com"
    url = "https://github.com/markuseggenbauer/build_api"
    description = "A cmake adapter for component based C++ software building"
    topics = ("C++", "build", "component")

    def source(self):
        git = tools.Git()
        git.clone("https://github.com/markuseggenbauer/build_api.git", "main")

    def package(self):
        self.copy("*.*", dst="cmake", src="cmake")

    def package_info(self):
        self.cpp_info.libs = ["build_api"]
        self.cpp_info.includedirs = ['.']
        self.cpp_info.build_modules.append("cmake/me_build_api.cmake")
        self.cpp_info.builddirs = ["cmake"]

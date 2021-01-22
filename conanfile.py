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
        self.run("git clone https://github.com/markuseggenbauer/build_api.git; cd build_api; git checkout conan_testing")

    def build(self):
        cmake = CMake(self)
        cmake.configure(source_folder="build_api")
        cmake.build()

    def package(self):
        self.copy("*.cmake", dst="", src="cmake/bin")
        self.copy("*.cpp", dst="", src="cmake/bin")

    def package_info(self):
        self.cpp_info.libs = ["build_api"]
        self.cpp_info.includedirs = ['.']
        self.cpp_info.build_modules.append("me_build_api.cmake")

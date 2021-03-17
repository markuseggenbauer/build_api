from conans import ConanFile, CMake, tools


class MeFindPackageConan(ConanFile):
    scm = {
        "type": "git",
        "url" : "auto",
        "subfolder" : "me_build",
        "revision" : "auto",
        "password" : os.environ.get("SCM_SECRET", None)
    }    
    name = "me_find_package"
    version = "main"
    license = "MIT License"
    author = "Markus Eggenbauer markus.eggenbauer@gmail.com"
    url = "https://github.com/markuseggenbauer/build_api.git", "me_find_package"
    description = "Enhanced cmake find_package feature."
    topics = ("C++", "build", "component", "cmake")
    exports_sources = "cmake/*"

    def package(self):
        self.copy("*.*", dst="cmake", src="cmake")

    def package_info(self):
        self.cpp_info.builddirs = ["cmake"]

import os
from conans import ConanFile, CMake, tools


class MeFindPackageConan(ConanFile):
    scm = {
        "type": "git",
        "url" : "auto",
        "subfolder" : "me_find_package",
        "revision" : "auto",
        "password" : os.environ.get("SCM_SECRET", None)
    }    
    name = "me_find_package"
    license = "MIT License"
    author = "Markus Eggenbauer markus.eggenbauer@gmail.com"
    url = "https://github.com/markuseggenbauer/build_api.git"
    description = "Enhanced cmake find_package feature."
    topics = ("C++", "build", "component", "cmake")
    exports_sources = "cmake/*"

    def set_version(self):
        git = tools.Git(folder=self.recipe_folder)
        self.version = "%s" % (git.get_tag() or git.get_branch())

    def package(self):
        self.copy("*.*", dst="cmake", src="cmake")

    def package_info(self):
        self.cpp_info.builddirs = ["cmake"]

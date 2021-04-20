# me_find_package

Macro me_find_package() has the same syntax as original 
[find_package()](https://cmake.org/cmake/help/latest/command/find_package.html) but uses additional 
CMake cache package meta-data (see below).
The macro me_find_package(<package_name>) performs the following tasks:

If CMake cache meta-data for the \<package_name\> exists, and folder 
${CMAKE_CURRENT_LIST_DIR}/sources/\<repository-name\>/\<sub_dir\>
exists, then me_find_package() calls add_subdirectory() for the aforementioned directory.

If CMake cache meta-data for the <package_name> exists, and folder 
${CMAKE_CURRENT_LIST_DIR}/sources/\<repository-name\>/\<sub_dir\>
does not exist, then me_find_package() calls find_package() and forwards all arguments.
Additionally, me_find_package() creates a target fetch_source.\<package-name\> which if
built populates ${CMAKE_CURRENT_LIST_DIR}/sources/\<repository-name\>/\<sub_dir\> according to the 
package meta-data. **Only Git repositories are supported.**

If CMake cache meta-data for the \<package_name\> does not exists, 
then me_find_package() calls find_package() and forwards all arguments.

## CMake cache package meta-data
Macro me_find_package() reads and uses the following variables from the CMake cache:

If variable ME_PACKAGE_METADATA_${PACKAGE_NAME}_EXISTS is defined in the CMakeCache,
then me_find_package(<package_name>) expects the following cache variables to be defined 
containing package meta-data:
- ME_PACKAGE_METADATA_<PACKAGE_NAME>_SOURCE: 

    URL of source code Git repository.
- ME_PACKAGE_METADATA_<PACKAGE_NAME>VERSION: 

    Repository version/revision/branch of dependent package.
- ME_PACKAGE_METADATA_<PACKAGE_NAME>SUB_DIR: 

    Sub-directory of package within the repository.

## CMake cache package meta-data auto-population
If your current project uses the [Conan package manager](https://docs.conan.io/en/latest/), 
then the inclusion of the me_find_package module itself populates the CMake cache
with package meta-data for all required packages 
listed in the conanfile of the current project 
if the required package recipe defines 
[Conan package recipe SCM attributes](https://docs.conan.io/en/latest/reference/conanfile/attributes.html#scm).

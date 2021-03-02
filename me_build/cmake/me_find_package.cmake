include_guard(GLOBAL)

function(me_find_package_local package package_dir)
    cmake_parse_arguments(
        "PARAMETER"
        "QUIET;REQUIRED"
        ""
        "OPTIONAL_COMPONENTS;COMPONENTS"
        ${ARGN}
    )

    if(NOT PARAMETER_QUIET)
        me_print(STATUS "Found local package: ${package} in ${package_dir}")
    endif()

    add_subdirectory(${package_dir}/${package})
    if(PARAMETER_COMPONENTS OR PARAMETER_OPTIONAL_COMPONENTS)
        foreach(component IN ITEMS ${PARAMETER_COMPONENTS})
            add_library(${package}::${component} ALIAS ${component})
        endforeach()
        foreach(component IN ITEMS ${PARAMETER_OPTIONAL_COMPONENTS})
            if(TARGET ${component})
                add_library(${package}::${component} ALIAS ${component})
            endif()
        endforeach()
    else()
        if(NOT PARAMETER_QUIET)
            me_print(STATUS "Found local package component: ${package}::${package}")
        endif()
        add_library(${package}::${package} ALIAS ${package})
    endif()
endfunction()

macro(me_find_package package)
    if(EXISTS "${CMAKE_CURRENT_LIST_DIR}/${package}/CMakeLists.txt")
        me_find_package_local(${package} "." ${ARGN})
        # elseif(EXISTS "${CMAKE_CURRENT_LIST_DIR}/../${package}/CMakeLists.txt")
        # me_find_package_local(${package} ".." ${ARGN})
    else()
        me_print(STATUS "No local package: ${package}")
        find_package(${package} ${ARGN})
    endif()
endmacro()

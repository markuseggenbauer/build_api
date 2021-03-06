include_guard(GLOBAL)

find_package(Git)
if(NOT GIT_FOUND)
    message(FATAL_ERROR "Mandatory program 'git' was not found.")
endif()

function(
    me_package_internal_get_package_metadata
    package_name
    out_repo_url
    out_repo_name
    out_sub_dir
    out_version
)
    message(DEBUG "me_package_internal_get_package_metadata(${package_name})")

    string(TOUPPER ${package_name} package_name_upper)
    set(
        ${out_repo_url}
        "$CACHE{ME_PACKAGE_METADATA_${package_name_upper}_SOURCE}"
        PARENT_SCOPE
    )
    string(REGEX REPLACE ".*\/" "" repo_name ${ME_PACKAGE_METADATA_${package_name_upper}_SOURCE})
    string(REGEX REPLACE "\\..*" "" repo_name ${repo_name})
    set(
        ${out_repo_name}
        "${repo_name}"
        PARENT_SCOPE
    )
    set(
        ${out_sub_dir}
        "$CACHE{ME_PACKAGE_METADATA_${package_name_upper}_SUB_DIR}"
        PARENT_SCOPE
    )
    set(
        ${out_version}
        "$CACHE{ME_PACKAGE_METADATA_${package_name_upper}_VERSION}"
        PARENT_SCOPE
    )

    message(DEBUG "me_package_internal_get_package_metadata(${package_name}):")
    message(DEBUG "  out_repo_url=\"$CACHE{ME_PACKAGE_METADATA_${package_name_upper}_SOURCE}\"")
    message(DEBUG "  out_repo_name=\"${repo_name}\"")
    message(DEBUG "  out_sub_dir=\"$CACHE{ME_PACKAGE_METADATA_${package_name_upper}_SUB_DIR}\"")
    message(DEBUG "  out_version=\"$CACHE{ME_PACKAGE_METADATA_${package_name_upper}_VERSION}\"")
endfunction()

function(me_package_internal_find_package_local package_name out_result)
    message(DEBUG "me_package_internal_find_package_local(${package_name})")
    cmake_parse_arguments(
        "PARAMETER"
        "QUIET;REQUIRED"
        ""
        "OPTIONAL_COMPONENTS;COMPONENTS"
        ${ARGN}
    )
    me_package_internal_get_package_metadata(
        ${package_name}
        repo_url
        repo_name
        sub_dir
        version
    )

    set(local_package_dir "$CACHE{ME_PACKAGE_LOCAL_PACKAGE_SOURCE_DIR}/${repo_name}/${sub_dir}")
    set(result FALSE)
    if(EXISTS "${local_package_dir}/CMakeLists.txt")
        message(STATUS "Found local package: ${package_name} in ${local_package_dir}")
        add_subdirectory("${package_dir}" ${package_name})
        if(PARAMETER_COMPONENTS OR PARAMETER_OPTIONAL_COMPONENTS)
            foreach(component IN ITEMS ${PARAMETER_COMPONENTS})
                add_library(${package_name}::${component} ALIAS ${component})
            endforeach()
            foreach(component IN ITEMS ${PARAMETER_OPTIONAL_COMPONENTS})
                if(TARGET ${component})
                    add_library(${package_name}::${component} ALIAS ${component})
                endif()
            endforeach()
        else()
            message(STATUS "Found local package component: ${package_name}::${package_name}")
            if(TARGET ${package_name})
                add_library(${package_name}::${package_name} ALIAS ${package_name})
            endif()
        endif()
        set(result TRUE)
        set(${out_result} TRUE)

    endif()
    message(DEBUG "me_package_internal_find_package_local(${package_name}): ")
    message(DEBUG "  out_result=\"${result}\"")
endfunction()

function(me_package_internal_add_package_source package_name)
    me_package_internal_get_package_metadata(
        ${package_name}
        repo_url
        repo_name
        sub_dir
        version
    )

    if(NOT TARGET fetch_source.all)
        add_custom_target(fetch_source.all)
    endif()

    if(NOT TARGET "fetch_source.${repo_name}")
        add_custom_target(
            "fetch_source.${repo_name}"
            COMMAND "${GIT_EXECUTABLE}" clone "${repo}" -b "${version}"
                    "$CACHE{ME_PACKAGE_LOCAL_PACKAGE_SOURCE_DIR}/${repo_name}"
        )
    endif()

    if(NOT TARGET "fetch_source.${package_name}")
        add_custom_target("fetch_source.${package_name}" DEPENDS "fetch_source.${repo_name}")
        add_dependencies(fetch_source.all "fetch_source.${package_name}")
    endif()
endfunction()

# API
set(me_pkg_mngr "conan")

include(me_package_internal_${me_pkg_mngr})

function(me_package_init)
    message(DEBUG "me_package_init(${ARGV0})")
    if(ARGC EQUAL 0)
        set(ARGV0 "${CMAKE_CURRENT_LIST_DIR}/sources")
    endif()
    set(
        ME_PACKAGE_LOCAL_PACKAGE_SOURCE_DIR
        "${ARGV0}"
        CACHE BOOL "Local package source directory."
    )
    me_package_internal_init()
endfunction()

macro(me_find_package package_name)
    message(DEBUG "me_find_package(${package_name})")
    me_package_internal_find_package_local(${package_name} result ${ARGN})

    if(NOT result)
        find_package(${package_name} ${ARGN})
        me_package_internal_add_package_source(${package_name})
    endif()
endmacro()

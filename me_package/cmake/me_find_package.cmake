include_guard(GLOBAL)

find_program(CONAN_CMD conan)
find_package(Git)

if(CONAN_CMD STREQUAL CONAN-NOTFOUND)
    message(FATAL_ERROR "Mandatory program 'conan' was not found.")
endif()

if(NOT GIT_FOUND)
    message(FATAL_ERROR "Mandatory program 'git' was not found.")
endif()

function(me_conan_get_requires file_path out_packageids)
    file(STRINGS "${file_path}" file_content)
    string(REGEX MATCH "\\[requires\\][^\\[]*" file_content "${file_content}")
    string(REGEX REPLACE "\\[requires\\]" "" file_content "${file_content}")
    list(
        FILTER
        file_content
        EXCLUDE
        REGEX
        "^#.*"
    )
    set(
        ${out_packageids}
        ${file_content}
        PARENT_SCOPE
    )
endfunction()

function(me_conan_write_package_json package_id)
    string(REGEX REPLACE "/.*" "" package_name "${package_id}")
    string(TOLOWER ${package_name} package_name_low)
    execute_process(
        COMMAND "${CONAN_CMD}" inspect ${package_id} --json
                "${CMAKE_BINARY_DIR}/${package_name_low}.config.json" OUTPUT_QUIET
    )
endfunction()

function(me_conan_read_package_json package_name out_json)
    string(TOLOWER ${package_name} package_name_low)
    file(READ "${CMAKE_BINARY_DIR}/${package_name_low}.config.json" file_content)
    set(
        ${out_json}
        "${file_content}"
        PARENT_SCOPE
    )
endfunction()

function(me_package_config_init)
    if(NOT ME_PACKAGES)
        me_conan_get_requires("${CMAKE_CURRENT_LIST_DIR}/conanfile.txt" ME_PACKAGES)
        foreach(package_id IN ITEMS ${ME_PACKAGES})
            me_conan_write_package_json(${package_id})
        endforeach()
        set(
            ME_PACKAGES
            ${ME_PACKAGES}
            PARENT_SCOPE
        )
    endif()
endfunction()

function(me_json_get_value input key output)
    string(FIND "${input}" "\"${key}\": [" find_result)
    if(find_result EQUAL -1)
        string(FIND "${input}" "\"${key}\": \"" find_result)
        if(find_result EQUAL -1)

        else()
            string(REGEX REPLACE ".*\"${key}\": \"" "" tmp "${input}")
            string(REGEX REPLACE "\".*" "" result ${tmp})
        endif()
    else()
        string(REGEX REPLACE ".*\"${key}\": \\[" "" tmp "${input}")
        string(REGEX REPLACE "\\].*" "," tmp "${tmp}")
        string(REGEX MATCHALL "\"[^\"]*\"" tmp "${tmp}")
        string(REPLACE "\"" "" result "${tmp}")
    endif()

    if(result)
        set(
            ${output}
            "${result}"
            PARENT_SCOPE
        )
    endif()

endfunction()

function(
    me_package_get_config
    package_name
    output_version
    output_repo
    output_dir
)
    me_conan_read_package_json(${package_name} json_content)
    me_json_get_value("${json_content}" version version)
    me_json_get_value("${json_content}" url url)

    list(LENGTH url url_size)
    list(GET url 0 repo)

    set(
        ${output_version}
        "${version}"
        PARENT_SCOPE
    )
    set(
        ${output_repo}
        "${repo}"
        PARENT_SCOPE
    )

    if(url_size EQUAL 2)
        list(GET url 1 dir)
        set(
            ${output_dir}
            "${dir}"
            PARENT_SCOPE
        )
    endif()

endfunction()

function(me_find_package_local package_name package_dir)
    cmake_parse_arguments(
        "PARAMETER"
        "QUIET;REQUIRED"
        ""
        "OPTIONAL_COMPONENTS;COMPONENTS"
        ${ARGN}
    )

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
endfunction()

function(me_package_add_fetch_package_source package_name)
    me_package_get_config(${package_name} version repo dir)
    string(REGEX REPLACE ".*\/" "" repo_name ${repo})
    string(REGEX REPLACE "\\..*" "" repo_name ${repo_name})

    if(NOT TARGET fetch_source.all)
        add_custom_target(fetch_source.all)
    endif()

    if(NOT TARGET "fetch_source.${repo_name}")
        add_custom_target(
            "fetch_source.${repo_name}"
            COMMAND "${GIT_EXECUTABLE}" clone "${repo}" -b "${version}" "sources/${repo_name}"
            WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/.."
        )
    endif()

    if(NOT TARGET "fetch_source.${package_name}")
        add_custom_target("fetch_source.${package_name}" DEPENDS "fetch_source.${repo_name}")
        add_dependencies(fetch_source.all "fetch_source.${package_name}")
    endif()
endfunction()

macro(me_find_package package_name)
    me_package_get_config(${package_name} VERSION REPO DIR)
    string(REGEX REPLACE ".*\/" "" repo_name ${REPO})
    string(REGEX REPLACE "\\..*" "" repo_name ${repo_name})

    if(EXISTS "${CMAKE_BINARY_DIR}/../sources/${repo_name}/${DIR}/CMakeLists.txt")
        message(STATUS "Found local package: ${package_name} in ${package_dir}")
        me_find_package_local(
            ${package_name} "${CMAKE_BINARY_DIR}/../sources/${repo_name}/${DIR}" ${ARGN}
        )
    else()
        me_package_add_fetch_package_source(${package_name})
        find_package(${package_name} ${ARGN})
    endif()
endmacro()

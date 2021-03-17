include_guard(GLOBAL)

find_program(CONAN_CMD conan)
if(CONAN_CMD STREQUAL CONAN-NOTFOUND)
    message(FATAL_ERROR "Mandatory program 'conan' was not found.")
endif()

function(me_package_conan_get_required_packages file_path out_packageids)
    file(STRINGS "${file_path}" file_content)
    string(REGEX MATCH "\\[full_requires\\][^\\[]*" file_content "${file_content}")
    string(REGEX REPLACE "\\[full_requires\\]" "" file_content "${file_content}")
    list(TRANSFORM file_content STRIP)
    set(
        ${out_packageids}
        ${file_content}
        PARENT_SCOPE
    )
endfunction()

function(me_package_conan_get_scm_attribute input key output)
    string(REGEX MATCH "${key}: [^ \t\r\n]+" find_result "${input}")
    if(NOT (find_result STREQUAL ""))
        string(REGEX REPLACE "${key}: " "" value "${find_result}")
        set(
            ${output}
            "${value}"
            PARENT_SCOPE
        )
    endif()
endfunction()

function(me_package_conan_populate_package_metadata package_id)
    string(REGEX REPLACE "/.*" "" package_name "${package_id}")
    string(REGEX REPLACE ":.*" "" package_name_version "${package_id}")
    string(TOUPPER ${package_name} package_name_upper)
    execute_process(
        COMMAND "${CONAN_CMD}" inspect "${package_name_version}" -a scm OUTPUT_VARIABLE _scm_data
    )
    me_package_conan_get_scm_attribute(${_scm_data} type _type)
    if(_type STREQUAL "git")
        me_package_conan_get_scm_attribute(${_scm_data} url _url)
        me_package_conan_get_scm_attribute(${_scm_data} revision _revision)
        me_package_conan_get_scm_attribute(${_scm_data} subfolder _subfolder)

        set(
            ME_PACKAGE_METADATA_${package_name_upper}_EXISTS
            TRUE
            CACHE BOOL "Package ${package_name_upper} exists."
        )
        set(
            ME_PACKAGE_METADATA_${package_name_upper}_VERSION
            "${_revision}"
            CACHE STRING "Package ${package_name_upper} version."
        )
        set(
            ME_PACKAGE_METADATA_${package_name_upper}_SOURCE
            "${_url}"
            CACHE STRING "Package ${package_name_upper} source origin"
        )

        if(NOT _subfolder)
            set(_subfolder ".")
        endif()

        set(
            ME_PACKAGE_METADATA_${package_name_upper}_SUB_DIR
            "${_subfolder}"
            CACHE STRING "Package ${package_name_upper} source sub-directory"
        )
    endif()
endfunction()

# me_package_<type> implementation
function(me_package_internal_init)
    if(EXISTS "${CMAKE_BINARY_DIR}/conaninfo.txt")
        me_package_conan_get_required_packages("${CMAKE_BINARY_DIR}/conaninfo.txt" packages)
        foreach(package_id IN ITEMS ${packages})
            me_package_conan_populate_package_metadata(${package_id})
        endforeach()
    endif()
endfunction()

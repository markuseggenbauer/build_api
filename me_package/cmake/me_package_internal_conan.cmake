include_guard(GLOBAL)

find_program(CONAN_CMD conan)
if(CONAN_CMD STREQUAL CONAN-NOTFOUND)
    message(FATAL_ERROR "Mandatory program 'conan' was not found.")
endif()

function(me_package_conan_json_get_value input key output)
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

function(me_package_conan_write_package_json package_id)
    string(REGEX REPLACE "/.*" "" package_name "${package_id}")
    string(REGEX REPLACE ":.*" "" package_name_version "${package_id}")
    string(TOLOWER ${package_name} package_name_lower)
    execute_process(
        COMMAND "${CONAN_CMD}" inspect ${package_name_version} --json
                "${CMAKE_BINARY_DIR}/${package_name_lower}.config.json" OUTPUT_QUIET
    )
endfunction()

function(me_package_conan_read_package_json package_name out_content)
    string(REGEX REPLACE "/.*" "" package_name "${package_id}")
    string(TOLOWER ${package_name} package_name_lower)
    file(READ "${CMAKE_BINARY_DIR}/${package_name_lower}.config.json" file_content)
    set(
        ${out_content}
        "${file_content}"
        PARENT_SCOPE
    )
endfunction()

function(me_package_conan_populate_package_metadate_from_json package_id _json_content)
    string(REGEX REPLACE "/.*" "" package_name "${package_id}")
    string(TOUPPER ${package_name} package_name_upper)

    me_package_conan_json_get_value("${_json_content}" version _version)

    me_package_conan_json_get_value("${_json_content}" url _url)
    list(LENGTH _url _url_size)
    list(GET _url 0 _source)

    if(_url_size EQUAL 2)
        list(GET _url 1 _sub_dir)
    else()
        set(_sub_dir ".")
    endif()

    set(
        ME_PACKAGE_METADATA_${package_name_upper}_EXISTS
        TRUE
        CACHE BOOL "Package ${package_name_upper} exists."
    )
    set(
        ME_PACKAGE_METADATA_${package_name_upper}_VERSION
        "${_version}"
        CACHE STRING "Package ${package_name_upper} version."
    )
    set(
        ME_PACKAGE_METADATA_${package_name_upper}_SOURCE
        "${_source}"
        CACHE STRING "Package ${package_name_upper} source origin"
    )
    set(
        ME_PACKAGE_METADATA_${package_name_upper}_SUB_DIR
        "${_sub_dir}"
        CACHE STRING "Package ${package_name_upper} source sub-directory"
    )

endfunction()

# me_package_<type> implementation
function(me_package_internal_init)
    me_package_conan_get_required_packages("${CMAKE_BINARY_DIR}/conaninfo.txt" packages)
    foreach(package_id IN ITEMS ${packages})
        me_package_conan_write_package_json(${package_id})
        me_package_conan_read_package_json(${package_id} json_content)
        me_package_conan_populate_package_metadate_from_json(${package_id} "${json_content}")
    endforeach()
endfunction()

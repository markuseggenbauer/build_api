include_guard(GLOBAL)

include(me_print)
include(me_internal)
include(me_sanitizers)

function(_me_add_package target)
    cmake_parse_arguments(
        "PARAMETER"
        ""
        "PUBLIC_HEADER_DIR;SOURCE_DIR"
        "PUBLIC_HEADERS;PUBLIC_HEADER_DEPENDS;SOURCES;SOURCE_DEPENDS"
        ${ARGN}
    )

    if(PARAMETER_PUBLIC_HEADER_DEPENDS)
        _me_build_variant_target_converter(
            ${target} PARAMETER_PUBLIC_HEADER_DEPENDS PARAMETER_PUBLIC_HEADER_DEPENDS
        )
    endif()

    if(PARAMETER_SOURCE_DEPENDS)
        _me_build_variant_target_converter(
            ${target} PARAMETER_SOURCE_DEPENDS PARAMETER_SOURCE_DEPENDS
        )
    endif()

    if(PARAMETER_PUBLIC_HEADERS OR PARAMETER_PUBLIC_HEADER_DEPENDS)

        if(NOT PARAMETER_PUBLIC_HEADER_DIR AND PARAMETER_PUBLIC_HEADERS)
            set(PARAMETER_PUBLIC_HEADER_DIR ".")
        endif()

        list(TRANSFORM PARAMETER_PUBLIC_HEADERS PREPEND "${PARAMETER_PUBLIC_HEADER_DIR}/")

        me_print(VERBOSE "  PUBLIC_HEADER_DIR: ${PARAMETER_PUBLIC_HEADER_DIR}")
        me_print_list(LOG_TYPE VERBOSE CAPTION "  PUBLIC_HEADERS:" ${PARAMETER_PUBLIC_HEADERS})
        me_print_list(
            LOG_TYPE VERBOSE CAPTION "  PUBLIC_HEADER_DEPENDS:" ${PARAMETER_PUBLIC_HEADER_DEPENDS}
        )

    endif()

    if(PARAMETER_SOURCES)
        if(NOT PARAMETER_SOURCE_DIR)
            set(PARAMETER_SOURCE_DIR ".")
        endif()

        list(TRANSFORM PARAMETER_SOURCES PREPEND "${PARAMETER_SOURCE_DIR}/")

        me_print(VERBOSE "  SOURCE_DIR: ${PARAMETER_SOURCE_DIR}")
        me_print_list(LOG_TYPE VERBOSE CAPTION "  SOURCES:" ${PARAMETER_SOURCES})
        me_print_list(LOG_TYPE VERBOSE CAPTION "  SOURCE_DEPENDS:" ${PARAMETER_SOURCE_DEPENDS})
    else()
        set(PARAMETER_SOURCES ${ME_CMAKE_SOURCE_DIR}/empty.cpp)
    endif()

    add_library(${target} OBJECT ${PARAMETER_SOURCES})

    if(PARAMETER_PUBLIC_HEADER_DIR)
        target_include_directories(${target} PUBLIC ${PARAMETER_PUBLIC_HEADER_DIR})
    endif()

    if(PARAMETER_SOURCE_DIR)
        target_include_directories(${target} PRIVATE ${PARAMETER_SOURCE_DIR})
    endif()

    if(PARAMETER_PUBLIC_HEADER_DEPENDS)
        target_link_libraries(${target} PUBLIC ${PARAMETER_PUBLIC_HEADER_DEPENDS})
    endif()

    if(PARAMETER_SOURCE_DEPENDS)
        target_link_libraries(${target} PRIVATE ${PARAMETER_SOURCE_DEPENDS})
    endif()

    _me_derive_link_target_property(
        ${target} ${PARAMETER_PUBLIC_HEADER_DEPENDS} ${PARAMETER_SOURCE_DEPENDS}
    )

    set_target_properties(${target} PROPERTIES POSITION_INDEPENDENT_CODE ON)
    set_target_properties(${target} PROPERTIES CXX_STANDARD 17 CXX_STANDARD_REQUIRED ON)

    _me_component_type_check_not(
        ${target} IMPLEMENTATION ${PARAMETER_PUBLIC_HEADER_DEPENDS} ${PARAMETER_SOURCE_DEPENDS}
    )

endfunction()

function(_me_add_implementation_package target)
    cmake_parse_arguments(
        "PARAMETER"
        ""
        "PUBLIC_HEADER_DIR;SOURCE_DIR"
        "PUBLIC_HEADERS;PUBLIC_HEADER_DEPENDS;SOURCES;SOURCE_DEPENDS"
        ${ARGN}
    )
    me_print(STATUS "Implementation-Package: ${target}")

    if(PARAMETER_PUBLIC_HEADER_DEPENDS)
        _me_build_variant_target_converter(
            ${target} PARAMETER_PUBLIC_HEADER_DEPENDS PARAMETER_PUBLIC_HEADER_DEPENDS
        )
    endif()

    if(PARAMETER_SOURCE_DEPENDS)
        _me_build_variant_target_converter(
            ${target} PARAMETER_SOURCE_DEPENDS PARAMETER_SOURCE_DEPENDS
        )
    endif()

    if(
        PARAMETER_PUBLIC_HEADERS
        OR PARAMETER_PUBLIC_HEADER_DIR
        OR PARAMETER_PUBLIC_HEADERS
    )
        me_print(FATAL_ERROR "No PUBLIC_HEADERS must be defined for an implementation unit.")
    endif()

    _me_add_package(${ARGV})
    _me_set_component_type(${target} IMPLEMENTATION)
endfunction()

function(_me_add_composition_package target)
    cmake_parse_arguments(
        "PARAMETER"
        ""
        ""
        "IMPLEMENTS;CONTAINS"
        ${ARGN}
    )

    if(PARAMETER_IMPLEMENTS)
        _me_build_variant_target_converter(${target} PARAMETER_IMPLEMENTS PARAMETER_IMPLEMENTS)
    endif()

    if(PARAMETER_CONTAINS)
        _me_build_variant_target_converter(${target} PARAMETER_CONTAINS PARAMETER_CONTAINS)
    endif()

    me_print(STATUS "Composition-Package: ${target}")
    me_print_list(LOG_TYPE VERBOSE CAPTION "  IMPLEMENTS:" ${PARAMETER_IMPLEMENTS})
    me_print_list(LOG_TYPE VERBOSE CAPTION "  CONTAINS:" ${PARAMETER_CONTAINS})

    add_library(${target} OBJECT ${ME_CMAKE_SOURCE_DIR}/empty.cpp)

    if(PARAMETER_CONTAINS)
        target_link_libraries(${target} PUBLIC ${PARAMETER_IMPLEMENTS})
    endif()

    _me_derive_link_target_property(${target} ${PARAMETER_IMPLEMENTS} ${PARAMETER_CONTAINS})

    _me_set_component_type(${target} INTEGRATION)

    _me_component_type_check_not(${target} IMPLEMENTATION ${PARAMETER_IMPLEMENTS})
    _me_component_type_check_not(${target} INTERFACE ${PARAMETER_CONTAINS})

endfunction()

function(me_add_package target)
    me_print(STATUS "Generic-Package: ${target}")
    _me_invoke_on_each_build_variant(_me_add_package ${target} ${ARGN})
    _me_invoke_on_each_build_variant(_me_set_component_type ${target} GENERIC)
endfunction()

function(me_add_interface_package target)
    me_print(STATUS "Interface-Package: ${target}")
    _me_invoke_on_each_build_variant(_me_add_package ${target} ${ARGN})
    _me_invoke_on_each_build_variant(_me_set_component_type ${target} INTERFACE)
endfunction()

function(me_add_implementation_package target)
    _me_invoke_on_each_build_variant(_me_add_implementation_package ${target} ${ARGN})
endfunction()

function(me_add_composition_package target)
    _me_invoke_on_each_build_variant(_me_add_composition_package ${target} ${ARGN})
endfunction()

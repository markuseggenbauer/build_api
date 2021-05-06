include_guard(GLOBAL)

include(me_print)

function(me_define_build_variant variant_name)
    cmake_parse_arguments(
        "PARAMETER"
        ""
        ""
        "BUILD_PROPERTIES"
        ${ARGN}
    )
    me_print(STATUS "New build-variant: ${variant_name}")

    set(
        ME_BUILD_VARIANT_${variant_name}
        ${PARAMETER_BUILD_PROPERTIES}
        PARENT_SCOPE
    )

    list(APPEND ME_BUILD_VARIANTS ${variant_name})
    set(
        ME_BUILD_VARIANTS
        ${ME_BUILD_VARIANTS}
        PARENT_SCOPE
    )

    add_custom_target(all-${variant_name})
endfunction()

function(_me_invoke_on_each_build_variant function_name target)
    cmake_language(CALL ${function_name} ${target} ${ARGN})
    foreach(variant_name IN ITEMS ${ME_BUILD_VARIANTS})
        cmake_language(CALL ${function_name} ${target}-${variant_name} ${ARGN})
        foreach(build_property IN ITEMS ${ME_BUILD_VARIANT_${variant_name}})
            cmake_language(
                CALL me_build_property_add_to_target_${build_property} ${target}-${variant_name}
            )
        endforeach()
        set_target_properties(
            ${target}-${variant_name} PROPERTIES EXCLUDE_FROM_ALL true OUTPUT_NAME
                                                                       ${variant_name}/${target}
        )
        add_dependencies(all-${variant_name} ${target}-${variant_name})
    endforeach()
endfunction()

function(_me_build_variant_target_converter target output_targets input_targets)
    string(FIND ${target} "-" position REVERSE)
    if(NOT position EQUAL -1)
        string(SUBSTRING ${target} 0 ${position} base_target)
        math(EXPR position "${position}+1")
        string(SUBSTRING ${target} ${position} -1 variant_name)
        foreach(input IN ITEMS ${${input_targets}})
            if(TARGET ${input}-${variant_name})
                list(APPEND result ${input}-${variant_name})
            else()
                list(APPEND result ${input})
            endif()
        endforeach()
    else()
        set(result ${${input_targets}})
    endif()
    set(
        ${output_targets}
        ${result}
        PARENT_SCOPE
    )
endfunction()

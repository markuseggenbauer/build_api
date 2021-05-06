include_guard(GLOBAL)

include(me_print)

find_program(CLANG_TIDY_CMD clang-tidy)

function(me_build_property_add_to_target_ClangTidy target)
    if(CLANG_TIDY_CMD)
        set_target_properties(${target} PROPERTIES CXX_CLANG_TIDY ${CLANG_TIDY_CMD})
    else()
        me_print(STATUS "clang-tidy analysis requested for ${target} but the tool is not available")
    endif()
endfunction()

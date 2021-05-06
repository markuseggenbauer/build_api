include_guard(GLOBAL)

include(me_sanitizers)

function(me_build_property_add_to_target_TSan target)
    add_sanitize_thread(${target})
endfunction()

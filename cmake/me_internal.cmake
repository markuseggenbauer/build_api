include_guard(GLOBAL)

define_property(
  TARGET
  PROPERTY ME_LINK_TARGETS
  BRIEF_DOCS "Transitive link targets."
  FULL_DOCS "List of targets a transitive link dependency exists.")

define_property(
  TARGET
  PROPERTY ME_COMPONENT_TYPE
  BRIEF_DOCS
    "Type of physical component [GENERIC, INTERFACE, INTEGRATION, IMPLEMENTATION]."
  FULL_DOCS
    "Describes what kind of component the target is: GENERIC, INTERFACE, INTEGRATION, IMPLEMENTATION.
    This type is used for consistency checking pof the physical component structure.
    If not set treated like a GENERIC component.")

function(me_derive_link_target_property target)

  foreach(dependency IN ITEMS ${ARGN})

    get_target_property(unit_type ${dependency} TYPE)
    if(unit_type STREQUAL OBJECT_LIBRARY)
      get_property(
        tmp_target_link_dependencies
        TARGET ${dependency}
        PROPERTY ME_LINK_TARGETS)
      list(APPEND target_link_dependencies ${tmp_target_link_dependencies})
    endif()
    list(APPEND target_link_dependencies ${dependency})

  endforeach()

  list(REMOVE_DUPLICATES target_link_dependencies)

  if(target_link_dependencies)
    set_property(
      TARGET ${target}
      APPEND
      PROPERTY ME_LINK_TARGETS ${target_link_dependencies})
  endif()
endfunction()

function(me_set_component_type target type)
  set_property(TARGET ${target} PROPERTY ME_COMPONENT_TYPE ${type})
endfunction()

function(me_component_type_check_not target type)
  # TODO: Warning if any of ${ARGN} is component_type 'type'. This would be a
  # pysical component structure deficit
endfunction()

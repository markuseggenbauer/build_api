include_guard()

function(me_print)
  message(${ARGN})
endfunction()

function(me_print_list)
  cmake_parse_arguments("PARAMETER" "" "LOG_TYPE;LOG_TYPE_ITEM;CAPTION" ""
                        ${ARGN})

  if(NOT PARAMETER_LOG_TYPE)
    set(PARAMETER_LOG_TYPE STATUS)
  endif()

  if(NOT PARAMETER_LOG_TYPE_ITEM)
    set(PARAMETER_LOG_TYPE_ITEM ${PARAMETER_LOG_TYPE})
  endif()

  if(PARAMETER_CAPTION)
    me_print(${PARAMETER_LOG_TYPE} ${PARAMETER_CAPTION})
    list(APPEND CMAKE_MESSAGE_INDENT "* ")
  endif()

  foreach(item IN ITEMS ${PARAMETER_UNPARSED_ARGUMENTS})
    me_print(${PARAMETER_LOG_TYPE_ITEM} "${item}")
  endforeach()
endfunction()

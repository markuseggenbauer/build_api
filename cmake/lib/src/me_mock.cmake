include_guard()

macro(me_mock_trace function_name)
  string(REPLACE ";" "|" _parameters "${ARGN}")
  list(APPEND ME_MOCK_TRACING_RECORD "${function_name}(${_parameters})")
  set(ME_MOCK_TRACING_RECORD
      ${ME_MOCK_TRACING_RECORD}
      PARENT_SCOPE)
  message(TRACE "  !: ${function_name}(${_parameters})")
endmacro()

function(me_mock_expect function_name)
  string(REPLACE ";" "|" _parameters "${ARGN}")
  list(APPEND ME_MOCK_TRACING_EXPECTATION "${function_name}(${_parameters})")
  set(ME_MOCK_TRACING_EXPECTATION
      ${ME_MOCK_TRACING_EXPECTATION}
      PARENT_SCOPE)
  message(TRACE "  ?: ${function_name}(${_parameters})")
endfunction()

function(me_mock_reset)
  set(ME_MOCK_TRACING_RECORD
      ""
      PARENT_SCOPE)
  set(ME_MOCK_TRACING_EXPECTATION
      ""
      PARENT_SCOPE)
endfunction()

function(me_mock_check_expectations)
  if(ME_MOCK_TRACING_RECORD STREQUAL ME_MOCK_TRACING_EXPECTATION)
    message(STATUS "  Success")
  else()
    message(FATAL_ERROR "  Fail")
  endif()
endfunction()
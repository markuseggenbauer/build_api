include_guard(GLOBAL)

function(me_mock_trace function_name)
  string(REPLACE ";" "|" _parameters "${ARGN}")
  set(ENV{ME_MOCK_TRACING_RECORD}
      "$ENV{ME_MOCK_TRACING_RECORD};${function_name}(${_parameters})")
  message(TRACE "  !: ${function_name}(${_parameters})")
endfunction()

function(me_mock_expect function_name)
  string(REPLACE ";" "|" _parameters "${ARGN}")
  set(ENV{ME_MOCK_TRACING_EXPECTATION}
      "$ENV{ME_MOCK_TRACING_EXPECTATION};${function_name}(${_parameters})")
  message(TRACE "  ?: ${function_name}(${_parameters})")
endfunction()

function(me_mock_reset)
  set(ENV{ME_MOCK_TRACING_RECORD})
  set(ENV{ME_MOCK_TRACING_EXPECTATION})
endfunction()

function(me_mock_check_expectations)
  set(TRACING_RECORD $ENV{ME_MOCK_TRACING_RECORD})
  set(TRACING_EXPECTATION $ENV{ME_MOCK_TRACING_EXPECTATION})
  if(TRACING_RECORD STREQUAL TRACING_EXPECTATION)
    message(STATUS "  Success")
  else()
    message(FATAL_ERROR "  Fail")
  endif()
endfunction()

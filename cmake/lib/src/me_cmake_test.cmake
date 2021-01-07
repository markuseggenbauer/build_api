include_guard()

include(me_mock)

function(me_cmake_test_begin testname)
  me_mock_reset()
  message(STATUS "Testing: ${testname}")
endfunction()

function(me_cmake_test_end)
  me_mock_check_expectations()
endfunction()

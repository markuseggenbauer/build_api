include_guard()

function(me_add_cmake_test cmake_file)
  add_test(
    NAME ${cmake_file}
    COMMAND
      ${CMAKE_COMMAND} "--log-level=TRACE"
      "-DCMAKE_MODULE_PATH=${CMAKE_CURRENT_SOURCE_DIR}/../src" "-P"
      "${cmake_file}"
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}")
endfunction()

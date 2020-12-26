add_test(
    NAME TestMePrint
    COMMAND ${CMAKE_COMMAND} -P "unittests_me_print.cmake"
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
)

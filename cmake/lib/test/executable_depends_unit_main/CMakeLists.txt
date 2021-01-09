# Test: executable artifact (no source) with dependency to source unit
me_add_executable(test_executable_depends_unit_main DEPENDS test_unit_main)
add_test(test_executable_depends_unit_main test_executable_depends_unit_main)

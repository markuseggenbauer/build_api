# include DUT
include(${CMAKE_CURRENT_SOURCE_DIR}/../src/me_print.cmake)


# prepare mocks
include(${CMAKE_CURRENT_SOURCE_DIR}/../src/me_mock.cmake)
macro(me_message)
    me_mock_trace(me_message ${ARGN})
endmacro()

# Testcases
# check no caption, items with default log-level
me_mock_expect(me_message STATUS A)
me_mock_expect(me_message STATUS B)
me_mock_expect(me_message STATUS C)

me_print_list(A B C)

me_mock_check_expectations()

# check no caption, items with explicit log-level (STATUS)
me_mock_expect(me_message STATUS A)
me_mock_expect(me_message STATUS B)
me_mock_expect(me_message STATUS C)

me_print_list(LOG_TYPE STATUS A B C)

me_mock_check_expectations()

# check no caption, items with explicit log-level (WARNING)
me_mock_expect(me_message WARNING A)
me_mock_expect(me_message WARNING B)
me_mock_expect(me_message WARNING C)

me_print_list(LOG_TYPE WARNING A B C)

me_mock_check_expectations()

# check with caption, all with default log-level
me_mock_expect(me_message STATUS Caption)
me_mock_expect(me_message STATUS A)
me_mock_expect(me_message STATUS B)
me_mock_expect(me_message STATUS C)

me_print_list(CAPTION Caption A B C)

me_mock_check_expectations()

# check with caption, all with explicit log-level (WARNING)
me_mock_expect(me_message WARNING Caption)
me_mock_expect(me_message WARNING A)
me_mock_expect(me_message WARNING B)
me_mock_expect(me_message WARNING C)

me_print_list(
    CAPTION Caption 
    LOG_TYPE WARNING
    A B C
)

me_mock_check_expectations()

# check with caption, all with explicit log-level (WARNING, VERBOSE)
me_mock_expect(me_message WARNING Caption)
me_mock_expect(me_message VERBOSE A)
me_mock_expect(me_message VERBOSE B)
me_mock_expect(me_message VERBOSE C)

me_print_list(
    CAPTION Caption 
    LOG_TYPE WARNING
    LOG_TYPE_ITEM VERBOSE
    A B C
)

me_mock_check_expectations()

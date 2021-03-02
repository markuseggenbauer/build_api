include(me_print) # include DUT

include(me_cmake_test) # me_cmake_test_*() functions

# prepare mocks
macro(me_print)
    me_mock_trace(me_print ${ARGV})
endmacro()

# Testcases check no caption, items with default log-level
me_cmake_test_begin(test_me_print_list_default_loglevel)

me_mock_expect(me_print STATUS A)
me_mock_expect(me_print STATUS B)
me_mock_expect(me_print STATUS C)

me_print_list(A B C)

me_cmake_test_end()

# check no caption, items with explicit log-level (STATUS)
me_cmake_test_begin(test_me_print_list_status_loglevel)

me_mock_expect(me_print STATUS A)
me_mock_expect(me_print STATUS B)
me_mock_expect(me_print STATUS C)

me_print_list(
    LOG_TYPE
    STATUS
    A
    B
    C
)

me_cmake_test_end()

# check no caption, items with explicit log-level (WARNING)
me_cmake_test_begin(test_me_print_list_warning_loglevel)

me_mock_expect(me_print WARNING A)
me_mock_expect(me_print WARNING B)
me_mock_expect(me_print WARNING C)

me_print_list(
    LOG_TYPE
    WARNING
    A
    B
    C
)

me_cmake_test_end()

# check with caption, all with default log-level
me_cmake_test_begin(test_me_print_list_caption)

me_mock_expect(me_print STATUS Caption)
me_mock_expect(me_print STATUS A)
me_mock_expect(me_print STATUS B)
me_mock_expect(me_print STATUS C)

me_print_list(
    CAPTION
    Caption
    A
    B
    C
)

me_cmake_test_end()

# check with caption, all with explicit log-level (WARNING)
me_cmake_test_begin(test_me_print_list_caption_warning_loglevel)

me_mock_expect(me_print WARNING Caption)
me_mock_expect(me_print WARNING A)
me_mock_expect(me_print WARNING B)
me_mock_expect(me_print WARNING C)

me_print_list(
    CAPTION
    Caption
    LOG_TYPE
    WARNING
    A
    B
    C
)

me_cmake_test_end()

# check with caption, all with explicit log-level (WARNING, VERBOSE)
me_cmake_test_begin(test_me_print_list_caption_warning_loglevel_verbose_itemloglevel)

me_mock_expect(me_print WARNING Caption)
me_mock_expect(me_print VERBOSE A)
me_mock_expect(me_print VERBOSE B)
me_mock_expect(me_print VERBOSE C)

me_print_list(
    CAPTION
    Caption
    LOG_TYPE
    WARNING
    LOG_TYPE_ITEM
    VERBOSE
    A
    B
    C
)

me_cmake_test_end()

# executable from empty unit
me_add_executable(executable_from_empty_unit CONTAINS empty_unit
                  independent_main)

# executable from header unit
me_add_executable(executable_from_header_unit CONTAINS header_dependent_main)

# executable from header/link unit
me_add_executable(executable_from_link_unit CONTAINS link_dependent_main)

# executable from header/link unit
me_add_executable(executable_from_link_unit_1 CONTAINS
                  incomplete_link_dependent_main source_depends_on_subdir)

# executable from component
me_add_executable(executable_from_component_private CONTAINS component_private)

# executable from library
me_add_executable(executable_from_library CONTAINS component_private_library)

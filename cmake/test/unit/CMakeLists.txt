# empty unit
me_add_unit(empty_unit)

# interface only units
me_add_unit(local_directory_single_header_interface_unit INTERFACES
            localdir_1.hpp)

me_add_unit(local_directory_multiple_header_interface_unit INTERFACES
            localdir_1.hpp localdir_2.hpp)

me_add_unit(sub_directory_single_header_interface_unit INTERFACE_DIR inc_subdir
            INTERFACES subdir_1.hpp)

me_add_unit(sub_directory_multiple_header_interface_unit INTERFACE_DIR
            inc_subdir INTERFACES subdir_1.hpp subdir_1.hpp)

# source only units
me_add_unit(local_directory_single_source_headerless_unit SOURCES
            localdir_1_headerless.cpp)

me_add_unit(sub_directory_single_source_headerless_unit SOURCE_DIR src_subdir
            SOURCES subdir_1_headerless.cpp)

# source and interface units
me_add_unit(local_directory_single_source_interface_unit HEADERS localdir_1.hpp
            SOURCES localdir_1.cpp)

me_add_unit(
  local_directory_multiple_source_interface_unit
  INTERFACES
  localdir_1.hpp
  localdir_2.hpp
  SOURCES
  localdir_1.cpp
  localdir_2.cpp)

me_add_unit(
  sub_directory_single_source_interface_unit
  INTERFACE_DIR
  inc_subdir
  INTERFACES
  subdir_1.hpp
  SOURCE_DIR
  src_subdir
  SOURCES
  subdir_1.cpp)

me_add_unit(
  sub_directory_multiple_source_interface_unit
  INTERFACE_DIR
  inc_subdir
  INTERFACES
  subdir_1.hpp
  subdir_2.hpp
  SOURCE_DIR
  src_subdir
  SOURCES
  subdir_1.cpp
  subdir_2.cpp)

# empty unit interface depends on empty unit
me_add_unit(empty_interface_depends_on_empty_unit INTERFACE_DEPENDS empty_unit)

# empty unit source depends on empty unit
me_add_unit(empty_source_depends_on_empty_unit SOURCE_DEPENDS empty_unit)

# interface depends on empty unit
me_add_unit(
  interface_depends_on_empty_unit
  INTERFACE_DEPENDS
  empty_unit
  SOURCE_DIR
  src_dependent
  SOURCES
  no_depends.cpp)

# source depends on empty unit
me_add_unit(
  source_depends_on_empty_unit
  SOURCE_DEPENDS
  empty_unit
  SOURCE_DIR
  src_dependent
  SOURCES
  no_depends.cpp)

# source depends on subdir interface only
me_add_unit(
  source_depends_on_subdir_interface
  SOURCE_DEPENDS
  sub_directory_multiple_header_interface_unit
  SOURCE_DIR
  src_dependent
  SOURCES
  depends_subdir_interface.cpp)

# source depends on subdir
me_add_unit(
  source_depends_on_subdir
  SOURCE_DEPENDS
  sub_directory_multiple_source_interface_unit
  SOURCE_DIR
  src_dependent
  SOURCES
  depends_subdir.cpp)

# interface depends on subdir interface only
me_add_unit(
  interface_depends_on_subdir_interface
  INTERFACE_DEPENDS
  sub_directory_multiple_header_interface_unit
  SOURCE_DIR
  src_dependent
  SOURCES
  depends_subdir_interface.cpp)

# main units
me_add_unit(independent_main SOURCE_DIR src_subdir SOURCES independent_main.cpp)
me_add_unit(
  header_dependent_main
  SOURCE_DIR
  src_subdir
  SOURCES
  header_dependent_main.cpp
  SOURCE_DEPENDS
  sub_directory_single_header_interface_unit)

me_add_unit(
  link_dependent_main
  SOURCE_DIR
  src_subdir
  SOURCES
  link_dependent_main.cpp
  SOURCE_DEPENDS
  sub_directory_multiple_source_interface_unit)

me_add_unit(
  incomplete_link_dependent_main
  SOURCE_DIR
  src_subdir
  SOURCES
  link_dependent_main.cpp
  SOURCE_DEPENDS
  sub_directory_multiple_header_interface_unit)

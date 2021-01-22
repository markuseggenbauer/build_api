file(GLOB cmake_files "*.cmake")
file(GLOB cpp_files "*.cpp")
file(COPY ${cmake_files} DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/bin)
file(COPY ${cpp_files} DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/bin)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_BINARY_DIR}/bin)
list(APPEND CMAKE_PREFIX_PATH ${CMAKE_CURRENT_BINARY_DIR}/bin)
set(ME_CMAKE_SOURCE_DIR ${CMAKE_CURRENT_BINARY_DIR}/bin)

add_subdirectory(test)
add_subdirectory(unittest)

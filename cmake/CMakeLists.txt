file(GLOB cmake_files "*.cmake")
file(GLOB cpp_files "*.cpp")
file(COPY ${cmake_files} DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/bin)
file(COPY ${cpp_files} DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/bin)

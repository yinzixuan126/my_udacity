cmake_minimum_required(VERSION 3.5)
project(hybridAStar)

set(CMAKE_CXX_STANDARD 11)
find_package( PythonLibs 2.7)

set(SOURCE_FILES main.cpp hybrid_breadth_first.h hybrid_breadth_first.cpp matplotlibcpp.h)
add_executable(hybridAStar ${SOURCE_FILES})
target_include_directories( hybridAStar PRIVATE ${PYTHON_INCLUDE_DIRS})
target_link_libraries( hybridAStar ${PYTHON_LIBRARIES})

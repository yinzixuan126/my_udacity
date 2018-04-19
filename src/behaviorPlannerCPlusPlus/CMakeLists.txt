cmake_minimum_required(VERSION 3.5)
project(behaviorPlannerCPlusPlus)

set(CMAKE_CXX_STANDARD 11)

set(SOURCE_FILES main.cpp vehicle.h vehicle.cpp road.h road.cpp)
add_executable(behaviorPlannerCPlusPlus ${SOURCE_FILES})

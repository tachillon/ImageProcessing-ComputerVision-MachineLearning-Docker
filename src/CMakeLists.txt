find_package(Eigen3 REQUIRED NO_MODULE)
find_package(OpenCV REQUIRED)

add_executable(${PROJECT_NAME} main.cpp)
target_link_libraries(${PROJECT_NAME} ${OpenCV_LIBS} ${Eigen3_LIBS})
target_include_directories(${PROJECT_NAME} PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
install (TARGETS ${PROJECT_NAME} DESTINATION bin)
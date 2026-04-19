cmake_minimum_required(VERSION 3.16)
project(SmartTranslator VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 覆盖率测试支持（可选）
option(CODE_COVERAGE "Enable coverage reporting" OFF)
if(CODE_COVERAGE AND CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
  add_compile_options(-O0 -g --coverage)
  add_link_options(--coverage)
endif()

# 跨平台 Qt 查找
if(APPLE)
  set(CMAKE_PREFIX_PATH "/opt/homebrew/opt/qt@5" ${CMAKE_PREFIX_PATH})
endif()

find_package(Qt5 REQUIRED COMPONENTS Core Widgets Network)

find_package(PkgConfig REQUIRED)
pkg_check_modules(TESSERACT REQUIRED tesseract)
pkg_check_modules(YAML_CPP REQUIRED yaml-cpp)
pkg_check_modules(SQLite3 REQUIRED sqlite3)

include_directories(
    ${PROJECT_SOURCE_DIR}/include
    ${TESSERACT_INCLUDE_DIRS}
    ${YAML_CPP_INCLUDE_DIRS}
    ${SQLite3_INCLUDE_DIRS}
)

set(SOURCES
    src/main.cpp
)

add_executable(${PROJECT_NAME} ${SOURCES})

target_link_libraries(${PROJECT_NAME}
    Qt5::Core
    Qt5::Widgets
    Qt5::Network
    ${TESSERACT_LIBRARIES}
    ${YAML_CPP_LIBRARIES}
    ${SQLite3_LIBRARIES}
)

install(TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION bin
)

install(FILES config/config.yaml
    DESTINATION share/${PROJECT_NAME}/
)

# 覆盖率目标（可选）
if(CODE_COVERAGE)
  add_custom_target(coverage
    COMMAND lcov --directory . --capture --output-file coverage.info
    COMMAND lcov --remove coverage.info '/usr/*' --output-file coverage.info.cleaned
    COMMAND genhtml -o coverage coverage.info.cleaned
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
  )
endif()

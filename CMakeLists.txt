cmake_minimum_required(VERSION 3.15)
project(SmartTranslator VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 打印关键路径信息（用于调试）
message(STATUS "CMake version: ${CMAKE_VERSION}")
message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")
message(STATUS "CMake prefix path: ${CMAKE_PREFIX_PATH}")
message(STATUS "CMake module path: ${CMAKE_MODULE_PATH}")

# 查找依赖包（Windows vcpkg / Linux apt / macOS brew）
find_package(Qt5 REQUIRED COMPONENTS Core Widgets)
message(STATUS "Qt5 found at: ${Qt5_DIR}")

find_package(Tesseract REQUIRED)
message(STATUS "Tesseract found: ${Tesseract_DIR}")
message(STATUS "Tesseract include: ${Tesseract_INCLUDE_DIRS}")

find_package(CURL REQUIRED)
message(STATUS "CURL found: ${CURL_DIR}")

find_package(yaml-cpp REQUIRED)
message(STATUS "yaml-cpp found: ${yaml-cpp_DIR}")

find_package(SQLite3 REQUIRED)
message(STATUS "SQLite3 found: ${SQLite3_DIR}")

find_package(GTest REQUIRED)
message(STATUS "GTest found: ${GTest_DIR}")

# 添加可执行文件（示例）
add_executable(smart-translator main.cpp)
target_link_libraries(smart-translator
    Qt5::Core
    Qt5::Widgets
    Tesseract::Tesseract
    CURL::libcurl
    yaml-cpp::yaml-cpp
    SQLite3::SQLite3
    GTest::gtest_main
)

# 启用测试
enable_testing()
add_subdirectory(tests)

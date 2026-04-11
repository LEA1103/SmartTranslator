cmake_minimum_required(VERSION 3.10)
project(smart-translator)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)

# Qt 项目必须开启！否则 macOS 一定会链接错误
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt5 REQUIRED COMPONENTS Core Widgets Gui)

include_directories(include)

file(GLOB_RECURSE SOURCES
    src/*.cpp
    include/*.h
)

add_executable(${PROJECT_NAME} ${SOURCES})

target_link_libraries(${PROJECT_NAME}
    Qt5::Core
    Qt5::Widgets
    Qt5::Gui
)

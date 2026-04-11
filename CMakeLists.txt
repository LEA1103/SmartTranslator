cmake_minimum_required(VERSION 3.10)
project(smart-translator)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 关键：开启自动 moc，避免 Qt 符号缺失
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# 针对 macOS 强制指定架构
if(APPLE)
    set(CMAKE_OSX_ARCHITECTURES "arm64" CACHE STRING "Build for arm64 only")
endif()

find_package(Qt5 REQUIRED COMPONENTS Core Widgets Gui)

file(GLOB_RECURSE SRCS
    src/*.cpp
    include/*.h
)

add_executable(${PROJECT_NAME} ${SRCS})

target_link_libraries(${PROJECT_NAME}
    Qt5::Core
    Qt5::Widgets
    Qt5::Gui
)

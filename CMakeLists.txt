cmake_minimum_required(VERSION 3.10)
project(smart-translator)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)

# 自动处理 Qt 的 MOC 等文件
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# macOS 专属配置：强制指定 Qt 路径
if(APPLE)
    set(CMAKE_PREFIX_PATH "$ENV{Qt5_DIR}")
endif()

# 查找 Qt
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

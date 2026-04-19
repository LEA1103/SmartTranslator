cmake_minimum_required(VERSION 3.16)
project(SmartTranslator VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 仅找 Qt（Windows 简化版）
find_package(Qt5 REQUIRED COMPONENTS Core Widgets Network)

# 源文件
set(SOURCES
    src/main.cpp
)

# 生成 exe
add_executable(${PROJECT_NAME} ${SOURCES})

# 链接 Qt
target_link_libraries(${PROJECT_NAME}
    Qt5::Core
    Qt5::Widgets
    Qt5::Network
)

# 安装规则
install(TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION bin
)

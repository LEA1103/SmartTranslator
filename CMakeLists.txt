cmake_minimum_required(VERSION 3.16)
project(SmartTranslator VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Windows Qt 自动配置
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# 找到Qt5（CI上Choco安装的Qt会自动被识别）
find_package(Qt5 REQUIRED COMPONENTS Core Widgets Network)

# 源文件（只保留main.cpp）
set(SOURCES
    src/main.cpp
)

# 生成Windows可执行文件
add_executable(${PROJECT_NAME} WIN32 ${SOURCES})

# 链接Qt库
target_link_libraries(${PROJECT_NAME}
    Qt5::Core
    Qt5::Widgets
    Qt5::Network
)

# 安装规则（适配NSIS打包）
install(TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION bin
)

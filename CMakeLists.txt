cmake_minimum_required(VERSION 3.16)
project(SmartTranslator VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 关键：开启Qt自动处理（必须！）
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# 找到Qt5（依赖CI传递的CMAKE_PREFIX_PATH）
find_package(Qt5 REQUIRED COMPONENTS Core Widgets Network)

# 源文件
set(SOURCES
    src/main.cpp
)

# 生成Windows可执行文件（WIN32参数避免控制台窗口）
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

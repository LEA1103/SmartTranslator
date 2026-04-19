cmake_minimum_required(VERSION 3.16)
project(SmartTranslator VERSION 1.0.0 LANGUAGES CXX)

# 启用C++17标准
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 找到Qt依赖
find_package(Qt5 REQUIRED COMPONENTS Core Widgets Network)

# 找到其他依赖
find_package(PkgConfig REQUIRED)
pkg_check_modules(TESSERACT REQUIRED tesseract)
pkg_check_modules(YAML_CPP REQUIRED yaml-cpp)
pkg_check_modules(SQLite3 REQUIRED sqlite3)

# 包含目录
include_directories(
    ${PROJECT_SOURCE_DIR}/include
    ${TESSERACT_INCLUDE_DIRS}
    ${YAML_CPP_INCLUDE_DIRS}
    ${SQLite3_INCLUDE_DIRS}
)

# 源文件（后续添加你的源码文件）
set(SOURCES
    src/main.cpp
    # 这里后续添加你的其他.cpp文件
)

# 生成可执行文件
add_executable(${PROJECT_NAME} ${SOURCES})

# 链接依赖库
target_link_libraries(${PROJECT_NAME}
    Qt5::Core
    Qt5::Widgets
    Qt5::Network
    ${TESSERACT_LIBRARIES}
    ${YAML_CPP_LIBRARIES}
    ${SQLite3_LIBRARIES}
)

# 安装规则（和你的打包脚本兼容）
install(TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION bin
)

install(FILES config/config.yaml
    DESTINATION share/${PROJECT_NAME}/
)

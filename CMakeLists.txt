cmake_minimum_required(VERSION 3.16)

# 项目名称（替换为你的实际项目名）
project(SmartTranslator VERSION 1.0 LANGUAGES CXX)

# 设置 C++ 标准
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)

# 自动运行 MOC/RCC/UIC（Qt 必备）
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# 查找 Qt 5 核心模块（根据你的项目需求增减）
find_package(Qt5 REQUIRED COMPONENTS
  Core
  Widgets
  Svg
  Network # 如果用到网络功能添加
)

# 列出你的源码文件（替换为实际文件）
set(SOURCES
  main.cpp
  mainwindow.cpp
  translator.cpp
  mainwindow.ui # UI 文件
  resources.qrc # 资源文件（可选）
)

# 生成可执行程序
add_executable(${PROJECT_NAME} WIN32 ${SOURCES})

# 链接 Qt 库
target_link_libraries(${PROJECT_NAME} PRIVATE
  Qt5::Core
  Qt5::Widgets
  Qt5::Svg
  Qt5::Network # 对应上面的模块
)

# Windows 特有配置（可选）
if(WIN32)
  # 设置程序图标（替换为你的 .rc 文件路径）
  # set_target_properties(${PROJECT_NAME} PROPERTIES WIN32_EXECUTABLE TRUE)
  # target_sources(${PROJECT_NAME} PRIVATE resources.rc)
  
  # 输出目录统一（方便打包）
  set_target_properties(${PROJECT_NAME} PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/$<CONFIG>
  )
endif()

cmake_minimum_required(VERSION 3.16)
project(SmartTranslator VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 跨平台 Qt 查找
if(APPLE)
  set(CMAKE_PREFIX_PATH "/opt/homebrew/opt/qt@5" ${CMAKE_PREFIX_PATH})
endif()

find_package(Qt5 REQUIRED COMPONENTS Core Widgets Network)

# macOS 专用 Tesseract 链接修复
if(APPLE)
  set(TESSERACT_ROOT "/opt/homebrew/opt/tesseract")
  include_directories(${TESSERACT_ROOT}/include)
  link_directories(${TESSERACT_ROOT}/lib)
  set(TESSERACT_LIBRARIES
    ${TESSERACT_ROOT}/lib/libtesseract.5.dylib
    ${TESSERACT_ROOT}/lib/libtesseract.dylib
  )
else()
  find_package(PkgConfig REQUIRED)
  pkg_check_modules(TESSERACT REQUIRED tesseract)
endif()

# 其他依赖
pkg_check_modules(YAML_CPP REQUIRED yaml-cpp)
pkg_check_modules(SQLite3 REQUIRED sqlite3)

# 包含目录
include_directories(
  ${PROJECT_SOURCE_DIR}/include
  ${TESSERACT_INCLUDE_DIRS}
  ${YAML_CPP_INCLUDE_DIRS}
  ${SQLITE3_INCLUDE_DIRS}
)

# 源文件
set(SOURCES
  src/main.cpp
)

# 生成可执行文件
add_executable(${PROJECT_NAME} ${SOURCES})

# 链接依赖
target_link_libraries(${PROJECT_NAME}
  Qt5::Core
  Qt5::Widgets
  Qt5::Network
  ${TESSERACT_LIBRARIES}
  ${YAML_CPP_LIBRARIES}
  ${SQLITE3_LIBRARIES}
)

# 安装规则（打包必须）
install(TARGETS ${PROJECT_NAME}
  RUNTIME DESTINATION bin
)

install(FILES config/config.yaml
  DESTINATION share/${PROJECT_NAME}/
)

# -------------------------- 【关键】CPack 打包配置 --------------------------
# 必须放在文件末尾，且所有变量设置在 include(CPack) 之前
set(CPACK_PACKAGE_NAME "${PROJECT_NAME}")
set(CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")
set(CPACK_PACKAGE_VENDOR "Smart Translator Team")
set(CPACK_PACKAGE_CONTACT "support@smarttranslator.com")
set(CPACK_PACKAGE_DESCRIPTION "Smart Translator - 实时屏幕翻译工具，支持OCR和多引擎翻译")

# Debian 打包专用配置
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Smart Translator Team <support@smarttranslator.com>")
set(CPACK_DEBIAN_PACKAGE_DEPENDS "qtbase5-dev, tesseract-ocr, libyaml-cpp-dev, libsqlite3-dev")

# 必须是文件的最后一行！
include(CPack)

cmake_minimum_required(VERSION 3.16)
project(SmartTranslator VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 覆盖率选项（保留）
option(CODE_COVERAGE "Enable coverage reporting" OFF)
if(CODE_COVERAGE AND CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
  add_compile_options(-O0 -g --coverage)
  add_link_options(--coverage)
endif()

# 跨平台 Qt 查找
if(APPLE)
  set(CMAKE_PREFIX_PATH "/opt/homebrew/opt/qt@5" ${CMAKE_PREFIX_PATH})
endif()

find_package(Qt5 REQUIRED COMPONENTS Core Widgets Network)

# 手动修复 Tesseract 链接（macOS 专用）
if(APPLE)
  # Homebrew 安装的 Tesseract 路径
  set(TESSERACT_ROOT "/opt/homebrew/opt/tesseract")
  include_directories(${TESSERACT_ROOT}/include)
  link_directories(${TESSERACT_ROOT}/lib)
  # 显式链接库
  set(TESSERACT_LIBRARIES
    ${TESSERACT_ROOT}/lib/libtesseract.5.dylib
    ${TESSERACT_ROOT}/lib/libtesseract.dylib
  )
else()
  # Linux 保持原来的 pkg_check
  find_package(PkgConfig REQUIRED)
  pkg_check_modules(TESSERACT REQUIRED tesseract)
endif()

# 其他依赖
find_package(PkgConfig REQUIRED)
pkg_check_modules(YAML_CPP REQUIRED yaml-cpp)
pkg_check_modules(SQLITE3 REQUIRED sqlite3)

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

# 安装规则
install(TARGETS ${PROJECT_NAME}
  RUNTIME DESTINATION bin
)

install(FILES config/config.yaml
  DESTINATION share/${PROJECT_NAME}/
)

# 覆盖率目标
if(CODE_COVERAGE)
  add_custom_target(coverage
    COMMAND lcov --directory . --capture --output-file coverage.info
    COMMAND lcov --remove coverage.info '/usr/*' --output-file coverage.info.cleaned
    COMMAND genhtml -o coverage coverage.info.cleaned
    WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
  )
endif()

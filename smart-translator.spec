Name:           smart-translator
Version:        1.0.0
Release:        1%{?dist}
Summary:        实时屏幕OCR翻译工具

License:        MIT
URL:            https://github.com/smarttranslator/smart-translator
Source0:        %{name}-%{version}.tar.gz

# 编译依赖
BuildRequires:  cmake >= 3.16
BuildRequires:  gcc-c++
BuildRequires:  qt5-qtbase-devel >= 5.15.0
BuildRequires:  tesseract-devel >= 4.1.0
BuildRequires:  libcurl-devel
BuildRequires:  yaml-cpp-devel
BuildRequires:  sqlite-devel

# 运行依赖（完整匹配项目）
Requires:       qt5-qtbase >= 5.15.0
Requires:       qt5-qtimageformats
Requires:       tesseract
Requires:       tesseract-langpack-chi-sim
Requires:       libcurl
Requires:       yaml-cpp
Requires:       sqlite-libs

%description
基于Qt和OCR技术的实时屏幕翻译工具，支持多语言识别、多翻译引擎、术语库管理。
功能包括：屏幕文字识别、实时翻译、配置文件管理、本地术语库存储。

%prep
%setup -q

%build
%cmake -DCMAKE_BUILD_TYPE=Release
%cmake_build

%install
%cmake_install

# 创建配置/资源目录
mkdir -p %{buildroot}%{_datadir}/%{name}/
mkdir -p %{buildroot}%{_datadir}/%{name}/tessdata/

# 安装配置文件
install -m 644 ../config/config.yaml %{buildroot}%{_datadir}/%{name}/

%files
# 可执行文件
%{_bindir}/%{name}

# 数据文件（配置+语言包）
%dir %{_datadir}/%{name}
%{_datadir}/%{name}/config.yaml

# 文档和许可证
%doc README.md
%license LICENSE

%changelog
* Fri Apr 19 2024 Smart Translator Team <support@smarttranslator.com> - 1.0.0-1
- 初始正式版本发布
- 支持跨平台实时屏幕翻译/OCR识别

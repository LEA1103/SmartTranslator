!define PRODUCT_NAME "Smart Translator"
!define PRODUCT_VERSION "1.0.0"
!define PRODUCT_PUBLISHER "Smart Translator Team"
!define PRODUCT_WEB_SITE "https://github.com/smarttranslator/smart-translator"

; ==================== 核心配置 ====================
Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "SmartTranslator-${PRODUCT_VERSION}-Setup.exe"
InstallDir "$PROGRAMFILES64\Smart Translator"
InstallDirRegKey HKLM "Software\Smart Translator" "InstallPath"
ShowInstDetails show
ShowUnInstDetails show

; 【修复】必须管理员权限（写入HKLM注册表/ProgramFiles目录）
RequestExecutionLevel admin

; 【修复】Unicode编码，支持中文无乱码
Unicode true

; ==================== 包含现代UI ====================
!include "MUI2.nsh"

; ==================== MUI 界面设置 ====================
!define MUI_ABORTWARNING
!define MUI_ICON "installer.ico"
!define MUI_UNICON "installer.ico"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "header.bmp"
!define MUI_WELCOMEFINISHPAGE_BITMAP "welcome.bmp"

; 【新增】组件描述（必须定义，否则报错）
!define MUI_COMPONENTSPAGE_SMALLDESC

; ==================== 安装页面 ====================
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "LICENSE"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

; ==================== 卸载页面 ====================
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

; ==================== 语言支持（中文+英文） ====================
!insertmacro MUI_LANGUAGE "SimpChinese"
!insertmacro MUI_LANGUAGE "English"

; ==================== 安装组件 ====================
Section "主程序（必选）" SecMain
  SectionIn RO
  SetOverwrite ifnewer
  
  ; 安装主程序文件
  SetOutPath "$INSTDIR"
  File "build\bin\Release\smart-translator.exe"
  File "config\config.yaml"

  ; 创建桌面快捷方式
  CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\smart-translator.exe" "" "" 0 SW_SHOWNORMAL

  ; 创建开始菜单目录
  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk" "$INSTDIR\smart-translator.exe"

SectionEnd

Section "OCR 语言包（推荐）" SecOcr
  SetOutPath "$INSTDIR\tessdata"
  File /r "tessdata\*.*"
SectionEnd

Section "开始菜单快捷方式" SecStartMenu
  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
  ; 【修复】错别字：卸卸载 → 卸载
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\卸载程序.lnk" "$INSTDIR\uninstall.exe"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\配置文件.lnk" "notepad.exe" "$INSTDIR\config.yaml"
SectionEnd

; ==================== 卸载程序 ====================
Section Uninstall
  ; 删除主程序文件
  Delete "$INSTDIR\smart-translator.exe"
  Delete "$INSTDIR\config.yaml"
  Delete "$INSTDIR\uninstall.exe"

  ; 删除OCR语言包目录
  RMDir /r "$INSTDIR\tessdata"

  ; 删除快捷方式
  Delete "$DESKTOP\${PRODUCT_NAME}.lnk"
  Delete "$SMPROGRAMS\${PRODUCT_NAME}\*.*"
  RMDir "$SMPROGRAMS\${PRODUCT_NAME}"

  ; 删除空安装目录
  RMDir "$INSTDIR"

  ; 清理注册表
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
  DeleteRegKey HKLM "Software\Smart Translator"

SectionEnd

; ==================== 安装前检查（自动卸载旧版本） ====================
Function .onInit
  ReadRegStr $R0 HKLM "Software\Smart Translator" "InstallPath"
  StrCmp $R0 "" done

  MessageBox MB_YESNO|MB_ICONQUESTION "检测到已安装旧版本，是否先卸载？" IDNO done
  ExecWait '"$R0\uninstall.exe" /S _?=$R0'

  done:
FunctionEnd

; ==================== 卸载后提示 ====================
Function un.onUninstSuccess
  MessageBox MB_OK|MB_ICONINFORMATION "${PRODUCT_NAME} 已成功卸载！"
FunctionEnd

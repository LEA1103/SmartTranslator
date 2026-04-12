!define PRODUCT_NAME "Smart Translator"
!define PRODUCT_VERSION "1.0.0"
!define PRODUCT_PUBLISHER "Smart Translator Team"
!define PRODUCT_WEB_SITE "https://github.com/smarttranslator/smart-translator"

; ==================== 安装程序信息 ====================
Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "SmartTranslator-${PRODUCT_VERSION}-Setup.exe"
InstallDir "$PROGRAMFILES\Smart Translator"
InstallDirRegKey HKLM "Software\Smart Translator" ""
ShowInstDetails show
ShowUnInstDetails show

; ==================== 包含现代UI ====================
!include "MUI2.nsh"

; ==================== MUI设置 ====================
!define MUI_ABORTWARNING
!define MUI_ICON "installer.ico"
!define MUI_UNICON "installer.ico"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "header.bmp"
!define MUI_WELCOMEFINISHPAGE_BITMAP "welcome.bmp"

; ==================== 页面 ====================
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "LICENSE"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

; ==================== 语言 ====================
!insertmacro MUI_LANGUAGE "SimpChinese"
!insertmacro MUI_LANGUAGE "English"

; ==================== 安装节 ====================
Section "主程序" SecMain
  SectionIn RO

  SetOutPath "$INSTDIR"
  File "build\bin\Release\smart-translator.exe"
  File "config\config.yaml"

  ; 创建快捷方式
  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk" "$INSTDIR\smart-translator.exe"
  CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\smart-translator.exe"

  ; 写入注册表
  WriteRegStr HKLM "Software\Smart Translator" "" "$INSTDIR"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "DisplayName" "${PRODUCT_NAME}"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "UninstallString" "$INSTDIR\uninstall.exe"
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}" "NoRepair" 1
  WriteUninstaller "$INSTDIR\uninstall.exe"

  SectionEnd

Section "OCR语言包" SecOcr
  SetOutPath "$INSTDIR\tessdata"
  File /r "tessdata\*.*"

  SectionEnd

Section "开始菜单快捷方式" SecStartMenu
  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\卸卸载.lnk" "$INSTDIR\uninstall.exe"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\配置文件.lnk" "notepad.exe" "$INSTDIR\config.yaml"

  SectionEnd

; ==================== 卸载节 ====================
Section Uninstall
  Delete "$INSTDIR\smart-translator.exe"
  Delete "$INSTDIR\config.yaml"
  Delete "$INSTDIR\uninstall.exe"
  RMDir /r "$INSTDIR\tessdata"
  RMDir "$INSTDIR"

  Delete "$SMPROGRAMS\${PRODUCT_NAME}\*.*"
  RMDir "$SMPROGRAMS\${PRODUCT_NAME}"
  Delete "$DESKTOP\${PRODUCT_NAME}.lnk"

  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
  DeleteRegKey HKLM "Software\Smart Translator"

  SectionEnd

; ==================== 函数 ====================
Function .onInit
  ; 检查是否已有安装
  ReadRegStr $R0 HKLM "Software\Smart Translator" ""
  StrCmp $R0 "" done

  MessageBox MB_YESNO|MB_ICONQUESTION \
    "检测到已安装版本，是否先卸载旧版本？" \
    IDNO done

  ExecWait '"$R0\uninstall.exe" /S _?=$R0'

  done:
  FunctionEnd

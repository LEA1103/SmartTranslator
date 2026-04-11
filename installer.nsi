Name "SmartTranslator"
OutFile "SmartTranslator-Setup.exe"
InstallDir "$PROGRAMFILES64\SmartTranslator"

Section
SetOutPath "$INSTDIR"
File "build\bin\Release\smart-translator.exe"
CreateShortCut "$DESKTOP\SmartTranslator.lnk" "$INSTDIR\smart-translator.exe"
SectionEnd

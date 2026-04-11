#!/bin/bash
mkdir -p SmartTranslator.app/Contents/MacOS
cp build/smart-translator SmartTranslator.app/Contents/MacOS/
hdiutil create -volname SmartTranslator -srcfolder . -ov -format UDZO SmartTranslator.dmg

Name "Litecoin Core (32-bit)"

RequestExecutionLevel highest
SetCompressor /SOLID lzma

# General Symbol Definitions
!define REGKEY "SOFTWARE\$(^Name)"
!define VERSION 0.10.2.2
!define COMPANY "Worldcoin Core project"
!define URL http://www.worldcoin.org/

# MUI Symbol Definitions
!define MUI_ICON "/f/dev/Worldcoin_core/v0.10.2/worldcoinUnSub/share/pixmaps/bitcoin.ico"
!define MUI_WELCOMEFINISHPAGE_BITMAP "/f/dev/Worldcoin_core/v0.10.2/worldcoinUnSub/share/pixmaps/nsis-wizard.bmp"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_RIGHT
!define MUI_HEADERIMAGE_BITMAP "/f/dev/Worldcoin_core/v0.10.2/worldcoinUnSub/share/pixmaps/nsis-header.bmp"
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_STARTMENUPAGE_REGISTRY_ROOT HKLM
!define MUI_STARTMENUPAGE_REGISTRY_KEY ${REGKEY}
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME StartMenuGroup
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "Litecoin Core"
!define MUI_FINISHPAGE_RUN $INSTDIR\litecoin-qt.exe
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "/f/dev/Worldcoin_core/v0.10.2/worldcoinUnSub/share/pixmaps/nsis-wizard.bmp"
!define MUI_UNFINISHPAGE_NOAUTOCLOSE

# Included files
!include Sections.nsh
!include MUI2.nsh
!if "32" == "64"
!include x64.nsh
!endif

# Variables
Var StartMenuGroup

# Installer pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_STARTMENU Application $StartMenuGroup
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

# Installer languages
!insertmacro MUI_LANGUAGE English

# Installer attributes
OutFile /f/dev/Worldcoin_core/v0.10.2/worldcoinUnSub/litecoin-${VERSION}-win32-setup.exe
!if "32" == "64"
InstallDir $PROGRAMFILES64\Worldcoin
!else
InstallDir $PROGRAMFILES\Worldcoin
!endif
CRCCheck on
XPStyle on
BrandingText " "
ShowInstDetails show
VIProductVersion ${VERSION}.2
VIAddVersionKey ProductName "Worldcoin Core"
VIAddVersionKey ProductVersion "${VERSION}"
VIAddVersionKey CompanyName "${COMPANY}"
VIAddVersionKey CompanyWebsite "${URL}"
VIAddVersionKey FileVersion "${VERSION}"
VIAddVersionKey FileDescription ""
VIAddVersionKey LegalCopyright ""
InstallDirRegKey HKCU "${REGKEY}" Path
ShowUninstDetails show

# Installer sections
Section -Main SEC0000
    SetOutPath $INSTDIR
    SetOverwrite on
    File /f/dev/Worldcoin_core/v0.10.2/worldcoinUnSub/release/litecoin-qt.exe
    File /oname=COPYING.txt /f/dev/Worldcoin_core/v0.10.2/worldcoinUnSub/COPYING
    File /oname=readme.txt /f/dev/Worldcoin_core/v0.10.2/worldcoinUnSub/doc/README_windows.txt
    SetOutPath $INSTDIR\daemon
    File /f/dev/Worldcoin_core/v0.10.2/worldcoinUnSub/release/litecoind.exe
    File /f/dev/Worldcoin_core/v0.10.2/worldcoinUnSub/release/litecoin-cli.exe
    SetOutPath $INSTDIR\doc
    File /r /f/dev/Worldcoin_core/v0.10.2/worldcoinUnSub/doc\*.*
    SetOutPath $INSTDIR
    WriteRegStr HKCU "${REGKEY}\Components" Main 1

    # Remove old wxwidgets-based-worldcoin executable and locales:
    Delete /REBOOTOK $INSTDIR\worldcoin.exe
    RMDir /r /REBOOTOK $INSTDIR\locale
SectionEnd

Section -post SEC0001
    WriteRegStr HKCU "${REGKEY}" Path $INSTDIR
    SetOutPath $INSTDIR
    WriteUninstaller $INSTDIR\uninstall.exe
    !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
    CreateDirectory $SMPROGRAMS\$StartMenuGroup
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\$(^Name).lnk" $INSTDIR\worldcoin-qt.exe
    CreateShortcut "$SMPROGRAMS\$StartMenuGroup\Uninstall $(^Name).lnk" $INSTDIR\uninstall.exe
    !insertmacro MUI_STARTMENU_WRITE_END
    WriteRegStr HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayName "$(^Name)"
    WriteRegStr HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayVersion "${VERSION}"
    WriteRegStr HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" Publisher "${COMPANY}"
    WriteRegStr HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" URLInfoAbout "${URL}"
    WriteRegStr HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" DisplayIcon $INSTDIR\uninstall.exe
    WriteRegStr HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" UninstallString $INSTDIR\uninstall.exe
    WriteRegDWORD HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoModify 1
    WriteRegDWORD HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)" NoRepair 1
    WriteRegStr HKCR "worldcoin" "URL Protocol" ""
    WriteRegStr HKCR "worldcoin" "" "URL:Worldcoin"
    WriteRegStr HKCR "worldcoin\DefaultIcon" "" $INSTDIR\worldcoin-qt.exe
    WriteRegStr HKCR "worldcoin\shell\open\command" "" '"$INSTDIR\worldcoin-qt.exe" "%1"'
SectionEnd

# Macro for selecting uninstaller sections
!macro SELECT_UNSECTION SECTION_NAME UNSECTION_ID
    Push $R0
    ReadRegStr $R0 HKCU "${REGKEY}\Components" "${SECTION_NAME}"
    StrCmp $R0 1 0 next${UNSECTION_ID}
    !insertmacro SelectSection "${UNSECTION_ID}"
    GoTo done${UNSECTION_ID}
next${UNSECTION_ID}:
    !insertmacro UnselectSection "${UNSECTION_ID}"
done${UNSECTION_ID}:
    Pop $R0
!macroend

# Uninstaller sections
Section /o -un.Main UNSEC0000
    Delete /REBOOTOK $INSTDIR\worldcoin-qt.exe
    Delete /REBOOTOK $INSTDIR\COPYING.txt
    Delete /REBOOTOK $INSTDIR\readme.txt
    RMDir /r /REBOOTOK $INSTDIR\daemon
    RMDir /r /REBOOTOK $INSTDIR\doc
    DeleteRegValue HKCU "${REGKEY}\Components" Main
SectionEnd

Section -un.post UNSEC0001
    DeleteRegKey HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$(^Name)"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\Uninstall $(^Name).lnk"
    Delete /REBOOTOK "$SMPROGRAMS\$StartMenuGroup\$(^Name).lnk"
    Delete /REBOOTOK "$SMSTARTUP\Litecoin.lnk"
    Delete /REBOOTOK $INSTDIR\uninstall.exe
    Delete /REBOOTOK $INSTDIR\debug.log
    Delete /REBOOTOK $INSTDIR\db.log
    DeleteRegValue HKCU "${REGKEY}" StartMenuGroup
    DeleteRegValue HKCU "${REGKEY}" Path
    DeleteRegKey /IfEmpty HKCU "${REGKEY}\Components"
    DeleteRegKey /IfEmpty HKCU "${REGKEY}"
    DeleteRegKey HKCR "worldcoin"
    RmDir /REBOOTOK $SMPROGRAMS\$StartMenuGroup
    RmDir /REBOOTOK $INSTDIR
    Push $R0
    StrCpy $R0 $StartMenuGroup 1
    StrCmp $R0 ">" no_smgroup
no_smgroup:
    Pop $R0
SectionEnd

# Installer functions
Function .onInit
    InitPluginsDir
!if "32" == "64"
    ${If} ${RunningX64}
      ; disable registry redirection (enable access to 64-bit portion of registry)
      SetRegView 64
    ${Else}
      MessageBox MB_OK|MB_ICONSTOP "Cannot install 64-bit version on a 32-bit system."
      Abort
    ${EndIf}
!endif
FunctionEnd

# Uninstaller functions
Function un.onInit
    ReadRegStr $INSTDIR HKCU "${REGKEY}" Path
    !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuGroup
    !insertmacro SELECT_UNSECTION Main ${UNSEC0000}
FunctionEnd

; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Design
; Description ...: This file This file creates the "Debug" tab under the "Bot" tab
; Syntax ........:
; Parameters ....: None
; Return values .: None
; Author ........:
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

;$hGUI_BotDebug = _GUICreate("", $g_iSizeWGrpTab2, $g_iSizeHGrpTab2, 5, 25, BitOR($WS_CHILD, $WS_TABSTOP), -1, $g_hGUI_BOT)
;GUISwitch($hGUI_BotDebug)

Global $g_hChkDebugSetLog = 0, $g_hChkDebugAndroid = 0, $g_hChkDebugClick = 0, $g_hChkDebugOCR = 0, $g_hChkDebugImageSave = 0, $g_hChkdebugBuildingPos = 0, $g_hChkdebugTrain = 0, $g_hChkDebugOCRDonate = 0
Global $g_hChkdebugAttackCSV = 0, $g_hChkMakeIMGCSV = 0, $g_hChkDebugDisableZoomout = 0, $g_hChkDebugDisableVillageCentering = 0, $g_hChkDebugDeadbaseImage = 0, $g_hChkDebugFunc = 0, _
	   $g_hChkDebugSmartZap = 0

Global $g_hBtnTestTrain = 0, $g_hBtnTestDonateCC = 0, $g_hBtnTestRequestCC = 0, $g_hBtnTestSendText = 0, $g_hBtnTestAttackBar = 0, $g_hBtnTestClickDrag = 0, $g_hBtnTestImage = 0
Global $g_hBtnTestVillageSize = 0, $g_hBtnTestDeadBase = 0, $g_hBtnTestTHimgloc = 0, $g_hBtnTestTrainsimgloc = 0, $g_hBtnTestQuickTrainsimgloc = 0, $g_hTxtRunFunction = 0
Global $g_hBtnRunFunction = 0, $g_hBtnTestDeadBaseFolder = 0, $g_hBtnTestCleanYard = 0, $g_hBtnTestAttackCSV = 0, $g_hBtnTestBuildingLocation = 0, $g_hBtnTestArmyWindow = 0
Global $g_hBtnTestConfigSave = 0, $g_hBtnTestConfigApply = 0, $g_hBtnTestConfigRead = 0, $g_hBtnTestOcrMemory = 0, $g_hBtnTestWeakBase = 0, $g_hBtnTestClickAway = 0, $g_hBtnTestAutoUpgrade = 0
Global $g_hBtnTestUpgradeWindow = 0, $g_hBtnTestSmartWait = 0, $g_hBtnConsoleWindow = 0
Global $g_hBtnImgCapture = 0, $g_hBtnTestAttackReportPng = 0, $g_hBtnGetBuilding = 0
Global $g_hGUI_ImgCapture = 0, $g_hTxtImgCaptureCode = 0, $g_hTxtImgCaptureTolerance = 0, $g_hTxtImgCaptureSize = 0, $g_hCmbImgCaptureFormat = 0, $g_hTxtImgCaptureIndex = 0, $g_hBtnImgCaptureClick = 0, $g_hBtnImgCaptureOpenFolder = 0, $g_hBtnImgCaptureClose = 0
Global $g_hGUI_GetBuilding = 0, $g_hCmbGetBuilding = 0, $g_hBtnGetBuildingRun = 0, $g_hBtnGetBuildingClose = 0
Global $g_hGUI_AttackReportPng = 0, $g_hRadAttackReportPngNormal = 0, $g_hRadAttackReportPngRevenge = 0, $g_hRadAttackReportPngRanked = 0, $g_hBtnAttackReportPngSelect = 0, $g_hBtnAttackReportPngClose = 0

Func CreateBotDebug()

	Local $x = 25, $xChk = 15, $y = 45
	GUICtrlCreateGroup(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "Group_01", "Debug"), $x - 20, $y - 20, $g_iSizeWGrpTab2, $g_iSizeHGrpTab2)
	$g_hChkDebugSetLog = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugSetLog", "Messages"), $xChk, $y - 5, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugSetLog_Info _01", "Debug: Enables debug SetLog messages in code for Troubleshooting."))

	$g_hBtnTestAttackReportPng = GUICtrlCreateButton("AtkReport", $x + 70, $y - 5, 75, 25)
	_GUICtrlSetTip(-1, "Select a PNG and test AttackReport OCR")

	$g_hBtnImgCapture = GUICtrlCreateButton("ImgCapture", $x + 70, $y + 25, 75, 25)
	_GUICtrlSetTip(-1, "Open image capture tool")

	$g_hBtnGetBuilding = GUICtrlCreateButton("GetLocation", $x + 70, $y + 55, 75, 25)
	_GUICtrlSetTip(-1, "Run GetLocationBuilding for selected building")

	$y += 20
	$g_hChkDebugAndroid = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugAndroid", "Android"), $xChk, $y - 5, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugAndroid_Info _01", "Debug: Enables additional log debug messages for Android operations."))

	$y += 20
	$g_hChkDebugClick = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugClick", "Click"), $xChk, $y - 5, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugClick_Info _01", "Debug: Write the clicked (x,y) coordinates to the log."))

	$y += 20
	$g_hChkDebugFunc = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugFunc", "Functions"), $xChk, $y - 5, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugFunc_Info _01", "Debug: Enables debug function times and call hierarchy."))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetState(-1, $GUI_HIDE)

	$y += 20
	$g_hChkDebugOCR = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugOCR", "OCR"), $xChk, $y - 5, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugOCR_Info _01", "Debug: Enables Saving OCR images for troubleshooting."))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetState(-1, $GUI_HIDE)

	$y += 20
	$g_hChkDebugImageSave = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugImageSave", "Images"), $xChk, $y - 5, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugImageSave_Info _01", "Debug: Enables Saving images for troubleshooting."))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetState(-1, $GUI_HIDE)

	$y += 20
	$g_hChkdebugBuildingPos = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkdebugBuildingPos", "Buildings"), $xChk, $y - 5, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkdebugBuildingPos_Info _01", "Debug: Enables showing positions of buildings in log."))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetState(-1, $GUI_HIDE)

	$y += 20
	$g_hChkdebugTrain = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkdebugTrain", "Training"), $xChk, $y - 5, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkdebugTrain_Info _01", "Debug: Enables showing debug during training."))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetState(-1, $GUI_HIDE)

	$y += 20
	$g_hChkDebugOCRDonate = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugOCRDonate", "Online Debug Donations"), $xChk, $y - 5, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugOCRDonate_Info _01", "Debug: make ocr of donations and simulate only donate but no donate any troop"))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetState(-1, $GUI_HIDE)

	$y += 20
	$g_hChkdebugAttackCSV = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkdebugAttackCSV", "Attack CSV"), $xChk, $y - 5, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkdebugAttackCSV_Info _01", "Debug: Generates special CSV parse log files"))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetState(-1, $GUI_HIDE)

	$y += 20
	$g_hChkMakeIMGCSV = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkMakeIMGCSV", "Attack CSV Image"), $xChk, $y - 5, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkMakeIMGCSV_Info _01", "Debug: Enables saving clean and location marked up images of bases attacked by CSV scripts"))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetState(-1, $GUI_HIDE)

	$y += 20
	$g_hChkDebugDisableZoomout = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugDisableZoomout", "Disable ZoomOut"), $xChk, $y - 5, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugDisableZoomout_Info _01", "Debug: Disables zoomout of village."))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetState(-1, $GUI_HIDE)

	$y += 20
	$g_hChkDebugDisableVillageCentering = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugDisableVillageCentering", "Disable Village Centering"), $xChk, $y - 5, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugDisableVillageCentering_Info _01", "Debug: Disables centering of village."))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetState(-1, $GUI_HIDE)

	$y += 20
	$g_hChkDebugDeadbaseImage = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugDeadbaseImage", "DeadBase Image Save"), $xChk, $y - 5, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugDeadbaseImage_Info _01", "Debug: Saves images of skipped deadbase villages."))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetState(-1, $GUI_HIDE)

	$y += 20
	$g_hChkDebugSmartZap = GUICtrlCreateCheckbox(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugSmartZap", "Debug SmartZap"), $xChk, $y - 5, -1, -1)
	_GUICtrlSetTip(-1, GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ChkDebugSmartZap_Info _01", "Use it to debug SmartZap"))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetState(-1, $GUI_HIDE)

	Local $x = 300
	$y = 40
	Local $yNext = 30
	$g_hBtnTestTrain = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "BtnTestTrain", "Test Train"), $x, $y, 140, 25)
	$y += $yNext

	$g_hBtnTestDonateCC = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "BtnTestDonateCC", "Test Donate"), $x, $y, 140, 25)
	$y += $yNext

	$g_hBtnTestRequestCC = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "BtnTestRequestCC", "Test Request"), $x, $y, 140, 25)
	$y += $yNext

	$g_hBtnTestAttackBar = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "BtnTestAttackBar", "Test Attack Bar"), $x, $y, 140, 25)
	$y += $yNext

	$g_hBtnTestClickDrag = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "BtnTestClickDrag", "Test Click Drag"), $x, $y, 140, 25)
	$y += $yNext

	$g_hBtnTestImage = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "BtnTestImage", "Test Image"), $x, $y, 140, 25)
	$y += $yNext

	$g_hBtnTestVillageSize = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "BtnTestVillageSize", "Test Village Size"), $x, $y, 140, 25)
	$y += $yNext

	$g_hBtnTestDeadBase = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "BtnTestDeadBase", "Test Dead Base"), $x, $y, 140, 25)
	$y += $yNext

	$g_hBtnTestTHimgloc = GUICtrlCreateButton("ImgLoc TH", $x, $y, 140, 25)
	$y += $yNext

	$g_hBtnTestTrainsimgloc = GUICtrlCreateButton("PrepareAttack", $x, $y, 140, 25)
	$y += $yNext

	$g_hBtnTestQuickTrainsimgloc = GUICtrlCreateButton("PrepareAttack Remain", $x, $y, 140, 25)

	$y += $yNext
	$g_hBtnTestOcrMemory = GUICtrlCreateButton("OCR Memory Test", $x, $y, 140, 25)

	$y += $yNext
	$g_hBtnTestSmartWait = GUICtrlCreateButton("Smart Wait Test", $x, $y, 140, 25)

	; now go up again
	$x -= 145

	$g_hTxtRunFunction = GUICtrlCreateInput("ZoomOut()", $x - 145, $y + 3, 140, 20)
	$g_hBtnRunFunction = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "RunFunction", "Run Function"), $x, $y, 140, 25)
	$y -= $yNext

	$g_hBtnTestDeadBaseFolder = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "BtnTestDeadBaseFolder", "Test Dead Base Folder"), $x, $y, 140, 25)
	$g_hBtnTestCleanYard = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "BtnTestCleanYard", "Test Clean Yard"), $x - 145, $y, 140, 25)
	$y -= $yNext

	$g_hBtnTestAttackCSV = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "BtnTestAttackCSV", "Test Attack CSV"), $x, $y, 140, 25)
	$g_hBtnTestBuildingLocation = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "BtnTestBuildingLocation", "Find Building"), $x - 145, $y, 140, 25)
	$y -= $yNext

	$g_hBtnTestConfigSave = GUICtrlCreateButton("Config Save", $x + 20, $y, 120, 25)
	$y -= $yNext
	$g_hBtnTestConfigApply = GUICtrlCreateButton("Config Apply", $x + 20, $y, 120, 25)
	$y -= $yNext
	$g_hBtnTestConfigRead = GUICtrlCreateButton("Config Read", $x + 20, $y, 120, 25)
	$y -= $yNext

	$g_hBtnTestSendText = GUICtrlCreateButton("Send Text", $x + 20, $y, 120, 25)
	$y -= $yNext

	$g_hBtnTestWeakBase = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "TestWeakBase", "Test Weak Base"), $x + 20, $y, 120, 25)
	$y -= $yNext

	$g_hBtnTestClickAway = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "TestClickAway", "Test Click Away"), $x + 20, $y, 120, 25)
	$y -= $yNext

	$g_hBtnTestAutoUpgrade = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "TestAutoUpgrade", "Test Auto Upgrade"), $x + 20, $y, 120, 25)
	$y -= $yNext

	$g_hBtnTestUpgradeWindow = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "TestUpgradeWindow", "Test Upgrade Window"), $x + 20, $y, 120, 25)
	$y -= $yNext

	$g_hBtnConsoleWindow = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "ConsoleWindow", "Show/Hide Console"), $x + 20, $y, 120, 25)
	$y -= $yNext

	$g_hBtnTestArmyWindow = GUICtrlCreateButton(GetTranslatedFileIni("MBR GUI Design Child Bot - Debug", "BtnTestArmyWindow", "Army Window"), $x + 20, $y, 120, 25)
	$y -= $yNext
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	CreateImgCaptureWindow()
	CreateGetBuildingWindow()
	CreateAttackReportPngWindow()
	GUISwitch($g_hGUI_BOT)

EndFunc   ;==>CreateBotDebug

Func CreateImgCaptureWindow()
	Local $x = 20, $y = 20
	Local $iLabelW = 86, $iFieldX = $x + $iLabelW + 8
	Local $iBtnGap = 5, $iBtnW1 = 110, $iBtnW2 = 112
	Local $iBtnStart = 38
	$g_hGUI_ImgCapture = _GUICreate("ImgCapture", 305, 248, $g_iFrmBotPosX + 90, $g_iFrmBotPosY + 90, $WS_DLGFRAME, -1, $g_hFrmBot)
	GUISetOnEvent($GUI_EVENT_CLOSE, "CloseImgCaptureWindow", $g_hGUI_ImgCapture)

	GUICtrlCreateLabel("Output Name:", $x, $y + 4, $iLabelW, 20)
	$g_hTxtImgCaptureCode = GUICtrlCreateInput("Img", $iFieldX, $y, 88, 20)

	$y += 28
	GUICtrlCreateLabel("Index:", $x, $y + 4, $iLabelW, 20)
	$g_hTxtImgCaptureIndex = GUICtrlCreateInput("100", $iFieldX, $y, 54, 20)

	$y += 28
	GUICtrlCreateLabel("Tolerance:", $x, $y + 4, $iLabelW, 20)
	$g_hTxtImgCaptureTolerance = GUICtrlCreateInput("92", $iFieldX, $y, 54, 20)

	$y += 28
	GUICtrlCreateLabel("Capture Size:", $x, $y + 4, $iLabelW, 20)
	$g_hTxtImgCaptureSize = GUICtrlCreateInput("32", $iFieldX, $y, 54, 20)

	$y += 28
	GUICtrlCreateLabel("Format:", $x, $y + 4, $iLabelW, 20)
	$g_hCmbImgCaptureFormat = GUICtrlCreateCombo("", $iFieldX, $y, 54, 20, $CBS_DROPDOWNLIST)
	GUICtrlSetData(-1, "png|bmp", "png")

	$y += 30
	$g_hBtnImgCaptureClick = GUICtrlCreateButton("Click Capture", $iBtnStart, $y, $iBtnW1, 24)
	GUICtrlSetOnEvent(-1, "BtnImgCaptureClick")
	$g_hBtnImgCaptureOpenFolder = GUICtrlCreateButton("Open Folder", $iBtnStart + $iBtnW1 + $iBtnGap, $y, $iBtnW2, 24)
	GUICtrlSetOnEvent(-1, "BtnImgCaptureOpenFolder")

	$y += 24 + 5
	$g_hBtnImgCaptureClose = GUICtrlCreateButton("Close", 97, $y, $iBtnW2, 24)
	GUICtrlSetOnEvent(-1, "CloseImgCaptureWindow")

	GUISetState(@SW_HIDE, $g_hGUI_ImgCapture)
	GUISwitch($g_hGUI_BOT)
EndFunc   ;==>CreateImgCaptureWindow

Func CreateGetBuildingWindow()
	Local $x = 26, $y = 22
	Local $iBtnGap = 8, $iBtnW = 92
	Local $iBtnStart = 27

	$g_hGUI_GetBuilding = _GUICreate("GetLocation", 250, 120, $g_iFrmBotPosX + 105, $g_iFrmBotPosY + 105, $WS_DLGFRAME, -1, $g_hFrmBot)
	GUISetOnEvent($GUI_EVENT_CLOSE, "CloseGetBuildingWindow", $g_hGUI_GetBuilding)

	GUICtrlCreateLabel("Building:", $x, $y + 4, 54, 20)
	$g_hCmbGetBuilding = GUICtrlCreateCombo("", $x + 56, $y, 144, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
	GUICtrlSetData(-1, "All|Air Defense|Air Sweeper|Clan Castle|Eagle Artillery|Firespitter|Inferno Tower|Monolith|Mortar|Revenge Tower|Scattershot|Town Hall|Wizard Tower|XBow", "Town Hall")
	_GUICtrlSetTip(-1, "Select building template to test")

	$y += 42
	$g_hBtnGetBuildingRun = GUICtrlCreateButton("Run", $iBtnStart, $y, $iBtnW, 24)
	GUICtrlSetOnEvent(-1, "BtnGetBuildingRun")
	$g_hBtnGetBuildingClose = GUICtrlCreateButton("Close", $iBtnStart + $iBtnW + $iBtnGap, $y, $iBtnW, 24)
	GUICtrlSetOnEvent(-1, "CloseGetBuildingWindow")

	GUISetState(@SW_HIDE, $g_hGUI_GetBuilding)
	GUISwitch($g_hGUI_BOT)
EndFunc   ;==>CreateGetBuildingWindow

Func CreateAttackReportPngWindow()
	Local $x = 20, $y = 14
	Local $iBtnGap = 8, $iBtnW = 100
	Local $iBtnStart = 31

	$g_hGUI_AttackReportPng = _GUICreate("AtkReport", 300, 130, $g_iFrmBotPosX + 110, $g_iFrmBotPosY + 110, $WS_DLGFRAME, -1, $g_hFrmBot)
	GUISetOnEvent($GUI_EVENT_CLOSE, "CloseAttackReportPngWindow", $g_hGUI_AttackReportPng)

	GUICtrlCreateGroup("Mode", $x, $y, 260, 52)
	$g_hRadAttackReportPngNormal = GUICtrlCreateRadio("Normal", $x + 12, $y + 19, 58, 20)
	GUICtrlSetState(-1, $GUI_CHECKED)
	$g_hRadAttackReportPngRanked = GUICtrlCreateRadio("Ranked", $x + 88, $y + 19, 65, 20)
	$g_hRadAttackReportPngRevenge = GUICtrlCreateRadio("Revenge", $x + 172, $y + 19, 70, 20)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	$y += 60
	$g_hBtnAttackReportPngSelect = GUICtrlCreateButton("Select PNG", $iBtnStart + 15, $y, $iBtnW, 24)
	GUICtrlSetOnEvent(-1, "BtnSelectAttackReportPng")
	$g_hBtnAttackReportPngClose = GUICtrlCreateButton("Close", $iBtnStart + $iBtnW + $iBtnGap + 15, $y, $iBtnW, 24)
	GUICtrlSetOnEvent(-1, "CloseAttackReportPngWindow")

	GUISetState(@SW_HIDE, $g_hGUI_AttackReportPng)
	GUISwitch($g_hGUI_BOT)
EndFunc   ;==>CreateAttackReportPngWindow

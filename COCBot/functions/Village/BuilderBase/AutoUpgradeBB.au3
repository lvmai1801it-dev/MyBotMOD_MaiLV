; #FUNCTION# ===========================================================================================================
; Name ..........: AutoUpgradeBB
; Author ........: Phael
; Description ...: Builder Base Auto Upgrade entry point.
; Remarks .......: Uses Builder Base filters and confirmation screens; called by BBSpamCycle and scheduled maintenance.
; ======================================================================================================================
Func AutoUpgradeBB($bDeferZoomOut = False)
	If Not $g_bRunState Or (Not $g_bAutoUpgradeBBEnabled And Not $g_bAutoStarUpgradeBBEnabled) Then Return 0
	SetLog("Checking Builder Base Auto Upgrade", $COLOR_INFO)
	If Not IsMainPageBuilderBase(1) Then
		SetLog("AutoUpgradeBB: Builder Base screen not detected", $COLOR_WARNING)
		Return 0
	EndIf
	Local $bBuilderCountValid = False
	If $g_bAutoUpgradeBBEnabled Then
		$bBuilderCountValid = getBuilderCount(True, True)
		If $bBuilderCountValid Then
			SetLog("Master Builders: " & $g_iFreeBuilderCountBB)
		Else
			SetLog("Master Builders: OCR failed", $COLOR_WARNING)
		EndIf
	EndIf
	Local $iStarted = 0
	If $g_bAutoUpgradeBBEnabled And $bBuilderCountValid And $g_iFreeBuilderCountBB > 0 Then $iStarted += _AutoUpgradeBBBuilders()
	If $g_bAutoStarUpgradeBBEnabled And $g_bRunState And IsMainPageBuilderBase(1) Then $iStarted += AutoStarUpgrade(True)
	If $iStarted > 0 And $g_bRunState And IsMainPageBuilderBase(1) And Not $bDeferZoomOut Then
		ZoomOutSimple(Default, Default, Default, True)
		ZoomOut()
	EndIf
	Return $iStarted
EndFunc   ;==>AutoUpgradeBB

; #FUNCTION# ===========================================================================================================
; Name ..........: _AutoUpgradeBBBuilders
; Description ...: Starts suggested Builder Base upgrades until no master builder remains.
; Remarks .......: Called by AutoUpgradeBB before the Star Laboratory upgrade pass.
; ======================================================================================================================

Func _AutoUpgradeBBBuilders()
	If Not $g_bRunState Or Not $g_bAutoUpgradeBBEnabled Then Return 0
	If $g_iFreeBuilderCountBB < 1 Then Return 0
	If Not _AUpgradeApplyBuilderBaseFilters(False, True) Then
		SetLog("AutoUpgradeBB: Could not apply configured filters", $COLOR_ERROR)
		CloseWindow()
		Return 0
	EndIf
	Local $iStarted = 0, $bMenuClosed = False, $aSkippedSuggestions[0]
	SetLog("Filters: " & _AUpgradeFilterName($g_iAutoUpgradeBBResourceFilter, "Default|Gold|Elixir") & " | " & _AUpgradeFilterName($g_iAutoUpgradeBBTypeFilter, "Default|Army|Defense|Hero|Resource|Permanent") & " | " & _AUpgradeFilterName($g_iAutoUpgradeBBSorting, "Default|Cost Max|Cost Min"), $COLOR_INFO)
	While $g_bRunState And $g_iFreeBuilderCountBB > 0
		If Not _AUpgradeBBOpenMenu(False) Then ExitLoop
		$bMenuClosed = False
		Local $aRows = _AUpgradeBBGetSuggestionRows()
		If Not IsArray($aRows) Then
			SetLog("AutoUpgradeBB: No visible upgrade suggestion found", $COLOR_WARNING)
			CloseWindow()
			$bMenuClosed = True
			ExitLoop
		EndIf
		Local $iStartedBeforeRows = $iStarted, $bStopBuilderScan = False, $bTryNextSuggestion = False
		For $iRow = 0 To UBound($aRows) - 1
			Local $sSuggestionKey = StringLower($aRows[$iRow][0]) & "@" & $aRows[$iRow][2], $bSuggestionSkipped = False
			For $iSkipped = 0 To UBound($aSkippedSuggestions) - 1
				If $aSkippedSuggestions[$iSkipped] = $sSuggestionKey Then
					$bSuggestionSkipped = True
					ExitLoop
				EndIf
			Next
			If $bSuggestionSkipped Then ContinueLoop
			Local $sCostState = _AUpgradeGetCostPixelState($aRows[$iRow][1], $aRows[$iRow][2])
			Local $sResource = StringLeft(StringLower($aRows[$iRow][0]), 5) = "goldb" ? "Gold" : "Elixir"
			If $sCostState = "Insufficient" Then
				SetLog("Upgrade Skipped: " & $sResource & " Insufficient", $COLOR_DEBUG)
				ContinueLoop
			EndIf
			If $sCostState <> "Affordable" Then
				SetLog("Upgrade Skipped: " & $sResource & " Cost Color Unknown", $COLOR_DEBUG)
				ContinueLoop
			EndIf
			Click(Random($aRows[$iRow][1] - 3, $aRows[$iRow][1] + 3, 1), Random($aRows[$iRow][2] - 3, $aRows[$iRow][2] + 3, 1), 1, 120, "#AUTOUPGRADEBB")
			If _Sleep(650) Then
				$bStopBuilderScan = True
				ExitLoop
			EndIf
			Local $aConfirm = _AUpgradeBBFindConfirmation()
			If Not IsArray($aConfirm) Then
				SetLog("Upgrade Skipped: " & $sResource & " Screen Not Detected", $COLOR_DEBUG)
				ReDim $aSkippedSuggestions[UBound($aSkippedSuggestions) + 1]
				$aSkippedSuggestions[UBound($aSkippedSuggestions) - 1] = $sSuggestionKey
				CloseWindow()
				$bMenuClosed = True
				$bTryNextSuggestion = True
				ExitLoop
			EndIf
			SetLog($sResource & " Upgrade Selected", $COLOR_ACTION)
			Local $iFreeBuildersBeforeUpgrade = $g_iFreeBuilderCountBB
			_AUpgradeBBClickConfirmation($aConfirm, "#AUTOUPGRADEBB")
			If _Sleep(750) Then ExitLoop
			CloseWindow()
			Local $bUpgradeStarted = False
			$bMenuClosed = IsMainPageBuilderBase(1)
			If $bMenuClosed Then
				For $iBuilderTry = 0 To 4
					If getBuilderCount(True, True) And $g_iFreeBuilderCountBB < $iFreeBuildersBeforeUpgrade Then
						$bUpgradeStarted = True
						ExitLoop
					EndIf
					If $iBuilderTry < 4 And _Sleep(300) Then ExitLoop
				Next
			EndIf
			If Not $bUpgradeStarted Then
				SetLog("AutoUpgradeBB: Master Builder count did not confirm the upgrade", $COLOR_ERROR)
				$bStopBuilderScan = True
				ExitLoop
			EndIf
			$iStarted += 1
			SetLog($sResource & " Upgrade Started", $COLOR_SUCCESS)
			SetLog("Free Master Builders Remaining: " & $g_iFreeBuilderCountBB, $COLOR_SUCCESS)
			ExitLoop
		Next
		If $bStopBuilderScan Then ExitLoop
		If $bTryNextSuggestion Then ContinueLoop
		If $iStarted = $iStartedBeforeRows Then ExitLoop
		If Not IsMainPageBuilderBase(1) Then ExitLoop
	WEnd
	If Not $bMenuClosed Then CloseWindow()
	If $iStarted = 0 Then SetLog("No upgrade started")
	Return $iStarted
EndFunc   ;==>_AutoUpgradeBBBuilders

; #FUNCTION# ===========================================================================================================
; Name ..........: AutoUpgradeBBMaintenance
; Description ...: Runs Builder Base and Star Laboratory upgrades outside the attack cycle.
; Remarks .......: Switches bases for maintenance and returns to the Main Village without starting an attack.
; ======================================================================================================================

Func AutoUpgradeBBMaintenance()
	If Not $g_bRunState Or (Not $g_bAutoUpgradeBBEnabled And Not $g_bAutoStarUpgradeBBEnabled) Then Return 0
	If Not IsMainPage(1) Then
		SetLog("AutoUpgradeBBMaintenance: Main Village screen not detected", $COLOR_WARNING)
		Return 0
	EndIf

	If Not SwitchBetweenBases(True, True) Or Not IsMainPageBuilderBase(1) Then
		SetLog("AutoUpgradeBBMaintenance: Could not reach Builder Base", $COLOR_WARNING)
		If $g_bRunState And isOnBuilderBase(True) Then SwitchBetweenBases(True, False)
		Return 0
	EndIf

	AutoUpgradeBB()

	If $g_bRunState And Not $g_bRestart And Not $g_bBotPaused Then
		For $i = 0 To 1
			If Not IsArray(_PixelSearch(822, 7, 855, 41, Hex(0xF02227, 6), 55)) Then ExitLoop
			CloseWindow()
			If _Sleep(250) Then ExitLoop
		Next
		If isOnBuilderBase(True) Then SwitchBetweenBases(True, False)
	EndIf

	Return 0
EndFunc   ;==>AutoUpgradeBBMaintenance

; #FUNCTION# ===========================================================================================================
; Name ..........: AutoStarUpgrade
; Description ...: Builder Base Laboratory Auto Upgrade entry point.
; Remarks .......: Uses the Builder Base Star Laboratory menu; called by scheduled Builder Base maintenance.
; ======================================================================================================================

Func AutoStarUpgrade($bDeferZoomOut = False)
	If Not $g_bRunState Or Not $g_bAutoStarUpgradeBBEnabled Then Return 0
	SetLog("Checking Auto Star Laboratory Upgrade", $COLOR_INFO)
	If Not IsMainPageBuilderBase(1) Then
		SetLog("AutoStarUpgrade: Builder Base screen not detected", $COLOR_WARNING)
		Return 0
	EndIf
	Local $sLabCount = getLabBuilderCount()
	If $sLabCount <> "1#1" Then
		If $sLabCount = "" Then
			SetLog("AutoStarUpgrade: Star Laboratory availability not detected", $COLOR_WARNING)
		Else
			SetLog("AutoStarUpgrade: Star Laboratory is not available", $COLOR_INFO)
		EndIf
		Return 0
	EndIf
	SetLog("Star Laboratory: " & StringReplace($sLabCount, "#", "/"))
	If Not _AUpgradeApplyBuilderBaseFilters(True, True) Then
		SetLog("AutoStarUpgrade: Could not apply configured filters", $COLOR_ERROR)
		CloseWindow()
		Return 0
	EndIf
	SetLog("Filters: " & _AUpgradeFilterName($g_iAutoLabUpgradeBBSorting, "Default|Cost Max|Cost Min"), $COLOR_INFO)
	If _Sleep(350) Then Return 0
	Local $aRows = _AUpgradeBBGetSuggestionRows()
	If Not IsArray($aRows) Then
		SetLog("AutoStarUpgrade: No visible Star Laboratory upgrade suggestion found", $COLOR_WARNING)
		CloseWindow()
		Return 0
	EndIf
	Local $iRow = _AUpgradeBBFindAffordableRow($aRows, True)
	If $iRow < 0 Then
		SetLog("No upgrade started")
		CloseWindow()
		Return 0
	EndIf
	Local $sResource = _AUpgradeGetResourceName($aRows[$iRow][0])
	SetLog($sResource & " Upgrade Selected", $COLOR_ACTION)
	Click(Random($aRows[$iRow][1] - 3, $aRows[$iRow][1] + 3, 1), Random($aRows[$iRow][2] - 3, $aRows[$iRow][2] + 3, 1), 1, 120, "#AUTOLABUPGRADEBB")
	If _Sleep(650) Then Return 0
	Local $aConfirm = _AUpgradeBBFindConfirmation()
	If Not IsArray($aConfirm) Then
		SetLog("AutoStarUpgrade: Star Laboratory confirmation not detected", $COLOR_ERROR)
		CloseWindow()
		Return 0
	EndIf
	_AUpgradeBBClickConfirmation($aConfirm, "#AUTOLABUPGRADEBB")
	If _Sleep(750) Then Return 0
	CloseWindow()
	CloseWindow()
	Local $sLabCountAfterUpgrade = ""
	For $iLabTry = 0 To 4
		$sLabCountAfterUpgrade = getLabBuilderCount()
		If $sLabCountAfterUpgrade = "0#1" Then ExitLoop
		If $iLabTry < 4 And _Sleep(300) Then ExitLoop
	Next
	If $sLabCountAfterUpgrade <> "0#1" Then
		SetLog("AutoStarUpgrade: Upgrade not registered; Star Laboratory remains available", $COLOR_ERROR)
		Return 0
	EndIf
	SetLog($sResource & " Upgrade Started", $COLOR_SUCCESS)
	SetLog("Star Laboratory Available: 0/1", $COLOR_SUCCESS)
	If Not $bDeferZoomOut Then
		ZoomOutSimple(Default, Default, Default, True)
		ZoomOut()
	EndIf
	Return 1
EndFunc   ;==>AutoStarUpgrade

Func _AUpgradeBBEnsureMenuOpen()
	For $iTry = 0 To 1
		If IsArray(_PixelSearch(822, 7, 855, 41, Hex(0xF02227, 6), 55)) Then Return True
		If Not IsMainPageBuilderBase(1) Then Return False
		If Not _AUpgradeClickImage($g_sImgAUpgradeBBBuild, 750, 620, 855, 710, "#AUBBBUILD") Then Return False
		If _Sleep(700) Then Return False
	Next
	Return IsArray(_PixelSearch(822, 7, 855, 41, Hex(0xF02227, 6), 55))
EndFunc   ;==>_AUpgradeBBEnsureMenuOpen

Func _AUpgradeBBOpenMenu($bStarLab)
	If Not _AUpgradeBBEnsureMenuOpen() Then Return False
	Local $sMenuImage = $bStarLab ? $g_sImgAUpgradeBBStarLabMenu : $g_sImgAUpgradeBBMasterMenu
	Local $iLeft = $bStarLab ? 735 : 550, $iTop = 635, $iRight = $bStarLab ? 810 : 630, $iBottom = 715
	If Not _AUpgradeClickImage($sMenuImage, $iLeft, $iTop, $iRight, $iBottom, $bStarLab ? "#AUBBSTLAB" : "#AUBBMASTER") Then
		SetLog($bStarLab ? "AutoStarUpgrade: Star Laboratory menu image not detected" : "AutoUpgradeBB: Master Builder menu image not detected", $COLOR_ERROR)
		Return False
	EndIf
	If _Sleep(450) Then Return False
	Return True
EndFunc   ;==>_AUpgradeBBOpenMenu

Func _AUpgradeApplyBuilderBaseFilters($bStarLab, $bSuppressLog = False, $bTestMode = False)
	If Not _AUpgradeBBOpenMenu($bStarLab) Then Return False
	If _AUpgradeBBFilterPanelOpen() Then
		Click(Random(536, 546, 1), Random(19, 29, 1), 1, 120, "#AUBBFILTER")
		If _Sleep(350) Then Return False
		If _AUpgradeBBFilterPanelOpen() Then Return False
	EndIf
	Click(Random(536, 546, 1), Random(19, 29, 1), 1, 120, "#AUBBFILTER")
	If _Sleep(350) Then Return False
	If Not _AUpgradeBBFilterPanelOpen() Then
		SetLog($bTestMode ? "TestAutoUpgradeBBFilter: Filter panel not detected" : "Builder Base AutoUpgrade: Filter panel not detected", $COLOR_ERROR)
		Return False
	EndIf
	Local $iResource, $iType, $iSorting
	Local $aResourceX[2] = [153, 290], $aResourceY[2] = [114, 114]
	Local $aTypeX[6] = [153, 290, 427, 153, 290, 427], $aTypeY[6] = [199, 199, 199, 252, 252, 252]
	Local $aSortingX[2] = [153, 290], $aSortingY[2] = [334, 334]
	If $bStarLab Then
		$iSorting = _GUICtrlComboBox_GetCurSel($g_hCmbAutoLabUpgradeBBSorting)
		If $iSorting < 0 Or $iSorting > 2 Then $iSorting = 0
		$g_iAutoLabUpgradeBBSorting = $iSorting
		If $iSorting > 0 Then
			Local $iSortX = $iSorting = 1 ? 338 : 475
			Click(Random($iSortX - 5, $iSortX + 5, 1), Random(130, 140, 1), 1, 120, "#AUBBFILTER")
			If _Sleep(250) Then Return False
		EndIf
		If Not _AUpgradeBBFilterPanelOpen() Then Return False
	Else
		$iResource = _GUICtrlComboBox_GetCurSel($g_hCmbAutoUpgradeBBResource)
		$iType = _GUICtrlComboBox_GetCurSel($g_hCmbAutoUpgradeBBType)
		$iSorting = _GUICtrlComboBox_GetCurSel($g_hCmbAutoUpgradeBBSorting)
		If $iResource < 0 Or $iResource > 2 Then $iResource = 0
		If $iType < 0 Or $iType > 5 Then $iType = 0
		If $iSorting < 0 Or $iSorting > 2 Then $iSorting = 0
		If Not _AUpgradeApplyFilterGroup($aResourceX, $aResourceY, $iResource - 1) Then Return False
		Local $iTypeFilter = $iType - 1
		If $iType = 5 Then $iTypeFilter = 5 ; Permanent is the final option; New is intentionally skipped.
		If Not _AUpgradeApplyFilterGroup($aTypeX, $aTypeY, $iTypeFilter) Then Return False
		$g_iAutoUpgradeBBResourceFilter = $iResource
		$g_iAutoUpgradeBBTypeFilter = $iType
		$g_iAutoUpgradeBBSorting = $iSorting
	EndIf
	If Not $bStarLab And Not _AUpgradeApplyFilterGroup($aSortingX, $aSortingY, $iSorting - 1) Then Return False
	If Not _AUpgradeBBFilterPanelOpen() Then Return False
	Click(Random(536, 546, 1), Random(19, 29, 1), 1, 120, "#AUBBFILTER")
	If _Sleep(350) Then Return False
	If Not $bSuppressLog Then
		If Not $bStarLab Then
			SetLog("[Resource Filter]: " & _AUpgradeFilterName($iResource, "Default|Gold|Elixir"), $COLOR_INFO)
			SetLog("[Type Filter]: " & _AUpgradeFilterName($iType, "Default|Army|Defense|Hero|Resource|Permanent"), $COLOR_INFO)
		EndIf
		SetLog("[Sorting]: " & _AUpgradeFilterName($iSorting, "Default|Cost Max|Cost Min"), $COLOR_INFO)
	EndIf
	Return True
EndFunc   ;==>_AUpgradeApplyBuilderBaseFilters

Func _AUpgradeBBFilterPanelOpen()
	Return IsArray(_PixelSearch(245, 68, 250, 75, Hex(0x7F5C3E, 6), 12))
EndFunc   ;==>_AUpgradeBBFilterPanelOpen

Func TestAutoUpgradeBBFilter($bSuppressLog = False)
	If Not IsMainPageBuilderBase(1) Then
		SetLog("TestAutoUpgradeBBFilter: Builder Base screen not detected", $COLOR_ERROR)
		Return False
	EndIf
	Return _AUpgradeApplyBuilderBaseFilters(False, $bSuppressLog, True)
EndFunc   ;==>TestAutoUpgradeBBFilter

Func TestAutoStarUpgradeFilter($bSuppressLog = False)
	If Not IsMainPageBuilderBase(1) Then
		SetLog("TestAutoStarUpgradeFilter: Builder Base screen not detected", $COLOR_ERROR)
		Return False
	EndIf
	Return _AUpgradeApplyBuilderBaseFilters(True, $bSuppressLog, True)
EndFunc   ;==>TestAutoStarUpgradeFilter

Func _AUpgradeBBGetSuggestionRows()
	Local $aFoundRows = QuickMIS("CNX", $g_sImgAUpgradeBBMenu, 780, 50 + $g_iMidOffsetY, 859, 650 + $g_iMidOffsetY)
	If Not IsArray($aFoundRows) Then Return -1
	_ArraySort($aFoundRows, 0, 0, 0, 2)
	Local $aRows[0][4]
	For $i = 0 To UBound($aFoundRows) - 1
		Local $sResource = StringLower($aFoundRows[$i][0])
		If StringLeft($sResource, 5) <> "goldb" And StringLeft($sResource, 7) <> "elixirb" Then ContinueLoop
		If _AUpgradeIsNewSuggestion(Number($aFoundRows[$i][2])) Then
			SetDebugLog("AutoUpgradeBB skipped green New suggestion at " & $aFoundRows[$i][1] & "," & $aFoundRows[$i][2], $COLOR_DEBUG)
			ContinueLoop
		EndIf
		Local $bDuplicate = False
		For $j = 0 To UBound($aRows) - 1
			If StringLeft(StringLower($aRows[$j][0]), 5) = StringLeft($sResource, 5) And Abs(Number($aRows[$j][2]) - Number($aFoundRows[$i][2])) <= 24 Then $bDuplicate = True
			If StringLeft($sResource, 7) = "elixirb" And StringLeft(StringLower($aRows[$j][0]), 7) = "elixirb" And Abs(Number($aRows[$j][2]) - Number($aFoundRows[$i][2])) <= 24 Then $bDuplicate = True
		Next
		If $bDuplicate Then ContinueLoop
		ReDim $aRows[UBound($aRows) + 1][4]
		For $k = 0 To 3
			$aRows[UBound($aRows) - 1][$k] = $aFoundRows[$i][$k]
		Next
	Next
	If UBound($aRows) = 0 Then Return -1
	Return $aRows
EndFunc   ;==>_AUpgradeBBGetSuggestionRows

Func _AUpgradeBBFindAffordableRow(ByRef $aRows, $bStarLab)
	For $i = 0 To UBound($aRows) - 1
		Local $sResource = StringLower($aRows[$i][0])
		If $bStarLab And StringLeft($sResource, 7) <> "elixirb" Then ContinueLoop
		Local $sCostState = _AUpgradeGetCostPixelState($aRows[$i][1], $aRows[$i][2])
		Local $sResourceName = StringLeft($sResource, 5) = "goldb" ? "Gold" : "Elixir"
		If $sCostState = "Insufficient" Then
			SetLog("Upgrade Skipped: " & $sResourceName & " Insufficient", $COLOR_DEBUG)
			ContinueLoop
		EndIf
		If $sCostState <> "Affordable" Then
			SetLog("Upgrade Skipped: " & $sResourceName & " Cost Color Unknown", $COLOR_DEBUG)
			ContinueLoop
		EndIf
		Return $i
	Next
	Return -1
EndFunc   ;==>_AUpgradeBBFindAffordableRow

Func _AUpgradeBBFindConfirmation()
	Local $aConfirm[3]
	Local $aHeroConfirm = _PixelSearch(600, 535 + $g_iMidOffsetY, 810, 660 + $g_iMidOffsetY, Hex(0x8BD43A, 6), 35)
	If IsArray($aHeroConfirm) Then
		$aConfirm[0] = 1
		$aConfirm[1] = $aHeroConfirm[0]
		$aConfirm[2] = $aHeroConfirm[1]
		Return $aConfirm
	EndIf
	Local $aClassicRibbon = _PixelSearch(95, 300 + $g_iMidOffsetY, 240, 365 + $g_iMidOffsetY, Hex(0xF8D66C, 6), 24)
	If Not IsArray($aClassicRibbon) Then Return -1
	Local $aNormalConfirm = _PixelSearch(325, 515 + $g_iMidOffsetY, 540, 625 + $g_iMidOffsetY, Hex(0x8BD43A, 6), 35)
	If IsArray($aNormalConfirm) Then
		$aConfirm[0] = 0
		$aConfirm[1] = $aNormalConfirm[0]
		$aConfirm[2] = $aNormalConfirm[1]
		Return $aConfirm
	EndIf
	Return -1
EndFunc   ;==>_AUpgradeBBFindConfirmation

Func _AUpgradeBBClickConfirmation(ByRef $aConfirm, $sClickTag)
	If $aConfirm[0] = 1 Then
		Click(Random(690, 720, 1), Random(580 + $g_iMidOffsetY, 605 + $g_iMidOffsetY, 1), 1, 120, $sClickTag)
	Else
		Click(Random(420, 450, 1), Random(550 + $g_iMidOffsetY, 580 + $g_iMidOffsetY, 1), 1, 120, $sClickTag)
	EndIf
EndFunc   ;==>_AUpgradeBBClickConfirmation

Func TestAutoUpgradeBB($bConfirm = False)
	If Not TestAutoUpgradeBBFilter() Then Return False
	If _Sleep(350) Then Return False
	Local $aRows = _AUpgradeBBGetSuggestionRows()
	If Not IsArray($aRows) Then
		SetLog("TestAutoUpgradeBB: No visible upgrade suggestion found", $COLOR_ERROR)
		Return False
	EndIf
	Local $iRow = _AUpgradeBBFindAffordableRow($aRows, False)
	If $iRow < 0 Then Return False
	SetLog("[Upgrade Icon]: " & $aRows[$iRow][0] & " detected at " & $aRows[$iRow][1] & "," & $aRows[$iRow][2], $COLOR_INFO)
	Click(Random($aRows[$iRow][1] - 3, $aRows[$iRow][1] + 3, 1), Random($aRows[$iRow][2] - 3, $aRows[$iRow][2] + 3, 1), 1, 120, "#AUTESTBB")
	If _Sleep(650) Then Return False
	Local $aConfirm = _AUpgradeBBFindConfirmation()
	If Not IsArray($aConfirm) Then
		SetLog("TestAutoUpgradeBB: Builder Base confirmation screen not detected", $COLOR_ERROR)
		Return False
	EndIf
	SetLog("[Upgrade Screen]: " & ($aConfirm[0] = 1 ? "Builder Base Hero" : "Builder Base Normal"), $COLOR_INFO)
	SetLog("Builder Base upgrade confirmation detected", $COLOR_INFO)
	If Not $bConfirm Then
		SetLog("Upgrade not started; call TestAutoUpgradeBB(True) to confirm and spend resources", $COLOR_WARNING)
		Return True
	EndIf
	_AUpgradeBBClickConfirmation($aConfirm, "#AUTESTBB")
	If _Sleep(650) Then Return False
	SetLog("Builder Base upgrade confirmation clicked", $COLOR_SUCCESS)
	Return True
EndFunc   ;==>TestAutoUpgradeBB

Func TestAutoStarUpgrade($bConfirm = False)
	If Not TestAutoStarUpgradeFilter() Then Return False
	If _Sleep(350) Then Return False
	Local $aRows = _AUpgradeBBGetSuggestionRows()
	If Not IsArray($aRows) Then
		SetLog("TestAutoStarUpgrade: No visible Star Laboratory upgrade suggestion found", $COLOR_ERROR)
		Return False
	EndIf
	Local $iRow = _AUpgradeBBFindAffordableRow($aRows, True)
	If $iRow < 0 Then Return False
	SetLog("[Upgrade Icon]: " & $aRows[$iRow][0] & " detected at " & $aRows[$iRow][1] & "," & $aRows[$iRow][2], $COLOR_INFO)
	Click(Random($aRows[$iRow][1] - 3, $aRows[$iRow][1] + 3, 1), Random($aRows[$iRow][2] - 3, $aRows[$iRow][2] + 3, 1), 1, 120, "#AUTESTBBLAB")
	If _Sleep(650) Then Return False
	Local $aConfirm = _AUpgradeBBFindConfirmation()
	If Not IsArray($aConfirm) Then
		SetLog("TestAutoStarUpgrade: Star Laboratory confirmation screen not detected", $COLOR_ERROR)
		Return False
	EndIf
	SetLog("[Upgrade Screen]: " & ($aConfirm[0] = 1 ? "Builder Base Hero" : "Builder Base Normal"), $COLOR_INFO)
	SetLog("Star Laboratory upgrade confirmation detected", $COLOR_INFO)
	If Not $bConfirm Then
		SetLog("Upgrade not started; call TestAutoStarUpgrade(True) to confirm and spend resources", $COLOR_WARNING)
		Return True
	EndIf
	_AUpgradeBBClickConfirmation($aConfirm, "#AUTESTBBLAB")
	If _Sleep(650) Then Return False
	SetLog("Star Laboratory upgrade confirmation clicked", $COLOR_SUCCESS)
	Return True
EndFunc   ;==>TestAutoStarUpgrade

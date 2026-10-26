; #FUNCTION# ====================================================================================================================
; Name ..........: LocateBlacksmith
; Description ...:
; Syntax ........: LocateBlacksmith()
; Parameters ....:
; Return values .: None
; Author ........: Moebius14 (Dec 2023)
; Modified ......:
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func LocateBlacksmith($bCollect = True)
	If $g_iTownHallLevel < 8 Then
		SetLog("Townhall Lvl " & $g_iTownHallLevel & " has no Blacksmith, so skip locating.", $COLOR_DEBUG)
		Return False
	EndIf

	Local $aPreviousBlacksmithPos[3] = [$g_aiBlacksmithPos[0], $g_aiBlacksmithPos[1], $g_aiBlacksmithPos[2]]
	$g_aiBlacksmithPos[0] = -1
	$g_aiBlacksmithPos[1] = -1
	$g_aiBlacksmithPos[2] = -1

	; auto locate
	If ImgLocateBlacksmith(False, False, $aPreviousBlacksmithPos) Then
		SetLog("Blacksmith Detected: (" & $g_aiBlacksmithPos[0] & "," & $g_aiBlacksmithPos[1] & "), Level: " & $g_aiBlacksmithPos[2], $COLOR_SUCCESS)
		Return True
	EndIf

	If Not isInsideDiamond($aPreviousBlacksmithPos) Then LogUnknownBuildingPosition("Blacksmith")

	If Not _LocateBlacksmith($bCollect) Then
		$g_aiBlacksmithPos[0] = $aPreviousBlacksmithPos[0]
		$g_aiBlacksmithPos[1] = $aPreviousBlacksmithPos[1]
		$g_aiBlacksmithPos[2] = $aPreviousBlacksmithPos[2]
		Return False
	EndIf

	Return True
EndFunc   ;==>LocateBlacksmith

Func _LocateBlacksmith($bCollect = True)
	Local $stext, $MsgBox, $iStupid = 0, $iSilly = 0, $sErrorText = ""

	WinGetAndroidHandle()
	checkMainScreen(False)

	While 1
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
		$stext = $sErrorText & @CRLF & GetTranslatedFileIni("MBR Popups", "Func_Locate_Blacksmith_01", "Click OK then click on your Blacksmith") & @CRLF & @CRLF & _
				GetTranslatedFileIni("MBR Popups", "Locate_building_01", -1) & @CRLF & @CRLF & GetTranslatedFileIni("MBR Popups", "Locate_building_02", -1) & @CRLF
		$MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Ok_Cancel", "Ok|Cancel"), GetTranslatedFileIni("MBR Popups", "Func_Locate_Blacksmith_02", "Locate Blacksmith"), $stext, 15)
		If $MsgBox = 1 Then
			WinGetAndroidHandle()
			ClearScreen()
			Local $aPos = FindPos()
			$g_aiBlacksmithPos[0] = Int($aPos[0])
			$g_aiBlacksmithPos[1] = Int($aPos[1])
			If isInsideDiamond($g_aiBlacksmithPos) = False Then
				$iStupid += 1
				Select
					Case $iStupid = 1
						$sErrorText = "Blacksmith Location Not Valid!" & @CRLF
						SetDebugLog("Location not valid, try again", $COLOR_DEBUG)
						ContinueLoop
					Case $iStupid = 2
						$sErrorText = "Please try to click inside the grass field!" & @CRLF
						ContinueLoop
					Case $iStupid = 3
						$sErrorText = "This is not funny, Please stop!" & @CRLF & @CRLF
						ContinueLoop
					Case $iStupid = 4
						$sErrorText = "Last Chance, DO NOT MAKE ME ANGRY, or" & @CRLF & "I will give ALL of your gold to Barbarian King," & @CRLF & "And ALL of your Gems to the Archer Queen!" & @CRLF
						ContinueLoop
					Case $iStupid > 4
						SetDebugLog(" Operator Error - Bad Blacksmith Location.", $COLOR_DEBUG)
						ClearScreen()
						Return False
				EndSelect
			EndIf
		Else
			SetLog("Locate Blacksmith Cancelled", $COLOR_INFO)
			ClearScreen()
			Return False
		EndIf
		Local $sBlacksmithInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)
		If $sBlacksmithInfo[0] > 1 Or $sBlacksmithInfo[0] = "" Then
			If StringInStr($sBlacksmithInfo[1], "smith") = 0 Then
				Local $sLocMsg = ($sBlacksmithInfo[0] = "" ? "Nothing" : $sBlacksmithInfo[1])

				$iSilly += 1
				Select
					Case $iSilly = 1
						$sErrorText = "Wait, That is not the Blacksmith?, It was a " & $sLocMsg & @CRLF
						ContinueLoop
					Case $iSilly = 2
						$sErrorText = "Quit joking, That was " & $sLocMsg & @CRLF
						ContinueLoop
					Case $iSilly = 3
						$sErrorText = "This is not funny, why did you click " & $sLocMsg & "? Please stop!" & @CRLF
						ContinueLoop
					Case $iSilly = 4
						$sErrorText = $sLocMsg & " ?!?!?!" & @CRLF & @CRLF & "Last Chance, DO NOT MAKE ME ANGRY, or" & @CRLF & "I will give ALL of your gold to Barbarian King," & @CRLF & "And ALL of your Gems to the Archer Queen!" & @CRLF
						ContinueLoop
					Case $iSilly > 4
						SetDebugLog("Ok, you really think that's a Blacksmith?" & @CRLF & "I don't care anymore, go ahead with it!", $COLOR_DEBUG)
						ClearScreen()
						ExitLoop
				EndSelect
			EndIf
		Else
			SetDebugLog(" Operator Error - Bad Blacksmith Location: " & "(" & $g_aiBlacksmithPos[0] & "," & $g_aiBlacksmithPos[1] & ")", $COLOR_DEBUG)
			$g_aiBlacksmithPos[0] = -1
			$g_aiBlacksmithPos[1] = -1
			ClearScreen()
			Return False
		EndIf
		$g_aiBlacksmithPos[2] = $sBlacksmithInfo[2]
		SetLog("Blacksmith Detected: (" & $g_aiBlacksmithPos[0] & "," & $g_aiBlacksmithPos[1] & "), Level: " & $g_aiBlacksmithPos[2], $COLOR_SUCCESS)
		ExitLoop
	WEnd
	ClearScreen()
	Return True

EndFunc   ;==>_LocateBlacksmith

; Image Search for Blacksmith
Func ImgLocateBlacksmith($bSilent = False, $bKeepSelected = False, $aPreviousPos = Default)
	Local $sImgDir = @ScriptDir & "\imgxml\Buildings\Blacksmith\"

	Local $sSearchArea = "FV"
	Local $avBlacksmith, $bLocalSearch = False

	; Fast path: search around the last known position first.
	If IsArray($aPreviousPos) And UBound($aPreviousPos) >= 2 And $aPreviousPos[0] > 0 And $aPreviousPos[1] > 0 Then
		Local $iLeft = $aPreviousPos[0] - 90
		Local $iTop = $aPreviousPos[1] - 90
		Local $iRight = $aPreviousPos[0] + 90
		Local $iBottom = $aPreviousPos[1] + 90
		If $iLeft < 0 Then $iLeft = 0
		If $iTop < 0 Then $iTop = 0
		If $iRight > $g_iGAME_WIDTH Then $iRight = $g_iGAME_WIDTH
		If $iBottom > $g_iGAME_HEIGHT Then $iBottom = $g_iGAME_HEIGHT
		Local $sLocalArea = GetDiamondFromRect2($iLeft, $iTop, $iRight, $iBottom)
		$avBlacksmith = findMultiple($sImgDir, $sLocalArea, $sLocalArea, 0, 1000, 1, "objectname,objectpoints", True)
		$bLocalSearch = True
	EndIf

	; Fallback: preserve the original full-village search.
	If Not IsArray($avBlacksmith) Or UBound($avBlacksmith, $UBOUND_ROWS) <= 0 Then _
		$avBlacksmith = findMultiple($sImgDir, $sSearchArea, $sSearchArea, 0, 1000, 1, "objectname,objectpoints", Not $bLocalSearch)

	If Not IsArray($avBlacksmith) Or UBound($avBlacksmith, $UBOUND_ROWS) <= 0 Then
		If Not $bSilent Then SetDebugLog("Couldn't find Blacksmith on main village", $COLOR_DEBUG)
		If $g_bDebugImageSave Then SaveDebugImage("Blacksmith", False)
		Return False
	EndIf

	Local $avBlacksmithRes, $aiBlacksmithCoords

	; active/inactive Blacksmith have different images
	; loop thro the detected images
	For $i = 0 To UBound($avBlacksmith, $UBOUND_ROWS) - 1
		$avBlacksmithRes = $avBlacksmith[$i]
		$aiBlacksmithCoords = decodeSingleCoord($avBlacksmithRes[1])
	Next

	If IsArray($aiBlacksmithCoords) And UBound($aiBlacksmithCoords, $UBOUND_ROWS) > 1 Then
		$g_aiBlacksmithPos[0] = $aiBlacksmithCoords[0]
		$g_aiBlacksmithPos[1] = $aiBlacksmithCoords[1]
		BuildingClick($g_aiBlacksmithPos[0], $g_aiBlacksmithPos[1])
		If _Sleep($DELAYIMGLOCATE1) Then Return
		Local $sBlacksmithInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)
		If StringInStr($sBlacksmithInfo[1], "smith") Then
			$g_aiBlacksmithPos[2] = $sBlacksmithInfo[2]
			If $bSilent Then SetLog("Blacksmith Detected: (" & $g_aiBlacksmithPos[0] & "," & $g_aiBlacksmithPos[1] & ")", $COLOR_SUCCESS)
			If _Sleep($DELAYIMGLOCATE1) Then Return
			If Not $bKeepSelected Then ClearScreen()
			Return True
		Else
			If Not $bSilent Then SetDebugLog("Wrong click position, please manually locate", $COLOR_DEBUG)
			If _Sleep($DELAYIMGLOCATE1) Then Return
			ClearScreen()
		EndIf
	EndIf

	Return False
EndFunc   ;==>ImgLocateBlacksmith

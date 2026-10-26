; #FUNCTION# ====================================================================================================================
; Name ..........: LocateHeroHall
; Description ...:
; Syntax ........: LocateHeroHall
; Parameters ....:
; Return values .: None
; Author ........: ProMac(07/2015)
; Modified ......: Moebius14(11/2024)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func LocateHeroHall($bCollect = True)
	If $g_iTownHallLevel < 7 Then
		SetLog("Townhall Lvl " & $g_iTownHallLevel & " has no Hero Hall, so skip locating.", $COLOR_DEBUG)
		Return False
	EndIf

	Local $aPreviousHeroHallPos[3] = [$g_aiHeroHallPos[0], $g_aiHeroHallPos[1], $g_aiHeroHallPos[2]]
	$g_aiHeroHallPos[0] = -1
	$g_aiHeroHallPos[1] = -1
	$g_aiHeroHallPos[2] = -1

	; auto locate
	If ImgLocateHeroHall(False, False, $aPreviousHeroHallPos) Then
		SetLog("Hero Hall Detected: (" & $g_aiHeroHallPos[0] & "," & $g_aiHeroHallPos[1] & "), Level: " & $g_aiHeroHallPos[2], $COLOR_SUCCESS)
		Return True
	EndIf

	If Not isInsideDiamond($aPreviousHeroHallPos) Then LogUnknownBuildingPosition("Hero Hall")

	If Not _LocateHeroHall($bCollect) Then
		$g_aiHeroHallPos[0] = $aPreviousHeroHallPos[0]
		$g_aiHeroHallPos[1] = $aPreviousHeroHallPos[1]
		$g_aiHeroHallPos[2] = $aPreviousHeroHallPos[2]
		Return False
	EndIf

	SetLog("Hero Hall Detected: (" & $g_aiHeroHallPos[0] & "," & $g_aiHeroHallPos[1] & "), Level: " & $g_aiHeroHallPos[2], $COLOR_SUCCESS)
	Return True

EndFunc   ;==>LocateHeroHall

Func _LocateHeroHall($bCollect = True)
	Local $stext, $MsgBox, $iStupid = 0, $iSilly = 0, $sErrorText = ""

	WinGetAndroidHandle()
	checkMainScreen(False)

	While 1
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
		$stext = $sErrorText & @CRLF & GetTranslatedFileIni("MBR Popups", "Func_Locate_HeroHall_01", "Click OK then click on your Hero Hall") & @CRLF & @CRLF & _
				GetTranslatedFileIni("MBR Popups", "Locate_building_01", -1) & @CRLF & @CRLF & GetTranslatedFileIni("MBR Popups", "Locate_building_02", -1) & @CRLF
		$MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Ok_Cancel", "Ok|Cancel"), GetTranslatedFileIni("MBR Popups", "Func_Locate_HeroHall_02", "Locate Hero Hall"), $stext, 15)
		If $MsgBox = 1 Then
			WinGetAndroidHandle()
			ClearScreen()
			Local $aPos = FindPos()
			$g_aiHeroHallPos[0] = Int($aPos[0])
			$g_aiHeroHallPos[1] = Int($aPos[1])
			If isInsideDiamond($g_aiHeroHallPos) = False Then
				$iStupid += 1
				Select
					Case $iStupid = 1
						$sErrorText = "Hero Hall Location Not Valid!" & @CRLF
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
						SetDebugLog(" Operator Error - Bad Hero Hall Location.", $COLOR_DEBUG)
						ClearScreen()
						Return False
				EndSelect
			EndIf
		Else
			SetLog("Locate Hero Hall Cancelled", $COLOR_INFO)
			ClearScreen()
			Return False
		EndIf
		Local $sHeroHallInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)
		If $sHeroHallInfo[0] > 1 Or $sHeroHallInfo[0] = "" Then
			If StringInStr($sHeroHallInfo[1], "Hero") = 0 Then
				Local $sLocMsg = ($sHeroHallInfo[0] = "" ? "Nothing" : $sHeroHallInfo[1])

				$iSilly += 1
				Select
					Case $iSilly = 1
						$sErrorText = "Wait, That is not the Hero Hall?, It was a " & $sLocMsg & @CRLF
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
						SetDebugLog("Ok, you really think that's a Hero Hall?" & @CRLF & "I don't care anymore, go ahead with it!", $COLOR_DEBUG)
						ClearScreen()
						ExitLoop
				EndSelect
			Else
				$g_aiHeroHallPos[2] = $sHeroHallInfo[2]
			EndIf
		Else
			SetDebugLog(" Operator Error - Bad Hero Hall Location: " & "(" & $g_aiHeroHallPos[0] & "," & $g_aiHeroHallPos[1] & ")", $COLOR_DEBUG)
			$g_aiHeroHallPos[0] = -1
			$g_aiHeroHallPos[1] = -1
			$g_aiHeroHallPos[2] = -1
			ClearScreen()
			Return False
		EndIf
		SetLog("Hero Hall Detected: (" & $g_aiHeroHallPos[0] & "," & $g_aiHeroHallPos[1] & "), Level: " & $g_aiHeroHallPos[2], $COLOR_SUCCESS)
		ExitLoop
	WEnd
	ClearScreen()
	Return True

EndFunc   ;==>_LocateHeroHall

; Image Search for Hero Hall
Func ImgLocateHeroHall($bSilent = False, $bKeepSelected = False, $aPreviousPos = Default)

	ZoomOut()

	Local $sImgDir = @ScriptDir & "\imgxml\Buildings\HeroHall\"

	Local $sSearchArea = "FV"
	Local $avHeroHall, $bLocalSearch = False

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
		$avHeroHall = findMultiple($sImgDir, $sLocalArea, $sLocalArea, 0, 1000, 1, "objectname,objectpoints", True)
		$bLocalSearch = True
	EndIf

	; Fallback: preserve the original full-village search.
	If Not IsArray($avHeroHall) Or UBound($avHeroHall, $UBOUND_ROWS) <= 0 Then _
		$avHeroHall = findMultiple($sImgDir, $sSearchArea, $sSearchArea, 0, 1000, 1, "objectname,objectpoints", Not $bLocalSearch)

	If Not IsArray($avHeroHall) Or UBound($avHeroHall, $UBOUND_ROWS) <= 0 Then
		If Not $bSilent Then SetDebugLog("Couldn't find Hero Hall on main village", $COLOR_DEBUG)
		If $g_bDebugImageSave Then SaveDebugImage("HeroHall", False)
		Return False
	EndIf

	Local $avHeroHallRes, $aiHeroHallCoords

	; active/inactive Hero Hall have different images
	; loop thro the detected images
	For $i = 0 To UBound($avHeroHall, $UBOUND_ROWS) - 1
		$avHeroHallRes = $avHeroHall[$i]
		$aiHeroHallCoords = decodeSingleCoord($avHeroHallRes[1])
	Next

	If IsArray($aiHeroHallCoords) And UBound($aiHeroHallCoords, $UBOUND_ROWS) > 1 Then
		$g_aiHeroHallPos[0] = $aiHeroHallCoords[0]
		$g_aiHeroHallPos[1] = $aiHeroHallCoords[1]

		BuildingClick($g_aiHeroHallPos[0], $g_aiHeroHallPos[1])
		If _Sleep($DELAYIMGLOCATE1) Then Return
		Local $sHeroHallInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)
		If StringInStr($sHeroHallInfo[1], "Hero") Then
			$g_aiHeroHallPos[2] = $sHeroHallInfo[2]
			If $bSilent Then SetLog("Hero Hall Detected: (" & $g_aiHeroHallPos[0] & "," & $g_aiHeroHallPos[1] & "), Level: " & $g_aiHeroHallPos[2], $COLOR_SUCCESS)
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
EndFunc   ;==>ImgLocateHeroHall

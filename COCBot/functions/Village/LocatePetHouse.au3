; #FUNCTION# ====================================================================================================================
; Name ..........: LocatePetHouse
; Description ...:
; Syntax ........: LocatePetHouse()
; Parameters ....:
; Return values .: None
; Author ........: KnowJack (June 2015)
; Modified ......: Sardo 2015-08 GrumpyHog 2021-04
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2025
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
Func LocatePetHouse($bCollect = True)
	If $g_iTownHallLevel < 14 Then
		SetLog("Townhall Lvl " & $g_iTownHallLevel & " has no Pet House, so skip locating.", $COLOR_DEBUG)
		Return False
	EndIf

	Local $aPreviousPetHousePos[3] = [$g_aiPetHousePos[0], $g_aiPetHousePos[1], $g_aiPetHousePos[2]]
	$g_aiPetHousePos[0] = -1
	$g_aiPetHousePos[1] = -1
	$g_aiPetHousePos[2] = -1

	; auto locate
	If ImgLocatePetHouse(False, False, $aPreviousPetHousePos) Then
		SetLog("Pet House Detected: (" & $g_aiPetHousePos[0] & "," & $g_aiPetHousePos[1] & "), Level: " & $g_aiPetHousePos[2], $COLOR_SUCCESS)
		Return True
	EndIf

	If Not isInsideDiamond($aPreviousPetHousePos) Then LogUnknownBuildingPosition("Pet House")

	If Not _LocatePetHouse($bCollect) Then
		$g_aiPetHousePos[0] = $aPreviousPetHousePos[0]
		$g_aiPetHousePos[1] = $aPreviousPetHousePos[1]
		$g_aiPetHousePos[2] = $aPreviousPetHousePos[2]
		Return False
	EndIf

	Return True
EndFunc   ;==>LocatePetHouse

Func _LocatePetHouse($bCollect = True)
	Local $stext, $MsgBox, $iStupid = 0, $iSilly = 0, $sErrorText = ""

	WinGetAndroidHandle()
	checkMainScreen(False)

	While 1
		_ExtMsgBoxSet(1 + 64, $SS_CENTER, 0x004080, 0xFFFF00, 12, "Comic Sans MS", 600)
		$stext = $sErrorText & @CRLF & GetTranslatedFileIni("MBR Popups", "Func_Locate_PetHouse_01", "Click OK then click on your Pet House") & @CRLF & @CRLF & _
				GetTranslatedFileIni("MBR Popups", "Locate_building_01", -1) & @CRLF & @CRLF & GetTranslatedFileIni("MBR Popups", "Locate_building_02", -1) & @CRLF
		$MsgBox = _ExtMsgBox(0, GetTranslatedFileIni("MBR Popups", "Ok_Cancel", "Ok|Cancel"), GetTranslatedFileIni("MBR Popups", "Func_Locate_PetHouse_02", "Locate PetHouse"), $stext, 15)
		If $MsgBox = 1 Then
			WinGetAndroidHandle()
			ClearScreen()
			Local $aPos = FindPos()
			$g_aiPetHousePos[0] = Int($aPos[0])
			$g_aiPetHousePos[1] = Int($aPos[1])
			If isInsideDiamond($g_aiPetHousePos) = False Then
				$iStupid += 1
				Select
					Case $iStupid = 1
						$sErrorText = "Pet House Location Not Valid!" & @CRLF
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
						SetDebugLog(" Operator Error - Bad Pet House Location.", $COLOR_DEBUG)
						ClearScreen()
						Return False
				EndSelect
			EndIf
		Else
			SetLog("Locate Pet House Cancelled", $COLOR_INFO)
			ClearScreen()
			Return False
		EndIf
		Local $sPetHouseInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)
		If $sPetHouseInfo[0] > 1 Or $sPetHouseInfo[0] = "" Then
			If StringInStr($sPetHouseInfo[1], "Pet") = 0 Then
				Local $sLocMsg = ($sPetHouseInfo[0] = "" ? "Nothing" : $sPetHouseInfo[1])

				$iSilly += 1
				Select
					Case $iSilly = 1
						$sErrorText = "Wait, That is not the Pet House?, It was a " & $sLocMsg & @CRLF
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
						SetDebugLog("Ok, you really think that's a Pet House?" & @CRLF & "I don't care anymore, go ahead with it!", $COLOR_DEBUG)
						ClearScreen()
						ExitLoop
				EndSelect
			EndIf
		Else
			SetDebugLog(" Operator Error - Bad Pet House Location: " & "(" & $g_aiPetHousePos[0] & "," & $g_aiPetHousePos[1] & ")", $COLOR_DEBUG)
			$g_aiPetHousePos[0] = -1
			$g_aiPetHousePos[1] = -1
			ClearScreen()
			Return False
		EndIf
		$g_aiPetHousePos[2] = $sPetHouseInfo[2]
		SetLog("Pet House Detected: (" & $g_aiPetHousePos[0] & "," & $g_aiPetHousePos[1] & "), Level: " & $g_aiPetHousePos[2], $COLOR_SUCCESS)
		ExitLoop
	WEnd
	ClearScreen()
	Return True

EndFunc   ;==>_LocatePetHouse

; Image Search for Pet House
Func ImgLocatePetHouse($bSilent = False, $bKeepSelected = False, $aPreviousPos = Default)
	Local $sImgDir = @ScriptDir & "\imgxml\Buildings\PetHouse\"

	Local $sSearchArea = "FV"
	Local $avPetHouse, $bLocalSearch = False

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
		$avPetHouse = findMultiple($sImgDir, $sLocalArea, $sLocalArea, 0, 1000, 1, "objectname,objectpoints", True)
		$bLocalSearch = True
	EndIf

	; Fallback: preserve the original full-village search.
	If Not IsArray($avPetHouse) Or UBound($avPetHouse, $UBOUND_ROWS) <= 0 Then _
		$avPetHouse = findMultiple($sImgDir, $sSearchArea, $sSearchArea, 0, 1000, 1, "objectname,objectpoints", Not $bLocalSearch)

	If Not IsArray($avPetHouse) Or UBound($avPetHouse, $UBOUND_ROWS) <= 0 Then
		If Not $bSilent Then SetDebugLog("Couldn't find Pet House on main village", $COLOR_DEBUG)
		If $g_bDebugImageSave Then SaveDebugImage("PetHouse", False)
		Return False
	EndIf

	Local $avPetHouseRes, $aiPetHouseCoords

	; active/inactive Pet House have different images
	; loop thro the detected images
	For $i = 0 To UBound($avPetHouse, $UBOUND_ROWS) - 1
		$avPetHouseRes = $avPetHouse[$i]
		$aiPetHouseCoords = decodeSingleCoord($avPetHouseRes[1])
	Next

	If IsArray($aiPetHouseCoords) And UBound($aiPetHouseCoords, $UBOUND_ROWS) > 1 Then
		$g_aiPetHousePos[0] = $aiPetHouseCoords[0]
		$g_aiPetHousePos[1] = $aiPetHouseCoords[1]
		BuildingClick($g_aiPetHousePos[0], $g_aiPetHousePos[1])
		If _Sleep($DELAYIMGLOCATE1) Then Return
		Local $sPetHouseInfo = BuildingInfo(242, 475 + $g_iBottomOffsetY)
		If StringInStr($sPetHouseInfo[1], "Pet") Then
			$g_aiPetHousePos[2] = $sPetHouseInfo[2]
			If $bSilent Then SetLog("Pet House Detected: (" & $g_aiPetHousePos[0] & "," & $g_aiPetHousePos[1] & ")", $COLOR_SUCCESS)
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
EndFunc   ;==>ImgLocatePetHouse

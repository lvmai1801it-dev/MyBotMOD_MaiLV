; #FUNCTION# ===========================================================================================================
; Name ..........: Attack Report Test
; Author ........: Phael
; Description ...: Runs AttackReport OCR against a PNG loaded into TestCapture.
; Remarks .......: Attack totals and database stats are not updated.
; ======================================================================================================================
Func AtkReport($sPngPath, $vMode = "normal")
	; === TEST INITIALIZATION ===
	Local $sMode = _AtkReportMode($vMode)
	Local $bRevengeBattle = ($sMode = "revenge")
	Local $bRankedBattle = ($sMode = "ranked")

	; === IMAGE VALIDATION ===
	If Not FileExists($sPngPath) Then
		SetLog("[AtkReport] Test image not found: " & $sPngPath, $COLOR_ERROR)
		Return False
	EndIf

	Local $hHBitmap = _AtkReportLoadPngAsHBitmap($sPngPath)
	If $hHBitmap = 0 Then Return False

	; === STATE BACKUP ===
	Local $bRunState = $g_bRunState
	Local $bOcrForceCaptureRegion = OcrForceCaptureRegion()

	; === CAPTURE SETUP ===
	SetLog("[AtkReport] Testing PNG: " & $sPngPath, $COLOR_INFO)
	SetLog("[AtkReport] Mode: " & _AtkReportModeText($sMode), $COLOR_INFO)

	$g_bRunState = True
	OcrForceCaptureRegion(True)
	TestCapture($hHBitmap)
	_CaptureRegion()
	_CaptureRegion2Sync()

	; === REPORT EXECUTION ===
	AttackReport($bRevengeBattle, True, $bRankedBattle)

	; === STATE RESTORATION ===
	_AtkReportRestoreCaptureState($bRunState, $bOcrForceCaptureRegion)
	Return True
EndFunc   ;==>AtkReport

; === HELPERS ===

Func _AtkReportMode($vMode)
	If IsString($vMode) Then
		Local $sMode = StringLower(StringStripWS($vMode, $STR_STRIPALL))
		If $sMode = "normal" Or $sMode = "n" Then Return "normal"
		If $sMode = "ranked" Or $sMode = "rk" Then Return "ranked"
		If $sMode = "revenge" Or $sMode = "rv" Or $sMode = "r" Then Return "revenge"
		Return "normal"
	EndIf

	Return ($vMode = True ? "revenge" : "normal")
EndFunc   ;==>_AtkReportMode

Func _AtkReportModeText($sMode)
	Switch $sMode
		Case "ranked"
			Return "Ranked"
		Case "revenge"
			Return "Revenge"
	EndSwitch

	Return "Normal"
EndFunc   ;==>_AtkReportModeText

Func _AtkReportLoadPngAsHBitmap($sPngPath)
	Local $hBitmap = _GDIPlus_BitmapCreateFromFile($sPngPath)
	If $hBitmap = 0 Then
		SetLog("[AtkReport] Could not load PNG: " & $sPngPath, $COLOR_ERROR)
		Return 0
	EndIf

	Local $hHBitmap = _GDIPlus_BitmapCreateDIBFromBitmap($hBitmap)
	_GDIPlus_BitmapDispose($hBitmap)

	If $hHBitmap = 0 Then
		SetLog("[AtkReport] Could not create bitmap handle: " & $sPngPath, $COLOR_ERROR)
		Return 0
	EndIf

	Return $hHBitmap
EndFunc   ;==>_AtkReportLoadPngAsHBitmap

Func _AtkReportRestoreCaptureState($bRunState, $bOcrForceCaptureRegion)
	OcrForceCaptureRegion($bOcrForceCaptureRegion)
	$g_bRunState = $bRunState

	If $g_hBitmap <> 0 Then GdiDeleteBitmap($g_hBitmap)
	If $g_hHBitmap2 <> 0 And $g_hHBitmap2 <> $g_hHBitmapTest And $g_hHBitmap2 <> $g_hHBitmap Then GdiDeleteHBitmap($g_hHBitmap2)

	$g_hHBitmap = 0
	TestCapture(0)
EndFunc   ;==>_AtkReportRestoreCaptureState

Attribute VB_Name = "Ppt_To_Svg"
' Name:
' - Convert_Powerpoint_To_SVG
'
' Purpose:
' - To convert Powerpoint Presentations into SVG-files.
' - Support the NATO Open Systems Working Group to use
' - Powerpoint to provide graphics in SVG-format for
' - inclusion in the NC3TA.
'
' Description:
' - A messagebox appears asking the user to specify the
'   powerpoint files that need to be converted.
' - The user can select interactively the files that need
'   to be converted.
' - The resultfiles will be put in a subdirectory of the
'   source directory called “SVG”. If it does not exist,
'   it will be created.
'
' System requirements:
' - Powerpoint97 or higher is supported.
'
' Version Info
' - Version: 1.0
' - Date: 17 March 2003
'   Initial release to NATO Open Systems Working Group.
'
' Limitations
' - Version 1.0 only implements a subset of the powerpoint
'   functionality that is relevant to convert a major subset
'   of existing NC3TA Powerpoint slides to the SVG format.
'
' Author:
' - W.H. van Goeverden, Mod NL / DTO
'
' Copyright info:
' - Copyright 2003, Ministry of Defence of the Netherlands,
'   Defensie Telematica Organisatie
' - Permission is granted to use this software to support
'   the development and maintenance of figures being used
'   in the NATO C3 Technical Architecture.
'
' Warranty info:
' - This software is provided ``as is'' and without any
'   express or implied warranties, including, without
'   limitation, the implied warranties of merchantability
'   and fitness for a particular purpose.
'
Option Explicit

Private Declare Function GetOpenFileName Lib "comdlg32.dll" Alias _
    "GetOpenFileNameA" (pOpenfilename As Open_Filename_Tp) As Boolean
         
Private Type Open_Filename_Tp
    lStructSize As Long
    hwndOwner As Long
    hInstance As Long
    lpstrFilter As String
    lpstrCustomFilter As String
    nMaxCustFilter As Long
    nFilterIndex As Long
    lpstrFile As String
    nMaxFile As Long
    lpstrFileTitle As String
    nMaxFileTitle As Long
    lpstrInitialDir As String
    lpstrTitle As String
    flags As Long
    nFileOffset As Integer
    nFileExtension As Integer
    lpstrDefExt As String
    lCustData As Long
    lpfnHook As Long
    lpTemplateName As String
End Type

Private Source_Directory As String
Private Target_Directory As String
Private Filename As String
Private Cur_Indent As Integer
Private ForeColor_Red, ForeColor_Green, ForeColor_Blue As Integer
Private BackColor_Red, BackColor_Green, BackColor_Blue As Integer
Private LineColor_Red, LineColor_Green, LineColor_Blue As Integer
Private MidDark_ForeColor_Red, MidLight_ForeColor_Red As Integer
Private MidDark_ForeColor_Green, MidLight_ForeColor_Green As Integer
Private MidDark_ForeColor_Blue, MidLight_ForeColor_Blue As Integer

Private Sh_Text_Color, Sh_Text_Color_Red, Sh_Text_Color_Green, Sh_Text_Color_Blue As Integer
Private Shape_Filled As Boolean
Private Shapeline_Visible As Boolean
Private Shapeline_Weight As Single
Private Symbolname As String
Public Sub Convert_Powerpoint_To_SVG()
    Dim OpenFile As Open_Filename_Tp
    Dim lReturn As Long
    Dim Pathname, Filename As String
    Dim Start_Index_FirstFile As Long
    Dim Start_Index_Filename, End_Index_Filename As Long
    Dim OFN_AllowMultiSelect As Long
    Dim OFN_FileMustExist As Long
    Dim OFN_Explorer As Long
    Dim Total_Result_List As String
    Dim Subdirname As String
    Dim SVG_Subdir_Exists As Boolean
    Total_Result_List = "List of converted presentations:" & Chr(10) & Chr(10)
    SVG_Subdir_Exists = False
    OFN_AllowMultiSelect = &H200
    OFN_FileMustExist = &H1000
    OFN_Explorer = &H80000
    OpenFile.lStructSize = Len(OpenFile)
    OpenFile.hwndOwner = 0
    OpenFile.lpstrFilter = "Powerpoint Slides (*.ppt)" & Chr(0) & "*.ppt" & Chr(0)
    OpenFile.nFilterIndex = 1
    OpenFile.lpstrFile = String(20000, 0)
    OpenFile.nMaxFile = Len(OpenFile.lpstrFile) - 1
    OpenFile.lpstrFileTitle = OpenFile.lpstrFile
    OpenFile.nMaxFileTitle = OpenFile.nMaxFile
    OpenFile.lpstrInitialDir = ""
    OpenFile.lpstrTitle = "Select Powerpoint files that must be converted"
    OpenFile.flags = OFN_FileMustExist + OFN_AllowMultiSelect + OFN_Explorer
    OpenFile.lpstrDefExt = "ppt"
    lReturn = GetOpenFileName(OpenFile)
    If lReturn = 1 Then
        Start_Index_FirstFile = OpenFile.nFileOffset
        Pathname = Left(OpenFile.lpstrFile, Start_Index_FirstFile - 1)
        Subdirname = Dir(Pathname & "\", vbDirectory)
        Do While Subdirname <> ""
            If Subdirname <> "." And Subdirname <> ".." Then
                If (GetAttr(Pathname & "\" & Subdirname) And vbDirectory) = vbDirectory Then
                    If UCase(Subdirname) = "SVG" Then
                        SVG_Subdir_Exists = True
                    End If
                End If
            End If
            Subdirname = Dir
        Loop
        If SVG_Subdir_Exists = False Then
            MkDir (Pathname & "\SVG")
        End If
        Start_Index_Filename = Start_Index_FirstFile + 1
        'Explict type conversion
        Dim Pathname_StrPar As String
        Pathname_StrPar = Pathname
        Do
            End_Index_Filename = InStr(Start_Index_Filename, OpenFile.lpstrFile, Chr(0), vbTextCompare)
            Filename = Mid(OpenFile.lpstrFile, Start_Index_Filename, End_Index_Filename - Start_Index_Filename - 4)
            Call Ppt2Svg( _
                Source_Directory:=CStr(Pathname), _
                Target_Directory:=CStr(Pathname & "\SVG"), _
                Figure_Name:=Filename)
            Presentations(Filename).Close
            Start_Index_Filename = End_Index_Filename + 1
            Total_Result_List = Total_Result_List & "- " & Filename & Chr(10)
        Loop While Mid(OpenFile.lpstrFile, Start_Index_Filename, 1) <> Chr(0)
    Else
        Total_Result_List = Total_Result_List & "- No files were converted"
    End If
    MsgBox (Total_Result_List)
End Sub
Private Function Format_3Dec(Number As Variant)
    Dim Number_String, Result As String
    Dim Char_Nr As Long
    Result = ""
    If Number = 0 Then
        Number_String = "0"
    Else
        Number_String = Format(Number, "0.###")
    End If
    If Mid$(Number_String, Len(Number_String), 1) = "," Then
        Number_String = Mid$(Number_String, 1, Len(Number_String) - 1)
        Result = Number_String
    ElseIf Mid$(Number_String, Len(Number_String), 1) = "." Then
        Number_String = Mid$(Number_String, 1, Len(Number_String) - 1)
        Result = Number_String
    Else
        For Char_Nr = 1 To Len(Number_String)
            If Mid$(Number_String, Char_Nr, 1) = "," Then
                Result = Result & "."
            Else
                Result = Result & Mid$(Number_String, Char_Nr, 1)
            End If
        Next Char_Nr
    End If
    Format_3Dec = Result
End Function
Private Sub Put_SVGLine(Line As String)
    Print #1, Space$(Cur_Indent) & Line
End Sub
Private Sub Increment_Indent()
    Cur_Indent = Cur_Indent + 2
End Sub
Private Sub Decrement_Indent()
    Cur_Indent = Cur_Indent - 2
End Sub
Private Function String_Without_Spaces(Input_String As String)
    Dim Result As String
    Dim Char_Nr As Long
    For Char_Nr = 1 To Len(Input_String)
        If Mid$(Input_String, Char_Nr, 1) <> " " Then
            Result = Result & Mid$(Input_String, Char_Nr, 1)
        End If
    Next Char_Nr
    String_Without_Spaces = Result
End Function
Private Sub Ppt2Svg( _
    Source_Directory As String, _
    Target_Directory As String, _
    Figure_Name As String)
    Dim Source_Filename As String
    Source_Filename = Source_Directory & "\" & _
        Figure_Name & ".ppt"
    Presentations.Open Filename:=Source_Filename, ReadOnly:=msoFalse
    Cur_Indent = 0
    Open Target_Directory & "\" & _
        Figure_Name & ".svg" For Output As #1
    Put_SVGLine ("<?xml version=""1.0"" standalone=""no""?>")
    Put_SVGLine ("<!DOCTYPE svg PUBLIC ""-//W3C//DTD SVG 1.0//EN""")
    Call Increment_Indent
        Put_SVGLine ("""http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd"">")
    Call Decrement_Indent
    Put_SVGLine ("<svg width=""" & _
        Format_3Dec(ActivePresentation.PageSetup.SlideWidth) + 20 & _
        """ height=""" & _
        Format_3Dec(ActivePresentation.PageSetup.SlideHeight) + 20 & """>")
    Call Increment_Indent
        Call Parse_Slide(ActivePresentation.Slides(1))
    Call Decrement_Indent
    Put_SVGLine ("</svg>")
    Close #1
End Sub
Private Sub Parse_Slide(Cur_Slide As Slide)
    Dim Sh As Shape
    For Each Sh In Cur_Slide.Shapes
        Call Convert_Shape(Sh:=Sh)
    Next Sh
End Sub
Private Sub Convert_Shape(Sh As Shape)
    ForeColor_Red = Sh.Fill.ForeColor.RGB Mod 256
    ForeColor_Green = Sh.Fill.ForeColor.RGB \ 256 Mod 256
    ForeColor_Blue = Sh.Fill.ForeColor.RGB \ 65536 Mod 256
    BackColor_Red = Sh.Fill.BackColor.RGB Mod 256
    BackColor_Green = Sh.Fill.BackColor.RGB \ 256 Mod 256
    BackColor_Blue = Sh.Fill.BackColor.RGB \ 65536 Mod 256
    LineColor_Red = Sh.Line.ForeColor.RGB Mod 256
    LineColor_Green = Sh.Line.ForeColor.RGB \ 256 Mod 256
    LineColor_Blue = Sh.Line.ForeColor.RGB \ 65536 Mod 256
    Shape_Filled = Sh.Fill.Visible
    Shapeline_Visible = Sh.Line.Visible
    Shapeline_Weight = Sh.Line.Weight
    Select Case Sh.Type
        Case msoGroup
            Call Group2SVG(Sh:=Sh)
        Case msoAutoShape
            Call AutoShape2Svg(Sh:=Sh)
            If Sh.HasTextFrame Then
                Call Put_Shape_Text_Frame(Sh)
            End If
        Case msoCallout
            MsgBox ("Conversion of ""Callout Shapes"" not yet supported")
        Case msoChart
            MsgBox ("Conversion of ""Chart Shapes"" not yet supported")
        Case msoComment
            MsgBox ("Conversion of ""Comment Shapes"" not yet supported")
        Case msoEmbeddedOLEObject
            MsgBox ("Conversion of ""EmbeddedOLEObject Shapes"" not yet supported")
        Case msoFormControl
            MsgBox ("Conversion of ""FormControl Shapes"" not yet supported")
        Case msoFreeform
            Call Freeform2SVG(Sh:=Sh)
            If Sh.HasTextFrame Then
                Call Put_Shape_Text_Frame(Sh)
            End If
        Case msoLine
            Call Line2Svg(Sh:=Sh)
        Case msoLinkedOLEObject
            MsgBox ("Conversion of ""LinkedOLEObject Shapes"" not yet supported")
        Case msoLinkedPicture
            MsgBox ("Conversion of ""LinkedPicture Shapes"" not yet supported")
        Case msoMedia
            MsgBox ("Conversion of ""Media Shapes"" not yet supported")
        Case msoOLEControlObject
            MsgBox ("Conversion of ""OLEControlObject Shapes"" not yet supported")
        Case msoPicture
            MsgBox ("Conversion of ""Picture Shapes"" not yet supported")
        Case msoPlaceholder
            Select Case Sh.PlaceholderFormat.Type
                Case ppPlaceholderTitle
                    If Sh.HasTextFrame Then
                        Call Put_Shape_Text_Frame(Sh)
                    End If
                Case ppPlaceholderCenterTitle
                    If Sh.HasTextFrame Then
                        Call Put_Shape_Text_Frame(Sh)
                    End If
                Case Else
                    MsgBox ("Conversion of ""Placeholder Shapes"" not yet supported")
            End Select
        Case msoShapeTypeMixed
            MsgBox ("Conversion of ""ShapeTypeMixed Shapes"" not yet supported")
        Case msoTextBox
            Call TextBox2SVG(Sh:=Sh)
            If Sh.HasTextFrame Then
                Call Put_Shape_Text_Frame(Sh)
            End If
        Case msoTextEffect
            MsgBox ("Conversion of ""TextEffect Shapes"" not yet supported")
    End Select
End Sub
Private Sub Put_Shape_Fill_Attributes(Sh As Shape)
    If Shape_Filled Then
        Call Put_SVGLine(Line:="fill=""rgb(" & _
            ForeColor_Red & "," & _
            ForeColor_Green & "," & _
            ForeColor_Blue & ")""")
    Else
        Call Put_SVGLine(Line:="fill=""none""")
    End If
End Sub
Private Sub Put_Shape_Line_Attributes(Sh As Shape)
    If Shapeline_Visible Then
        Call Put_SVGLine(Line:="stroke=""rgb(" & _
            LineColor_Red & "," & _
            LineColor_Green & "," & _
            LineColor_Blue & ")""")
        Select Case Sh.Line.DashStyle
            Case msoLineDash
                Call Put_SVGLine(Line:="stroke-dasharray=""" & Format_3Dec(4.5 * Shapeline_Weight) & "," & Format_3Dec(3 * Shapeline_Weight) & """")
            Case msoLineDashDot
            Case msoLineDashDotDot
            Case msoLineDashStyleMixed
            Case msoLineLongDash
            Case msoLineLongDashDot
                Call Put_SVGLine(Line:="stroke-dasharray=""15,5,5,5""")
            Case msoLineRoundDot
                Call Put_SVGLine(Line:="stroke-dasharray=""1""")
            Case msoLineSquareDot
                Call Put_SVGLine(Line:="stroke-dasharray=""" & Format_3Dec(Shapeline_Weight) & "," & Format_3Dec(Shapeline_Weight) & """")
            Case msoLineSolid
            Case msoLineSquareDot
        End Select
        Call Put_SVGLine(Line:="stroke-width=""" & Format_3Dec(Shapeline_Weight) & """")
    Else
        Call Put_SVGLine(Line:="stroke=""none""")
    End If
End Sub
Private Sub Put_Shape_Transform_Attributes(Sh As Shape)
    Call Put_SVGLine(Line:="transform=")
    Call Increment_Indent
        If Sh.Rotation = 0 Then
            Call Put_SVGLine(Line:="""translate(" & _
                Format_3Dec(Sh.Left + Sh.Width / 2) & ", " & _
                Format_3Dec(Sh.Top + Sh.Height / 2) & ")""")
        Else
            Call Put_SVGLine(Line:="""translate(" & _
                Format_3Dec(Sh.Left + Sh.Width / 2) & ", " & _
                Format_3Dec(Sh.Top + Sh.Height / 2) & ")")
            Call Put_SVGLine(Line:="rotate(" & _
                Format_3Dec(Sh.Rotation) & ")""")
        End If
    Call Decrement_Indent
End Sub
Private Sub Put_Shape_Text_Frame(Sh As Shape)
    Dim SVG_Line, Temp_SVG_Line As String
    With Sh.TextFrame
        Sh_Text_Color = .TextRange.Font.Color.RGB
        Sh_Text_Color_Red = Sh_Text_Color Mod 256
        Sh_Text_Color_Green = Sh_Text_Color \ 256 Mod 256
        Sh_Text_Color_Blue = Sh_Text_Color \ 65536 Mod 256
        Dim Num_Of_Lines As Integer
        Dim X_Coord, Y_Coord As Integer
        Dim Char_Nr As Integer
        If .HasText Then
            For Num_Of_Lines = 1 To .TextRange.Lines.Count
                X_Coord = 0
                Y_Coord = 0
                Call Put_SVGLine(Line:="<text")
                Call Increment_Indent
                    Call Put_SVGLine(Line:="x=" & """" & Format_3Dec(X_Coord) & """")
                    Call Put_SVGLine(Line:="y=" & """" & Format(Y_Coord, "0") & """")
                    If (Sh.TextFrame.TextRange.Lines(Num_Of_Lines).Font.Name = "Symbol") Or _
                        (Sh.TextFrame.TextRange.Lines(Num_Of_Lines).Font.Name = "Wingdings") Then
'                        font-family undefined
                    Else
                        Call Put_SVGLine(Line:="font-family=" & """" & _
                            Sh.TextFrame.TextRange.Lines(Num_Of_Lines).Font.Name & """")
                    End If
                    Call Put_SVGLine(Line:="font-size=" & """" & Sh.TextFrame.TextRange.Lines(Num_Of_Lines).Characters(1).Font.Size & """")
                    If Sh.TextFrame.TextRange.Lines(Num_Of_Lines).Font.Underline Then
                        Call Put_SVGLine(Line:="text-decoration=""underline""")
                    End If
                    If Sh.TextFrame.TextRange.Lines(Num_Of_Lines).Font.Italic Then
                        Call Put_SVGLine(Line:="font-style=""italic""")
                    End If
                    If Sh.TextFrame.TextRange.Lines(Num_Of_Lines).Font.Bold Then
                        Call Put_SVGLine(Line:="font-weight=""bold""")
                    End If
                    If Sh.TextFrame.Orientation = msoTextOrientationHorizontal Then
                        Call Put_SVGLine(Line:="transform=")
                        Call Increment_Indent
                            Call Put_SVGLine(Line:="""translate(" & _
                                Format_3Dec(Sh.Left + Sh.Width / 2) & "," & _
                                Format_3Dec(Sh.Top + Sh.Height / 2) & ")")
                            Call Put_SVGLine(Line:="rotate(" & _
                                Format_3Dec(Sh.Rotation) & ")")
                            Call Put_SVGLine(Line:="translate(" & _
                                Format_3Dec(-(Sh.Left + Sh.Width / 2) + _
                                    Sh.TextFrame.TextRange.Lines(Num_Of_Lines).BoundLeft) & "," & _
                                Format_3Dec(-(Sh.Top + Sh.Height / 2) - _
                                    (Sh.TextFrame.TextRange.Lines(Num_Of_Lines).Characters(1).Font.Size / 2) + _
                                    Sh.TextFrame.TextRange.Lines(Num_Of_Lines).BoundHeight + _
                                    Sh.TextFrame.TextRange.Lines(Num_Of_Lines).BoundTop) & ")""")
                        Call Decrement_Indent
                    ElseIf Sh.TextFrame.Orientation = msoTextOrientationVerticalFarEast Then
                        Call Put_SVGLine(Line:="transform=")
                        Call Increment_Indent
                            Call Put_SVGLine(Line:= _
                                """translate(" & _
                                Format_3Dec(Sh.TextFrame.TextRange.BoundLeft + Sh.TextFrame.TextRange.BoundWidth) & "," & _
                                Format_3Dec(Sh.TextFrame.TextRange.BoundTop) & ")")
                            Call Put_SVGLine(Line:= _
                                "rotate(" & Format_3Dec(90) & ")")
                            Call Put_SVGLine(Line:= _
                                "translate(" & _
                                Format_3Dec(-Sh.TextFrame.TextRange.BoundLeft) & ", " & _
                                Format_3Dec(-Sh.TextFrame.TextRange.BoundTop) & ")")
                            Call Put_SVGLine(Line:= _
                                "rotate(" & Format_3Dec(Sh.Rotation) & ")")
                            Call Put_SVGLine(Line:= _
                                "translate(" & _
                                Format_3Dec(Sh.Left + Sh.Width / 2) & "," & _
                                Format_3Dec(Sh.Top + Sh.Height / 2) & ")")
                            Call Put_SVGLine(Line:= _
                                "rotate(" & Format_3Dec(Sh.Rotation) & ")")
                            Call Put_SVGLine(Line:= _
                                "translate(" & _
                                Format_3Dec(-(Sh.Left + Sh.Width / 2) + _
                                    Sh.TextFrame.TextRange.Lines(Num_Of_Lines).BoundLeft) & "," & _
                                Format_3Dec(-(Sh.Top + Sh.Height / 2) - _
                                    (Sh.TextFrame.TextRange.Lines(Num_Of_Lines).Characters(1).Font.Size / 2) + _
                                    Sh.TextFrame.TextRange.Lines(Num_Of_Lines).BoundWidth + _
                                    Sh.TextFrame.TextRange.Lines(Num_Of_Lines).BoundTop) & ")""")
                        Call Decrement_Indent
                    End If
                    Call Put_SVGLine(Line:= _
                        "stroke=""rgb(" & _
                        Sh_Text_Color_Red & "," & _
                        Sh_Text_Color_Green & "," & Sh_Text_Color_Blue & ")"">")
                    Temp_SVG_Line = Sh.TextFrame.TextRange.Lines(Num_Of_Lines).Text
                    SVG_Line = ""
                    For Char_Nr = 1 To Len(Temp_SVG_Line)
                        If AscW(Mid$(Temp_SVG_Line, Char_Nr, 1)) = 34 Then
                            SVG_Line = SVG_Line & "&quot;"
                        ElseIf AscW(Mid$(Temp_SVG_Line, Char_Nr, 1)) = 147 Then
                            SVG_Line = SVG_Line & "&quot;"
                        ElseIf AscW(Mid$(Temp_SVG_Line, Char_Nr, 1)) = 148 Then
                            SVG_Line = SVG_Line & "&quot;"
                        ElseIf AscW(Mid$(Temp_SVG_Line, Char_Nr, 1)) = 38 Then
                            SVG_Line = SVG_Line & "&amp;"
                        ElseIf AscW(Mid$(Temp_SVG_Line, Char_Nr, 1)) = 39 Then
                            SVG_Line = SVG_Line & "&apos;"
                        ElseIf AscW(Mid$(Temp_SVG_Line, Char_Nr, 1)) = 145 Then
                            SVG_Line = SVG_Line & "&apos;"
                        ElseIf AscW(Mid$(Temp_SVG_Line, Char_Nr, 1)) = 146 Then
                            SVG_Line = SVG_Line & "&apos;"
                        ElseIf AscW(Mid$(Temp_SVG_Line, Char_Nr, 1)) = -3864 Then
                            SVG_Line = SVG_Line & "&#x2192;"
                        ElseIf (AscW(Mid$(Temp_SVG_Line, Char_Nr, 1)) = 87) And _
                            Sh.TextFrame.TextRange.Lines(Num_Of_Lines).Characters(Char_Nr).Font.Name = "Symbol" Then
                                SVG_Line = SVG_Line & "&#x03A9;"
                        ElseIf (AscW(Mid$(Temp_SVG_Line, Char_Nr, 1)) = 232) And _
                            Sh.TextFrame.TextRange.Lines(Num_Of_Lines).Characters(Char_Nr).Font.Name = "Wingdings" Then
                                SVG_Line = SVG_Line & "&#x2192;"
                        ElseIf AscW(Mid$(Temp_SVG_Line, Char_Nr, 1)) = -4009 Then
                            SVG_Line = SVG_Line & "&#x03A9;"
                        ElseIf AscW(Mid$(Temp_SVG_Line, Char_Nr, 1)) < 32 Then
                            SVG_Line = SVG_Line
                        ElseIf (AscW(Mid$(Temp_SVG_Line, Char_Nr, 1)) >= 32) And _
                            (AscW(Mid$(Temp_SVG_Line, Char_Nr, 1)) < 127) Then
                            SVG_Line = SVG_Line & Mid$(Temp_SVG_Line, Char_Nr, 1)
                        Else
                            SVG_Line = SVG_Line & "&#" & AscW(Mid$(Temp_SVG_Line, Char_Nr, 1)) & ";"
                        End If
                    Next Char_Nr
                    Call Put_SVGLine(Line:=CStr(SVG_Line))
                Call Decrement_Indent
                Call Put_SVGLine(Line:="</text>")
            Next Num_Of_Lines
        End If
    End With
End Sub
Private Sub AutoShape2Svg(Sh As Shape)
'    Call Put_SVGLine(Line:="<defs>")
'    Call Increment_Indent
        Select Case Sh.AutoShapeType
            Case msoShapeRectangle
                Call Rectangle2Svg(Sh:=Sh)
            Case msoShapeOval
                Call Oval2Svg(Sh:=Sh)
            Case msoShapeFlowchartAlternateProcess
                Call FlowchartAlternateProcess2Svg( _
                    Sh:=Sh, Width:=73, Height:=49)
            Case msoShapeFlowchartCard
                Call FlowchartCard2Svg( _
                    Sh:=Sh, Width:=73, Height:=64)
            Case msoShapeFlowchartCollate
                Call FlowchartCollate2Svg( _
                   Sh:=Sh, Width:=37, Height:=73)
            Case msoShapeFlowchartConnector
                Call FlowchartConnector2Svg( _
                   Sh:=Sh, Width:=73, Height:=73)
            Case msoShapeFlowchartData
                Call FlowchartData2Svg( _
                   Sh:=Sh, Width:=73, Height:=49)
            Case msoShapeFlowchartDecision
                Call FlowchartDecision2Svg( _
                   Sh:=Sh, Width:=73, Height:=49)
            Case msoShapeFlowchartDelay
                Call FlowchartDelay2Svg( _
                   Sh:=Sh, Width:=49, Height:=49)
            Case msoShapeFlowchartDirectAccessStorage
                Call FlowchartDirectAccessStorage2Svg( _
                   Sh:=Sh, Width:=73, Height:=55)
            Case msoShapeFlowchartDisplay
                Call FlowchartDisplay2Svg( _
                   Sh:=Sh, Width:=73, Height:=49)
            Case msoShapeFlowchartDocument
                Call FlowchartDocument2Svg( _
                   Sh:=Sh, Width:=73, Height:=49)
            Case msoShapeFlowchartExtract
                Call FlowchartExtract2Svg( _
                   Sh:=Sh, Width:=55, Height:=55)
            Case msoShapeFlowchartInternalStorage
                Call FlowchartInternalStorage2Svg( _
                   Sh:=Sh, Width:=49, Height:=49)
            Case msoShapeFlowchartMagneticDisk
                Call FlowchartMagneticDisk2Svg( _
                   Sh:=Sh, Width:=73, Height:=49)
            Case msoShapeFlowchartManualInput
                Call FlowchartManualInput2Svg( _
                   Sh:=Sh, Width:=73, Height:=37)
            Case msoShapeFlowchartManualOperation
                Call FlowchartManualOperation2Svg( _
                   Sh:=Sh, Width:=73, Height:=49)
            Case msoShapeFlowchartMerge
                Call FlowchartMerge2Svg( _
                   Sh:=Sh, Width:=55, Height:=55)
            Case msoShapeFlowchartMultidocument
                Call FlowchartMultidocument2Svg( _
                   Sh:=Sh, Width:=85, Height:=61)
            Case msoShapeFlowchartOffpageConnector
                Call FlowchartOffpageConnector2Svg( _
                   Sh:=Sh, Width:=49, Height:=49)
            Case msoShapeFlowchartOr
                Call FlowchartOr2Svg( _
                   Sh:=Sh, Width:=49, Height:=49)
            Case msoShapeFlowchartPredefinedProcess
                Call FlowchartPredefinedProcess2Svg( _
                   Sh:=Sh, Width:=73, Height:=49)
            Case msoShapeFlowchartPreparation
                Call FlowchartPreparation2Svg( _
                   Sh:=Sh, Width:=85, Height:=49)
            Case msoShapeFlowchartProcess
                Call FlowchartProcess2Svg( _
                   Sh:=Sh, Width:=73, Height:=49)
            Case msoShapeFlowchartPunchedTape
                Call FlowchartPunchedTape2Svg( _
                   Sh:=Sh, Width:=73, Height:=64)
            Case msoShapeFlowchartSequentialAccessStorage
                Call FlowchartSequentialAccessStorage2Svg( _
                   Sh:=Sh, Width:=49, Height:=49)
            Case msoShapeFlowchartSort
                Call FlowchartSort2Svg( _
                   Sh:=Sh, Width:=37, Height:=73)
            Case msoShapeFlowchartStoredData
                Call FlowchartStoredData2Svg( _
                   Sh:=Sh, Width:=73, Height:=49)
            Case msoShapeFlowchartSummingJunction
                Call FlowchartSummingJunction2Svg( _
                   Sh:=Sh, Width:=49, Height:=49)
            Case msoShapeFlowchartTerminator
                Call FlowchartTerminator2Svg( _
                   Sh:=Sh, Width:=73, Height:=25)
            Case msoShapeRoundedRectangle
                Call RoundedRectangle2Svg( _
                   Sh:=Sh, Width:=72, Height:=72)
            Case msoShapeActionButtonBackorPrevious
                Call ActionButtonBackorPrevious2Svg( _
                   Sh:=Sh, Width:=82.875, Height:=82.875)
            Case msoShapeRightArrow
                Call ShapeRightArrow2Svg( _
                   Sh:=Sh, Width:=76.875, Height:=38.25)
            Case msoShapeCube
                Call ShapeCube2Svg( _
                   Sh:=Sh, Width:=95.5, Height:=95.5)
            Case Else
                Call UndefinedAutoshape2SVG( _
                   Sh:=Sh, Width:=Sh.Width, Height:=Sh.Height)
        End Select
'    Call Decrement_Indent
'    Call Put_SVGLine(Line:="</defs>")
'    Dim Symbolname As String
'    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
'    Call Put_SVGLine(Line:="<use ")
'    Call Increment_Indent
'        Call Put_SVGLine(Line:="xlink:href=""#" & Symbolname & """")
'        Call Put_SVGLine(Line:= _
'             "x=""" & Format_3Dec(-Sh.Width / 2) & """ " & _
'             "y=""" & Format_3Dec(-Sh.Height / 2) & """ " & _
'             "width=""" & Format_3Dec(Sh.Width) & """ " & _
'             "height=""" & Format_3Dec(Sh.Height) & """")
'        Call Put_Shape_Fill_Attributes(Sh)
'        Call Put_Shape_Line_Attributes(Sh)
'        Call Put_Shape_Transform_Attributes(Sh)
'    Call Decrement_Indent
'    Call Put_SVGLine(Line:="/>")
End Sub
Private Sub Group2SVG(Sh As Shape)
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Put_SVGLine ("<g id=""" & Symbolname & """>")
    Call Increment_Indent
        For Each Sh In Sh.GroupItems
            Call Convert_Shape(Sh:=Sh)
        Next Sh
    Call Decrement_Indent
    Put_SVGLine ("</g>")
End Sub
Private Sub Rectangle2Svg(Sh As Shape)
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Put_SVGLine ("<desc>" & Symbolname & "</desc>")
    Put_SVGLine ("<rect")
    Call Increment_Indent
        Call Put_SVGLine(Line:="x=""" & Format_3Dec(-Sh.Width / 2) & """")
        Call Put_SVGLine(Line:="y=""" & Format_3Dec(-Sh.Height / 2) & """")
        Call Put_SVGLine(Line:="width=""" & Format_3Dec(Sh.Width) & """")
        Call Put_SVGLine(Line:="height=""" & Format_3Dec(Sh.Height) & """")
        Call Put_Shape_Fill_Attributes(Sh)
        Call Put_Shape_Line_Attributes(Sh)
        Call Put_Shape_Transform_Attributes(Sh)
    Call Decrement_Indent
    Put_SVGLine ("/>")
End Sub
Private Sub Oval2Svg(Sh As Shape)
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Put_SVGLine ("<desc>" & Symbolname & "</desc>")
    Put_SVGLine ("<ellipse")
    Call Increment_Indent
        Call Put_SVGLine(Line:="cx=""0""")
        Call Put_SVGLine(Line:="cy=""0""")
        Call Put_SVGLine(Line:="rx=" & """" & Format_3Dec(Sh.Width / 2) & """")
        Call Put_SVGLine(Line:="ry=" & """" & Format_3Dec(Sh.Height / 2) & """")
        Call Put_Shape_Fill_Attributes(Sh)
        Call Put_Shape_Line_Attributes(Sh)
        Call Put_Shape_Transform_Attributes(Sh)
    Call Decrement_Indent
    Put_SVGLine ("/>")
End Sub
Private Sub Define_Triangle(Shape_Name As String, Width As Single, Height As Single, Size As Integer)
    Dim Name As String
    Name = String_Without_Spaces(Input_String:=Shape_Name)
    Put_SVGLine ("<defs>")
    Call Increment_Indent
        Put_SVGLine ("<marker id=""Triangle" & Size & "_" & Name & """")
        Call Increment_Indent
            Put_SVGLine ("viewBox=""0 0 " & Format_3Dec(Width) & " " & Format_3Dec(Height) & """ refX=""" & Format_3Dec(0.125) & """ refY=""" & Format_3Dec(Height / 2) & """")
            Put_SVGLine ("markerUnits = ""strokeWidth""")
            Put_SVGLine ("markerWidth=""" & Format_3Dec(Width) & """ markerHeight=""" & Format_3Dec(Height) & """")
            Put_SVGLine ("orient=""auto"">")
            Put_SVGLine ("<polygon points=")
            Call Increment_Indent
                Put_SVGLine ("""" & "0," & Format_3Dec(Height) & " " & Format_3Dec(Width) & "," & Format_3Dec(Height / 2) & " 0,0" & """")
            Call Decrement_Indent
            Put_SVGLine ("/>")
        Call Decrement_Indent
        Put_SVGLine ("</marker>")
    Call Decrement_Indent
    Put_SVGLine ("</defs>")
End Sub
Private Sub Define_Triangle_Flip(Shape_Name As String, Width As Single, Height As Single, Size As Integer)
    Dim Name As String
    Name = String_Without_Spaces(Input_String:=Shape_Name)
    Put_SVGLine ("<defs>")
    Call Increment_Indent
        Put_SVGLine ("<marker id=""Triangle" & Size & "_Flip_" & Name & """")
        Call Increment_Indent
            Put_SVGLine ("viewBox=""0 0 " & Format_3Dec(Width) & " " & Format_3Dec(Height) & """ refX=""" & Format_3Dec(Width - 0.125) & """ refY=""" & Format_3Dec(Height / 2) & """")
            Put_SVGLine ("markerUnits = ""strokeWidth""")
            Put_SVGLine ("markerWidth=""" & Format_3Dec(Width) & """ markerHeight=""" & Format_3Dec(Height) & """")
            Put_SVGLine ("orient=""auto"">")
            Put_SVGLine ("<polygon points=")
            Call Increment_Indent
                Put_SVGLine ("""" & Format_3Dec(Width) & "," & Format_3Dec(Height) & " 0," & Format_3Dec(Height / 2) & " " & Format_3Dec(Width) & ",0" & """")
            Call Decrement_Indent
            Put_SVGLine ("/>")
        Call Decrement_Indent
        Put_SVGLine ("</marker>")
    Call Decrement_Indent
    Put_SVGLine ("</defs>")
End Sub
Private Sub Define_Diamond(Shape_Name As String, Width As Single, Height As Single, Size As Integer)
    Dim Name As String
    Name = String_Without_Spaces(Input_String:=Shape_Name)
    Put_SVGLine ("<defs>")
    Call Increment_Indent
        Put_SVGLine ("<marker id=""Diamond" & Size & "_" & Name & """")
        Call Increment_Indent
            Put_SVGLine ("viewBox=""0 0 " & Format_3Dec(Width) & " " & Format_3Dec(Height) & """ refX=""" & Format_3Dec(Width / 2) & """ refY=""" & Format_3Dec(Height / 2) & """")
            Put_SVGLine ("markerUnits = ""strokeWidth""")
            Put_SVGLine ("markerWidth=""" & Format_3Dec(Width) & """ markerHeight=""" & Format_3Dec(Height) & """")
            Put_SVGLine ("orient=""auto"">")
            Put_SVGLine ("<polygon points=")
            Call Increment_Indent
                Put_SVGLine ("""" & Format_3Dec(Width / 2) & "," & Format_3Dec(Height) & " " & Format_3Dec(Width) & "," & Format_3Dec(Height / 2) & " " & Format_3Dec(Width / 2) & ",0 " & "0," & Format_3Dec(Height / 2) & """")
            Call Decrement_Indent
            Put_SVGLine ("/>")
        Call Decrement_Indent
        Put_SVGLine ("</marker>")
    Call Decrement_Indent
    Put_SVGLine ("</defs>")
End Sub
Private Sub Define_Diamond_Flip(Shape_Name As String, Width As Single, Height As Single, Size As Integer)
    Dim Name As String
    Name = String_Without_Spaces(Input_String:=Shape_Name)
    Put_SVGLine ("<defs>")
    Call Increment_Indent
        Put_SVGLine ("<marker id=""Diamond" & Size & "_Flip_" & Name & """")
        Call Increment_Indent
            Put_SVGLine ("viewBox=""0 0 " & Format_3Dec(Width) & " " & Format_3Dec(Height) & """ refX=""" & Format_3Dec(Width / 2) & """ refY=""" & Format_3Dec(Height / 2) & """")
            Put_SVGLine ("markerUnits = ""strokeWidth""")
            Put_SVGLine ("markerWidth=""" & Format_3Dec(Width) & """ markerHeight=""" & Format_3Dec(Height) & """")
            Put_SVGLine ("orient=""auto"">")
            Put_SVGLine ("<polygon points=")
            Call Increment_Indent
                Put_SVGLine ("""" & Format_3Dec(Width / 2) & "," & Format_3Dec(Height) & " " & Format_3Dec(Width) & "," & Format_3Dec(Height / 2) & " " & Format_3Dec(Width / 2) & ",0 " & "0," & Format_3Dec(Height / 2) & """")
            Call Decrement_Indent
            Put_SVGLine ("/>")
        Call Decrement_Indent
        Put_SVGLine ("</marker>")
    Call Decrement_Indent
    Put_SVGLine ("</defs>")
End Sub
Private Sub Define_Oval(Shape_Name As String, Rx As Single, Ry As Single, Size As Integer)
    Dim Name As String
    Name = String_Without_Spaces(Input_String:=Shape_Name)
    Put_SVGLine ("<defs>")
    Call Increment_Indent
        Put_SVGLine ("<marker id=""Oval" & Size & "_" & Name & """")
        Call Increment_Indent
            Put_SVGLine ("viewBox=""" & "0" & " " & "0" & " " & Format_3Dec(2 * Rx) & " " & Format_3Dec(2 * Ry) & """ refX=""" & Format_3Dec(Rx) & """ refY=""" & Format_3Dec(Ry) & """")
            Put_SVGLine ("markerUnits = ""strokeWidth""")
            Put_SVGLine ("markerWidth=""" & Format_3Dec(2 * Rx) & """ markerHeight=""" & Format_3Dec(2 * Ry) & """")
            Put_SVGLine ("orient=""auto"">")
            Put_SVGLine ("<ellipse")
            Call Increment_Indent
                Put_SVGLine ("cx = """ & Format_3Dec(Rx) & """")
                Put_SVGLine ("cy = """ & Format_3Dec(Ry) & """")
                Put_SVGLine ("rx = """ & Format_3Dec(Rx) & """")
                Put_SVGLine ("ry = """ & Format_3Dec(Ry) & """")
            Call Decrement_Indent
            Put_SVGLine ("/>")
        Call Decrement_Indent
        Put_SVGLine ("</marker>")
    Call Decrement_Indent
    Put_SVGLine ("</defs>")
End Sub
Private Sub Define_Oval_Flip(Shape_Name As String, Rx As Single, Ry As Single, Size As Integer)
    Dim Name As String
    Name = String_Without_Spaces(Input_String:=Shape_Name)
    Put_SVGLine ("<defs>")
    Call Increment_Indent
        Put_SVGLine ("<marker id=""Oval" & Size & "_Flip_" & Name & """")
        Call Increment_Indent
            Put_SVGLine ("viewBox=""" & "0" & " " & "0" & " " & Format_3Dec(2 * Rx) & " " & Format_3Dec(2 * Ry) & """ refX=""" & Format_3Dec(Rx) & """ refY=""" & Format_3Dec(Ry) & """")
            Put_SVGLine ("markerUnits = ""strokeWidth""")
            Put_SVGLine ("markerWidth=""" & Format_3Dec(2 * Rx) & """ markerHeight=""" & Format_3Dec(2 * Ry) & """")
            Put_SVGLine ("orient=""auto"">")
            Put_SVGLine ("<ellipse")
            Call Increment_Indent
                Put_SVGLine ("cx = """ & Format_3Dec(Rx) & """")
                Put_SVGLine ("cy = """ & Format_3Dec(Ry) & """")
                Put_SVGLine ("rx = """ & Format_3Dec(Rx) & """")
                Put_SVGLine ("ry = """ & Format_3Dec(Ry) & """")
            Call Decrement_Indent
            Put_SVGLine ("/>")
        Call Decrement_Indent
        Put_SVGLine ("</marker>")
    Call Decrement_Indent
    Put_SVGLine ("</defs>")
End Sub
Private Sub Line2Svg(Sh As Shape)
    Dim Symbolname As String
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Dim Line_Length As Double
    Line_Length = Sqr((Sh.Width ^ 2) + (Sh.Height ^ 2))
    Dim Line_Reduction_Factor, Line_Reduction_Factor_Flip As Double
    Line_Reduction_Factor = 0
    Line_Reduction_Factor_Flip = 0
    Put_SVGLine ("<desc>" & Symbolname & "</desc>")
    Select Case Sh.Line.BeginArrowheadStyle
        Case msoArrowheadDiamond
        Select Case Sh.Line.BeginArrowheadLength
            Case msoArrowheadLengthMedium
                Select Case Sh.Line.BeginArrowheadWidth
                    Case msoArrowheadNarrow
                    Case msoArrowheadWide
                    Case msoArrowheadWidthMedium
                        If Sh.HorizontalFlip Xor Sh.VerticalFlip Then
                            Call Define_Diamond(Shape_Name:=Symbolname, _
                                Width:=2.55 + (5.25 / Sh.Line.Weight), _
                                Height:=2.55 + (5.25 / Sh.Line.Weight), _
                                Size:=5)
                        Else
                            Call Define_Diamond_Flip(Shape_Name:=Symbolname, _
                                Width:=2.55 + (5.25 / Sh.Line.Weight), _
                                Height:=2.55 + (5.25 / Sh.Line.Weight), _
                                Size:=5)
                        End If
                    Case msoArrowheadWidthMixed
                End Select
            Case msoArrowheadLong
                Select Case Sh.Line.BeginArrowheadWidth
                    Case msoArrowheadNarrow
                    Case msoArrowheadWide
                        If Sh.HorizontalFlip Xor Sh.VerticalFlip Then
                            Call Define_Oval(Shape_Name:=Symbolname, _
                                Rx:=2.25 + (3 / Sh.Line.Weight), _
                                Ry:=2.25 + (3 / Sh.Line.Weight), _
                                Size:=9)
                        Else
                            Call Define_Oval_Flip(Shape_Name:=Symbolname, _
                                Rx:=2.25 + (3 / Sh.Line.Weight), _
                                Ry:=2.25 + (3 / Sh.Line.Weight), _
                                Size:=9)
                        End If
                    Case msoArrowheadWidthMedium
                        If Sh.HorizontalFlip Xor Sh.VerticalFlip Then
                            Call Define_Oval(Shape_Name:=Symbolname, _
                                Rx:=2.25 + (3 / Sh.Line.Weight), _
                                Ry:=1.2 + (3 / Sh.Line.Weight), _
                                Size:=6)
                        Else
                            Call Define_Oval_Flip(Shape_Name:=Symbolname, _
                                Rx:=2.25 + (3 / Sh.Line.Weight), _
                                Ry:=1.2 + (3 / Sh.Line.Weight), _
                                Size:=6)
                        End If
                    Case msoArrowheadWidthMixed
                End Select
        End Select
        Case msoArrowheadNone
        Case msoArrowheadOpen
        Case msoArrowheadOval
        Select Case Sh.Line.BeginArrowheadLength
            Case msoArrowheadLengthMedium
                Select Case Sh.Line.BeginArrowheadWidth
                    Case msoArrowheadNarrow
                    Case msoArrowheadWide
                    Case msoArrowheadWidthMedium
                        If Sh.HorizontalFlip Xor Sh.VerticalFlip Then
                            Call Define_Oval(Shape_Name:=Symbolname, _
                                Rx:=1.2 + (3 / Sh.Line.Weight), _
                                Ry:=1.2 + (3 / Sh.Line.Weight), _
                                Size:=5)
                        Else
                            Call Define_Oval_Flip(Shape_Name:=Symbolname, _
                                Rx:=1.2 + (3 / Sh.Line.Weight), _
                                Ry:=1.2 + (3 / Sh.Line.Weight), _
                                Size:=5)
                        End If
                    Case msoArrowheadWidthMixed
                End Select
            Case msoArrowheadLong
                Select Case Sh.Line.BeginArrowheadWidth
                    Case msoArrowheadNarrow
                    Case msoArrowheadWide
                        If Sh.HorizontalFlip Xor Sh.VerticalFlip Then
                            Call Define_Oval(Shape_Name:=Symbolname, _
                                Rx:=2.25 + (3 / Sh.Line.Weight), _
                                Ry:=2.25 + (3 / Sh.Line.Weight), _
                                Size:=9)
                        Else
                            Call Define_Oval_Flip(Shape_Name:=Symbolname, _
                                Rx:=2.25 + (3 / Sh.Line.Weight), _
                                Ry:=2.25 + (3 / Sh.Line.Weight), _
                                Size:=9)
                        End If
                    Case msoArrowheadWidthMedium
                        If Sh.HorizontalFlip Xor Sh.VerticalFlip Then
                            Call Define_Oval(Shape_Name:=Symbolname, _
                                Rx:=2.25 + (3 / Sh.Line.Weight), _
                                Ry:=1.2 + (3 / Sh.Line.Weight), _
                                Size:=6)
                        Else
                            Call Define_Oval_Flip(Shape_Name:=Symbolname, _
                                Rx:=2.25 + (3 / Sh.Line.Weight), _
                                Ry:=1.2 + (3 / Sh.Line.Weight), _
                                Size:=6)
                        End If
                    Case msoArrowheadWidthMixed
                End Select
        End Select
        Case msoArrowheadStealth
        Case msoArrowheadStyleMixed
        Case msoArrowheadTriangle
        Select Case Sh.Line.BeginArrowheadLength
            Case msoArrowheadLengthMedium
                Select Case Sh.Line.BeginArrowheadWidth
                    Case msoArrowheadNarrow
                    Case msoArrowheadWide
                    Case msoArrowheadWidthMedium
                        If Sh.HorizontalFlip Xor Sh.VerticalFlip Then
                            Line_Reduction_Factor = _
                                (2.5 * Sh.Line.Weight + 5.5) / Line_Length
                            Call Define_Triangle(Shape_Name:=Symbolname, _
                                Width:=2.5 + (5.5 / Sh.Line.Weight), _
                                Height:=2.5 + (5.5 / Sh.Line.Weight), _
                                Size:=5)
                        Else
                            Line_Reduction_Factor_Flip = _
                                (2.5 * Sh.Line.Weight + 5.5) / Line_Length
                            Call Define_Triangle_Flip(Shape_Name:=Symbolname, _
                                Width:=2.5 + (5.5 / Sh.Line.Weight), _
                                Height:=2.5 + (5.5 / Sh.Line.Weight), _
                                Size:=5)
                        End If
                    Case msoArrowheadWidthMixed
                End Select
            Case msoArrowheadLengthMixed
            Case msoArrowheadLong
                Select Case Sh.Line.BeginArrowheadWidth
                    Case msoArrowheadNarrow
                    Case msoArrowheadWide
                        If Sh.HorizontalFlip Xor Sh.VerticalFlip Then
                            Line_Reduction_Factor = _
                                (4.5 * Sh.Line.Weight + 7.5) / Line_Length
                            Call Define_Triangle(Shape_Name:=Symbolname, _
                                Width:=4.5 + (7.5 / Sh.Line.Weight), _
                                Height:=4.5 + (8.25 / Sh.Line.Weight), _
                                Size:=9)
                        Else
                            Line_Reduction_Factor_Flip = _
                                (4.5 * Sh.Line.Weight + 7.5) / Line_Length
                            Call Define_Triangle_Flip(Shape_Name:=Symbolname, _
                                Width:=4.5 + (7.5 / Sh.Line.Weight), _
                                Height:=4.5 + (8.25 / Sh.Line.Weight), _
                                Size:=9)
                        End If
                    Case msoArrowheadWidthMedium
                    Case msoArrowheadWidthMixed
                End Select
            Case msoArrowheadShort
        End Select
    End Select
    Select Case Sh.Line.EndArrowheadStyle
        Case msoArrowheadDiamond
        Case msoArrowheadNone
        Case msoArrowheadOpen
        Case msoArrowheadOval
        Select Case Sh.Line.EndArrowheadLength
            Case msoArrowheadLengthMedium
                Select Case Sh.Line.EndArrowheadWidth
                    Case msoArrowheadNarrow
                    Case msoArrowheadWide
                    Case msoArrowheadWidthMedium
                        If Sh.HorizontalFlip Xor Sh.VerticalFlip Then
                            Call Define_Oval_Flip(Shape_Name:=Symbolname, _
                                Rx:=1.2 + (3 / Sh.Line.Weight), _
                                Ry:=1.2 + (3 / Sh.Line.Weight), _
                                Size:=5)
                        Else
                            Call Define_Oval(Shape_Name:=Symbolname, _
                                Rx:=1.2 + (3 / Sh.Line.Weight), _
                                Ry:=1.2 + (3 / Sh.Line.Weight), _
                                Size:=5)
                        End If
                    Case msoArrowheadWidthMixed
                End Select
            Case msoArrowheadLong
                Select Case Sh.Line.EndArrowheadWidth
                    Case msoArrowheadNarrow
                    Case msoArrowheadWide
                        If Sh.HorizontalFlip Xor Sh.VerticalFlip Then
                            Call Define_Oval_Flip(Shape_Name:=Symbolname, _
                                Rx:=2.25 + (3 / Sh.Line.Weight), _
                                Ry:=2.25 + (3 / Sh.Line.Weight), _
                                Size:=9)
                        Else
                            Call Define_Oval(Shape_Name:=Symbolname, _
                                Rx:=2.25 + (3 / Sh.Line.Weight), _
                                Ry:=2.25 + (3 / Sh.Line.Weight), _
                                Size:=9)
                        End If
                    Case msoArrowheadWidthMedium
                        If Sh.HorizontalFlip Xor Sh.VerticalFlip Then
                            Call Define_Oval_Flip(Shape_Name:=Symbolname, _
                                Rx:=2.25 + (3 / Sh.Line.Weight), _
                                Ry:=1.2 + (3 / Sh.Line.Weight), _
                                Size:=6)
                        Else
                            Call Define_Oval(Shape_Name:=Symbolname, _
                                Rx:=2.25 + (3 / Sh.Line.Weight), _
                                Ry:=1.2 + (3 / Sh.Line.Weight), _
                                Size:=6)
                        End If
                    Case msoArrowheadWidthMixed
                End Select
        End Select
        Case msoArrowheadStealth
        Case msoArrowheadStyleMixed
        Case msoArrowheadTriangle
        Select Case Sh.Line.EndArrowheadLength
            Case msoArrowheadLengthMedium
                Select Case Sh.Line.EndArrowheadWidth
                    Case msoArrowheadNarrow
                    Case msoArrowheadWide
                    Case msoArrowheadWidthMedium
                        If Sh.HorizontalFlip Xor Sh.VerticalFlip Then
                            Line_Reduction_Factor_Flip = _
                                (2.5 * Sh.Line.Weight + 5.5) / Line_Length
                            Call Define_Triangle_Flip(Shape_Name:=Symbolname, _
                                Width:=2.5 + (5.5 / Sh.Line.Weight), _
                                Height:=2.5 + (5.5 / Sh.Line.Weight), _
                                Size:=5)
                        Else
                            Line_Reduction_Factor = _
                                (2.5 * Sh.Line.Weight + 5.5) / Line_Length
                            Call Define_Triangle(Shape_Name:=Symbolname, _
                                Width:=2.5 + (5.5 / Sh.Line.Weight), _
                                Height:=2.5 + (5.5 / Sh.Line.Weight), _
                                Size:=5)
                        End If
                    Case msoArrowheadWidthMixed
                End Select
            Case msoArrowheadLengthMixed
            Case msoArrowheadLong
                Select Case Sh.Line.EndArrowheadWidth
                    Case msoArrowheadNarrow
                    Case msoArrowheadWide
                        If Sh.HorizontalFlip Xor Sh.VerticalFlip Then
                            Line_Reduction_Factor_Flip = _
                                (4.5 * Sh.Line.Weight + 7.5) / Line_Length
                            Call Define_Triangle_Flip(Shape_Name:=Symbolname, _
                                Width:=4.5 + (7.5 / Sh.Line.Weight), _
                                Height:=4.5 + (8.25 / Sh.Line.Weight), _
                                Size:=9)
                        Else
                            Line_Reduction_Factor = _
                                (4.5 * Sh.Line.Weight + 7.5) / Line_Length
                            Call Define_Triangle(Shape_Name:=Symbolname, _
                                Width:=4.5 + (7.5 / Sh.Line.Weight), _
                                Height:=4.5 + (8.25 / Sh.Line.Weight), _
                                Size:=9)
                        End If
                    Case msoArrowheadWidthMedium
                    Case msoArrowheadWidthMixed
                End Select
            Case msoArrowheadShort
        End Select
    End Select
    Put_SVGLine ("<line")
    Dim X1, X2, Y1, Y2 As Double
    Call Increment_Indent
        If (Not Sh.VerticalFlip) And (Not Sh.HorizontalFlip) Then
            X1 = -Sh.Width / 2
            X2 = Sh.Width / 2
            Y1 = -Sh.Height / 2
            Y2 = Sh.Height / 2
            Put_SVGLine ("x1=""" & Format_3Dec(X1 + Line_Reduction_Factor_Flip * Sh.Width) & """")
            Put_SVGLine ("x2=""" & Format_3Dec(X2 - Line_Reduction_Factor * Sh.Width) & """")
            Put_SVGLine ("y1=""" & Format_3Dec(Y1 + Line_Reduction_Factor_Flip * Sh.Height) & """")
            Put_SVGLine ("y2=""" & Format_3Dec(Y2 - Line_Reduction_Factor * Sh.Height) & """")
        ElseIf Sh.VerticalFlip And (Not Sh.HorizontalFlip) Then
            X1 = Sh.Width / 2
            X2 = -Sh.Width / 2
            Y1 = -Sh.Height / 2
            Y2 = Sh.Height / 2
            Put_SVGLine ("x1=""" & Format_3Dec(X1 - Line_Reduction_Factor_Flip * Sh.Width) & """")
            Put_SVGLine ("x2=""" & Format_3Dec(X2 + Line_Reduction_Factor * Sh.Width) & """")
            Put_SVGLine ("y1=""" & Format_3Dec(Y1 + Line_Reduction_Factor_Flip * Sh.Height) & """")
            Put_SVGLine ("y2=""" & Format_3Dec(Y2 - Line_Reduction_Factor * Sh.Height) & """")
        ElseIf (Not Sh.VerticalFlip) And Sh.HorizontalFlip Then
            X1 = -Sh.Width / 2
            X2 = Sh.Width / 2
            Y1 = Sh.Height / 2
            Y2 = -Sh.Height / 2
            Put_SVGLine ("x1=""" & Format_3Dec(X1 + Line_Reduction_Factor_Flip * Sh.Width) & """")
            Put_SVGLine ("x2=""" & Format_3Dec(X2 - Line_Reduction_Factor * Sh.Width) & """")
            Put_SVGLine ("y1=""" & Format_3Dec(Y1 - Line_Reduction_Factor_Flip * Sh.Height) & """")
            Put_SVGLine ("y2=""" & Format_3Dec(Y2 + Line_Reduction_Factor * Sh.Height) & """")
        ElseIf Sh.VerticalFlip And Sh.HorizontalFlip Then
            X1 = Sh.Width / 2
            X2 = -Sh.Width / 2
            Y1 = Sh.Height / 2
            Y2 = -Sh.Height / 2
            Put_SVGLine ("x1=""" & Format_3Dec(X1 - Line_Reduction_Factor_Flip * Sh.Width) & """")
            Put_SVGLine ("x2=""" & Format_3Dec(X2 + Line_Reduction_Factor * (Sh.Width)) & """")
            Put_SVGLine ("y1=""" & Format_3Dec(Y1 - Line_Reduction_Factor_Flip * Sh.Height) & """")
            Put_SVGLine ("y2=""" & Format_3Dec(Y2 + Line_Reduction_Factor * Sh.Height) & """")
        End If
        Select Case Sh.Line.BeginArrowheadStyle
            Case msoArrowheadDiamond
                Select Case Sh.Line.BeginArrowheadLength
                    Case msoArrowheadLengthMedium
                        Select Case Sh.Line.BeginArrowheadWidth
                            Case msoArrowheadNarrow
                            Case msoArrowheadWide
                            Case msoArrowheadWidthMedium
                                If Sh.HorizontalFlip Xor Sh.VerticalFlip Then
                                    Call Put_SVGLine(Line:= _
                                        "marker-end=""url(#Diamond5_" & _
                                        String_Without_Spaces(Sh.Name) & ")""")
                                Else
                                    Call Put_SVGLine(Line:= _
                                        "marker-start=""url(#Diamond5_Flip_" & _
                                        String_Without_Spaces(Sh.Name) & ")""")
                                End If
                            Case msoArrowheadWidthMixed
                        End Select
                    Case msoArrowheadLengthMixed
                    Case msoArrowheadLong
                        Select Case Sh.Line.BeginArrowheadWidth
                            Case msoArrowheadNarrow
                            Case msoArrowheadWide
                                If Sh.HorizontalFlip Xor Sh.VerticalFlip Then
                                    Call Put_SVGLine(Line:= _
                                        "marker-end=""url(#Diamond9_" & _
                                        String_Without_Spaces(Sh.Name) & ")""")
                                Else
                                    Call Put_SVGLine(Line:= _
                                        "marker-start=""url(#Diamond9_Flip_" & _
                                        String_Without_Spaces(Sh.Name) & ")""")
                                End If
                            Case msoArrowheadWidthMedium
                                If Sh.HorizontalFlip Xor Sh.VerticalFlip Then
                                    Call Put_SVGLine(Line:= _
                                        "marker-end=""url(#Diamond6_" & _
                                        String_Without_Spaces(Sh.Name) & ")""")
                                Else
                                    Call Put_SVGLine(Line:= _
                                        "marker-start=""url(#Diamond6_Flip_" & _
                                        String_Without_Spaces(Sh.Name) & ")""")
                                End If
                            Case msoArrowheadWidthMixed
                        End Select
                    Case msoArrowheadShort
                End Select
            Case msoArrowheadNone
            Case msoArrowheadOpen
            Case msoArrowheadOval
                Select Case Sh.Line.BeginArrowheadLength
                    Case msoArrowheadLengthMedium
                        Select Case Sh.Line.BeginArrowheadWidth
                            Case msoArrowheadNarrow
                            Case msoArrowheadWide
                            Case msoArrowheadWidthMedium
                                If Sh.HorizontalFlip Xor Sh.VerticalFlip Then
                                    Call Put_SVGLine(Line:= _
                                        "marker-end=""url(#Diamond5_" & _
                                        String_Without_Spaces(Sh.Name) & ")""")
                                Else
                                    Call Put_SVGLine(Line:= _
                                        "marker-start=""url(#Diamond5_Flip_" & _
                                        String_Without_Spaces(Sh.Name) & ")""")
                                End If
                            Case msoArrowheadWidthMixed
                        End Select
                    Case msoArrowheadLengthMixed
                    Case msoArrowheadLong
                        Select Case Sh.Line.BeginArrowheadWidth
                            Case msoArrowheadNarrow
                            Case msoArrowheadWide
                                If Sh.HorizontalFlip Xor Sh.VerticalFlip Then
                                    Call Put_SVGLine(Line:= _
                                        "marker-end=""url(#Diamond9_" & _
                                        String_Without_Spaces(Sh.Name) & ")""")
                                Else
                                    Call Put_SVGLine(Line:= _
                                        "marker-start=""url(#Diamond9_Flip_" & _
                                        String_Without_Spaces(Sh.Name) & ")""")
                                End If
                            Case msoArrowheadWidthMedium
                                If Sh.HorizontalFlip Xor Sh.VerticalFlip Then
                                    Call Put_SVGLine(Line:= _
                                        "marker-end=""url(#Diamond6_" & _
                                        String_Without_Spaces(Sh.Name) & ")""")
                                Else
                                    Call Put_SVGLine(Line:= _
                                        "marker-start=""url(#Diamond6_Flip_" & _
                                        String_Without_Spaces(Sh.Name) & ")""")
                                End If
                            Case msoArrowheadWidthMixed
                        End Select
                    Case msoArrowheadShort
                End Select
            Case msoArrowheadStealth
            Case msoArrowheadStyleMixed
            Case msoArrowheadTriangle
                Select Case Sh.Line.BeginArrowheadLength
                    Case msoArrowheadLengthMedium
                        Select Case Sh.Line.BeginArrowheadWidth
                            Case msoArrowheadNarrow
                            Case msoArrowheadWide
                            Case msoArrowheadWidthMedium
                                If Sh.HorizontalFlip Xor Sh.VerticalFlip Then
                                    Call Put_SVGLine(Line:= _
                                        "marker-end=""url(#Triangle5_" & _
                                        String_Without_Spaces(Sh.Name) & ")""")
                                Else
                                    Call Put_SVGLine(Line:= _
                                        "marker-start=""url(#Triangle5_Flip_" & _
                                        String_Without_Spaces(Sh.Name) & ")""")
                                End If
                            Case msoArrowheadWidthMixed
                        End Select
                    Case msoArrowheadLengthMixed
                    Case msoArrowheadLong
                        Select Case Sh.Line.BeginArrowheadWidth
                            Case msoArrowheadNarrow
                            Case msoArrowheadWide
                                If Sh.HorizontalFlip Xor Sh.VerticalFlip Then
                                    Call Put_SVGLine(Line:= _
                                        "marker-end=""url(#Triangle9_" & _
                                        String_Without_Spaces(Sh.Name) & ")""")
                                Else
                                    Call Put_SVGLine(Line:= _
                                        "marker-start=""url(#Triangle9_Flip_" & _
                                        String_Without_Spaces(Sh.Name) & ")""")
                                End If
                            Case msoArrowheadWidthMedium
                            Case msoArrowheadWidthMixed
                        End Select
                    Case msoArrowheadShort
                End Select
        End Select
        Select Case Sh.Line.EndArrowheadStyle
            Case msoArrowheadDiamond
            Case msoArrowheadNone
            Case msoArrowheadOpen
            Case msoArrowheadOval
                Select Case Sh.Line.EndArrowheadLength
                    Case msoArrowheadLengthMedium
                        Select Case Sh.Line.EndArrowheadWidth
                            Case msoArrowheadNarrow
                            Case msoArrowheadWide
                            Case msoArrowheadWidthMedium
                                If Sh.HorizontalFlip Xor Sh.VerticalFlip Then
                                    Call Put_SVGLine(Line:= _
                                        "marker-start=""url(#Oval5_Flip_" & _
                                        String_Without_Spaces(Sh.Name) & ")""")
                                Else
                                    Call Put_SVGLine(Line:= _
                                        "marker-end=""url(#Oval5_" & _
                                        String_Without_Spaces(Sh.Name) & ")""")
                                End If
                            Case msoArrowheadWidthMixed
                        End Select
                    Case msoArrowheadLengthMixed
                    Case msoArrowheadLong
                        Select Case Sh.Line.EndArrowheadWidth
                            Case msoArrowheadNarrow
                            Case msoArrowheadWide
                                If Sh.HorizontalFlip Xor Sh.VerticalFlip Then
                                    Call Put_SVGLine(Line:= _
                                        "marker-start=""url(#Oval9_Flip_" & _
                                        String_Without_Spaces(Sh.Name) & ")""")
                                Else
                                    Call Put_SVGLine(Line:= _
                                        "marker-end=""url(#Oval9_" & _
                                        String_Without_Spaces(Sh.Name) & ")""")
                                End If
                            Case msoArrowheadWidthMedium
                                If Sh.HorizontalFlip Xor Sh.VerticalFlip Then
                                    Call Put_SVGLine(Line:= _
                                        "marker-start=""url(#Oval6_Flip_" & _
                                        String_Without_Spaces(Sh.Name) & ")""")
                                Else
                                    Call Put_SVGLine(Line:= _
                                        "marker-end=""url(#Oval6_" & _
                                        String_Without_Spaces(Sh.Name) & ")""")
                                End If
                            Case msoArrowheadWidthMixed
                        End Select
                    Case msoArrowheadShort
                End Select
            Case msoArrowheadStealth
            Case msoArrowheadStyleMixed
            Case msoArrowheadTriangle
                Select Case Sh.Line.EndArrowheadLength
                    Case msoArrowheadLengthMedium
                        Select Case Sh.Line.EndArrowheadWidth
                            Case msoArrowheadNarrow
                            Case msoArrowheadWide
                            Case msoArrowheadWidthMedium
                                If Sh.HorizontalFlip Xor Sh.VerticalFlip Then
                                    Call Put_SVGLine(Line:= _
                                        "marker-start=""url(#Triangle5_Flip_" & _
                                        String_Without_Spaces(Sh.Name) & ")""")
                                Else
                                    Call Put_SVGLine(Line:= _
                                        "marker-end=""url(#Triangle5_" & _
                                        String_Without_Spaces(Sh.Name) & ")""")
                                End If
                            Case msoArrowheadWidthMixed
                        End Select
                    Case msoArrowheadLengthMixed
                    Case msoArrowheadLong
                        Select Case Sh.Line.EndArrowheadWidth
                            Case msoArrowheadNarrow
                            Case msoArrowheadWide
                                If Sh.HorizontalFlip Xor Sh.VerticalFlip Then
                                    Call Put_SVGLine(Line:= _
                                        "marker-start=""url(#Triangle9_Flip_" & _
                                        String_Without_Spaces(Sh.Name) & ")""")
                                Else
                                    Call Put_SVGLine(Line:= _
                                        "marker-end=""url(#Triangle9_" & _
                                        String_Without_Spaces(Sh.Name) & ")""")
                                End If
                            Case msoArrowheadWidthMedium
                            Case msoArrowheadWidthMixed
                        End Select
                    Case msoArrowheadShort
                End Select
        End Select
        Call Put_Shape_Line_Attributes(Sh)
        Call Put_Shape_Transform_Attributes(Sh)
    Call Decrement_Indent
    Put_SVGLine ("/>")
End Sub
Private Sub Freeform2SVG(Sh As Shape)
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Put_SVGLine ("<desc>" & Symbolname & "</desc>")
    Put_SVGLine ("<polygon points=")
    Dim XValue, YValue As Variant
    Dim Nodes_Count_Div_4, Nodes_Count_Mod_4 As Long
    Dim Min_X, Min_Y, Max_X, Max_Y As Single
    Dim SVG_Line As String
    Dim I, J As Integer
    Dim Points_Array As Variant
    Min_X = 1000000
    Min_Y = 1000000
    Max_X = -1000000
    Max_Y = -10
    For I = 1 To Sh.Nodes.Count
        Points_Array = Sh.Nodes(I).Points
        XValue = Points_Array(1, 1)
        YValue = Points_Array(1, 2)
        If XValue < Min_X Then
            Min_X = XValue
        End If
        If YValue < Min_Y Then
            Min_Y = YValue
        End If
        If XValue > Max_X Then
            Max_X = XValue
        End If
        If YValue > Max_Y Then
            Max_Y = YValue
        End If
    Next I
    Nodes_Count_Mod_4 = Sh.Nodes.Count Mod 4
    Nodes_Count_Div_4 = (Sh.Nodes.Count - Nodes_Count_Mod_4) / 4
    Call Increment_Indent
        For I = 1 To Nodes_Count_Div_4
            If I = 1 Then
                SVG_Line = """"
            Else
                SVG_Line = ""
            End If
            For J = 1 To 4
                Points_Array = Sh.Nodes(4 * (I - 1) + J).Points
                XValue = Points_Array(1, 1) ' - Min_X - (Max_X - Min_X) / 2
                YValue = Points_Array(1, 2) ' - Min_Y - (Max_Y - Min_Y) / 2
                SVG_Line = SVG_Line & Format_3Dec(XValue) & "," & Format_3Dec(YValue)
                If J < 4 Then
                    SVG_Line = SVG_Line & " "
                End If
            Next J
            If Nodes_Count_Mod_4 = 0 And I = Nodes_Count_Div_4 Then
                SVG_Line = SVG_Line & """"
            End If
            Put_SVGLine (SVG_Line)
        Next I
        If Nodes_Count_Mod_4 <> 0 Then
            If Nodes_Count_Div_4 = 0 Then
                SVG_Line = """"
            Else
                SVG_Line = ""
            End If
            For J = 1 To Nodes_Count_Mod_4
                Points_Array = Sh.Nodes(4 * Nodes_Count_Div_4 + J).Points
                XValue = Points_Array(1, 1) ' - Min_X - (Max_X - Min_X) / 2
                YValue = Points_Array(1, 2) ' - Min_Y - (Max_Y - Min_Y) / 2
                SVG_Line = SVG_Line & Format_3Dec(XValue) & "," & Format_3Dec(YValue)
                If J < Nodes_Count_Mod_4 Then
                    SVG_Line = SVG_Line & " "
                End If
            Next J
            SVG_Line = SVG_Line & """"
            Put_SVGLine (SVG_Line)
        End If
        Call Put_Shape_Fill_Attributes(Sh)
        Call Put_Shape_Line_Attributes(Sh)
        Call Put_SVGLine(Line:="transform=")
        Call Increment_Indent
'            If Sh.Rotation = 0 Then
'                Call Put_SVGLine(Line:="""translate(" & _
'                    Format_3Dec(Sh.Left + Sh.Width / 2) & ", " & _
'                    Format_3Dec(Sh.Top + Sh.Height / 2) & ")""")
'            Else
                SVG_Line = _
                    """rotate(" & _
                    Format_3Dec(Sh.Rotation) & " " & _
                    Format_3Dec(Sh.Left + Sh.Width / 2) & " " & _
                    Format_3Dec(Sh.Top + Sh.Height / 2) & ") "
                SVG_Line = SVG_Line & _
                    "translate(" & _
                    Format_3Dec(Sh.Left) & "," & _
                    Format_3Dec(Sh.Top) & ") "
                SVG_Line = SVG_Line & _
                    "scale(" & _
                    Format_3Dec(Sh.Width / (Max_X - Min_X)) & " " & _
                    Format_3Dec(Sh.Height / (Max_Y - Min_Y)) & ") "
                SVG_Line = SVG_Line & _
                    "translate(" & _
                    Format_3Dec(-Min_X) & "," & _
                    Format_3Dec(-Min_Y) & ")"""
                Call Put_SVGLine(Line:=SVG_Line)
'            End If
        Call Decrement_Indent
    Call Decrement_Indent
    Put_SVGLine ("/>")
End Sub
Private Sub TextBox2SVG _
    (Sh As Shape)
    Dim SVG_Line As String
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Put_SVGLine ("<desc>" & Symbolname & "</desc>")
    Put_SVGLine ("<rect")
    Call Increment_Indent
        Call Put_SVGLine(Line:="x=""" & Format_3Dec(-Sh.Width / 2) & """")
        Call Put_SVGLine(Line:="y=""" & Format_3Dec(-Sh.Height / 2) & """")
        Call Put_SVGLine(Line:="width=""" & Format_3Dec(Sh.Width) & """")
        Call Put_SVGLine(Line:="height=""" & Format_3Dec(Sh.Height) & """")
        Call Put_Shape_Fill_Attributes(Sh)
        Call Put_Shape_Line_Attributes(Sh)
        Call Put_Shape_Transform_Attributes(Sh)
    Call Decrement_Indent
    Put_SVGLine ("/>")
End Sub
Private Sub Transform_Symbol(Sh As Shape, Width As Single, Height As Single)
    Dim SVG_Line As String
    Call Put_SVGLine(Line:="transform=")
    Call Increment_Indent
        SVG_Line = _
            """rotate(" & _
            Format_3Dec(Sh.Rotation) & " " & _
            Format_3Dec(Sh.Left + Sh.Width / 2) & " " & _
            Format_3Dec(Sh.Top + Sh.Height / 2) & ") "
        SVG_Line = SVG_Line & _
            "translate(" & _
            Format_3Dec(Sh.Left) & "," & _
            Format_3Dec(Sh.Top) & ") "
        SVG_Line = SVG_Line & _
            "scale(" & _
            Format_3Dec(Sh.Width / Width) & " " & _
            Format_3Dec(Sh.Height / Height) & ") "
        SVG_Line = SVG_Line & _
            "translate(" & _
            Format_3Dec(-1) & "," & _
            Format_3Dec(-1) & ")"""
        SVG_Line = SVG_Line & ">"
        Call Put_SVGLine(Line:=SVG_Line)
    Call Decrement_Indent
End Sub
Private Sub FlowchartAlternateProcess2Svg _
    (Sh As Shape, Width As Single, Height As Single)
    Dim Symbolname As String
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Call Put_SVGLine(Line:="<desc>Symbol FlowchartAlternateProcess</desc>")
    Call Put_SVGLine(Line:="<g")
    Call Increment_Indent
        Call Put_SVGLine(Line:="id=""" & Symbolname & """")
        Call Transform_Symbol(Sh:=Sh, Width:=Width, Height:=Height)
        Put_SVGLine ("<polygon points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "7,1 5.75,1.125 4.625,1.5 3.625,2")
            Put_SVGLine ("2.75,2.75 2,3.625 1.5,4.625 1.125,5.75")
            Put_SVGLine ("1,7 1,43 1.125,44.25 1.5,45.375")
            Put_SVGLine ("2,46.375 2.75,47.25 3.625,48 4.625,48.5")
            Put_SVGLine ("5.75,48.875 7,49 67,49 68.25,48.875")
            Put_SVGLine ("69.375,48.5 70.375,48 71.25,47.25 72,46.375")
            Put_SVGLine ("72.5,45.375 72.875,44.25 73,43 73,7")
            Put_SVGLine ("72.875,5.75 72.5,4.625 72,3.625 71.25,2.75")
            Put_SVGLine ("70.375,2 69.375,1.5 68.25,1.125 67,1" & """")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
    Call Decrement_Indent
    Put_SVGLine ("</g>")
End Sub
Private Sub FlowchartCard2Svg _
    (Sh As Shape, Width As Single, Height As Single)
    Dim Symbolname As String
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Call Put_SVGLine(Line:="<desc>Symbol FlowchartCard</desc>")
    Call Put_SVGLine(Line:="<g")
    Call Increment_Indent
        Call Put_SVGLine(Line:="id=""" & Symbolname & """")
        Call Transform_Symbol(Sh:=Sh, Width:=Width, Height:=Height)
        Put_SVGLine ("<polygon points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "15.375,1 73,1 73,64 1,64")
            Put_SVGLine ("1,13.625" & """")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
    Call Decrement_Indent
    Put_SVGLine ("</g>")
End Sub
Private Sub FlowchartCollate2Svg _
    (Sh As Shape, Width As Single, Height As Single)
    Dim Symbolname As String
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Call Put_SVGLine(Line:="<desc>Symbol FlowchartCollate</desc>")
    Call Put_SVGLine(Line:="<g")
    Call Increment_Indent
        Call Put_SVGLine(Line:="id=""" & Symbolname & """")
        Call Transform_Symbol(Sh:=Sh, Width:=Width, Height:=Height)
        Put_SVGLine ("<polygon points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "37,73 1,73 37,1 1,1" & """")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
    Call Decrement_Indent
    Put_SVGLine ("</g>")
End Sub
Private Sub FlowchartConnector2Svg _
    (Sh As Shape, Width As Single, Height As Single)
    Dim Symbolname As String
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Call Put_SVGLine(Line:="<desc>Symbol FlowchartConnector</desc>")
    Call Put_SVGLine(Line:="<g")
    Call Increment_Indent
        Call Put_SVGLine(Line:="id=""" & Symbolname & """")
        Call Transform_Symbol(Sh:=Sh, Width:=Width, Height:=Height)
        Put_SVGLine ("<ellipse")
        Call Increment_Indent
            Put_SVGLine ("cx=""37""")
            Put_SVGLine ("cy=""37""")
            Put_SVGLine ("rx=""36.125""")
            Put_SVGLine ("ry=""36.125""")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
    Call Decrement_Indent
    Put_SVGLine ("</g>")
End Sub
Private Sub FlowchartData2Svg _
    (Sh As Shape, Width As Single, Height As Single)
    Dim Symbolname As String
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Call Put_SVGLine(Line:="<desc>Symbol FlowchartData</desc>")
    Call Put_SVGLine(Line:="<g")
    Call Increment_Indent
        Call Put_SVGLine(Line:="id=""" & Symbolname & """")
        Call Transform_Symbol(Sh:=Sh, Width:=Width, Height:=Height)
        Put_SVGLine ("<polygon points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "15.375,1 73,1 58.375,49 1,49" & """")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
    Call Decrement_Indent
    Put_SVGLine ("</g>")
End Sub
Private Sub FlowchartDecision2Svg _
    (Sh As Shape, Width As Single, Height As Single)
    Dim Symbolname As String
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Call Put_SVGLine(Line:="<desc>Symbol FlowchartDecision</desc>")
    Call Put_SVGLine(Line:="<g")
    Call Increment_Indent
        Call Put_SVGLine(Line:="id=""" & Symbolname & """")
        Call Transform_Symbol(Sh:=Sh, Width:=Width, Height:=Height)
        Put_SVGLine ("<polygon points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "37,1 1,25 37,49 73,25" & """")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
    Call Decrement_Indent
    Put_SVGLine ("</g>")
End Sub
Private Sub FlowchartDelay2Svg _
    (Sh As Shape, Width As Single, Height As Single)
    Dim Symbolname As String
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Call Put_SVGLine(Line:="<desc>Symbol FlowchartDelay</desc>")
    Call Put_SVGLine(Line:="<g")
    Call Increment_Indent
        Call Put_SVGLine(Line:="id=""" & Symbolname & """")
        Call Transform_Symbol(Sh:=Sh, Width:=Width, Height:=Height)
        Put_SVGLine ("<polygon points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "25,1 27.5,1.125 29.875,1.5 32.125,2.125")
            Put_SVGLine ("34.375,2.875 36.5,3.875 38.375,5.125 40.25,6.5")
            Put_SVGLine ("42,8 43.5,9.75 44.875,11.625 46.125,13.625")
            Put_SVGLine ("47.125,15.625 47.875,17.875 48.5,20.125 48.875,22.5")
            Put_SVGLine ("49,25 48.875,27.5 48.5,29.875 47.875,32.125")
            Put_SVGLine ("47.125,34.375 46.125,36.5 44.875,38.375 43.5,40.25")
            Put_SVGLine ("42,42 40.25,43.5 38.375,44.875 36.5,46.125")
            Put_SVGLine ("34.375,47.125 32.125,47.875 29.875,48.5 27.5,48.875")
            Put_SVGLine ("25,49 1,49 1,1" & """")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
    Call Decrement_Indent
    Put_SVGLine ("</g>")
End Sub
Private Sub FlowchartDirectAccessStorage2Svg _
    (Sh As Shape, Width As Single, Height As Single)
    Dim Symbolname As String
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Call Put_SVGLine(Line:="<desc>Symbol FlowchartDirectAccessStorage</desc>")
    Call Put_SVGLine(Line:="<g")
    Call Increment_Indent
        Call Put_SVGLine(Line:="id=""" & Symbolname & """")
        Call Transform_Symbol(Sh:=Sh, Width:=Width, Height:=Height)
        Put_SVGLine ("<polygon points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "73,28 73,30.75 72.75,33.375 72.125,38.5")
            Put_SVGLine ("71.5,40.875 71,43.125 70.25,45.125 69.5,47.125")
            Put_SVGLine ("68.625,48.875 67.75,50.375 66.75,51.75 65.75,52.875")
            Put_SVGLine ("64.625,53.75 63.5,54.5 62.375,54.875 61.125,55")
            Put_SVGLine ("12.875,55 11.625,54.875 10.5,54.5 9.375,53.75")
            Put_SVGLine ("8.25,52.875 7.25,51.75 6.25,50.375 5.375,48.875")
            Put_SVGLine ("4.5,47.125 3.75,45.125 3,43.125 2.5,40.875")
            Put_SVGLine ("2,38.5 1.25,33.375 1.125,30.75 1,28")
            Put_SVGLine ("1.125,25.25 1.25,22.625 2,17.5 2.5,15.125")
            Put_SVGLine ("3,12.875 3.75,10.875 4.5,8.875 5.375,7.125")
            Put_SVGLine ("6.25,5.625 7.25,4.25 8.25,3.125 9.375,2.25")
            Put_SVGLine ("10.5,1.5 11.625,1.125 12.875,1 61.125,1")
            Put_SVGLine ("62.375,1.125 63.5,1.5 64.625,2.25 65.75,3.125")
            Put_SVGLine ("66.75,4.25 67.75,5.625 68.625,7.125 69.5,8.875")
            Put_SVGLine ("70.25,10.875 71,12.875 71.5,15.125 72.125,17.5")
            Put_SVGLine ("72.75,22.625 73,25.25" & """")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
        Put_SVGLine ("<polyline points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "61.125,55 59.875,54.875 58.75,54.5 57.5,53.75")
            Put_SVGLine ("56.5,52.875 55.375,51.75 54.375,50.375 53.5,48.875")
            Put_SVGLine ("52.625,47.125 51.875,45.125 51.125,43.125 50.625,40.875")
            Put_SVGLine ("50.125,38.5 49.375,33.375 49.25,30.75 49.125,28")
            Put_SVGLine ("49.25,25.25 49.375,22.625 50.125,17.5 50.625,15.125")
            Put_SVGLine ("51.125,12.875 51.875,10.875 52.625,8.875 53.5,7.125")
            Put_SVGLine ("54.375,5.625 55.375,4.25 56.5,3.125 57.5,2.25")
            Put_SVGLine ("58.75,1.5 59.875,1.125 61.125,1" & """")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
    Call Decrement_Indent
    Put_SVGLine ("</g>")
End Sub
Private Sub FlowchartDisplay2Svg _
    (Sh As Shape, Width As Single, Height As Single)
    Dim Symbolname As String
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Call Put_SVGLine(Line:="<desc>Symbol FlowchartDisplay</desc>")
    Call Put_SVGLine(Line:="<g")
    Call Increment_Indent
        Call Put_SVGLine(Line:="id=""" & Symbolname & """")
        Call Transform_Symbol(Sh:=Sh, Width:=Width, Height:=Height)
        Put_SVGLine ("<polygon points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "60.875,1 62,1.375 63.125,1.875 64.25,2.5")
            Put_SVGLine ("65.375,3.25 66.375,4.25 67.375,5.25 68.375,6.5")
            Put_SVGLine ("69.125,7.75 70.5,11.75 71.5,15.875 72.375,20.25")
            Put_SVGLine ("73,25 72.375,29.625 71.5,33.875 70.5,38.125")
            Put_SVGLine ("69.125,42 68.375,43.375 67.375,44.625 66.375,45.625")
            Put_SVGLine ("65.375,46.625 64.25,47.5 63.125,48.125 62,48.625")
            Put_SVGLine ("60.875,49 12.875,49 1,25 12.875,1" & """")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
    Call Decrement_Indent
    Put_SVGLine ("</g>")
End Sub
Private Sub FlowchartDocument2Svg _
    (Sh As Shape, Width As Single, Height As Single)
    Dim Symbolname As String
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Call Put_SVGLine(Line:="<desc>Symbol FlowchartDocument</desc>")
    Call Put_SVGLine(Line:="<g")
    Call Increment_Indent
        Call Put_SVGLine(Line:="id=""" & Symbolname & """")
        Call Transform_Symbol(Sh:=Sh, Width:=Width, Height:=Height)
        Put_SVGLine ("<polygon points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "1,45.875 3.375,46.5 5.75,47 10.375,47.875")
            Put_SVGLine ("12.375,48.25 14.25,48.5 16.125,48.75 17.875,49")
            Put_SVGLine ("20.125,49 22.125,48.875 23.625,48.875 24.875,48.75")
            Put_SVGLine ("25.875,48.625 26.75,48.5 28.125,48.375 31.125,47.875")
            Put_SVGLine ("33.875,47.25 36.25,46.5 37.5,46.125 38.75,45.625")
            Put_SVGLine ("41.25,45 43.875,44 46.75,43.25 49.625,42.375")
            Put_SVGLine ("51.125,42 52.75,41.625 54.375,41.25 56.125,40.875")
            Put_SVGLine ("57.875,40.625 59.625,40.375 61.5,40 63.5,39.75")
            Put_SVGLine ("68.125,39.625 73,39.5 73,1 1,1" & """")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
    Call Decrement_Indent
    Put_SVGLine ("</g>")
End Sub
Private Sub FlowchartExtract2Svg _
    (Sh As Shape, Width As Single, Height As Single)
    Dim Symbolname As String
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Call Put_SVGLine(Line:="<desc>Symbol FlowchartExtract</desc>")
    Call Put_SVGLine(Line:="<g")
    Call Increment_Indent
        Call Put_SVGLine(Line:="id=""" & Symbolname & """")
        Call Transform_Symbol(Sh:=Sh, Width:=Width, Height:=Height)
        Put_SVGLine ("<polygon points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "28,1 55,55 1,55" & """")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
    Call Decrement_Indent
    Put_SVGLine ("</g>")
End Sub
Private Sub FlowchartInternalStorage2Svg _
    (Sh As Shape, Width As Single, Height As Single)
    Dim Symbolname As String
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Call Put_SVGLine(Line:="<desc>Symbol FlowchartInternalStorage</desc>")
    Call Put_SVGLine(Line:="<g")
    Call Increment_Indent
        Call Put_SVGLine(Line:="id=""" & Symbolname & """")
        Call Transform_Symbol(Sh:=Sh, Width:=Width, Height:=Height)
        Put_SVGLine ("<rect")
        Call Increment_Indent
            Put_SVGLine ("x=""1""")
            Put_SVGLine ("y=""1""")
            Put_SVGLine ("width=""48""")
            Put_SVGLine ("height=""48""")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
        Put_SVGLine ("<line")
        Call Increment_Indent
            Put_SVGLine ("x1=""10.375""")
            Put_SVGLine ("x2=""10.5""")
            Put_SVGLine ("y1=""1""")
            Put_SVGLine ("y2=""49""")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
        Put_SVGLine ("<line")
        Call Increment_Indent
            Put_SVGLine ("x1=""1""")
            Put_SVGLine ("x2=""49""")
            Put_SVGLine ("y1=""10.375""")
            Put_SVGLine ("y2=""10.5""")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
    Call Decrement_Indent
    Put_SVGLine ("</g>")
End Sub
Private Sub FlowchartMagneticDisk2Svg _
    (Sh As Shape, Width As Single, Height As Single)
    Dim Symbolname As String
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Call Put_SVGLine(Line:="<desc>Symbol FlowchartMagneticDisk</desc>")
    Call Put_SVGLine(Line:="<g")
    Call Increment_Indent
        Call Put_SVGLine(Line:="id=""" & Symbolname & """")
        Call Transform_Symbol(Sh:=Sh, Width:=Width, Height:=Height)
        Put_SVGLine ("<polygon points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "37,1 29.75,1.125 26.25,1.375 23,1.625")
            Put_SVGLine ("19.875,1.875 16.875,2.25 14.125,2.75 11.5,3.25")
            Put_SVGLine ("9.25,3.75 7.125,4.375 5.375,4.875 3.875,5.625")
            Put_SVGLine ("2.625,6.25 1.75,7 1.25,7.75 1,8.5")
            Put_SVGLine ("1,41.5 1.25,42.25 1.75,43 2.625,43.75")
            Put_SVGLine ("3.875,44.375 5.375,45.125 7.125,45.75 9.25,46.25")
            Put_SVGLine ("11.5,46.75 14.125,47.25 16.875,47.75 19.875,48.125")
            Put_SVGLine ("23,48.375 26.25,48.625 29.75,48.875 37,49")
            Put_SVGLine ("44.25,48.875 47.75,48.625 51,48.375 54.125,48.125")
            Put_SVGLine ("57.125,47.75 59.875,47.25 62.5,46.75 64.75,46.25")
            Put_SVGLine ("66.875,45.75 68.625,45.125 70.125,44.375 71.375,43.75")
            Put_SVGLine ("72.25,43 72.875,42.25 73,41.5 73,8.5")
            Put_SVGLine ("72.875,7.75 72.25,7 71.375,6.25 70.125,5.625")
            Put_SVGLine ("68.625,4.875 66.875,4.375 64.75,3.75 62.5,3.25")
            Put_SVGLine ("59.875,2.75 57.125,2.25 54.125,1.875 51,1.625")
            Put_SVGLine ("47.75,1.375 44.25,1.125" & """")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
        Put_SVGLine ("<polyline points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "1,8.5 1.25,9.25 1.75,10 2.625,10.75")
            Put_SVGLine ("3.875,11.5 5.375,12.125 7.125,12.75 9.25,13.375")
            Put_SVGLine ("11.5,13.875 14.125,14.375 16.875,14.875 19.875,15.25")
            Put_SVGLine ("23,15.5 26.25,15.75 29.75,16 37,16.125")
            Put_SVGLine ("44.25,16 47.75,15.75 51,15.5 54.125,15.25")
            Put_SVGLine ("57.125,14.875 59.875,14.375 62.5,13.875 64.75,13.375")
            Put_SVGLine ("66.875,12.75 68.625,12.125 70.125,11.5 71.375,10.75")
            Put_SVGLine ("72.25,10 72.875,9.25 73,8.5" & """")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
    Call Decrement_Indent
    Put_SVGLine ("</g>")
End Sub
Private Sub FlowchartManualInput2Svg _
    (Sh As Shape, Width As Single, Height As Single)
    Dim Symbolname As String
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Call Put_SVGLine(Line:="<desc>Symbol FlowchartManualInput</desc>")
    Call Put_SVGLine(Line:="<g")
    Call Increment_Indent
        Call Put_SVGLine(Line:="id=""" & Symbolname & """")
        Call Transform_Symbol(Sh:=Sh, Width:=Width, Height:=Height)
        Put_SVGLine ("<polygon points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "1,8.125 73,1 73,37 1,37" & """")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
    Call Decrement_Indent
    Put_SVGLine ("</g>")
End Sub
Private Sub FlowchartManualOperation2Svg _
    (Sh As Shape, Width As Single, Height As Single)
    Dim Symbolname As String
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Call Put_SVGLine(Line:="<desc>Symbol FlowchartManualOperation</desc>")
    Call Put_SVGLine(Line:="<g")
    Call Increment_Indent
        Call Put_SVGLine(Line:="id=""" & Symbolname & """")
        Call Transform_Symbol(Sh:=Sh, Width:=Width, Height:=Height)
        Put_SVGLine ("<polygon points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "1,1 73,1 58.5,49 15.5,49" & """")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
    Call Decrement_Indent
    Put_SVGLine ("</g>")
End Sub
Private Sub FlowchartMerge2Svg _
    (Sh As Shape, Width As Single, Height As Single)
    Dim Symbolname As String
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Call Put_SVGLine(Line:="<desc>Symbol FlowchartMerge</desc>")
    Call Put_SVGLine(Line:="<g")
    Call Increment_Indent
        Call Put_SVGLine(Line:="id=""" & Symbolname & """")
        Call Transform_Symbol(Sh:=Sh, Width:=Width, Height:=Height)
        Put_SVGLine ("<polygon points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "1,1 55,1 28,55" & """")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
    Call Decrement_Indent
    Put_SVGLine ("</g>")
End Sub
Private Sub FlowchartMultidocument2Svg _
    (Sh As Shape, Width As Single, Height As Single)
    Dim Symbolname As String
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Call Put_SVGLine(Line:="<desc>Symbol FlowchartMultidocument</desc>")
    Call Put_SVGLine(Line:="<g")
    Call Increment_Indent
        Call Put_SVGLine(Line:="id=""" & Symbolname & """")
        Call Transform_Symbol(Sh:=Sh, Width:=Width, Height:=Height)
        Put_SVGLine ("<polygon points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "1,57.875 3.375,58.5 5.75,58.875 8,59.375")
            Put_SVGLine ("10.375,59.875 14.375,60.375 16.25,60.625 18.125,61")
            Put_SVGLine ("20.25,61 22.125,60.875 23.75,60.875 25,60.75")
            Put_SVGLine ("26.125,60.625 27,60.5 27.75,60.375 28.5,60.25")
            Put_SVGLine ("30,60 31.25,59.75 32.625,59.375 33.875,59.125")
            Put_SVGLine ("35.125,58.75 36.25,58.375 37.625,58 39,57.625")
            Put_SVGLine ("41.625,56.75 44.125,55.875 47,55.125 49.625,54.25")
            Put_SVGLine ("51.25,53.875 52.875,53.5 54.625,53.125 56.375,52.75")
            Put_SVGLine ("60.125,52 64,51.5 66.25,51.375 68.625,51.25")
            Put_SVGLine ("71,51.125 73.375,51 73.375,46.375 75.625,46.125")
            Put_SVGLine ("78.75,46.125 78.75,41.125 81.625,41 85,41")
            Put_SVGLine ("85,1 12.5,1 12.5,6 7,6")
            Put_SVGLine ("7,11.25 1,11.25" & """")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
        Put_SVGLine ("<polyline points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "12.5,6 78.75,6 78.75,41.125" & """")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
        Put_SVGLine ("<polyline points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "7,11.25 73.375,11.25 73.375,46.375" & """")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
    Call Decrement_Indent
    Put_SVGLine ("</g>")
End Sub
Private Sub FlowchartOffpageConnector2Svg _
    (Sh As Shape, Width As Single, Height As Single)
    Dim Symbolname As String
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Call Put_SVGLine(Line:="<desc>Symbol FlowchartOffpageConnector</desc>")
    Call Put_SVGLine(Line:="<g")
    Call Increment_Indent
        Call Put_SVGLine(Line:="id=""" & Symbolname & """")
        Call Transform_Symbol(Sh:=Sh, Width:=Width, Height:=Height)
        Put_SVGLine ("<polygon points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "1,1 49,1 49,39.375 25,49")
            Put_SVGLine ("1,39.375" & """")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
    Call Decrement_Indent
    Put_SVGLine ("</g>")
End Sub
Private Sub FlowchartOr2Svg _
    (Sh As Shape, Width As Single, Height As Single)
    Dim Symbolname As String
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Call Put_SVGLine(Line:="<desc>Symbol FlowchartOr</desc>")
    Call Put_SVGLine(Line:="<g")
    Call Increment_Indent
        Call Put_SVGLine(Line:="id=""" & Symbolname & """")
        Call Transform_Symbol(Sh:=Sh, Width:=Width, Height:=Height)
        Put_SVGLine ("<polygon points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "25,1 22.5,1.125 20.125,1.5 17.875,2.125")
            Put_SVGLine ("15.625,2.875 13.625,3.875 11.625,5.125 9.75,6.5")
            Put_SVGLine ("8,8 6.5,9.75 5.125,11.625 3.875,13.625")
            Put_SVGLine ("2.875,15.625 2.125,17.875 1.5,20.125 1.125,22.5")
            Put_SVGLine ("1,25 1.125,27.5 1.5,29.875 2.125,32.125")
            Put_SVGLine ("2.875,34.375 3.875,36.5 5.125,38.375 6.5,40.25")
            Put_SVGLine ("8,42 9.75,43.5 11.625,44.875 13.625,46.125")
            Put_SVGLine ("15.625,47.125 17.875,47.875 20.125,48.5 22.5,48.875")
            Put_SVGLine ("25,49 27.5,48.875 29.875,48.5 32.125,47.875")
            Put_SVGLine ("34.375,47.125 36.5,46.125 38.375,44.875 40.25,43.5")
            Put_SVGLine ("42,42 43.5,40.25 44.875,38.375 46.125,36.5")
            Put_SVGLine ("47.125,34.375 47.875,32.125 48.5,29.875 48.875,27.5")
            Put_SVGLine ("49,25 48.875,22.5 48.5,20.125 47.875,17.875")
            Put_SVGLine ("47.125,15.625 46.125,13.625 44.875,11.625 43.5,9.75")
            Put_SVGLine ("42,8 40.25,6.5 38.375,5.125 36.5,3.875")
            Put_SVGLine ("34.375,2.875 32.125,2.125 29.875,1.5 27.5,1.125" & """")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
        Put_SVGLine ("<line")
        Call Increment_Indent
            Put_SVGLine ("x1=""1""")
            Put_SVGLine ("x2=""49""")
            Put_SVGLine ("y1=""25""")
            Put_SVGLine ("y2=""25.125""")
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
        Put_SVGLine ("<line")
        Call Increment_Indent
            Put_SVGLine ("x1=""25""")
            Put_SVGLine ("x2=""25.125""")
            Put_SVGLine ("y1=""1""")
            Put_SVGLine ("y2=""49""")
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
    Call Decrement_Indent
    Put_SVGLine ("</g>")
End Sub
Private Sub FlowchartPredefinedProcess2Svg _
    (Sh As Shape, Width As Single, Height As Single)
    Dim Symbolname As String
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Call Put_SVGLine(Line:="<desc>Symbol FlowchartPredefinedProcess</desc>")
    Call Put_SVGLine(Line:="<g")
    Call Increment_Indent
        Call Put_SVGLine(Line:="id=""" & Symbolname & """")
        Call Transform_Symbol(Sh:=Sh, Width:=Width, Height:=Height)
        Put_SVGLine ("<rect")
        Call Increment_Indent
            Put_SVGLine ("x=""1""")
            Put_SVGLine ("y=""1""")
            Put_SVGLine ("width=""72""")
            Put_SVGLine ("height=""48""")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
        Put_SVGLine ("<line")
        Call Increment_Indent
            Put_SVGLine ("x1=""9.75""")
            Put_SVGLine ("x2=""9.875""")
            Put_SVGLine ("y1=""1""")
            Put_SVGLine ("y2=""49""")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
        Put_SVGLine ("<line")
        Call Increment_Indent
            Put_SVGLine ("x1=""64.25""")
            Put_SVGLine ("x2=""64.375""")
            Put_SVGLine ("y1=""1""")
            Put_SVGLine ("y2=""49""")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
    Call Decrement_Indent
    Put_SVGLine ("</g>")
End Sub
Private Sub FlowchartPreparation2Svg _
    (Sh As Shape, Width As Single, Height As Single)
    Dim Symbolname As String
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Call Put_SVGLine(Line:="<desc>Symbol FlowchartPreparation</desc>")
    Call Put_SVGLine(Line:="<g")
    Call Increment_Indent
        Call Put_SVGLine(Line:="id=""" & Symbolname & """")
        Call Transform_Symbol(Sh:=Sh, Width:=Width, Height:=Height)
        Put_SVGLine ("<polygon points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "17.875,1 68,1 85,25 68,49")
            Put_SVGLine ("17.875,49 1,25" & """")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
    Call Decrement_Indent
    Put_SVGLine ("</g>")
End Sub
Private Sub FlowchartProcess2Svg _
    (Sh As Shape, Width As Single, Height As Single)
    Dim Symbolname As String
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Call Put_SVGLine(Line:="<desc>Symbol FlowchartProcess</desc>")
    Call Put_SVGLine(Line:="<g")
    Call Increment_Indent
        Call Put_SVGLine(Line:="id=""" & Symbolname & """")
        Call Transform_Symbol(Sh:=Sh, Width:=Width, Height:=Height)
        Put_SVGLine ("<rect")
        Call Increment_Indent
            Put_SVGLine ("x=""1""")
            Put_SVGLine ("y=""1""")
            Put_SVGLine ("width=""72.125""")
            Put_SVGLine ("height=""48.125""")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
    Call Decrement_Indent
    Put_SVGLine ("</g>")
End Sub
Private Sub FlowchartPunchedTape2Svg _
    (Sh As Shape, Width As Single, Height As Single)
    Dim Symbolname As String
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Call Put_SVGLine(Line:="<desc>Symbol FlowchartPunchedTape</desc>")
    Call Put_SVGLine(Line:="<g")
    Call Increment_Indent
        Call Put_SVGLine(Line:="id=""" & Symbolname & """")
        Call Transform_Symbol(Sh:=Sh, Width:=Width, Height:=Height)
        Put_SVGLine ("<polygon points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "73,57.75 72.25,56.5 71.125,55.375 69.5,54.25")
            Put_SVGLine ("67.5,53.25 64.75,52.625 61.625,52.125 58.375,51.625")
            Put_SVGLine ("55,51.375 51.375,51.625 48.125,52.125 45.125,52.625")
            Put_SVGLine ("42.375,53.25 40.25,54.25 39.375,54.875 38.625,55.375")
            Put_SVGLine ("38,56 37.625,56.5 37.25,57.125 37,57.75")
            Put_SVGLine ("36.25,58.875 35.125,60 33.625,61.125 31.625,62")
            Put_SVGLine ("28.75,62.625 25.75,63.125 22.5,63.625 19,64")
            Put_SVGLine ("15.5,63.625 12.25,63.125 9.25,62.625 6.375,62")
            Put_SVGLine ("5.25,61.5 4.25,61.125 3.375,60.5 2.75,60")
            Put_SVGLine ("1.625,58.875 1,57.75 1,7.25 1.625,8.5")
            Put_SVGLine ("2.75,9.625 3.375,10.125 4.25,10.625 5.25,11.125")
            Put_SVGLine ("6.375,11.5 9.25,12.25 12.25,12.75 15.5,13.25")
            Put_SVGLine ("19,13.625 22.5,13.25 25.75,12.75 28.75,12.25")
            Put_SVGLine ("31.625,11.5 33.625,10.625 35.125,9.625 36.25,8.5")
            Put_SVGLine ("37,7.25 37.25,6.625 37.625,6.125 38,5.5")
            Put_SVGLine ("38.625,5 39.375,4.375 40.25,3.875 42.375,2.75")
            Put_SVGLine ("45.125,2.125 48.125,1.625 51.375,1.25 55,1")
            Put_SVGLine ("58.375,1.25 61.625,1.625 64.75,2.125 67.5,2.75")
            Put_SVGLine ("69.5,3.875 71.125,5 72.25,6.125 73,7.25" & """")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
    Call Decrement_Indent
    Put_SVGLine ("</g>")
End Sub
Private Sub FlowchartSequentialAccessStorage2Svg _
    (Sh As Shape, Width As Single, Height As Single)
    Dim Symbolname As String
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Call Put_SVGLine(Line:="<desc>Symbol FlowchartSequentialAccessStorage</desc>")
    Call Put_SVGLine(Line:="<g")
    Call Increment_Indent
        Call Put_SVGLine(Line:="id=""" & Symbolname & """")
        Call Transform_Symbol(Sh:=Sh, Width:=Width, Height:=Height)
        Put_SVGLine ("<polygon points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "42.5,41.375 44,39.625 45.375,37.75 46.375,35.875")
            Put_SVGLine ("47.375,33.75 48.125,31.75 48.625,29.5 48.875,27.25")
            Put_SVGLine ("49,25 48.875,22.5 48.5,20.125 47.875,17.875")
            Put_SVGLine ("47.125,15.625 46.125,13.625 44.875,11.625 43.5,9.75")
            Put_SVGLine ("42,8 40.25,6.5 38.375,5.125 36.5,3.875")
            Put_SVGLine ("34.375,2.875 32.125,2.125 29.875,1.5 27.5,1.125")
            Put_SVGLine ("25,1 22.5,1.125 20.125,1.5 17.875,2.125")
            Put_SVGLine ("15.625,2.875 13.625,3.875 11.625,5.125 9.75,6.5")
            Put_SVGLine ("8,8 6.5,9.75 5.125,11.625 3.875,13.625")
            Put_SVGLine ("2.875,15.625 2.125,17.875 1.5,20.125 1.125,22.5")
            Put_SVGLine ("1,25 1.125,27.375 1.5,29.75 2.125,32.125")
            Put_SVGLine ("2.875,34.25 3.875,36.375 5,38.375 6.375,40.125")
            Put_SVGLine ("8,41.875 9.625,43.375 11.5,44.875 13.375,46")
            Put_SVGLine ("15.5,47 17.75,47.875 20,48.5 22.375,48.875")
            Put_SVGLine ("24.75,49 47.625,49 47.625,41.375" & """")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
    Call Decrement_Indent
    Put_SVGLine ("</g>")
End Sub
Private Sub FlowchartSort2Svg _
    (Sh As Shape, Width As Single, Height As Single)
    Dim Symbolname As String
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Call Put_SVGLine(Line:="<desc>Symbol FlowchartSort</desc>")
    Call Put_SVGLine(Line:="<g")
    Call Increment_Indent
        Call Put_SVGLine(Line:="id=""" & Symbolname & """")
        Call Transform_Symbol(Sh:=Sh, Width:=Width, Height:=Height)
        Put_SVGLine ("<polygon points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "19,1 1,37 19,73 37,37" & """")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
        Put_SVGLine ("<line")
        Call Increment_Indent
            Put_SVGLine ("x1=""1""")
            Put_SVGLine ("x2=""37""")
            Put_SVGLine ("y1=""37""")
            Put_SVGLine ("y2=""37.125""")
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
    Call Decrement_Indent
    Put_SVGLine ("</g>")
End Sub
Private Sub FlowchartStoredData2Svg _
    (Sh As Shape, Width As Single, Height As Single)
    Dim Symbolname As String
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Call Put_SVGLine(Line:="<desc>Symbol FlowchartStoredData</desc>")
    Call Put_SVGLine(Line:="<g")
    Call Increment_Indent
        Call Put_SVGLine(Line:="id=""" & Symbolname & """")
        Call Transform_Symbol(Sh:=Sh, Width:=Width, Height:=Height)
        Put_SVGLine ("<polygon points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "13,49 11.875,48.625 10.75,48 9.625,47.375")
            Put_SVGLine ("8.625,46.5 7.5,45.625 6.5,44.5 4.625,42")
            Put_SVGLine ("3.25,38.125 2.125,34 1.375,29.5 1,24.875")
            Put_SVGLine ("1.375,20.375 2.125,16 3.25,11.75 4.625,7.75")
            Put_SVGLine ("6.5,5.375 7.5,4.25 8.625,3.375 9.625,2.5")
            Put_SVGLine ("10.75,1.875 11.875,1.375 13,1 73,1")
            Put_SVGLine ("71.875,1.375 70.75,1.875 69.75,2.5 68.625,3.375")
            Put_SVGLine ("67.625,4.25 66.625,5.375 64.625,7.75 63.25,11.75")
            Put_SVGLine ("62.125,16 61.375,20.375 61,24.875 61.375,29.5")
            Put_SVGLine ("62.125,34 63.25,38.125 64.625,42 66.625,44.5")
            Put_SVGLine ("67.625,45.625 68.625,46.5 69.75,47.375 70.75,48")
            Put_SVGLine ("71.875,48.625 73,49" & """")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
    Call Decrement_Indent
    Put_SVGLine ("</g>")
End Sub
Private Sub FlowchartSummingJunction2Svg _
    (Sh As Shape, Width As Single, Height As Single)
    Dim Symbolname As String
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Call Put_SVGLine(Line:="<desc>Symbol FlowchartSummingJunction</desc>")
    Call Put_SVGLine(Line:="<g")
    Call Increment_Indent
        Call Put_SVGLine(Line:="id=""" & Symbolname & """")
        Call Transform_Symbol(Sh:=Sh, Width:=Width, Height:=Height)
        Put_SVGLine ("<polygon points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "25,1 22.5,1.125 20.125,1.5 17.875,2.125")
            Put_SVGLine ("15.625,2.875 13.625,3.875 11.625,5.125 9.75,6.5")
            Put_SVGLine ("8,8 6.5,9.75 5.125,11.625 3.875,13.625")
            Put_SVGLine ("2.875,15.625 2.125,17.875 1.5,20.125 1.125,22.5")
            Put_SVGLine ("1,25 1.125,27.5 1.5,29.875 2.125,32.125")
            Put_SVGLine ("2.875,34.375 3.875,36.5 5.125,38.375 6.5,40.25")
            Put_SVGLine ("8,42 9.75,43.5 11.625,44.875 13.625,46.125")
            Put_SVGLine ("15.625,47.125 17.875,47.875 20.125,48.5 22.5,48.875")
            Put_SVGLine ("25,49 27.5,48.875 29.875,48.5 32.125,47.875")
            Put_SVGLine ("34.375,47.125 36.5,46.125 38.375,44.875 40.25,43.5")
            Put_SVGLine ("42,42 43.5,40.25 44.875,38.375 46.125,36.5")
            Put_SVGLine ("47.125,34.375 47.875,32.125 48.5,29.875 48.875,27.5")
            Put_SVGLine ("49,25 48.875,22.5 48.5,20.125 47.875,17.875")
            Put_SVGLine ("47.125,15.625 46.125,13.625 44.875,11.625 43.5,9.75")
            Put_SVGLine ("42,8 40.25,6.5 38.375,5.125 36.5,3.875")
            Put_SVGLine ("34.375,2.875 32.125,2.125 29.875,1.5 27.5,1.125" & """")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
        Put_SVGLine ("<line")
        Call Increment_Indent
            Put_SVGLine ("x1=""8""")
            Put_SVGLine ("x2=""42""")
            Put_SVGLine ("y1=""8""")
            Put_SVGLine ("y2=""42""")
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
        Put_SVGLine ("<line")
        Call Increment_Indent
            Put_SVGLine ("x1=""42""")
            Put_SVGLine ("x2=""8""")
            Put_SVGLine ("y1=""8""")
            Put_SVGLine ("y2=""42""")
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
    Call Decrement_Indent
    Put_SVGLine ("</g>")
End Sub
Private Sub FlowchartTerminator2Svg _
    (Sh As Shape, Width As Single, Height As Single)
    Dim Symbolname As String
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Call Put_SVGLine(Line:="<desc>Symbol FlowchartTerminator</desc>")
    Call Put_SVGLine(Line:="<g")
    Call Increment_Indent
        Call Put_SVGLine(Line:="id=""" & Symbolname & """")
        Call Transform_Symbol(Sh:=Sh, Width:=Width, Height:=Height)
        Put_SVGLine ("<polygon points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "12.625,1 11.375,1.125 10.25,1.25 8.125,2")
            Put_SVGLine ("6.125,3 4.375,4.5 3,6.25 1.875,8.375")
            Put_SVGLine ("1.25,10.625 1,13 1.25,15.375 1.875,17.625")
            Put_SVGLine ("3,19.75 4.375,21.5 6.125,23 8.125,24")
            Put_SVGLine ("10.25,24.75 11.375,25 12.625,25 61.375,25")
            Put_SVGLine ("62.625,25 63.75,24.75 66,24 67.875,23")
            Put_SVGLine ("69.625,21.5 71,19.75 72.125,17.625 72.75,15.375")
            Put_SVGLine ("73,13 72.75,10.625 72.125,8.375 71,6.25")
            Put_SVGLine ("69.625,4.5 67.875,3 66,2 63.75,1.25")
            Put_SVGLine ("62.625,1.125 61.375,1" & """")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
    Call Decrement_Indent
    Put_SVGLine ("</g>")
End Sub
Private Sub RoundedRectangle2Svg _
    (Sh As Shape, Width As Single, Height As Single)
    Dim Symbolname As String
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Call Put_SVGLine(Line:="<desc>Symbol RoundedRectangle</desc>")
    Call Put_SVGLine(Line:="<g")
    Call Increment_Indent
        Call Put_SVGLine(Line:="id=""" & Symbolname & """")
        Call Transform_Symbol(Sh:=Sh, Width:=Width, Height:=Height)
        Put_SVGLine ("<polygon points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "13,1 11.75,1.125 10.625,1.25 8.375,2")
            Put_SVGLine ("6.25,3 4.5,4.5 3,6.25 2,8.375")
            Put_SVGLine ("1.25,10.625 1.125,11.75 1,13 1,61")
            Put_SVGLine ("1.125,62.25 1.25,63.375 2,65.625 3,67.75")
            Put_SVGLine ("4.5,69.5 6.25,71 8.375,72 10.625,72.75")
            Put_SVGLine ("11.75,73 13,73 61,73 62.25,73")
            Put_SVGLine ("63.375,72.75 65.625,72 67.75,71 69.5,69.5")
            Put_SVGLine ("71,67.75 72,65.625 72.75,63.375 73,62.25")
            Put_SVGLine ("73,61 73,13 73,11.75 72.75,10.625")
            Put_SVGLine ("72,8.375 71,6.25 69.5,4.5 67.75,3")
            Put_SVGLine ("65.625,2 63.375,1.25 62.25,1.125 61,1" & """")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
    Call Decrement_Indent
    Put_SVGLine ("</g>")
End Sub
Private Sub ActionButtonBackorPrevious2Svg _
    (Sh As Shape, Width As Single, Height As Single)
    Dark_ForeColor_Red = CByte(3 * ForeColor_Red / 5)
    MidDark_ForeColor_Red = CByte(4 * ForeColor_Red / 5)
    Light_ForeColor_Red = CByte((3 * ForeColor_Red / 5) + 102)
    MidLight_ForeColor_Red = CByte((4 * ForeColor_Red / 5) + 51)
    Dark_ForeColor_Green = CByte(3 * ForeColor_Green / 5)
    MidDark_ForeColor_Green = CByte(4 * ForeColor_Green / 5)
    Light_ForeColor_Green = CByte((3 * ForeColor_Green / 5) + 102)
    MidLight_ForeColor_Green = CByte((4 * ForeColor_Green / 5) + 51)
    Dark_ForeColor_Blue = CByte(3 * ForeColor_Blue / 5)
    MidDark_ForeColor_Blue = CByte(4 * ForeColor_Blue / 5)
    Light_ForeColor_Blue = CByte((3 * ForeColor_Blue / 5) + 102)
    MidLight_ForeColor_Blue = CByte((4 * ForeColor_Blue / 5) + 51)
    Dim Symbolname As String
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Call Put_SVGLine(Line:="<desc>Symbol ActionButtonBackorPrevious</desc>")
    Call Put_SVGLine(Line:="<g")
    Call Increment_Indent
        Call Put_SVGLine(Line:="id=""" & Symbolname & """")
        Call Transform_Symbol(Sh:=Sh, Width:=Width, Height:=Height)
        Put_SVGLine ("<rect")
        Call Increment_Indent
            Put_SVGLine ("x=""2.625""")
            Put_SVGLine ("y=""2.625""")
            Put_SVGLine ("width=""81.875""")
            Put_SVGLine ("height=""81.875""")
            Put_SVGLine ("stroke=""none""")
            Call Put_SVGLine(Line:="fill=""rgb(" & _
                ForeColor_Red & "," & _
                ForeColor_Green & "," & _
                ForeColor_Blue & ")""")
        Call Decrement_Indent
        Put_SVGLine ("/>")
        Put_SVGLine ("<polygon points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "2.625,2.625 7.875,7.875 80,7.875 84.5,2.625" & """")
            Put_SVGLine ("stroke=""none""")
            Call Put_SVGLine(Line:="fill=""rgb(" & _
                MidLight_ForeColor_Red & "," & _
                MidLight_ForeColor_Green & "," & _
                MidLight_ForeColor_Blue & ")""")
        Call Decrement_Indent
        Put_SVGLine ("/>")
        Put_SVGLine ("<polygon points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "2.625,2.625 2.625,84.5 7.875,80 7.875,7.875" & """")
            Put_SVGLine ("stroke=""none""")
            Call Put_SVGLine(Line:="fill=""rgb(" & _
                Light_ForeColor_Red & "," & _
                Light_ForeColor_Green & "," & _
                Light_ForeColor_Blue & ")""")
        Call Decrement_Indent
        Put_SVGLine ("/>")
        Put_SVGLine ("<polygon points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "2.625,84.5 84.5,84.5 80,80 7.875,80" & """")
            Put_SVGLine ("stroke=""none""")
            Call Put_SVGLine(Line:="fill=""rgb(" & _
                MidDark_ForeColor_Red & "," & _
                MidDark_ForeColor_Green & "," & _
                MidDark_ForeColor_Blue & ")""")
        Call Decrement_Indent
        Put_SVGLine ("/>")
        Put_SVGLine ("<polygon points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "84.5,84.5 84.5,2.625 80,7.875 80,80" & """")
            Put_SVGLine ("stroke=""none""")
            Call Put_SVGLine(Line:="fill=""rgb(" & _
                Dark_ForeColor_Red & "," & _
                Dark_ForeColor_Green & "," & _
                Dark_ForeColor_Blue & ")""")
        Call Decrement_Indent
        Put_SVGLine ("/>")
        Put_SVGLine ("<polygon points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "69.375,18.375 18.375,43.875 69.375,69.5" & """")
            Call Put_SVGLine(Line:="fill=""rgb(" & _
                Dark_ForeColor_Red & "," & _
                Dark_ForeColor_Green & "," & _
                Dark_ForeColor_Blue & ")""")
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
        Put_SVGLine ("<rect")
        Call Increment_Indent
            Put_SVGLine ("x=""2.625""")
            Put_SVGLine ("y=""2.625""")
            Put_SVGLine ("width=""81.875""")
            Put_SVGLine ("height=""81.875""")
            Put_SVGLine ("fill=""none""")
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
        Put_SVGLine ("<rect")
        Call Increment_Indent
            Put_SVGLine ("x=""7.875""")
            Put_SVGLine ("y=""7.875""")
            Put_SVGLine ("width=""72.125""")
            Put_SVGLine ("height=""72.125""")
            Put_SVGLine ("fill=""none""")
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
        Put_SVGLine ("<line")
        Call Increment_Indent
            Put_SVGLine ("x1=""2.625""")
            Put_SVGLine ("x2=""7.875""")
            Put_SVGLine ("y1=""2.625""")
            Put_SVGLine ("y2=""7.875""")
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
        Put_SVGLine ("<line")
        Call Increment_Indent
            Put_SVGLine ("x1=""7.875""")
            Put_SVGLine ("x2=""2.625""")
            Put_SVGLine ("y1=""80""")
            Put_SVGLine ("y2=""84.5""")
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
        Put_SVGLine ("<line")
        Call Increment_Indent
            Put_SVGLine ("x1=""84.5""")
            Put_SVGLine ("x2=""80""")
            Put_SVGLine ("y1=""84.5""")
            Put_SVGLine ("y2=""80""")
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
        Put_SVGLine ("<line")
        Call Increment_Indent
            Put_SVGLine ("x1=""80""")
            Put_SVGLine ("x2=""84.5""")
            Put_SVGLine ("y1=""7.875""")
            Put_SVGLine ("y2=""2.625""")
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
    Call Decrement_Indent
    Put_SVGLine ("</g>")
End Sub
Private Sub ShapeRightArrow2Svg _
    (Sh As Shape, Width As Single, Height As Single)
    Dim Symbolname As String
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Call Put_SVGLine(Line:="<desc>Symbol ShapeRightArrow</desc>")
    Call Put_SVGLine(Line:="<g")
    Call Increment_Indent
        Call Put_SVGLine(Line:="id=""" & Symbolname & """")
        Call Transform_Symbol(Sh:=Sh, Width:=Width, Height:=Height)
        Put_SVGLine ("<polygon points=")
        Call Increment_Indent
'            Put_SVGLine ("""" & "58.75,1 58.75,10.5 1,10.5 1,29.5")
'            Put_SVGLine ("58.75,29.5 58.75,39 78,20" & """")
            Put_SVGLine ("""" & "" & _
                Format_3Dec(Sh.Adjustments(1) * 78) & ",1 " & _
                Format_3Dec(Sh.Adjustments(1) * 78) & "," & _
                Format_3Dec(Sh.Adjustments(2) * 40) & " 1," & _
                Format_3Dec(Sh.Adjustments(2) * 40) & " 1," & _
                Format_3Dec((1 - Sh.Adjustments(2)) * 40) & "")
            Put_SVGLine ("" & _
                Format_3Dec(Sh.Adjustments(1) * 78) & "," & _
                Format_3Dec((1 - Sh.Adjustments(2)) * 40) & " " & _
                Format_3Dec(Sh.Adjustments(1) * 78) & ",39 78,20" & """")
            Call Put_Shape_Fill_Attributes(Sh)
            Call Put_Shape_Line_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
    Call Decrement_Indent
    Put_SVGLine ("</g>")
End Sub
Private Sub ShapeCube2Svg _
    (Sh As Shape, Width As Single, Height As Single)
    MidDark_ForeColor_Red = CByte(4 * ForeColor_Red / 5)
    MidLight_ForeColor_Red = CByte((4 * ForeColor_Red / 5) + 51)
    MidDark_ForeColor_Green = CByte(4 * ForeColor_Green / 5)
    MidLight_ForeColor_Green = CByte((4 * ForeColor_Green / 5) + 51)
    MidDark_ForeColor_Blue = CByte(4 * ForeColor_Blue / 5)
    MidLight_ForeColor_Blue = CByte((4 * ForeColor_Blue / 5) + 51)
    Dim Symbolname As String
    Dim Scl As Single
    Dim C1x, C1y, C2x, C2y, C3x, C3y, C4x, C4y, C5x, C5y, C6x, C6y, C7x, C7y As Single
    ' Compute corners
    If Sh.Width = Sh.Height Then
        Scl = Sh.Height / Height
        C1x = 1
        C1y = Scl * Sh.Adjustments(1) * 97
        C2x = Scl * (1 - Sh.Adjustments(1)) * 97
        C2y = Scl * Sh.Adjustments(1) * 97
        C3x = Scl * 97
        C3y = 1
        C4x = Scl * Sh.Adjustments(1) * 97
        C4y = 1
        C5x = 1
        C5y = Scl * 97
        C6x = Scl * (1 - Sh.Adjustments(1)) * 97
        C6y = Scl * 97
        C7x = Scl * 97
        C7y = Scl * (1 - Sh.Adjustments(1)) * 97
    ElseIf Sh.Width > Sh.Height Then
        Scl = Sh.Height / Height
        C1x = 1
        C1y = Scl * Sh.Adjustments(1) * 97
        C2x = Scl * (1 - Sh.Adjustments(1)) * 97 + Sh.Width - Sh.Height
        C2y = Scl * Sh.Adjustments(1) * 97
        C3x = Scl * 97 + Sh.Width - Sh.Height
        C3y = 1
        C4x = Scl * Sh.Adjustments(1) * 97
        C4y = 1
        C5x = 1
        C5y = Scl * 97
        C6x = Scl * (1 - Sh.Adjustments(1)) * 97 + Sh.Width - Sh.Height
        C6y = Scl * 97
        C7x = Scl * 97 + Sh.Width - Sh.Height
        C7y = Scl * (1 - Sh.Adjustments(1)) * 97
    ElseIf Sh.Width < Sh.Height Then
        Scl = Sh.Width / Width
        C1x = 1
        C1y = Scl * Sh.Adjustments(1) * 97
        C2x = Scl * (1 - Sh.Adjustments(1)) * 97
        C2y = Scl * Sh.Adjustments(1) * 97
        C3x = Scl * 97
        C3y = 1
        C4x = Scl * Sh.Adjustments(1) * 97
        C4y = 1
        C5x = 1
        C5y = Scl * 97 + Sh.Height - Sh.Width
        C6x = Scl * (1 - Sh.Adjustments(1)) * 97
        C6y = Scl * 97 + Sh.Height - Sh.Width
        C7x = Scl * 97
        C7y = Scl * (1 - Sh.Adjustments(1)) * 97 + Sh.Height - Sh.Width
    End If
    If Sh.HorizontalFlip Then
        C1x = -C1x
        C2x = -C2x
        C3x = -C3x
        C4x = -C4x
        C5x = -C5x
        C6x = -C6x
        C7x = -C7x
    End If
    If Sh.VerticalFlip Then
        C1y = -C1y
        C2y = -C2y
        C3y = -C3y
        C4y = -C4y
        C5y = -C5y
        C6y = -C6y
        C7y = -C7y
    End If
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Call Put_SVGLine(Line:="<desc>Symbol ShapeCube</desc>")
    Call Put_SVGLine(Line:="<g")
    Call Increment_Indent
        Call Put_SVGLine(Line:="id=""" & Symbolname & """")
        Call Put_SVGLine(Line:="transform=")
        Call Increment_Indent
            Put_SVGLine ( _
                """rotate(" & _
                Format_3Dec(Sh.Rotation) & " " & _
                Format_3Dec(Sh.Left + Sh.Width / 2) & " " & _
                Format_3Dec(Sh.Top + Sh.Height / 2) & ") ")
            Put_SVGLine ( _
                "translate(" & _
                Format_3Dec(Sh.Left) & "," & _
                Format_3Dec(Sh.Top) & ")"">")
        Call Decrement_Indent
        Put_SVGLine ("<polygon points=")
        Call Increment_Indent
            Call Put_SVGLine("""" & "" & _
                Format_3Dec(C1x) & "," & Format_3Dec(C1y) & " " & _
                Format_3Dec(C2x) & "," & Format_3Dec(C2y) & " " & _
                Format_3Dec(C3x) & "," & Format_3Dec(C3y) & " " & _
                Format_3Dec(C4x) & "," & Format_3Dec(C4y) & "" & """")
            Call Put_SVGLine(Line:="stroke=""none""")
            If Shape_Filled Then
                Call Put_SVGLine(Line:="fill=""rgb(" & _
                    MidLight_ForeColor_Red & "," & _
                    MidLight_ForeColor_Green & "," & _
                    MidLight_ForeColor_Blue & ")""")
            Else
                Call Put_Shape_Fill_Attributes(Sh)
            End If
        Call Decrement_Indent
        Put_SVGLine ("/>")
        Put_SVGLine ("<polyline points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "" & _
                Format_3Dec(C5x) & "," & Format_3Dec(C5y) & " " & _
                Format_3Dec(C6x) & "," & Format_3Dec(C6y) & " " & _
                Format_3Dec(C2x) & "," & Format_3Dec(C2y) & " " & _
                Format_3Dec(C1x) & "," & Format_3Dec(C1y) & "" & """")
            Call Put_Shape_Fill_Attributes(Sh)
        Call Decrement_Indent
        Put_SVGLine ("/>")
        Put_SVGLine ("<polyline points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "" & _
                Format_3Dec(C6x) & "," & Format_3Dec(C6y) & " " & _
                Format_3Dec(C7x) & "," & Format_3Dec(C7y) & " " & _
                Format_3Dec(C3x) & "," & Format_3Dec(C3y) & " " & _
                Format_3Dec(C2x) & "," & Format_3Dec(C2y) & "" & """")
            Call Put_SVGLine(Line:="stroke=""none""")
            If Shape_Filled Then
                Call Put_SVGLine(Line:="fill=""rgb(" & _
                    MidDark_ForeColor_Red & "," & _
                    MidDark_ForeColor_Green & "," & _
                    MidDark_ForeColor_Blue & ")""")
            Else
                Call Put_Shape_Fill_Attributes(Sh)
            End If
        Call Decrement_Indent
        Put_SVGLine ("/>")
        Put_SVGLine ("<polygon points=")
        Call Increment_Indent
            Call Put_SVGLine("""" & "" & _
                Format_3Dec(C5x) & "," & Format_3Dec(C5y) & " " & _
                Format_3Dec(C6x) & "," & Format_3Dec(C6y) & " " & _
                Format_3Dec(C7x) & "," & Format_3Dec(C7y) & " " & _
                Format_3Dec(C3x) & "," & Format_3Dec(C3y) & " " & _
                Format_3Dec(C4x) & "," & Format_3Dec(C4y) & " " & _
                Format_3Dec(C1x) & "," & Format_3Dec(C1y) & "" & """")
            Call Put_Shape_Line_Attributes(Sh)
            Call Put_SVGLine(Line:="fill=""none""")
        Call Decrement_Indent
        Put_SVGLine ("/>")
        Put_SVGLine ("<polyline points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "" & _
                Format_3Dec(C1x) & "," & Format_3Dec(C1y) & " " & _
                Format_3Dec(C2x) & "," & Format_3Dec(C2y) & " " & _
                Format_3Dec(C3x) & "," & Format_3Dec(C3y) & "" & """")
            Call Put_Shape_Line_Attributes(Sh)
            Call Put_SVGLine(Line:="fill=""none""")
        Call Decrement_Indent
        Put_SVGLine ("/>")
        Put_SVGLine ("<polyline points=")
        Call Increment_Indent
            Put_SVGLine ("""" & "" & _
                Format_3Dec(C6x) & "," & Format_3Dec(C6y) & " " & _
                Format_3Dec(C2x) & "," & Format_3Dec(C2y) & "" & """")
            Call Put_Shape_Line_Attributes(Sh)
            Call Put_SVGLine(Line:="fill=""none""")
        Call Decrement_Indent
        Put_SVGLine ("/>")
    Call Decrement_Indent
    Put_SVGLine ("</g>")
End Sub
Private Sub UndefinedAutoshape2SVG _
    (Sh As Shape, Width As Single, Height As Single)
    Dim Symbolname As String
    Symbolname = String_Without_Spaces(Input_String:=Sh.Name)
    Put_SVGLine ("<symbol id=""" & _
        Symbolname & """ " & _
            "viewBox=""0 0 " & Format_3Dec(Width + 1) & " " & _
            Format_3Dec(Height + 1) & """" & ">")
    Call Increment_Indent
        Put_SVGLine ("<desc>Undefined Symbol """ & Sh.AutoShapeType & """</desc>")
    Call Decrement_Indent
    Put_SVGLine ("</symbol>")
End Sub

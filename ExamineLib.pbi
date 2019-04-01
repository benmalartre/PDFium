Define pdf_dll = OpenLibrary(#PB_Any, "pdfium.dll")

Define search_for.s = "circle"

ExamineLibraryFunctions(pdf_dll)
While NextLibraryFunction()
  name.s = LibraryFunctionName()
  If FindString(LCase(name), search_for) > 0
    Debug name
  EndIf

Wend 


; IDE Options = PureBasic 5.62 (Windows - x64)
; CursorPosition = 2
; EnableXP
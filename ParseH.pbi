Structure CLine_t
  content.s
  multi.b
EndStructure

Structure CFile_t
  file.i
  infile_name.s
  outfile_name.s
  List lines.CLine_t()
EndStructure

Procedure HeaderToLines(*file.CFile_t)
  Define line.s
  Define *current.CLine_t
  If FileSize(*file\infile_name) > 0
    *file\file = ReadFile(#PB_Any , *file\infile_name)
    If *file\file
      AddElement(*file\lines())
      *current = *file\lines()
      While Not Eof(*file\file)
        line = ReadString(*file\file)
        If Not Left(LTrim(line, " "),2) = "//"
          *current\content + line
           If Not Right(RTrim(line," "), 1) = ";"
            *current\content + Chr(10)
            *current\multi = #True
          Else
            AddElement(*file\lines())
            *current = *file\lines()
          EndIf
        EndIf
        
       
        
      Wend  
      
    EndIf
   

  EndIf
  
EndProcedure

Define file.CFile_t
InitializeStructure(file, CFile_t)
file\infile_name = "fpdf_edit.h"

HeaderToLines(file)
ForEach file\lines()
  Debug "--------------------------------------------------------"
  Debug file\lines()\content
Next



; IDE Options = PureBasic 5.62 (Windows - x64)
; CursorPosition = 30
; Folding = -
; EnableXP
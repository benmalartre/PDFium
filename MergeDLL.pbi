Procedure GetDLLContent(filename.s)
  Define *mem = #Null
  If ReadFile(0, filename) 
    length = Lof(0)                            ; Lit la taille en octets du fichier 
    *mem = AllocateMemory(length)         ; alloue un bloc mémoire de la taille du fichier
    If *mem
      bytes = ReadData(0, *mem, length)   ; Lit les données du fichier et les place dans le bloc mémoire
      Debug "Nombre d'octets lus: " + Str(bytes)
    EndIf
    CloseFile(0)
  EndIf
  ProcedureReturn *mem
EndProcedure

Procedure SetDLLContent(filename.s, *mem)
  If OpenFile(0, filename) 
    WriteData(0, *mem, MemorySize(*mem))
    CloseFile(0)
  EndIf
EndProcedure
  

Procedure MergeDLL(o.s, a.s, b.s)
  If FileSize(a)>0 And FileSize(b)>0  
    *b = GetDLLContent(a)
    *a = GetDLLContent(b)
    
    sa = MemorySize(*a)
    sb = MemorySize(*b)
    *n = AllocateMemory(sa + sb)
    CopyMemory(*a, *n, sa)
    CopyMemory(*b, *n + sa, sb)
    
    SetDLLContent(o, *n)
    
    FreeMemory(*a)
    FreeMemory(*b)
    FreeMemory(*n)
  EndIf
  
EndProcedure

Define a.s = "pdfium.dll"
Define b.s = "writer.dll"
Define o.s = "merged.dll"

MergeDLL(o, a, b)
; IDE Options = PureBasic 5.62 (Windows - x64)
; CursorPosition = 18
; Folding = -
; EnableXP
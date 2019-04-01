EnableExplicit


Prototype protoInitLibrary()
Prototype protoLoadDocument(documentpath.p-utf8,password.p-utf8)
Prototype protoGetMetaText(document, tag.p-utf8, buffer, buflen) 

Procedure Main()
  
  Protected pdf_dll =OpenLibrary(#PB_Any, "pdfium.dll")
  
  Debug pdf_dll
  
  Protected InitLibrary.protoInitLibrary = GetFunction(pdf_dll,"FPDF_InitLibrary")
  Protected LoadDocument.protoLoadDocument = GetFunction(pdf_dll,"FPDF_LoadDocument")
  Protected GetMetaText.protoGetMetaText = GetFunction(pdf_dll,"FPDF_GetMetaText")
  
  InitLibrary()
  
  Protected pdf_doc = LoadDocument("form.pdf", "")
  
  Protected buflen = 1024
  Protected *buffer = AllocateMemory(buflen)
  
  Protected ret = GetMetaText(pdf_doc,"Title",*buffer, buflen)
  
  Debug PeekS(*buffer, ret/2)
  
  ;FillMemory(*buffer, buflen)
  ret = GetMetaText(pdf_doc,"Author",*buffer, buflen)
  
  Debug PeekS(*buffer, ret/2)
  
  ;FillMemory(*buffer, buflen)
  ret = GetMetaText(pdf_doc,"Creator",*buffer, buflen)
  
  Debug PeekS(*buffer, ret/2)
  
  
EndProcedure


Main()

; IDE Options = PureBasic 5.62 (Windows - x64)
; CursorPosition = 5
; Folding = -
; EnableXP
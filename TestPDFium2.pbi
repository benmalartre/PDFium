EnableExplicit

Prototype protoInitLibrary()
Prototype protoLoadDocument(documentpath.p-ascii,password.p-utf8)
Prototype protoGetMetaText(document, tag.p-utf8, buffer, buflen)
Prototype protoGetPageCount(document)
Prototype protoLoadPage(document, page_index)
Prototype protoLoadTextPage(textpage)
Prototype protoCloseTextPage(textpage)
Prototype protoCountChars(textpage)
Prototype protoGetText(textpage, istart, iCharCnt, *result)
Prototype protoCloseDocument(document)

Procedure Main()
 
  Protected pdf_dll =OpenLibrary(#PB_Any, "pdfium.dll")
 
  Protected InitLibrary.protoInitLibrary = GetFunction(pdf_dll,"FPDF_InitLibrary")
  Protected LoadDocument.protoLoadDocument = GetFunction(pdf_dll,"FPDF_LoadDocument")
  Protected GetMetaText.protoGetMetaText = GetFunction(pdf_dll,"FPDF_GetMetaText")
  Protected LoadPage.protoLoadPage = GetFunction(pdf_dll,"FPDF_LoadPage")
  Protected GetText.protoGetText = GetFunction(pdf_dll,"FPDFText_GetText")
  Protected LoadTextPage.protoLoadTextPage = GetFunction(pdf_dll,"FPDFText_LoadPage")
  Protected CountChars.protoCountChars = GetFunction(pdf_dll,"FPDFText_CountChars")

  Protected     igPdfDoc.i = 0 ;Handle of Loaded PDF File
  Protected    igPageNum.i = 0 ;Current page of current PDF document
  Protected igTotalPages.i = 0
  Protected    igPdfPage.i = 0 ;Handle of Loaded PDF Page
 
  Protected *result
  Protected sTxt.s
  Protected iPdfTextPage.i, iTotalChars.i, iBuffLen.i
  Protected sFullpage.s
  Protected sPart.s

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
 
  igPdfPage = LoadPage(pdf_doc, 0)
  iPdfTextPage = LoadTextPage(igPdfPage)
  iTotalChars = CountChars(iPdfTextPage)
  iBuffLen = (iTotalChars * SizeOf(Character))
  *result = AllocateMemory(iBuffLen)
 
  ret = GetText(iPdfTextPage, 0, 1024, *result)
 
  Debug PeekS(*result, ret/2)
 
  CloseLibrary(#PB_Any)
 
EndProcedure

Main()
; IDE Options = PureBasic 5.62 (Windows - x64)
; CursorPosition = 15
; FirstLine = 7
; Folding = -
; EnableXP
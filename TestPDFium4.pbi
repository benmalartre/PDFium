
Global sgPDF.s = "form.pdf"
Global sgJPG.s = "img.jpg"

Prototype protoGetBlock(param, position, *buf, size)

Structure FPDF_FILEACCESS
  FileLen.i
  *GetBlock.protoGetBlock
  param.i
  pdf_file$
  pdf_handle.i
EndStructure

Procedure GetBlockCallback(*param.FPDF_FILEACCESS,  position, *buf, size)
  
  If *param\pdf_handle = 0
    If FileSize(*param\pdf_file$) > 0
      *param\pdf_handle = ReadFile(#PB_Any,*param\pdf_file$)
    EndIf
  EndIf 
  
  If *param\pdf_handle
    FileSeek(*param\pdf_handle, position)
    ReadData(*param\pdf_handle, *buf, size)
    ProcedureReturn #True
  EndIf   
  
    ProcedureReturn #False   
  
EndProcedure  

Procedure Create_FPDF_FILEACCESS(file$) 
  
  Protected *this.FPDF_FILEACCESS = AllocateStructure(FPDF_FILEACCESS)
  
  *this\FileLen = FileSize(file$)
  *this\GetBlock = @GetBlockCallback()
  *this\param = *this
  *this\pdf_file$ = file$
  
  ProcedureReturn *this
  
EndProcedure

Global *FPDF_FILEACCESS.FPDF_FILEACCESS= Create_FPDF_FILEACCESS(sgJPG)


Prototype protoInitLibrary()
Prototype protoLoadDocument(documentpath.p-utf8, password.p-utf8)
Prototype jpgObject(pages, count, imgObject, fileObject)
Prototype protoGetPageCount(document)
Prototype protoRenderPage(hDC, page, start_x, start_y, size_x, size_y, rotate, flags)
Prototype protoLoadPage(document, page_index)                                        
Prototype protoGetMediaBox(page, left, bottom, right, top)
Prototype protoInsertObject(pdfObject, newObject, insertAfter)
Prototype protoCloseDocument(document)
Prototype protoClosePage(page) 

Procedure Main(*win)
  
  CanvasGadget(0, 0, 0, 800, 600)
  
  Protected pdf_dll =OpenLibrary(#PB_Any, "pdfium.dll")
  
  Protected InitLibrary.protoInitLibrary = GetFunction(pdf_dll,"FPDF_InitLibrary")
  Protected GetPageCount.protoGetPageCount = GetFunction(pdf_dll,"FPDF_GetPageCount")
  Protected LoadDocument.protoLoadDocument = GetFunction(pdf_dll,"FPDF_LoadDocument")
  Protected InsertObject.protoInsertObject = GetFunction(pdf_dll,"FPDFPage_InsertObject")
  Protected RenderPage.protoRenderPage = GetFunction(pdf_dll,"FPDF_RenderPage")
  Protected LoadPage.protoLoadPage = GetFunction(pdf_dll,"FPDF_LoadPage")
  Protected GetMediaBox.protoGetMediaBox = GetFunction(pdf_dll,"FPDFPage_GetMediaBox")
  Protected CloseDocument.protoCloseDocument = GetFunction(pdf_dll,"FPDF_CloseDocument")
  Protected ClosePage.protoClosePage = GetFunction(pdf_dll,"FPDF_ClosePage")
  
  Protected ImageObj_LoadJpegFile.jpgObject = GetFunction(pdf_dll,"FPDFImageObj_LoadJpegFile")
  
  InitLibrary()
  Protected pdf_doc = LoadDocument(sgPDF, "")
  Protected pdf_page = LoadPage(pdf_doc, 0)
  Protected hJPG = ImageObj_LoadJpegFile(0, 0, *newObject, *FPDF_FILEACCESS)
  InsertObject(pdf_doc, hJPG, 0)
  
  hDC = StartDrawing(CanvasOutput(0))
    RenderPage(hDC, pdf_page, 0, 0, 800, 600, 0, $100);
  StopDrawing()  

  Repeat
  Until WaitWindowEvent() = #PB_Event_CloseWindow
  
  ClosePage(pdf_page)
  CloseDocument(pdf_doc)   
  CloseLibrary(pdf_dll)
  
EndProcedure

Define iFlags.i = #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_ScreenCentered | #PB_Window_SizeGadget
Main(OpenWindow(#PB_Any, 0, 0, 800, 600, "Pdfium", iFlags))
; IDE Options = PureBasic 5.62 (Windows - x64)
; CursorPosition = 81
; FirstLine = 42
; Folding = -
; EnableXP
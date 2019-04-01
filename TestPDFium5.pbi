XIncludeFile "PDFium.pbi"


Structure TextObject
  text.s
  font_size.f
  posx.f
  posy.f
EndStructure

Global pdf_dll         
Global pdf_doc        
Global page_handle 
Global text_handle
    
Global ret            
Global pages        
Global version.l    
Global width.d    
Global height.d     
Global ratio.d
Global img           
Global hdc           


PDFIum::Init()

width = 720
height = 1024

; create new document
pdf_doc.i = PDFium::CreateNewDocument()
Debug PDFium::NewPage
page_handle = PDFium::NewPage(pdf_doc, 0 , width, height)


For i=0 To 12
  text_handle = PDFium::NewTextObject(pdf_doc, "Arial", 12.0)
  Debug "CREATE TEXT : "+Str(text_handle)
  If text_handle
    PDFium::SetText(text_handle, "this is bullshit")
  EndIf
  
  matrix = PDFium::GetMatrix(text_handle)

  PDFium::Transform(text_handle,1,0,0,1,20,20 * i)
  PDFium::PageInsertObject(page_handle, text_handle)
Next

; PDFium::PageGenerateContent(page_handle)

; // Add some text To the page
; +  FPDF_PAGEOBJECT text1 = FPDFPageObj_NewTextObj(doc, "Arial", 12.0f);
; +  EXPECT_TRUE(text1);
; +  EXPECT_TRUE(FPDFText_SetText(text1, "I'm at the bottom of the page"));
; +  FPDFPageObj_Transform(text1, 1, 0, 0, 1, 20, 20);
; +  FPDFPage_InsertObject(page, text1);
Define num_objects = PDFium::GetNumPageObjects(page_handle)
; Define object_handle, i
; For i=0 To num_objects - 1
;   object_handle = PDFium::GetPageObject(page_handle, i)
;   Debug object_handle
;   matrix = PDFium::GetMatrix(object_handle)
;   Debug matrix
; ;   Debug "Object : "+Str(object_handle)
; Next


Define window = OpenWindow(#PB_Any, 0,0,width+100, height + 100, "PDFium")
Define canvas = CanvasGadget(#PB_Any, 0, 0, WindowWidth(window, #PB_Window_InnerCoordinate), WindowHeight(window, #PB_Window_InnerCoordinate))


; ...create image
img = CreateImage(#PB_Any, width, height, 24, RGBA(255,255,255,0))
hdc = StartDrawing(ImageOutput(img))
; ...render page to image
ret = PDFium::RenderPage(hdc, page_handle, 0, 0, width, height, 0, 0)
StopDrawing()

; StartDrawing(CanvasOutput(canvas))
; DrawingMode(#PB_2DDrawing_AllChannels)
; DrawImage(ImageID(img), 0,0)
; StopDrawing()
StartVectorDrawing(CanvasVectorOutput(canvas))
AddPathBox(0,0,width, height)
VectorSourceColor(RGBA(128,128,128,255))
FillPath()

; MovePathCursor(0,0)
DrawVectorImage(ImageID(img),255, GadgetWidth(canvas), GadgetHeight(canvas))
StopVectorDrawing()


; ... saving image
; SaveImage(img, "test.bmp", #PB_ImagePlugin_BMP)

PDFium::ClosePage(page_handle)
PDFium::CloseDocument(pdf_doc)

Repeat
  e = WaitWindowEvent()
Until e = #PB_Event_CloseWindow

; PDFium::CloseLibrary(#PB_Any)



; IDE Options = PureBasic 5.62 (Windows - x64)
; CursorPosition = 49
; FirstLine = 19
; EnableXP
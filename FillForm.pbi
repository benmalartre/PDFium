XIncludeFile "PDFium.pbi"

Global font_id

Structure TextObject_t
  text.s
  font.i
  font_size.f
  font_color.i
  posx.f
  posy.f
EndStructure

Structure Form_t
  file_in.s
  file_out.s
  img.i
  hdc.i
  width.i
  height.i
  offsetx.f
  offsety.f
  document.i
  page.i
  List text.TextObject_t()
EndStructure

Procedure AddText(*form.Form_t, text.s, x.f, y.f, font_size.f=12)
  AddElement(*form\text())
  *form\text()\text = text
  *form\text()\font_size = font_size
  *form\text()\posx = x
  *form\text()\posy = y
  *form\text()\font_color = RGBA(Random(255),Random(255), Random(255), 255)
  *form\text()\font = font_id
  ProcedureReturn *form\text()
EndProcedure

Procedure Pick(canvas, *form.Form_t)
  Define mx = GetGadgetAttribute(canvas, #PB_Canvas_MouseX)
  Define my = GetGadgetAttribute(canvas, #PB_Canvas_MouseY)
  
  StartVectorDrawing(CanvasVectorOutput(canvas))
  
  StopVectorDrawing()
  
EndProcedure


Procedure Draw(canvas, *form.Form_t)
  ForEach *form\text()
    Debug *form\text()\posx
    Debug *form\text()\posy
    VectorFont(FontID(*form\text()\font), *form\text()\font_size)
    VectorSourceColor(*form\text()\font_color)
    MovePathCursor(*form\text()\posx, *form\text()\posy)
    AddPathText(*form\text()\text)
    FillPath()
  Next
 
EndProcedure


PDFIum::Init()

font_id = LoadFont(#PB_Any, "Arial", 24)
Define form.Form_t
InitializeStructure(form, Form_t)
form\file_in = "form.pdf"
form\file_out = "form_modified.pdf"

form\document = PDFium::LoadDocument(form\file_in, "")


; load page and get size
form\page = PDFium::LoadPage(form\document, 0)
form\height = PDFium::GetPageHeight(form\page)
form\width = PDFium::GetPageWidth(form\page)

Define cl.f, cb.f, cr.f, ct.f
PDFium::GetCropBox(form\page, @cl, @cb, @cr,@ct)

form\offsetx = cl
form\offsety = cb

Define text_handle.i
Define text.s = "this is bullshit"
Define tx.f, ty.f, ts.f
PDFium::StandardFont(form\document, "Arial")
For i=0 To 256
  ts = Random(6)+12
  text_handle = PDFium::NewTextObject(form\document, "Arial", ts)
  If text_handle
    PDFium::SetText(text_handle, PDFium::TranslateText("this is bullshit"))
  EndIf
  tx = Random(form\width)
  ty = Random(form\height)
  matrix = PDFium::GetMatrix(text_handle)
  
  
  PDFium::Transform(text_handle,1,0,0,1,tx,ty)
  PDFium::InsertPageObject(form\page, text_handle)
  
  AddText(form, text, tx-form\offsetx, form\height-ty-(ts-form\offsety), ts)
Next

PDFium::GeneratePageContent(form\page)

Define window = OpenWindow(#PB_Any, 0,0,form\width, form\height, "PDFium")
Define canvas = CanvasGadget(#PB_Any, 0, 0, form\width, form\height)

form\img = CreateImage(#PB_Any, form\width, form\height, 24, RGBA(255,255,255,0))
form\hdc = StartDrawing(ImageOutput(form\img))
; render pdf page to image
PDFium::RenderPage(form\hdc, form\page, 0, 0, form\width, form\height, 0, 0)
StopDrawing()

StartVectorDrawing(CanvasVectorOutput(canvas))
ResetCoordinates()
AddPathBox(0,0,form\width, form\height)
VectorSourceColor(RGBA(128,128,128,255))
FillPath()

MovePathCursor(0,0)
DrawVectorImage(ImageID(form\img),255, GadgetWidth(canvas), GadgetHeight(canvas))
Draw(canvas, form)
StopVectorDrawing()

Define writer = PDFium::NewWriter(form\file_out)
PDFium::SaveAsCopy(form\document, writer,0)
PDFium::DeleteWriter(writer)
; ... saving image
; SaveImage(img, "test.bmp", #PB_ImagePlugin_BMP)

PDFium::ClosePage(form\page)
PDFium::CloseDocument(form\document)

Repeat
  e = WaitWindowEvent()
Until e = #PB_Event_CloseWindow

; PDFium::CloseLibrary(#PB_Any)



; IDE Options = PureBasic 5.62 (Windows - x64)
; CursorPosition = 90
; FirstLine = 56
; Folding = -
; EnableXP
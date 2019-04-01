UseJPEGImageEncoder()

img = CreateImage(#PB_Any, 800,800)
StartDrawing(ImageOutput(img))
For x=0 To 799
  For y=0 To 799
    Plot(x, y, RGB(Random(255), Random(255), Random(255)))
  Next
Next

SaveImage(img, "E:\Projects\RnD\PDFium\img.jpg")
FreeImage(img)
; IDE Options = PureBasic 5.62 (Windows - x64)
; CursorPosition = 11
; EnableXP
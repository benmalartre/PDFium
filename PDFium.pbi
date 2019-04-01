DeclareModule PDFium
  
  ; Structure for custom file write
  Structure FileWrite_t Align #PB_Structure_AlignC
  EndStructure
  
  Prototype PFNNEWWRITER(filename.p-utf8)
  Prototype PFNDELETEWRITER(*writer.FileWrite_t)
  
  Global writer_dll = OpenLibrary(#PB_Any, "writer.dll")
  If writer_dll = 0
    Debug "Error loading writer DLL"
    End
  EndIf
  
  ; library
  Global NewWriter.PFNNEWWRITER         = GetFunction(writer_dll, "NewWriter")
  Global DeleteWriter.PFNDELETEWRITER   = GetFunction(writer_dll, "DeleteWriter")

  Macro ARGB(_a, _r, _g,_b)    
    (((_b)&$FF) | (((_g)&$FF) << 8) | (((_r)&$FF) << 16) | (((_a)&$FF) << 24))
  EndMacro
  
  Macro GetBValue(_argb) : (PeekA(_argb)) : EndMacro
  Macro GetGValue(_argb) : (PeekA(_argb) >> 8) : EndMacro
  Macro GetRValue(_argb) : (PeekA(_argb) >> 16) : EndMacro
  Macro GetAValue(_argb) : (PeekA(_argb) >> 24) : EndMacro


  ; Refer To PDF Reference version 1.7 table 4.12 For all color space families.
  #FPDF_COLORSPACE_UNKNOWN = 0
  #FPDF_COLORSPACE_DEVICEGRAY = 1
  #FPDF_COLORSPACE_DEVICERGB = 2
  #FPDF_COLORSPACE_DEVICECMYK = 3
  #FPDF_COLORSPACE_CALGRAY = 4
  #FPDF_COLORSPACE_CALRGB = 5
  #FPDF_COLORSPACE_LAB = 6
  #FPDF_COLORSPACE_ICCBASED = 7
  #PDF_COLORSPACE_SEPARATION = 8
  #PDF_COLORSPACE_DEVICEN = 9
  #FPDF_COLORSPACE_INDEXED = 10
  #FPDF_COLORSPACE_PATTERN = 11
  
  ; The page object constants.
  #FPDF_PAGEOBJ_UNKNOWN = 0
  #FPDF_PAGEOBJ_TEXT = 1
  #FPDF_PAGEOBJ_PATH = 2
  #FPDF_PAGEOBJ_IMAGE = 3
  #FPDF_PAGEOBJ_SHADING = 4
  #FPDF_PAGEOBJ_FORM = 5
  
  ; The path segment constants.
  #FPDF_SEGMENT_UNKNOWN = -1
  #FPDF_SEGMENT_LINETO = 0
  #FPDF_SEGMENT_BEZIERTO = 1
  #FPDF_SEGMENT_MOVETO = 2
  #FPDF_FILLMODE_NONE = 0
  #FPDF_FILLMODE_ALTERNATE = 1
  #FPDF_FILLMODE_WINDING = 2
  #FPDF_FONT_TYPE1 = 1
  #FPDF_FONT_TRUETYPE = 2
  #FPDF_LINECAP_BUTT = 0
  #FPDF_LINECAP_ROUND = 1
  #FPDF_LINECAP_PROJECTING_SQUARE = 2
  #FPDF_LINEJOIN_MITER = 0
  #FPDF_LINEJOIN_ROUND = 1
  #FPDF_LINEJOIN_BEVEL = 2
  #FPDF_PRINTMODE_EMF = 0
  #FPDF_PRINTMODE_TEXTONLY = 1
  #FPDF_PRINTMODE_POSTSCRIPT2 = 2
  #FPDF_PRINTMODE_POSTSCRIPT3 = 3
  #FPDF_PRINTMODE_POSTSCRIPT2_PASSTHROUGH = 4
  #FPDF_PRINTMODE_POSTSCRIPT3_PASSTHROUGH = 5
  #FPDF_TEXTRENDERMODE_FILL = 0
  #FPDF_TEXTRENDERMODE_STROKE = 1
  #FPDF_TEXTRENDERMODE_FILL_STROKE = 2
  #FPDF_TEXTRENDERMODE_INVISIBLE = 3
  #FPDF_TEXTRENDERMODE_FILL_CLIP = 4
  #FPDF_TEXTRENDERMODE_STROKE_CLIP = 5
  #FPDF_TEXTRENDERMODE_FILL_STROKE_CLIP = 6
  #FPDF_TEXTRENDERMODE_CLIP = 7
  
  Structure ImageMetada_t
    width.l
    height.l
  
    horizontal_dpi.f
    vertical_dpi.f
    bits_per_pixel.l
    colorspace.l
  
    marked_content_id.l
  EndStructure

  Prototype PFNINITLIBRARY()
  
  ; document
  Prototype PFNCREATENEWDOCUMENT()
  Prototype PFNLOADDOCUMENT(documentpath.p-ascii,password.p-utf8)
  Prototype PFNCLOSEDOCUMENT(document)
  Prototype PFNSAVEASCOPY(document.i, *writer.FileWrite_t, flag.i)
  Prototype PFNSAVEWITHVERSION(document.i, *writer.FileWrite_t, flag.i, version.i)

  Prototype PFNGETMETATEXT(document, tag.p-utf8, buffer, buflen)
  Prototype PFNGETFILEVERSION(document, *version)
  Prototype PFNGETPAGECOUNT(document)
  Prototype PFNFONT(document.i, name.p-ascii)
  Prototype PFNSTANDARDFONT(document.i, name.p-ascii)
  
  ; page
  Prototype PFNNEWPAGE(document.i, index.i, width.d, height.d)
  Prototype PFNDELETEPAGE(document.i, index.i)
  Prototype PFNLOADPAGE(document, pageindex.l)
  Prototype PFNCLOSEPAGE(page.i)
  Prototype.d PFNGETPAGEHEIGHT(page.i)
  Prototype.d PFNGETPAGEWIDTH(page.i)
  Prototype PFNGETCROPBOX(page.i, *left, *bottom, *right, *top)
  Prototype PFNSETCROPBOX(page.i, left.f, bottom.f, right.f, top.f)
  Prototype PFNGETPAGEROTATION(page.i)
  Prototype PFNSETPAGEROTATION(page.i, rotation.i)
  Prototype PFNINSERTPAGEOBJECT(page.i, obj.i)
  Prototype PFNREMOVEPAGEOBJECT(page.i, obj.i)
  Prototype PFNCOUNTPAGEOBJECTS(page.i)
  Prototype PFNGETPAGEOBJECT(page.i, index.i)
  Prototype PFNHASPAGETRANSPARENCY(page.i)
  Prototype PFNGENERATEPAGECONTENT(page.i)
  
  ; object
  Prototype PFNDESTROYOBJECT(obj.i)
  Prototype PFNHASOBJECTTRANSPARENCY(obj.i)
  Prototype PGNGETOBJECTTYPE(obj.i)
  Prototype PFNGETFILLCOLOR(obj.i)
  Prototype PFNGETSTROKECOLOR(obj.i)
  Prototype PFNSETFILLCOLOR(obj.i, color.i)
  Prototype PFNSETSTROKECOLOR(obj.i, color.i)
  
  Prototype PFNNEWTEXTOBJECT(document.i, text.p-utf8, font_size.f)
  Prototype PFNSETTEXT(obj.i, *text)
  
  ; TO IMPLEMENT
  
  Prototype PFNNEWIMAGEOBJECT(document.i)
  
  Prototype PFNCOUNTMARKS(obj.i)
  Prototype PFNGETMARK(obj.i, index.i)
  Prototype PFNADDMARK(obj.i, name.p-ascii)
  Prototype PFNREMOVEMARK(obj.i, mark.i)
  Prototype PFNGETMARKNAME(mark.i, *buffer, len.i)
  
  Prototype PFNTRANSFORMANNOTS(page.i, a.d, b.d, c.d, d.d, e.d, f.d)
  ; END TO IMPELMENT
  Prototype PFNGETMATRIX(obj.i)
  Prototype PFNSETMATRIX(obj.i)
  Prototype PFNTRANSFORM(obj.i, a.d, b.d, c.d, d.d, e.d, f.d)
  
  Prototype PFNRENDERPAGE(hdc, page, start_x.l, start_y.l, size_x.l, size_y.l, rotate.l, flags.l)
  
  
;   
; 
; 
;  
; 
; // Experimental API.
; // Get the number of key/value pair parameters in |mark|.
; //
; //   mark   - handle To a content mark.
; //
; // Returns the number of key/value pair parameters |mark|, Or -1 in Case of
; // failure.
; FPDF_EXPORT int FPDF_CALLCONV
; FPDFPageObjMark_CountParams(FPDF_PAGEOBJECTMARK mark);
; // Experimental API.
; // Get the key of a property in a content mark. |buffer| is only modified If
; // |buflen| is longer than the length of the key.
; //
; //   mark   - handle To a content mark.
; //   index  - index of the property.
; //   buffer - buffer For holding the returned key in UTF16-LE.
; //   buflen - length of the buffer.
; //
; // Returns the length of the key.
; FPDF_EXPORT unsigned long FPDF_CALLCONV
; FPDFPageObjMark_GetParamKey(FPDF_PAGEOBJECTMARK mark,
;                             unsigned long index,
;                             void* buffer,
;                             unsigned long buflen);
; // Experimental API.
; // Get the type of the value of a property in a content mark by key.
; //
; //   mark   - handle To a content mark.
; //   key    - string key of the property.
; //
; // Returns the type of the value, Or FPDF_OBJECT_UNKNOWN in Case of failure.
; FPDF_EXPORT FPDF_OBJECT_TYPE FPDF_CALLCONV
; FPDFPageObjMark_GetParamValueType(FPDF_PAGEOBJECTMARK mark,
;                                   FPDF_BYTESTRING key);
; // Experimental API.
; // Get the value of a number property in a content mark by key As int.
; // FPDFPageObjMark_GetParamValueType() should have returned FPDF_OBJECT_NUMBER
; // For this property.
; //
; //   mark      - handle To a content mark.
; //   key       - string key of the property.
; //   out_value - pointer To variable that will receive the value. Not filled If
; //               false is returned.
; //
; // Returns TRUE If the key maps To a number value, FALSE otherwise.
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV
; FPDFPageObjMark_GetParamIntValue(FPDF_PAGEOBJECTMARK mark,
;                                  FPDF_BYTESTRING key,
;                                  int* out_value);
; // Experimental API.
; // Get the value of a string property in a content mark by key.
; // |buffer| is only modified If |buflen| is longer than the length of the value.
; //
; //   mark       - handle To a content mark.
; //   key        - string key of the property.
; //   buffer     - buffer For holding the returned value in UTF16-LE.
; //   buflen     - length of the buffer.
; //   out_buflen - pointer To variable that will receive the length of the value.
; //                Not filled If false is returned.
; //
; // Returns TRUE If the key maps To a string/blob value, FALSE otherwise.
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV
; FPDFPageObjMark_GetParamStringValue(FPDF_PAGEOBJECTMARK mark,
;                                     FPDF_BYTESTRING key,
;                                     void* buffer,
;                                     unsigned long buflen,
;                                     unsigned long* out_buflen);
; // Experimental API.
; // Get the value of a blob property in a content mark by key.
; // |buffer| is only modified If |buflen| is longer than Or equal To the length
; // of the value.
; //
; //   mark       - handle To a content mark.
; //   key        - string key of the property.
; //   buffer     - buffer For holding the returned value.
; //   buflen     - length of the buffer.
; //   out_buflen - pointer To variable that will receive the length of the value.
; //                Not filled If false is returned.
; //
; // Returns TRUE If the key maps To a string/blob value, FALSE otherwise.
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV
; FPDFPageObjMark_GetParamBlobValue(FPDF_PAGEOBJECTMARK mark,
;                                   FPDF_BYTESTRING key,
;                                   void* buffer,
;                                   unsigned long buflen,
;                                   unsigned long* out_buflen);
; // Experimental API.
; // Set the value of an int property in a content mark by key. If a parameter
; // With key |key| exists, its value is set To |value|. Otherwise, it is added As
; // a new parameter.
; //
; //   document    - handle To the document.
; //   page_object - handle To the page object With the mark.
; //   mark        - handle To a content mark.
; //   key         - string key of the property.
; //   value       - int value To set.
; //
; // Returns TRUE If the operation succeeded, FALSE otherwise.
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV
; FPDFPageObjMark_SetIntParam(FPDF_DOCUMENT document,
;                             FPDF_PAGEOBJECT page_object,
;                             FPDF_PAGEOBJECTMARK mark,
;                             FPDF_BYTESTRING key,
;                             int value);
; // Experimental API.
; // Set the value of a string property in a content mark by key. If a parameter
; // With key |key| exists, its value is set To |value|. Otherwise, it is added As
; // a new parameter.
; //
; //   document    - handle To the document.
; //   page_object - handle To the page object With the mark.
; //   mark        - handle To a content mark.
; //   key         - string key of the property.
; //   value       - string value To set.
; //
; // Returns TRUE If the operation succeeded, FALSE otherwise.
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV
; FPDFPageObjMark_SetStringParam(FPDF_DOCUMENT document,
;                                FPDF_PAGEOBJECT page_object,
;                                FPDF_PAGEOBJECTMARK mark,
;                                FPDF_BYTESTRING key,
;                                FPDF_BYTESTRING value);
; // Experimental API.
; // Set the value of a blob property in a content mark by key. If a parameter
; // With key |key| exists, its value is set To |value|. Otherwise, it is added As
; // a new parameter.
; //
; //   document    - handle To the document.
; //   page_object - handle To the page object With the mark.
; //   mark        - handle To a content mark.
; //   key         - string key of the property.
; //   value       - pointer To blob value To set.
; //   value_len   - size in bytes of |value|.
; //
; // Returns TRUE If the operation succeeded, FALSE otherwise.
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV
; FPDFPageObjMark_SetBlobParam(FPDF_DOCUMENT document,
;                              FPDF_PAGEOBJECT page_object,
;                              FPDF_PAGEOBJECTMARK mark,
;                              FPDF_BYTESTRING key,
;                              void* value,
;                              unsigned long value_len);
; // Experimental API.
; // Removes a property from a content mark by key.
; //
; //   page_object - handle To the page object With the mark.
; //   mark        - handle To a content mark.
; //   key         - string key of the property.
; //
; // Returns TRUE If the operation succeeded, FALSE otherwise.
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV
; FPDFPageObjMark_RemoveParam(FPDF_PAGEOBJECT page_object,
;                             FPDF_PAGEOBJECTMARK mark,
;                             FPDF_BYTESTRING key);
; // Load an image from a JPEG image file And then set it into |image_object|.
; //
; //   pages        - pointer To the start of all loaded pages, may be NULL.
; //   nCount       - number of |pages|, may be 0.
; //   image_object - handle To an image object.
; //   fileAccess   - file access handler which specifies the JPEG image file.
; //
; // Returns TRUE on success.
; //
; // The image object might already have an associated image, which is Shared And
; // cached by the loaded pages. In that Case, we need To clear the cached image
; // For all the loaded pages. Pass |pages| And page count (|nCount|) To this API
; // To clear the image cache. If the image is Not previously Shared, Or NULL is a
; // valid |pages| value.
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV
; FPDFImageObj_LoadJpegFile(FPDF_PAGE* pages,
;                           int nCount,
;                           FPDF_PAGEOBJECT image_object,
;                           FPDF_FILEACCESS* fileAccess);
; // Load an image from a JPEG image file And then set it into |image_object|.
; //
; //   pages        - pointer To the start of all loaded pages, may be NULL.
; //   nCount       - number of |pages|, may be 0.
; //   image_object - handle To an image object.
; //   fileAccess   - file access handler which specifies the JPEG image file.
; //
; // Returns TRUE on success.
; //
; // The image object might already have an associated image, which is Shared And
; // cached by the loaded pages. In that Case, we need To clear the cached image
; // For all the loaded pages. Pass |pages| And page count (|nCount|) To this API
; // To clear the image cache. If the image is Not previously Shared, Or NULL is a
; // valid |pages| value. This function loads the JPEG image inline, so the image
; // content is copied To the file. This allows |fileAccess| And its associated
; // Data To be deleted after this function returns.
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV
; FPDFImageObj_LoadJpegFileInline(FPDF_PAGE* pages,
;                                 int nCount,
;                                 FPDF_PAGEOBJECT image_object,
;                                 FPDF_FILEACCESS* fileAccess);
; // Set the transform matrix of |image_object|.
; //
; //   image_object - handle To an image object.
; //   a            - matrix value.
; //   b            - matrix value.
; //   c            - matrix value.
; //   d            - matrix value.
; //   e            - matrix value.
; //   f            - matrix value.
; //
; // The matrix is composed As:
; //   |a c e|
; //   |b d f|
; // And can be used To scale, rotate, shear And translate the |page| annotations.
; //
; // Returns TRUE on success.
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV
; FPDFImageObj_SetMatrix(FPDF_PAGEOBJECT image_object,
;                        double a,
;                        double b,
;                        double c,
;                        double d,
;                        double e,
;                        double f);
; // Set |bitmap| To |image_object|.
; //
; //   pages        - pointer To the start of all loaded pages, may be NULL.
; //   nCount       - number of |pages|, may be 0.
; //   image_object - handle To an image object.
; //   bitmap       - handle of the bitmap.
; //
; // Returns TRUE on success.
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV
; FPDFImageObj_SetBitmap(FPDF_PAGE* pages,
;                        int nCount,
;                        FPDF_PAGEOBJECT image_object,
;                        FPDF_BITMAP bitmap);
; // Get a bitmap rasterisation of |image_object|. The returned bitmap will be
; // owned by the caller, And FPDFBitmap_Destroy() must be called on the returned
; // bitmap when it is no longer needed.
; //
; //   image_object - handle To an image object.
; //
; // Returns the bitmap.
; FPDF_EXPORT FPDF_BITMAP FPDF_CALLCONV
; FPDFImageObj_GetBitmap(FPDF_PAGEOBJECT image_object);
; // Get the decoded image Data of |image_object|. The decoded Data is the
; // uncompressed image Data, i.e. the raw image Data after having all filters
; // applied. |buffer| is only modified If |buflen| is longer than the length of
; // the decoded image Data.
; //
; //   image_object - handle To an image object.
; //   buffer       - buffer For holding the decoded image Data in raw bytes.
; //   buflen       - length of the buffer.
; //
; // Returns the length of the decoded image Data.
; FPDF_EXPORT unsigned long FPDF_CALLCONV
; FPDFImageObj_GetImageDataDecoded(FPDF_PAGEOBJECT image_object,
;                                  void* buffer,
;                                  unsigned long buflen);
; // Get the raw image Data of |image_object|. The raw Data is the image Data As
; // stored in the PDF without applying any filters. |buffer| is only modified If
; // |buflen| is longer than the length of the raw image Data.
; //
; //   image_object - handle To an image object.
; //   buffer       - buffer For holding the raw image Data in raw bytes.
; //   buflen       - length of the buffer.
; //
; // Returns the length of the raw image Data.
; FPDF_EXPORT unsigned long FPDF_CALLCONV
; FPDFImageObj_GetImageDataRaw(FPDF_PAGEOBJECT image_object,
;                              void* buffer,
;                              unsigned long buflen);
; // Get the number of filters (i.e. decoders) of the image in |image_object|.
; //
; //   image_object - handle To an image object.
; //
; // Returns the number of |image_object|'s filters.
; FPDF_EXPORT int FPDF_CALLCONV
; FPDFImageObj_GetImageFilterCount(FPDF_PAGEOBJECT image_object);
; // Get the filter at |index| of |image_object|'s list of filters. Note that the
; // filters need To be applied in order, i.e. the first filter should be applied
; // first, then the second, etc. |buffer| is only modified If |buflen| is longer
; // than the length of the filter string.
; //
; //   image_object - handle To an image object.
; //   index        - the index of the filter requested.
; //   buffer       - buffer For holding filter string, encoded in UTF-8.
; //   buflen       - length of the buffer.
; //
; // Returns the length of the filter string.
; FPDF_EXPORT unsigned long FPDF_CALLCONV
; FPDFImageObj_GetImageFilter(FPDF_PAGEOBJECT image_object,
;                             int index,
;                             void* buffer,
;                             unsigned long buflen);
; // Get the image metadata of |image_object|, including dimension, DPI, bits per
; // pixel, And colorspace. If the |image_object| is Not an image object Or If it
; // does Not have an image, then the Return value will be false. Otherwise,
; // failure To retrieve any specific parameter would result in its value being 0.
; //
; //   image_object - handle To an image object.
; //   page         - handle To the page that |image_object| is on. Required For
; //                  retrieving the image's bits per pixel and colorspace.
; //   metadata     - receives the image metadata; must not be NULL.
; //
; // Returns true If successful.
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV
; FPDFImageObj_GetImageMetadata(FPDF_PAGEOBJECT image_object,
;                               FPDF_PAGE page,
;                               FPDF_IMAGEOBJ_METADATA* metadata);
; // Create a new path object at an initial position.
; //
; //   x - initial horizontal position.
; //   y - initial vertical position.
; //
; // Returns a handle To a new path object.
; FPDF_EXPORT FPDF_PAGEOBJECT FPDF_CALLCONV FPDFPageObj_CreateNewPath(float x,
;                                                                     float y);
; // Create a closed path consisting of a rectangle.
; //
; //   x - horizontal position For the left boundary of the rectangle.
; //   y - vertical position For the bottom boundary of the rectangle.
; //   w - width of the rectangle.
; //   h - height of the rectangle.
; //
; // Returns a handle To the new path object.
; FPDF_EXPORT FPDF_PAGEOBJECT FPDF_CALLCONV FPDFPageObj_CreateNewRect(float x,
;                                                                     float y,
;                                                                     float w,
;                                                                     float h);
; // Get the bounding box of |page_object|.
; //
; // page_object  - handle To a page object.
; // left         - pointer where the left coordinate will be stored
; // bottom       - pointer where the bottom coordinate will be stored
; // right        - pointer where the right coordinate will be stored
; // top          - pointer where the top coordinate will be stored
; //
; // Returns TRUE on success.
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV
; FPDFPageObj_GetBounds(FPDF_PAGEOBJECT page_object,
;                       float* left,
;                       float* bottom,
;                       float* right,
;                       float* top);
; // Set the blend mode of |page_object|.
; //
; // page_object  - handle To a page object.
; // blend_mode   - string containing the blend mode.
; //
; // Blend mode can be one of following: Color, ColorBurn, ColorDodge, Darken,
; // Difference, Exclusion, HardLight, Hue, Lighten, Luminosity, Multiply, Normal,
; // Overlay, Saturation, Screen, SoftLight
; FPDF_EXPORT void FPDF_CALLCONV
; FPDFPageObj_SetBlendMode(FPDF_PAGEOBJECT page_object,
;                          FPDF_BYTESTRING blend_mode);
; // DEPRECATED As of May 2018. This API will be removed in the future. Please
; // use FPDFPageObj_SetStrokeColor instead.
; //
; // Set the stroke RGBA of a path. Range of values: 0 - 255.
; //
; // path   - the handle To the path object.
; // R      - the red component For the path stroke color.
; // G      - the green component For the path stroke color.
; // B      - the blue component For the path stroke color.
; // A      - the stroke alpha For the path.
; //
; // Returns TRUE on success.
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV
; FPDFPath_SetStrokeColor(FPDF_PAGEOBJECT path,
;                         unsigned int R,
;                         unsigned int G,
;                         unsigned int B,
;                         unsigned int A);
; // Set the stroke RGBA of a page object. Range of values: 0 - 255.
; //
; // page_object  - the handle To the page object.
; // R            - the red component For the object's stroke color.
; // G            - the green component For the object's stroke color.
; // B            - the blue component For the object's stroke color.
; // A            - the stroke alpha For the object.
; //
; // Returns TRUE on success.
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV
; FPDFPageObj_SetStrokeColor(FPDF_PAGEOBJECT page_object,
;                            unsigned int R,
;                            unsigned int G,
;                            unsigned int B,
;                            unsigned int A);
; // DEPRECATED As of May 2018. This API will be removed in the future. Please
; // use FPDFPageObj_GetStrokeColor instead. Get the stroke RGBA of a path.
; //
; // Get the stroke RGBA of a path. Range of values: 0 - 255.
; //
; // path   - the handle To the path object.
; // R      - the red component of the path stroke color.
; // G      - the green component of the path stroke color.
; // B      - the blue component of the path stroke color.
; // A      - the stroke alpha of the path.
; //
; // Returns TRUE on success.
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV
; FPDFPath_GetStrokeColor(FPDF_PAGEOBJECT path,
;                         unsigned int* R,
;                         unsigned int* G,
;                         unsigned int* B,
;                         unsigned int* A);
; // Get the stroke RGBA of a page object. Range of values: 0 - 255.
; //
; // page_object  - the handle To the page object.
; // R            - the red component of the path stroke color.
; // G            - the green component of the object's stroke color.
; // B            - the blue component of the object's stroke color.
; // A            - the stroke alpha of the object.
; //
; // Returns TRUE on success.
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV
; FPDFPageObj_GetStrokeColor(FPDF_PAGEOBJECT page_object,
;                            unsigned int* R,
;                            unsigned int* G,
;                            unsigned int* B,
;                            unsigned int* A);
; // DEPRECATED As of May 2018. This API will be removed in the future. Please
; // use FPDFPageObj_SetStrokeWidth instead.
; //
; // Set the stroke width of a path.
; //
; // path   - the handle To the path object.
; // width  - the width of the stroke.
; //
; // Returns TRUE on success
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV
; FPDFPath_SetStrokeWidth(FPDF_PAGEOBJECT path, float width);
; // Set the stroke width of a page object.
; //
; // path   - the handle To the page object.
; // width  - the width of the stroke.
; //
; // Returns TRUE on success
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV
; FPDFPageObj_SetStrokeWidth(FPDF_PAGEOBJECT page_object, float width);
; // Experimental API.
; // Get the stroke width of a page object.
; //
; // path   - the handle To the page object.
; // width  - the width of the stroke.
; //
; // Returns TRUE on success
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV
; FPDFPageObj_GetStrokeWidth(FPDF_PAGEOBJECT page_object, float* width);
; // DEPRECATED As of May 2018. This API will be removed in the future. Please
; // use FPDFPageObj_SetLineJoin instead.
; //
; // Set the line join of |page_object|.
; //
; // page_object  - handle To a page object.
; // line_join    - line join
; //
; // Line join can be one of following: FPDF_LINEJOIN_MITER, FPDF_LINEJOIN_ROUND,
; // FPDF_LINEJOIN_BEVEL
; FPDF_EXPORT void FPDF_CALLCONV FPDFPath_SetLineJoin(FPDF_PAGEOBJECT page_object,
;                                                     int line_join);
; // Set the line join of |page_object|.
; //
; // page_object  - handle To a page object.
; // line_join    - line join
; //
; // Line join can be one of following: FPDF_LINEJOIN_MITER, FPDF_LINEJOIN_ROUND,
; // FPDF_LINEJOIN_BEVEL
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV
; FPDFPageObj_SetLineJoin(FPDF_PAGEOBJECT page_object, int line_join);
; // DEPRECATED As of May 2018. This API will be removed in the future. Please
; // use FPDFPageObj_SetLineCap instead.
; //
; // Set the line cap of |page_object|.
; //
; // page_object - handle To a page object.
; // line_cap    - line cap
; //
; // Line cap can be one of following: FPDF_LINECAP_BUTT, FPDF_LINECAP_ROUND,
; // FPDF_LINECAP_PROJECTING_SQUARE
; FPDF_EXPORT void FPDF_CALLCONV FPDFPath_SetLineCap(FPDF_PAGEOBJECT page_object,
;                                                    int line_cap);
; // Set the line cap of |page_object|.
; //
; // page_object - handle To a page object.
; // line_cap    - line cap
; //
; // Line cap can be one of following: FPDF_LINECAP_BUTT, FPDF_LINECAP_ROUND,
; // FPDF_LINECAP_PROJECTING_SQUARE
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV
; FPDFPageObj_SetLineCap(FPDF_PAGEOBJECT page_object, int line_cap);
; // DEPRECATED As of May 2018. This API will be removed in the future. Please
; // use FPDFPageObj_SetFillColor instead.
; //
; // Set the fill RGBA of a path. Range of values: 0 - 255.
; //
; // path   - the handle To the path object.
; // R      - the red component For the path fill color.
; // G      - the green component For the path fill color.
; // B      - the blue component For the path fill color.
; // A      - the fill alpha For the path.
; //
; // Returns TRUE on success.
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV FPDFPath_SetFillColor(FPDF_PAGEOBJECT path,
;                                                           unsigned int R,
;                                                           unsigned int G,
;                                                           unsigned int B,
;                                                           unsigned int A);
; // Set the fill RGBA of a page object. Range of values: 0 - 255.
; //
; // page_object  - the handle To the page object.
; // R            - the red component For the object's fill color.
; // G            - the green component For the object's fill color.
; // B            - the blue component For the object's fill color.
; // A            - the fill alpha For the object.
; //
; // Returns TRUE on success.
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV
; FPDFPageObj_SetFillColor(FPDF_PAGEOBJECT page_object,
;                          unsigned int R,
;                          unsigned int G,
;                          unsigned int B,
;                          unsigned int A);
; // DEPRECATED As of May 2018. This API will be removed in the future. Please
; // use FPDFPageObj_GetFillColor instead.
; //
; // Get the fill RGBA of a path. Range of values: 0 - 255.
; //
; // path   - the handle To the path object.
; // R      - the red component of the path fill color.
; // G      - the green component of the path fill color.
; // B      - the blue component of the path fill color.
; // A      - the fill alpha of the path.
; //
; // Returns TRUE on success.
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV FPDFPath_GetFillColor(FPDF_PAGEOBJECT path,
;                                                           unsigned int* R,
;                                                           unsigned int* G,
;                                                           unsigned int* B,
;                                                           unsigned int* A);
; // Get the fill RGBA of a page object. Range of values: 0 - 255.
; //
; // page_object  - the handle To the page object.
; // R            - the red component of the object's fill color.
; // G            - the green component of the object's fill color.
; // B            - the blue component of the object's fill color.
; // A            - the fill alpha of the object.
; //
; // Returns TRUE on success.
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV
; FPDFPageObj_GetFillColor(FPDF_PAGEOBJECT page_object,
;                          unsigned int* R,
;                          unsigned int* G,
;                          unsigned int* B,
;                          unsigned int* A);
; // Experimental API.
; // Get number of segments inside |path|.
; //
; //   path - handle To a path.
; //
; // A segment is a command, created by e.g. FPDFPath_MoveTo(),
; // FPDFPath_LineTo() Or FPDFPath_BezierTo().
; //
; // Returns the number of objects in |path| Or -1 on failure.
; FPDF_EXPORT int FPDF_CALLCONV FPDFPath_CountSegments(FPDF_PAGEOBJECT path);
; // Experimental API.
; // Get segment in |path| at |index|.
; //
; //   path  - handle To a path.
; //   index - the index of a segment.
; //
; // Returns the handle To the segment, Or NULL on faiure.
; FPDF_EXPORT FPDF_PATHSEGMENT FPDF_CALLCONV
; FPDFPath_GetPathSegment(FPDF_PAGEOBJECT path, int index);
; // Experimental API.
; // Get coordinates of |segment|.
; //
; //   segment  - handle To a segment.
; //   x      - the horizontal position of the segment.
; //   y      - the vertical position of the segment.
; //
; // Returns TRUE on success, otherwise |x| And |y| is Not set.
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV
; FPDFPathSegment_GetPoint(FPDF_PATHSEGMENT segment, float* x, float* y);
; // Experimental API.
; // Get type of |segment|.
; //
; //   segment - handle To a segment.
; //
; // Returns one of the FPDF_SEGMENT_* values on success,
; // FPDF_SEGMENT_UNKNOWN on error.
; FPDF_EXPORT int FPDF_CALLCONV FPDFPathSegment_GetType(FPDF_PATHSEGMENT segment);
; // Experimental API.
; // Gets If the |segment| closes the current subpath of a given path.
; //
; //   segment - handle To a segment.
; //
; // Returns close flag For non-NULL segment, FALSE otherwise.
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV
; FPDFPathSegment_GetClose(FPDF_PATHSEGMENT segment);
; // Move a path's current point.
; //
; // path   - the handle To the path object.
; // x      - the horizontal position of the new current point.
; // y      - the vertical position of the new current point.
; //
; // Note that no line will be created between the previous current point And the
; // new one.
; //
; // Returns TRUE on success
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV FPDFPath_MoveTo(FPDF_PAGEOBJECT path,
;                                                     float x,
;                                                     float y);
; // Add a line between the current point And a new point in the path.
; //
; // path   - the handle To the path object.
; // x      - the horizontal position of the new point.
; // y      - the vertical position of the new point.
; //
; // The path's current point is changed to (x, y).
; //
; // Returns TRUE on success
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV FPDFPath_LineTo(FPDF_PAGEOBJECT path,
;                                                     float x,
;                                                     float y);
; // Add a cubic Bezier curve To the given path, starting at the current point.
; //
; // path   - the handle To the path object.
; // x1     - the horizontal position of the first Bezier control point.
; // y1     - the vertical position of the first Bezier control point.
; // x2     - the horizontal position of the second Bezier control point.
; // y2     - the vertical position of the second Bezier control point.
; // x3     - the horizontal position of the ending point of the Bezier curve.
; // y3     - the vertical position of the ending point of the Bezier curve.
; //
; // Returns TRUE on success
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV FPDFPath_BezierTo(FPDF_PAGEOBJECT path,
;                                                       float x1,
;                                                       float y1,
;                                                       float x2,
;                                                       float y2,
;                                                       float x3,
;                                                       float y3);
; // Close the current subpath of a given path.
; //
; // path   - the handle To the path object.
; //
; // This will add a line between the current point And the initial point of the
; // subpath, thus terminating the current subpath.
; //
; // Returns TRUE on success
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV FPDFPath_Close(FPDF_PAGEOBJECT path);
; // Set the drawing mode of a path.
; //
; // path     - the handle To the path object.
; // fillmode - the filling mode To be set: one of the FPDF_FILLMODE_* flags.
; // stroke   - a boolean specifying If the path should be stroked Or Not.
; //
; // Returns TRUE on success
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV FPDFPath_SetDrawMode(FPDF_PAGEOBJECT path,
;                                                          int fillmode,
;                                                          FPDF_BOOL stroke);
; // Experimental API.
; // Get the drawing mode of a path.
; //
; // path     - the handle To the path object.
; // fillmode - the filling mode of the path: one of the FPDF_FILLMODE_* flags.
; // stroke   - a boolean specifying If the path is stroked Or Not.
; //
; // Returns TRUE on success
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV FPDFPath_GetDrawMode(FPDF_PAGEOBJECT path,
;                                                          int* fillmode,
;                                                          FPDF_BOOL* stroke);
; // Experimental API.
; // Get the transform matrix of a path.
; //
; //   path - handle To a path.
; //   a    - matrix value.
; //   b    - matrix value.
; //   c    - matrix value.
; //   d    - matrix value.
; //   e    - matrix value.
; //   f    - matrix value.
; //
; // The matrix is composed As:
; //   |a c e|
; //   |b d f|
; // And used To scale, rotate, shear And translate the path.
; //
; // Returns TRUE on success.
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV FPDFPath_GetMatrix(FPDF_PAGEOBJECT path,
;                                                        double* a,
;                                                        double* b,
;                                                        double* c,
;                                                        double* d,
;                                                        double* e,
;                                                        double* f);
; // Experimental API.
; // Set the transform matrix of a path.
; //
; //   path - handle To a path.
; //   a    - matrix value.
; //   b    - matrix value.
; //   c    - matrix value.
; //   d    - matrix value.
; //   e    - matrix value.
; //   f    - matrix value.
; //
; // The matrix is composed As:
; //   |a c e|
; //   |b d f|
; // And can be used To scale, rotate, shear And translate the path.
; //
; // Returns TRUE on success.
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV FPDFPath_SetMatrix(FPDF_PAGEOBJECT path,
;                                                        double a,
;                                                        double b,
;                                                        double c,
;                                                        double d,
;                                                        double e,
;                                                        double f);
; // Create a new text object using one of the standard PDF fonts.
; //
; // document   - handle To the document.
; // font       - string containing the font name, without spaces.
; // font_size  - the font size For the new text object.
; //
; // Returns a handle To a new text object, Or NULL on failure
; FPDF_EXPORT FPDF_PAGEOBJECT FPDF_CALLCONV
; FPDFPageObj_NewTextObj(FPDF_DOCUMENT document,
;                        FPDF_BYTESTRING font,
;                        float font_size);
; // Set the text For a textobject. If it had text, it will be replaced.
; //
; // text_object  - handle To the text object.
; // text         - the UTF-16LE encoded string containing the text To be added.
; //
; // Returns TRUE on success
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV
; FPDFText_SetText(FPDF_PAGEOBJECT text_object, FPDF_WIDESTRING text);
; // Returns a font object loaded from a stream of Data. The font is loaded
; // into the document.
; //
; // document   - handle To the document.
; // Data       - the stream of Data, which will be copied by the font object.
; // size       - size of the stream, in bytes.
; // font_type  - FPDF_FONT_TYPE1 Or FPDF_FONT_TRUETYPE depending on the font
; // type.
; // cid        - a boolean specifying If the font is a CID font Or Not.
; //
; // The loaded font can be closed using FPDFFont_Close.
; //
; // Returns NULL on failure
; FPDF_EXPORT FPDF_FONT FPDF_CALLCONV FPDFText_LoadFont(FPDF_DOCUMENT document,
;                                                       const uint8_t* Data,
;                                                       uint32_t size,
;                                                       int font_type,
;                                                       FPDF_BOOL cid);
; // Experimental API.
; // Loads one of the standard 14 fonts per PDF spec 1.7 page 416. The preferred
; // way of using font style is using a dash To separate the name from the style,
; // For example 'Helvetica-BoldItalic'.
; //
; // document   - handle To the document.
; // font       - string containing the font name, without spaces.
; //
; // The loaded font should Not be closed using FPDFFont_Close. It will be
; // unloaded during the document's destruction.
; //
; // Returns NULL on failure.
; FPDF_EXPORT FPDF_FONT FPDF_CALLCONV
; FPDFText_LoadStandardFont(FPDF_DOCUMENT document, FPDF_BYTESTRING font);
; // DEPRECATED As of May 2018. This API will be removed in the future. Please
; // use FPDFPageObj_SetFillColor instead.
; //
; // Set the fill RGBA of a text object. Range of values: 0 - 255.
; //
; // text_object  - handle To the text object.
; // R            - the red component For the path fill color.
; // G            - the green component For the path fill color.
; // B            - the blue component For the path fill color.
; // A            - the fill alpha For the path.
; //
; // Returns TRUE on success.
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV
; FPDFText_SetFillColor(FPDF_PAGEOBJECT text_object,
;                       unsigned int R,
;                       unsigned int G,
;                       unsigned int B,
;                       unsigned int A);
; // Experimental API.
; // Get the transform matrix of a text object.
; //
; //   text - handle To a text.
; //   a    - matrix value.
; //   b    - matrix value.
; //   c    - matrix value.
; //   d    - matrix value.
; //   e    - matrix value.
; //   f    - matrix value.
; //
; // The matrix is composed As:
; //   |a c e|
; //   |b d f|
; // And used To scale, rotate, shear And translate the text.
; //
; // Returns TRUE on success.
; FPDF_EXPORT FPDF_BOOL FPDF_CALLCONV FPDFText_GetMatrix(FPDF_PAGEOBJECT text,
;                                                        double* a,
;                                                        double* b,
;                                                        double* c,
;                                                        double* d,
;                                                        double* e,
;                                                        double* f);
; // Experimental API.
; // Get the font size of a text object.
; //
; //   text - handle To a text.
; //
; // Returns the font size of the text object, measured in points (about 1/72
; // inch) on success; 0 on failure.
; FPDF_EXPORT double FPDF_CALLCONV FPDFTextObj_GetFontSize(FPDF_PAGEOBJECT text);
; // Close a loaded PDF font.
; //
; // font   - Handle To the loaded font.
; FPDF_EXPORT void FPDF_CALLCONV FPDFFont_Close(FPDF_FONT font);
; // Create a new text object using a loaded font.
; //
; // document   - handle To the document.
; // font       - handle To the font object.
; // font_size  - the font size For the new text object.
; //
; // Returns a handle To a new text object, Or NULL on failure
; FPDF_EXPORT FPDF_PAGEOBJECT FPDF_CALLCONV
; FPDFPageObj_CreateTextObj(FPDF_DOCUMENT document,
;                           FPDF_FONT font,
;                           float font_size);
; // Experimental API.
; // Get the text rendering mode of a text object.
; //
; // text     - the handle To the text object.
; //
; // Returns one of the FPDF_TEXTRENDERMODE_* flags on success, -1 on error.
; FPDF_EXPORT int FPDF_CALLCONV FPDFText_GetTextRenderMode(FPDF_PAGEOBJECT text);
; // Experimental API.
; // Get number of page objects inside |form_object|.
; //
; //   form_object - handle To a form object.
; //
; // Returns the number of objects in |form_object| on success, -1 on error.
; FPDF_EXPORT int FPDF_CALLCONV
; FPDFFormObj_CountObjects(FPDF_PAGEOBJECT form_object);
; // Experimental API.
; // Get page object in |form_object| at |index|.
; //
; //   form_object - handle To a form object.
; //   index       - the 0-based index of a page object.
; //
; // Returns the handle To the page object, Or NULL on error.
; FPDF_EXPORT FPDF_PAGEOBJECT FPDF_CALLCONV
; FPDFFormObj_GetObject(FPDF_PAGEOBJECT form_object, unsigned long index);
; #ifdef __cplusplus
; }  // extern "C"
; #endif  // __cplusplus
; #endif  // PUBLIC_FPDF_EDIT_H_

  
  Global pdf_dll = OpenLibrary(#PB_Any, "pdfium.dll")
  #BUFFER_LEN = 1024
  Global *buffer

  If pdf_dll = 0
    Debug "Error loading DLL"
    End
  EndIf
  
  ; library
  Global InitLibrary.PFNINITLIBRARY                 = GetFunction(pdf_dll, "FPDF_InitLibrary")
  
  ; document
  Global CreateNewDocument.PFNCREATENEWDOCUMENT     = GetFunction(pdf_dll, "FPDF_CreateNewDocument")
  Global LoadDocument.PFNLOADDOCUMENT               = GetFunction(pdf_dll, "FPDF_LoadDocument")
  Global CloseDocument.PFNCLOSEDOCUMENT             = GetFunction(pdf_dll, "FPDF_CloseDocument")
  Global SaveAsCopy.PFNSAVEASCOPY                   = GetFunction(pdf_dll, "FPDF_SaveAsCopy")
  Global SaveWithVersion.PFNSAVEWITHVERSION         = GetFunction(pdf_dll, "FPDF_SaveWithVersion")
  Global GetPageCount.PFNGETPAGECOUNT               = GetFunction(pdf_dll, "FPDF_GetPageCount")
  Global GetMetaText.PFNGETMETATEXT                 = GetFunction(pdf_dll, "FPDF_GetMetaText")
  Global GetFileVersion.PFNGETFILEVERSION           = GetFunction(pdf_dll, "FPDF_GetFileVersion")
  Global Font.PFNFONT                               = GetFunction(pdf_dll, "FPDFText_LoadFont")
  Global StandardFont.PFNSTANDARDFONT               = GetFunction(pdf_dll, "FPDFText_LoadStandardFont")
  
  ; page
  Global NewPage.PFNNEWPAGE                         = GetFunction(pdf_dll, "FPDFPage_New")
  Global DeletePage.PFNDELETEPAGE                   = GetFunction(pdf_dll, "FPDFPage_Delete")
  Global LoadPage.PFNLOADPAGE                       = GetFunction(pdf_dll, "FPDF_LoadPage")
  Global ClosePage.PFNCLOSEPAGE                     = GetFunction(pdf_dll, "FPDF_ClosePage")
  Global GetPageHeight.PFNGETPAGEHEIGHT             = GetFunction(pdf_dll, "FPDF_GetPageHeight")
  Global GetPageWidth.PFNGETPAGEWIDTH               = GetFunction(pdf_dll, "FPDF_GetPageWidth")
  Global GetCropBox.PFNGETCROPBOX                   = GetFunction(pdf_dll, "FPDFPage_GetCropBox")
  Global SetCropBox.PFNSETCROPBOX                   = GetFunction(pdf_dll, "FPDFPage_SetCropBox")
  Global GetPageRotation.PFNGETPAGEROTATION         = GetFunction(pdf_dll, "FPDFPage_GetRotation")
  Global SetPageRotation.PFNSETPAGEROTATION         = GetFunction(pdf_dll, "FPDFPage_SetRotation")
  Global InsertPageObject.PFNINSERTPageOBJECT       = GetFunction(pdf_dll, "FPDFPage_InsertObject")
  Global RemovePageObject.PFNREMOVEPAGEOBJECT       = GetFunction(pdf_dll, "FPDFPage_RemoveObject")
  Global CountPageObjects.PFNCOUNTPAGEOBJECTS       = GetFunction(pdf_dll, "FPDFPage_CountObjects")
  Global GetPageObject.PFNGETPAGEOBJECT             = GetFunction(pdf_dll, "FPDFPage_GetObject")
  Global HasPageTransparency.PFNHASPAGETRANSPARENCY = GetFunction(pdf_dll, "FPDFPage_HasTransparency")
  Global GeneratePageContent.PFNGENERATEPAGECONTENT = GetFunction(pdf_dll, "FPDFPage_GenerateContent")
  
  ; object
  Global DestroyObject.PFNDESTROYOBJECT             = GetFunction(pdf_dll, "FPDFPageObj_Destroy")
  Global HasObjectTransparency.PFNHASOBJECTTRANSPARENCY= GetFunction(pdf_dll, "FPDFPageObj_HasTransparency")
  Global GetObjectType.PGNGETOBJECTTYPE             = GetFunction(pdf_dll, "FPDFPageObj_GetType")
  
  Global GetFillColor.PFNGETFILLCOLOR               = GetFunction(pdf_dll, "FPDFPageObj_GetFillColor")
  Global GetStrokeColor.PFNGETSTROKECOLOR           = GetFunction(pdf_dll, "FPDFPageObj_GetStrokeColor")
  Global SetFillColor.PFNSETFILLCOLOR               = GetFunction(pdf_dll, "FPDFPageObj_SetFillColor")
  Global SetStrokeColor.PFNGETSTROKECOLOR           = GetFunction(pdf_dll, "FPDFPageObj_SetStrokeColor")
  
  Global NewTextObject.PFNNEWTEXTOBJECT             = GetFunction(pdf_dll, "FPDFPageObj_NewTextObj")
  Global SetText.PFNSETTEXT                         = GetFunction(pdf_dll, "FPDFText_SetText")
  
  Global NewImageObject.PFNNEWIMAGEOBJECT           = GetFunction(pdf_dll, "FPDFPageObj_NewImageObj")
  Global CountMarks.PFNCOUNTMARKS                   = GetFunction(pdf_dll, "FPDFPageObj_CountMarks")
  Global GetMark.PFNGETMARK                         = GetFunction(pdf_dll, "FPDFPageObj_GetMark")
  Global AddMark.PFNADDMARK                         = GetFunction(pdf_dll, "FPDFPageObj_AddMark")
  Global RemoveMark.PFNREMOVEMARK                   = GetFunction(pdf_dll, "FPDFPageObj_RemoveMark")
  Global GetMarkName.PFNGETMARKNAME                 = GetFunction(pdf_dll, "FPDFPageObjMark_GetName")
  
  Global TransformAnnots.PFNTRANSFORMANNOTS         = GetFunction(pdf_dll, "FPDFPage_TransformAnnots")
  
  Global GetMatrix.PFNGETMATRIX                     = GetFunction(pdf_dll, "FPDFPath_GetMatrix")
  Global SetMatrix.PFNSETMATRIX                     = GetFunction(pdf_dll, "FPDFPath_SetMatrix")
  Global Transform.PFNTRANSFORM                     = GetFunction(pdf_dll, "FPDFPageObj_Transform")
  Global RenderPage.PFNRENDERPAGE                   = GetFunction(pdf_dll, "FPDF_RenderPage")  
  
  Declare Init()
  Declare Term()
  Declare.s GetAuthor(pdf_doc)
  Declare.s GetCreator(pdf_doc)
  Declare.s GetTitle(pdf_doc)
  Declare TranslateText(text.s)
  
EndDeclareModule

Module PDFium
  Procedure Init()
    InitLibrary()
    *buffer = AllocateMemory(#BUFFER_LEN)
  EndProcedure
  
  Procedure Term()
    If pdf_dll : CloseLibrary(pdf_dll) : EndIf
    If *buffer : FreeMemory(*buffer) : EndIf
  EndProcedure
  
  ; PDF-Author
  Procedure.s GetAuthor(pdf_doc)
    Define ret = PDFium::GetMetaText(pdf_doc,"Author",*buffer, #BUFFER_LEN)
    If ret : ProcedureReturn PeekS(*buffer, ret) : EndIf
  EndProcedure
  
  ; PDF-Titel
  Procedure.s GetTitle(pdf_doc)
    Define ret = PDFium::GetMetaText(pdf_doc,"Title",*buffer, #BUFFER_LEN)
    If ret : ProcedureReturn PeekS(*buffer, ret) : EndIf
  EndProcedure

  ; PDF-Creator
  Procedure.S GetCreator(pdf_doc)
    Define ret = PDFium::GetMetaText(pdf_doc,"Creator",*buffer, #BUFFER_LEN)
    If ret : ProcedureReturn PeekS(*buffer, ret) : EndIf
  EndProcedure
  
  Procedure TranslateText(text.s)
    Define translated.s = PeekS(@text, -1, #PB_UTF16)
    CopyMemory(@translated, *buffer, StringByteLength(translated, #PB_UTF16))
    ProcedureReturn *buffer
  EndProcedure
  
EndModule

; IDE Options = PureBasic 5.62 (Windows - x64)
; CursorPosition = 1058
; FirstLine = 1038
; Folding = ---
; EnableXP
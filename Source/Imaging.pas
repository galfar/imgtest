{
  $Id: Imaging.pas,v 1.29 2006/10/26 13:29:28 galfar Exp $
  Vampyre Imaging Library
  by Marek Mauder (pentar@seznam.cz)
  http://imaginglib.sourceforge.net

  The contents of this file are used with permission, subject to the Mozilla
  Public License Version 1.1 (the "License"); you may not use this file except
  in compliance with the License. You may obtain a copy of the License at
  http://www.mozilla.org/MPL/MPL-1.1.html

  Software distributed under the License is distributed on an "AS IS" basis,
  WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
  the specific language governing rights and limitations under the License.

  Alternatively, the contents of this file may be used under the terms of the
  GNU Lesser General Public License (the  "LGPL License"), in which case the
  provisions of the LGPL License are applicable instead of those above.
  If you wish to allow use of your version of this file only under the terms
  of the LGPL License and not to allow others to use your version of this file
  under the MPL, indicate your decision by deleting  the provisions above and
  replace  them with the notice and other provisions required by the LGPL
  License.  If you do not delete the provisions above, a recipient may use
  your version of this file under either the MPL or the LGPL License.

  For more information about the LGPL: http://www.gnu.org/copyleft/lesser.html
}

{ This unit is heart of Imaging library. It contains basic functions for
  manipulating image data as well as various image file format support.}
unit Imaging;

{$I ImagingOptions.inc}

interface

uses
  ImagingTypes, SysUtils, Classes;

type
  { Default Imaging excepton class.}
  EImagingError = class(Exception);

  { Dynamic array of TImageData records.}
  TDynImageDataArray = array of TImageData;


{ ------------------------------------------------------------------------
                       Low Level Interface Functions
  ------------------------------------------------------------------------}

{ General Functions }

{ Initializes image (all is set to zeroes). Call this for each image
  before using it (before calling every other function) to be sure there
  are no random-filled bytes (which would cause errors later).}
procedure InitImage(var Image: TImageData);
{ Creates empty image of given dimensions and format. Image is filled with
  transparent black color (A=0, R=0, G=0, B=0).}
function NewImage(Width, Height: LongInt; Format: TImageFormat;
  var Image: TImageData): Boolean;
{ Returns True if given TImageData record is valid.}
function TestImage(const Image: TImageData): Boolean;
{ Frees given image data. Ater this call image is in the same state
  as after calling InitImage.}
function FreeImage(var Image: TImageData): Boolean;
{ Call FreeImage() on all images in given dynamic
  array.}
function FreeImagesInArray(var Images: TDynImageDataArray): Boolean;
{ Returns True if all TImageData records in given array are valid.}
function TestImagesInArray(const Images: TDynImageDataArray): Boolean;
{ Checks given file for every supported image file format and if
  the file is in one of them returns its string identifier
  (which can be used in LoadFromStream/LoadFromMem type functions).
  If file is not in any of the supported formats empty string is returned.}
function DetermineFileFormat(const FileName: string): string;
{ Checks given stream for every supported image file format and if
  the stream is in one of them returns its string identifier
  (which can be used in LoadFromStream/LoadFromMem type functions).
  If stream is not in any of the supported formats empty string is returned.}
function DetermineStreamFormat(Stream: TStream): string;
{ Checks given memory for every supported image file format and if
  the memory is in one of them returns its string identifier
  (which can be used in LoadFromStream/LoadFromMem type functions).
  If memory is not in any of the supported formats empty string is returned.}
function DetermineMemoryFormat(Data: Pointer; Size: LongInt): string;
{ Checks that an apropriate file format is supported purely from inspecting
  the given file name's extension (not contents of the file itself).
  The file need not exist.}
function IsFileFormatSupported(const FileName: string): Boolean;
            
{ Loading Functions }

{ Loads single image from given file.}
function LoadImageFromFile(const FileName: string; var Image: TImageData): Boolean;
{ Loads single image from given stream. If function fails stream position
  is not changed.}
function LoadImageFromStream(Stream: TStream; var Image: TImageData): Boolean;
{ Loads single image from given memory location.}
function LoadImageFromMemory(Data: Pointer; Size: LongInt; var Image: TImageData): Boolean;
{ Loads multiple images from given file.}
function LoadMultiImageFromFile(const FileName: string;
  var Images: TDynImageDataArray): Boolean;
{ Loads multiple images from given stream. If function fails stream position
  is not changed.}
function LoadMultiImageFromStream(Stream: TStream;
  var Images: TDynImageDataArray): Boolean;
{ Loads multiple images from given memory location.}
function LoadMultiImageFromMemory(Data: Pointer; Size: LongInt;
  var Images: TDynImageDataArray): Boolean;

{ Saving Functions }

{ Saves single image to given file.}
function SaveImageToFile(const FileName: string; const Image: TImageData): Boolean;
{ Saves single image to given stream. If function fails stream position
  is not changed. Ext identifies desired image file format (jpg, png, dds, ...).}
function SaveImageToStream(const Ext: string; Stream: TStream;
  const Image: TImageData): Boolean;
{ Saves single image to given memory location. Memory must be allocated and its
  size is passed in Size parameter in which number of written bytes is returned.
  Ext identifies desired image file format (jpg, png, dds, ...).}
function SaveImageToMemory(const Ext: string; Data: Pointer; var Size: LongInt;
  const Image: TImageData): Boolean;
{ Saves multiple images to given file. If format supports
  only single level images and there are multiple images to be saved,
  they are saved as sequence of files img000.jpg, img001.jpg ....).}
function SaveMultiImageToFile(const FileName: string;
  const Images: TDynImageDataArray): Boolean;
{ Saves multiple images to given stream. If format supports
  only single level images and there are multiple images to be saved,
  they are saved one after another to the stream. If function fails stream
  position is not changed. Ext identifies desired image file format (jpg, png, dds, ...).}
function SaveMultiImageToStream(const Ext: string; Stream: TStream;
  const Images: TDynImageDataArray): Boolean;
{ Saves multiple images to given memory location. If format supports
  only single level images and there are multiple images to be saved,
  they are saved one after another to the memory. Memory must be allocated and
  its size is passed in Size parameter in which number of written bytes is returned.
  Ext identifies desired image file format (jpg, png, dds, ...).}
function SaveMultiImageToMemory(const Ext: string; Data: Pointer;
  var Size: LongInt; const Images: TDynImageDataArray): Boolean;

{ Manipulation Functions }

{ Creates identical copy of image data. Clone should be initialized
  by InitImage or it should be vaild image which will be freed by CloneImage.}
function CloneImage(const Image: TImageData; var Clone: TImageData): Boolean;
{ Converts image to the given format.}
function ConvertImage(var Image: TImageData; DestFormat: TImageFormat): Boolean;
{ Flips given image. Reverses the image along its horizontal axis � the top
  becomes the bottom and vice versa.}
function FlipImage(var Image: TImageData): Boolean;
{ Mirrors given image. Reverses the image along its vertical axis � the left
  side becomes the right and vice versa.}
function MirrorImage(var Image: TImageData): Boolean;
{ Resizes given image to new dimensions. Nearest, bilinear, or bicubic filtering
  can be used.}
function ResizeImage(var Image: TImageData; NewWidth, NewHeight: LongInt;
  Filter: TResizeFilter): Boolean;
{ Swaps SrcChannel and DstChannel color or alpha channels of image.
  Use ChannelRed, ChannelBlue, ChannelGreen, ChannelAlpha constants to
  identify channels.}
function SwapChannels(var Image: TImageData; SrcChannel, DstChannel: LongInt): Boolean;
{ Reduces the number of colors of the Image. Currently MaxColors must be in
  range <1, 4096>. Color reduction works also for alpha channel. Note that for
  large images and big number of colors it can be very slow.
  Output format of the image is the same as input format.}
function ReduceColors(var Image: TImageData; MaxColors: LongInt): Boolean;
{ Generates mipmaps for image. Levels is the number of desired mipmaps levels
  with zero meaning all possible levels.}
function GenerateMipMaps(const Image: TImageData; Levels: LongInt;
  var MipMaps: TDynImageDataArray): Boolean;
{ Maps image to existing palette producing image in ifIndex8 format.
  Pal must be allocated to at least Entries * SizeOf(TColor32Rec) bytes.}
function MapImageToPalette(var Image: TImageData; Pal: PPalette32;
  Entries: LongInt): Boolean;
{ Splits image into XChunks x YChunks subimages. Default size of each chunk is
  ChunkWidth x ChunkHeight. If PreserveSize si True chunks at the edges of
  the image are also ChunkWidth x ChunkHeight sized and empty space is filled
  with Fill pixels. After calling this function XChunks contains number of
  chunks along x axis and YChunks along y axis. To access chunk [X, Y] use this
  index: Chunks[Y * XChunks + X].}
function SplitImage(var Image: TImageData; var Chunks: TDynImageDataArray;
  ChunkWidth, ChunkHeight: LongInt; var XChunks, YChunks: LongInt;
  PreserveSize: Boolean; Fill: Pointer): Boolean;
{ Creates palette with MaxColors based on the colors of images in Images array.
  Use it when you want to convert several images to indexed format using
  single palette for all of them. If ConvertImages is True images in array
  are converted to indexed format using resulting palette. if it is False
  images are left intact and only resulting palatte is returned in Pal.
  Pal must be allocated to at least MaxColors * SizeOf(TColor32Rec) bytes.}
function MakePaletteForImages(var Images: TDynImageDataArray; Pal: PPalette32;
  MaxColors: LongInt; ConvertImages: Boolean): Boolean;
{ Rotates image by 90, 180, 270, -90, -180, or -270 degrees counterclockwise.}
function RotateImage(var Image: TImageData; Angle: LongInt): Boolean;

{ Drawing/Pixel functions }

{ Copies rectangular part of SrcImage to DstImage. No blending is performed -
  alpha is simply copied to destination image. Operates also with
  negative X and Y coordinates.
  Note that copying is fastest for images in the same data format
  (and slowest for images in special formats).}
function CopyRect(const SrcImage: TImageData; SrcX, SrcY, Width, Height: LongInt;
  var DstImage: TImageData; DstX, DstY: LongInt): Boolean;
{ Fills given rectangle of image with given pixel fill data. Fill should point
  to the pixel in the same format as the given image is in.}
function FillRect(var Image: TImageData; X, Y, Width, Height: LongInt; FillColor: Pointer): Boolean;
{ Replaces pixels with OldPixel in the given rectangle by NewPixel.
  OldPixel and NewPixel should point to the pixels in the same format
  as the given image is in.}
function ReplaceColor(var Image: TImageData; X, Y, Width, Height: LongInt;
  OldColor, NewColor: Pointer): Boolean;
{ Stretches the contents of the source rectangle to the destination rectangle
  with optional resampling. No blending is performed - alpha is
  simply copied/resampled to destination image. Note that stretching is
  fastest for images in the same data format (and slowest for
  images in special formats).}
function StretchRect(const SrcImage: TImageData; SrcX, SrcY, SrcWidth,
  SrcHeight: LongInt; var DstImage: TImageData; DstX, DstY, DstWidth,
  DstHeight: LongInt; Filter: TResizeFilter): Boolean;
{ Copies pixel of Image at [X, Y] to memory pointed at by Pixel. Doesn't
  work with special formats.}
procedure GetPixelDirect(const Image: TImageData; X, Y: LongInt; Pixel: Pointer);
{ Copies pixel from memory pointed at by Pixel to Image at position [X, Y].
  Doesn't work with special formats.}
procedure SetPixelDirect(const Image: TImageData; X, Y: LongInt; Pixel: Pointer);
{ Function for getting pixel colors. Native pixel is read from Image and
  then translated to 32 bit ARGB. Works for all image formats (except special)
  so it is not very fast.}
function GetPixel32(const Image: TImageData; X, Y: LongInt): TColor32Rec;
{ Procedure for setting pixel colors. Input 32 bit ARGB color is translated to
  native format and then written to Image. Works for all image formats (except special)
  so it is not very fast.}
procedure SetPixel32(const Image: TImageData; X, Y: LongInt; const Color: TColor32Rec);
{ Function for getting pixel colors. Native pixel is read from Image and
  then translated to FP ARGB. Works for all image formats (except special)
  so it is not very fast.}
function GetPixelFP(const Image: TImageData; X, Y: LongInt): TColorFPRec;
{ Procedure for setting pixel colors. Input FP ARGB color is translated to
  native format and then written to Image. Works for all image formats (except special)
  so it is not very fast.}
procedure SetPixelFP(const Image: TImageData; X, Y: LongInt; const Color: TColorFPRec); 

{ Palette Functions }

{ Allocates new palette with Entries ARGB color entries.}
function NewPalette(Entries: LongInt; var Pal: PPalette32): Boolean;
{ Frees given palette.}
function FreePalette(var Pal: PPalette32): Boolean;
{ Copies Count palette entries from SrcPal starting at index SrcIdx to
  DstPal at index DstPal.}
function CopyPalette(SrcPal, DstPal: PPalette32; SrcIdx, DstIdx, Count: LongInt): Boolean;
{ Returns index of color in palette or index of nearest color if exact match
  is not found. Pal must be allocated to at least Entries * SizeOf(TColor32Rec) bytes.}
function FindColor(Pal: PPalette32; Entries: LongInt; Color: TColor32): LongInt;
{ Creates grayscale palette where each color channel has the same value.
  Pal must be allocated to at least Entries * SizeOf(TColor32Rec) bytes.}
function FillGrayscalePalette(Pal: PPalette32; Entries: LongInt): Boolean;
{ Creates palette with given bitcount for each channel.
  2^(RBits + GBits + BBits) should be equl to Entries. Examples:
  (3, 3, 2) will create palette with all possible colors of R3G3B2 format
  and (8, 0, 0) will create palette with 256 shades of red.
  Pal must be allocated to at least Entries * SizeOf(TColor32Rec) bytes.}
function FillCustomPalette(Pal: PPalette32; Entries: LongInt; RBits, GBits,
  BBits: Byte; Alpha: Byte = $FF): Boolean;
{ Swaps SrcChannel and DstChannel color or alpha channels of palette.
  Use ChannelRed, ChannelBlue, ChannelGreen, ChannelAlpha constants to
  identify channels. Pal must be allocated to at least
  Entries * SizeOf(TColor32Rec) bytes.}
function SwapChannelsOfPalette(Pal: PPalette32; Entries, SrcChannel,
  DstChannel: LongInt): Boolean;

{ Options Functions }

{ Sets value of integer option specified by OptionId parameter.
  Option Ids are constans starting ImagingXXX.}
function SetOption(OptionId, Value: LongInt): Boolean;
{ Returns value of integer option specified by OptionId parameter. If OptionId is
  invalid, InvalidOption is returned. Option Ids are constans
  starting ImagingXXX.}
function GetOption(OptionId: LongInt): LongInt;
{ Pushes current values of all options on the stack. Returns True
  if successfull (max stack depth is 8 now). }
function PushOptions: Boolean;
{ Pops back values of all options from the top of the stack. Returns True
  if successfull (max stack depth is 8 now). }
function PopOptions: Boolean;

{ Image Format Functions }

{ Returns short information about given image format.}
function GetImageFormatInfo(Format: TImageFormat; var Info: TImageFormatInfo): Boolean;
{ Returns size in bytes of Width x Height area of pixels. Works for all formats.}
function GetPixelsSize(Format: TImageFormat; Width, Height: LongInt): LongInt;

{ IO Functions }

{ User can set his own file IO functions used when loading from/saving to
  files by this function.}
procedure SetUserFileIO(OpenReadProc: TOpenReadProc; OpenWriteProc:
  TOpenWriteProc; CloseProc: TCloseProc; EofProc: TEofProc; SeekProc:
  TSeekProc; TellProc: TTellProc; ReadProc: TReadProc; WriteProc: TWriteProc);
{ Sets file IO functions to Imaging default.}
procedure ResetFileIO;


{ ------------------------------------------------------------------------
                           Other Imaging Stuff
  ------------------------------------------------------------------------}

type
  { Set of TImageFormat enum.}
  TImageFormats = set of TImageFormat;

  { Record containg set of IO functions internaly used by image loaders/savers.}
  TIOFunctions = record
    OpenRead: TOpenReadProc;
    OpenWrite: TOpenWriteProc;
    Close: TCloseProc;
    Eof: TEofProc;
    Seek: TSeekProc;
    Tell: TTellProc;
    Read: TReadProc;
    Write: TWriteProc;
  end;

  { Base class for various image file format loaders/savers which
    descend from this class.}
  TImageFileFormat = class(TObject)
  protected
    FExtensions: TStringList;
    FName: string;
    FCanLoad: Boolean;
    FCanSave: Boolean;
    FIsMultiImageFormat: Boolean;
    procedure AddExtensions(const AExtensions: string);
    function GetFormatInfo(Format: TImageFormat): PImageFormatInfo;
    function GetSupportedFormats: TImageFormats; virtual;
    { Method which must be overrided in descendants if they' are be capable
      of loading images.}
    procedure LoadData(Handle: TImagingHandle; var Images: TDynImageDataArray;
      OnlyFirstFrame: Boolean); virtual;
    { Method which must be overrided in descendants if they are be capable
      of saving images. If Index is MaxInt all images in array are saved, otherwise
      only image at index is saved.}
    procedure SaveData(Handle: TImagingHandle; const Images: TDynImageDataArray;
      Index: LongInt = MaxInt); virtual;
    { Creates clone of image compatible with format's saving function.
      It can convert image to another format, swap channels of image, ...
      Note that if input Image is already compatible it is returned in Comp,
      so before freeing Comp you must test if it is not original Image.
      Returns True if Comp is returned in compatible format}
    function MakeCompatible(const Image: TImageData; var Comp: TImageData): Boolean; virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;

    { Loads images from file source.}
    function LoadFromFile(const FileName: string; var Images: TDynImageDataArray;
      OnlyFirstLevel: Boolean = False): Boolean;
    { Loads images from stream source.}
    function LoadFromStream(Stream: TStream; var Images: TDynImageDataArray;
      OnlyFirstLevel: Boolean = False): Boolean;
    { Loads images from memory source.}
    function LoadFromMemory(Data: Pointer; Size: LongInt;
      var Images: TDynImageDataArray; OnlyFirstLevel: Boolean = False): Boolean;

    { Saves images to file. If format supports only single level images and
      there are multiple images to be saved, they are saved as sequence of
      independent images (for example SaveToFile saves sequence of
      files img000.jpg, img001.jpg ....).}
    function SaveToFile(const FileName: string; const Images: TDynImageDataArray;
      OnlyFirstLevel: Boolean = False): Boolean;
    { Saves images to stream. If format supports only single level images and
      there are multiple images to be saved, they are saved as sequence of
      independent images.}
    function SaveToStream(Stream: TStream; const Images: TDynImageDataArray;
      OnlyFirstLevel: Boolean = False): Boolean;
    { Saves images to memory. If format supports only single level images and
      there are multiple images to be saved, they are saved as sequence of
      independent images. Data must be already allocated and their size passed
      as Size parameter, number of written bytes is then returned in the same
      parameter.}
    function SaveToMemory(Data: Pointer; var Size: LongInt;
      const Images: TDynImageDataArray; OnlyFirstLevel: Boolean = False): Boolean;

    { Returns True if data located in source identified by Handle
      represent valid image in current format.}
    function TestFormat(Handle: TImagingHandle): Boolean; virtual;

    { List of file extensions for this format}
    property Extensions: TStringList read FExtensions;
    { Description of this format}
    property Name: string read FName;
    { Indicates whether images in this format can be loaded}
    property CanLoad: Boolean read FCanLoad;
    { Indicates whether images in this format can be saved}
    property CanSave: Boolean read FCanSave;
    { Indicates whether images in this format can contain multiple image levels}
    property IsMultiImageFormat: Boolean read FIsMultiImageFormat;
    { Set of TImageFormats supported by saving/loading functions of this format}
    property SupportedFormats: TImageFormats read GetSupportedFormats;
  end;

  { Class reference for TImageFileFormat class}
  TImageFileFormatClass = class of TImageFileFormat;

{ Returns symbolic name of given format.}
function GetFormatName(Format: TImageFormat): string;
{ Returns string with information about given Image.}
function ImageToStr(const Image: TImageData): string;
{ Returns Imaging version string in format 'Major.Minor.Patch'.}
function GetVersionStr: string;
{ If Condition is True then TruePart is retured, otherwise FalsePart is returned.}
function IffFormat(Condition: Boolean; const TruePart, FalsePart: TImageFormat): TImageFormat;
{ Registers new image loader/saver so it can be used by LoadFrom/SaveTo
  functions.}
procedure RegisterImageFileFormat(AClass: TImageFileFormatClass);
{ Registers new option so it can be used by Srt/GetOption functions.}
procedure RegisterOption(OptionId: LongInt; Variable: PLongInt);
{ Returns image format loader/saver asociated with given file
  extension or nil if not found.}
function FindImageFileFormat(const Ext: string): TImageFileFormat; overload;
{ Returns image format loader/saver based on its class
  or nil if not found or not registered.}
function FindImageFileFormat(AClass: TImageFileFormatClass): TImageFileFormat; overload;
{ Returns filter string for usage with open and save picture dialogs
  which contains all registered image file formats.
  If AllFilter is True filter for all known graphic files
  (like All(*.jpg;*.png;....) is added too at the first index
  (good for open image dialogs).}
function GetImageFileFormatsFilter(AllFilter: Boolean): string;
{ Returns file extension (without dot) of image format selected
  by given filter index. Used filter string is defined by GetImageFileFormatsFilter
  function. This function can be used with save dialogs (with filters created
  by GetImageFileFormatsFilter) to get the extension of file format selected
  in dialog quickly. Index is in range 1..N (as FilterIndex property
  of TOpenDialog/TSaveDialog)}
function GetFilterIndexExtension(Index: LongInt; AllFilter: Boolean): string;
{ Returns filter index of image file format specified by Ext. Used filter
  string is defined by GetImageFileFormatsFilter function.
  Returned index is in range 1..N (as FilterIndex property of TOpenDialog/TSaveDialog)}
function GetExtensionFilterIndex(const Ext: string; AllFilter: Boolean): LongInt;
{ Returns current IO functions.}
function GetIO: TIOFunctions;
{ Raises EImagingError with given message.}
procedure RaiseImaging(const Msg: string; const Args: array of const);

implementation

uses
{$IFDEF LINK_BITMAP}
  ImagingBitmap,
{$ENDIF}
{$IFDEF LINK_JPEG}
  ImagingJpeg,
{$ENDIF}
{$IF Defined(LINK_PNG) or Defined(LINK_MNG) or Defined(LINK_JNG)}
  ImagingNetworkGraphics,
{$IFEND}
{$IFDEF LINK_DDS}
  ImagingDds,
{$ENDIF}
{$IFDEF LINK_TARGA}
  ImagingTarga,
{$ENDIF}
  ImagingFormats, ImagingUtility, ImagingIO;

resourcestring
  SExceptMsg = 'Exception Message';
  SAllFilter = 'All Images';
  SUnknownFormat = 'Unknown and unsupported format';
  SErrorFreeImage = 'Error while freeing image. %s';
  SErrorCloneImage = 'Error while cloning image. %s';
  SErrorFlipImage = 'Error while flipping image. %s';
  SErrorMirrorImage = 'Error while mirroring image. %s';
  SErrorResizeImage = 'Error while resizing image.  %s';
  SErrorSwapImage = 'Error while swapping channels of image. %s';
  SFileFormatCanNotLoad = 'Image Format "%s" does not support loading images.';
  SFileFormatCanNotSave = 'Image Format "%s" does not support saving images.';
  SErrorNewImage = 'Error while creating image data with params: Width=%d ' +
    'Height=%d Format=%s.';
  SErrorConvertImage = 'Error while converting image to format "%s". %s';
  SImageInfo = 'Image @%p info: Width = %dpx, Height = %dpx, ' +
    'Format = %s, Size = %.0nKiB, Bits @%p, Palette @%p.';
  SImageInfoInvalid = 'Access violation encountered when getting info on ' +
    'image at address %p.';
  SFileNotValid = 'File "%s" is not valid image in "%s" format.';
  SStreamNotValid = 'Stream %p does not contain valid image in "%s" format.';
  SMemoryNotValid = 'Memory %p (%d Bytes) does not contain valid image ' +
    'in "%s" format.';
  SErrorLoadingFile = 'Error while loading images from file "%s".';
  SErrorLoadingStream = 'Error while loading images from stream %p.';
  SErrorLoadingMemory = 'Error while loading images from memory %p (%d Bytes).';
  SErrorSavingFile = 'Error while saving images to file "%s".';
  SErrorSavingStream = 'Error while saving images to stream %p.';
  SErrorSavingMemory = 'Error while saving images to memory %p (%d Bytes).';
  SErrorFindColor = 'Error while finding color in palette @%p with %d entries.';
  SErrorGrayscalePalette = 'Error while filling grayscale palette @%p with %d entries.';
  SErrorCustomPalette = 'Error while filling custom palette @%p with %d entries.';
  SErrorSwapPalette = 'Error while swapping channels of palette @%p with %d entries.';
  SErrorReduceColors = 'Error while reducing number of colors of image to %d. %s';
  SErrorGenerateMipMaps = 'Error while generating %d mipmap levels for image %s';
  SImagesNotValid = 'One or more images are not valid.';
  SErrorCopyRect = 'Error while copying rect from image %s to image %s.';
  SErrorMapImage = 'Error while mapping image %s to palette.';
  SErrorFillRect = 'Error while filling rectangle X:%d Y:%d W:%d H:%d in image %s';
  SErrorSplitImage = 'Error while splitting image %s to %dx%d sized chunks.';
  SErrorMakePaletteForImages = 'Error while making %d color palette for %d images.';
  SErrorNewPalette = 'Error while creating new palette with %d entries';
  SErrorFreePalette = 'Error while freeing palette @%p';
  SErrorCopyPalette = 'Error while copying %d entries from palette @%p to @%p';
  SErrorReplaceColor = 'Error while replacing colors in rectangle X:%d Y:%d W:%d H:%d of image %s';
  SErrorRotateImage = 'Error while rotating image %s by %d degrees';
  SErrorStretchRect = 'Error while stretching rect from image %s to image %s.';

const
  // initial size of array with options information
  InitialOptions = 256;
  // max depth of the option stack
  OptionStackDepth = 8;
  // do not change the default format now, its too late
  DefaultImageFormat: TImageFormat = ifA8R8G8B8;

type
  TOptionArray = array of PLongInt;
  TOptionValueArray = array of LongInt;

  TOptionStack = class(TObject)
  private
    FStack: array[0..OptionStackDepth - 1] of TOptionValueArray;
    FPosition: LongInt;
  public
    constructor Create;
    destructor Destroy; override;
    function Push: Boolean;
    function Pop: Boolean;
  end;

var
  // currently set IO functions
  IO: TIOFunctions;
  // list with all registered TImageFileFormat classes
  ImageFileFormats: TList = nil;
  // array with registered options (pointers to their values)
  Options: TOptionArray = nil;
  // array containing addional infomation about every image format
  ImageFormatInfos: TImageFormatInfoArray;
  // stack used by PushOptions/PopOtions functions
  OptionStack: TOptionStack = nil;
var
  // variable for ImagingColorReduction option
  ColorReductionMask: LongInt = $FF;
  // variable for ImagingLoadOverrideFormat option
  LoadOverrideFormat: TImageFormat = ifUnknown;
  // variable for ImagingSaveOverrideFormat option
  SaveOverrideFormat: TImageFormat = ifUnknown;
  // variable for ImagingSaveOverrideFormat option
  MipMapFilter: TSamplingFilter = sfLinear;


{ Internal unit functions }

{ Modifies option value to be in the allowed range. Works only
  for options registered in this unit.}
function CheckOptionValue(OptionId, Value: LongInt): LongInt; forward;
{ Sets IO functions to file IO.}
procedure SetFileIO; forward;
{ Sets IO functions to stream IO.}
procedure SetStreamIO; forward;
{ Sets IO functions to memory IO.}
procedure SetMemoryIO; forward;
{ Inits image format infos array.}
procedure InitImageFormats; forward;
{ Freew image format infos array.}
procedure FreeImageFileFormats; forward;
{ Creates options array and stack.}
procedure InitOptions; forward;
{ Frees options array and stack.}
procedure FreeOptions; forward;

{$IFDEF USE_INLINE}
{ Those inline functions are copied here from ImagingFormats
  because Delphi 9 cannot inline them if they are declared in
  circularly dependent units.}

procedure CopyPixel(Src, Dest: Pointer; BytesPerPixel: LongInt); inline;
begin
  case BytesPerPixel of
    1: PByte(Dest)^ := PByte(Src)^;
    2: PWord(Dest)^ := PWord(Src)^;
    3: PColor24Rec(Dest)^ := PColor24Rec(Src)^;
    4: PLongWord(Dest)^ := PLongWord(Src)^;
    6: PColor48Rec(Dest)^ := PColor48Rec(Src)^;
    8: PInt64(Dest)^ := PInt64(Src)^;
    16: PColorFPRec(Dest)^ := PColorFPRec(Src)^;
  end;
end;

function ComparePixels(PixelA, PixelB: Pointer; BytesPerPixel: LongInt): Boolean; inline;
begin
  case BytesPerPixel of
    1: Result := PByte(PixelA)^ = PByte(PixelB)^;
    2: Result := PWord(PixelA)^ = PWord(PixelB)^;
    3: Result := (PWord(PixelA)^ = PWord(PixelB)^) and
         (PColor24Rec(PixelA).R = PColor24Rec(PixelB).R);
    4: Result := PLongWord(PixelA)^ = PLongWord(PixelB)^;
    6: Result := (PLongWord(PixelA)^ = PLongWord(PixelB)^) and
         (PColor48Rec(PixelA).R = PColor48Rec(PixelB).R);
    8: Result := PInt64(PixelA)^ = PInt64(PixelB)^;
    16: Result := (PFloatHelper(PixelA).Data2 = PFloatHelper(PixelB).Data2) and
          (PFloatHelper(PixelA).Data1 = PFloatHelper(PixelB).Data1);
  else
    Result := False;
  end;
end;
{$ENDIF}

{ ------------------------------------------------------------------------
                       Low Level Interface Functions
  ------------------------------------------------------------------------}

{ General Functions }

procedure InitImage(var Image: TImageData);
begin
  FillChar(Image, SizeOf(Image), 0);
end;

function NewImage(Width, Height: LongInt; Format: TImageFormat; var Image:
  TImageData): Boolean;
var
  FInfo: PImageFormatInfo;
begin
  Result := False;
  if FreeImage(Image) and (Width >= 0) and (Height >= 0) then
  try
    Image.Width := Width;
    Image.Height := Height;
    // if desired format is not valid then default format is selected
    if (ImageFormatInfos[Format] = nil) or (Format = ifDefault)  then
      Image.Format := DefaultImageFormat
    else
      Image.Format := Format;
    FInfo := ImageFormatInfos[Image.Format];
    Image.Size := FInfo.GetPixelsSize(FInfo.Format, Image.Width, Image.Height);
    if FInfo.IsSpecial then
      FInfo.CheckDimensions(FInfo.Format, Image.Width, Image.Height);
    // image bits are allocated and set to zeroes
    GetMem(Image.Bits, Image.Size);
    FillChar(Image.Bits^, Image.Size, 0);
    // palette is allocated and set to zeroes
    GetMem(Image.Palette, FInfo.PaletteEntries * SizeOf(TColor32Rec));
    FillChar(Image.Palette^, FInfo.PaletteEntries * SizeOf(TColor32Rec), 0);

    Result := TestImage(Image);
  except
    InitImage(Image);
    Result := False;
    RaiseImaging(SErrorNewImage, [Width, Height, GetFormatName(Format)]);
  end;
end;

function TestImage(const Image: TImageData): Boolean;
begin
  Result := (LongInt(Image.Format) >= LongInt(Low(TImageFormat))) and
    (LongInt(Image.Format) <= LongInt(High(TImageFormat))) and
    (ImageFormatInfos[Image.Format] <> nil) and
    (Assigned(ImageFormatInfos[Image.Format].GetPixelsSize) and
    (ImageFormatInfos[Image.Format].GetPixelsSize(Image.Format,
    Image.Width, Image.Height) = Image.Size));
end;

function FreeImage(var Image: TImageData): Boolean;
begin
  try
    if TestImage(Image) then
    begin
      FreeMemNil(Image.Bits);
      FreeMemNil(Image.Palette);
    end;
    InitImage(Image);
    Result := True;
  except
    Result := False;
    RaiseImaging(SErrorFreeImage, [ImageToStr(Image)]);
  end;
end;

function FreeImagesInArray(var Images: TDynImageDataArray): Boolean;
var
  I: LongInt;
begin
  Result := True;
  for I := 0 to Length(Images) - 1 do
    Result := Result and FreeImage(Images[I]);
end;

function TestImagesInArray(const Images: TDynImageDataArray): Boolean;
var
  I: LongInt;
begin
  Result := True;
  for I := 0 to Length(Images) - 1 do
  begin
    Result := Result and TestImage(Images[I]);
    if not Result then
      Break;
  end;
end;

function DetermineFileFormat(const FileName: string): string;
var
  I: LongInt;
  Fmt: TImageFileFormat;
  Handle: TImagingHandle;
begin
  Result := '';
  SetFileIO;
  try
    Handle := IO.OpenRead(PChar(FileName));
    try
      for I := 0 to ImageFileFormats.Count - 1 do
      begin
        Fmt := TImageFileFormat(ImageFileFormats[I]);
        if Fmt.TestFormat(Handle) then
        begin
          Result := Fmt.Extensions[0];
          Exit;
        end;
      end;
    finally
      IO.Close(Handle);
    end;
  except
  end;
end;

function DetermineStreamFormat(Stream: TStream): string;
var
  I: LongInt;
  Fmt: TImageFileFormat;
  Handle: TImagingHandle;
begin
  Result := '';
  SetStreamIO;
  try
    Handle := IO.OpenRead(Pointer(Stream));
    for I := 0 to ImageFileFormats.Count - 1 do
    begin
      Fmt := TImageFileFormat(ImageFileFormats[I]);
      if Fmt.TestFormat(Handle) then
      begin
        Result := Fmt.Extensions[0];
        Exit;
      end;
    end;
    IO.Close(Handle);
  except
  end;
end;

function DetermineMemoryFormat(Data: Pointer; Size: LongInt): string;
var
  I: LongInt;
  Fmt: TImageFileFormat;
  Handle: TImagingHandle;
  IORec: TMemoryIORec;
begin
  Result := '';
  SetMemoryIO;
  IORec.Data := Data;
  IORec.Position := 0;
  IORec.Size := Size;
  try
    Handle := IO.OpenRead(@IORec);
    for I := 0 to ImageFileFormats.Count - 1 do
    begin
      Fmt := TImageFileFormat(ImageFileFormats[I]);
      if Fmt.TestFormat(Handle) then
      begin
        Result := Fmt.Extensions[0];
        Exit;
      end;
    end;
    IO.Close(Handle);
  except
  end;
end;

function IsFileFormatSupported(const FileName: string): Boolean;
begin
  Result := FindImageFileFormat(GetFileExt(FileName)) <> nil;
end;

{ Loading Functions }

function LoadImageFromFile(const FileName: string; var Image: TImageData):
  Boolean;
var
  Format: TImageFileFormat;
  IArray: TDynImageDataArray;
  I: LongInt;
begin
  Result := False;
  Format := FindImageFileFormat(DetermineFileFormat(FileName));
  if Format <> nil then
  begin
    FreeImage(Image);
    Result := Format.LoadFromFile(FileName, IArray, True);
    if Result and (Length(IArray) > 0) then
    begin
      Image := IArray[0];
      for I := 1 to Length(IArray) - 1 do
        FreeImage(IArray[I]);
    end
    else
      Result := False;
  end;
end;

function LoadImageFromStream(Stream: TStream; var Image: TImageData): Boolean;
var
  Format: TImageFileFormat;
  IArray: TDynImageDataArray;
  I: LongInt;
begin
  Result := False;
  Format := FindImageFileFormat(DetermineStreamFormat(Stream));
  if Format <> nil then
  begin
    FreeImage(Image);
    Result := Format.LoadFromStream(Stream, IArray, True);
    if Result and (Length(IArray) > 0) then
    begin
      Image := IArray[0];
      for I := 1 to Length(IArray) - 1 do
        FreeImage(IArray[I]);
    end
    else
      Result := False;
  end;
end;

function LoadImageFromMemory(Data: Pointer; Size: LongInt; var Image: TImageData): Boolean;
var
  Format: TImageFileFormat;
  IArray: TDynImageDataArray;
  I: LongInt;
begin
  Result := False;
  Format := FindImageFileFormat(DetermineMemoryFormat(Data, Size));
  if Format <> nil then
  begin
    FreeImage(Image);
    Result := Format.LoadFromMemory(Data, Size, IArray, True);
    if Result and (Length(IArray) > 0) then
    begin
      Image := IArray[0];
      for I := 1 to Length(IArray) - 1 do
        FreeImage(IArray[I]);
    end
    else
      Result := False;
  end;
end;

function LoadMultiImageFromFile(const FileName: string; var Images:
  TDynImageDataArray): Boolean;
var
  Format: TImageFileFormat;
begin
  Result := False;
  Format := FindImageFileFormat(DetermineFileFormat(FileName));
  if Format <> nil then
  begin
    FreeImagesInArray(Images);
    Result := Format.LoadFromFile(FileName, Images);
  end;
end;

function LoadMultiImageFromStream(Stream: TStream; var Images: TDynImageDataArray): Boolean;
var
  Format: TImageFileFormat;
begin
  Result := False;
  Format := FindImageFileFormat(DetermineStreamFormat(Stream));
  if Format <> nil then
  begin
    FreeImagesInArray(Images);
    Result := Format.LoadFromStream(Stream, Images);
  end;
end;

function LoadMultiImageFromMemory(Data: Pointer; Size: LongInt;
  var Images: TDynImageDataArray): Boolean;
var
  Format: TImageFileFormat;
begin
  Result := False;
  Format := FindImageFileFormat(DetermineMemoryFormat(Data, Size));
  if Format <> nil then
  begin
    FreeImagesInArray(Images);
    Result := Format.LoadFromMemory(Data, Size, Images);
  end;
end;

{ Saving Functions }

function SaveImageToFile(const FileName: string; const Image: TImageData): Boolean;
var
  Ext: string;
  Format: TImageFileFormat;
  IArray: TDynImageDataArray;
begin
  Result := False;
  Ext := GetFileExt(FileName);
  Format := FindImageFileFormat(Ext);
  if Format <> nil then
  begin
    SetLength(IArray, 1);
    IArray[0] := Image;
    Result := Format.SaveToFile(FileName, IArray, True);
  end;
end;

function SaveImageToStream(const Ext: string; Stream: TStream;
  const Image: TImageData): Boolean;
var
  Format: TImageFileFormat;
  IArray: TDynImageDataArray;
begin
  Result := False;
  Format := FindImageFileFormat(Ext);
  if Format <> nil then
  begin
    SetLength(IArray, 1);
    IArray[0] := Image;
    Result := Format.SaveToStream(Stream, IArray, True);
  end;
end;

function SaveImageToMemory(const Ext: string; Data: Pointer; var Size: LongInt;
  const Image: TImageData): Boolean;
var
  Format: TImageFileFormat;
  IArray: TDynImageDataArray;
begin
  Result := False;
  Format := FindImageFileFormat(Ext);
  if Format <> nil then
  begin
    SetLength(IArray, 1);
    IArray[0] := Image;
    Result := Format.SaveToMemory(Data, Size, IArray, True);
  end;
end;

function SaveMultiImageToFile(const FileName: string;
  const Images: TDynImageDataArray): Boolean;
var
  Ext: string;
  Format: TImageFileFormat;
begin
  Result := False;
  Ext := GetFileExt(FileName);
  Format := FindImageFileFormat(Ext);
  if Format <> nil then
    Result := Format.SaveToFile(FileName, Images);
end;

function SaveMultiImageToStream(const Ext: string; Stream: TStream;
  const Images: TDynImageDataArray): Boolean;
var
  Format: TImageFileFormat;
begin
  Result := False;
  Format := FindImageFileFormat(Ext);
  if Format <> nil then
    Result := Format.SaveToStream(Stream, Images);
end;

function SaveMultiImageToMemory(const Ext: string; Data: Pointer;
  var Size: LongInt; const Images: TDynImageDataArray): Boolean;
var
  Format: TImageFileFormat;
begin
  Result := False;
  Format := FindImageFileFormat(Ext);
  if Format <> nil then
    Result := Format.SaveToMemory(Data, Size, Images);
end;

{ Manipulation Functions }

function CloneImage(const Image: TImageData; var Clone: TImageData): Boolean;
var
  Info: PImageFormatInfo;
begin
  Result := False;
  if TestImage(Image) then
    with Image do
    try
      if TestImage(Clone) and (Image.Bits <> Clone.Bits) then
        FreeImage(Clone)
      else
        InitImage(Clone);

      Info := ImageFormatInfos[Format];
      Clone.Width := Width;
      Clone.Height := Height;
      Clone.Format := Format;
      Clone.Size := Size;

      if Info.PaletteEntries > 0 then
      begin
        GetMem(Clone.Palette, Info.PaletteEntries * SizeOf(TColor32Rec));
        Move(Palette^, Clone.Palette^, Info.PaletteEntries *
          SizeOf(TColor32Rec));
      end;
      
      GetMem(Clone.Bits, Clone.Size);
      Move(Bits^, Clone.Bits^, Clone.Size);
      Result := True;
    except
      RaiseImaging(SErrorCloneImage, [ImageToStr(Image)]);
    end;
end;

function ConvertImage(var Image: TImageData; DestFormat: TImageFormat): Boolean;
var
  NewData: Pointer;
  NewPal: PPalette32;
  NewSize, NumPixels: LongInt;
  SrcInfo, DstInfo: PImageFormatInfo;
begin
  Result := False;
  if TestImage(Image) then
  with Image do
  try
    // If default format is set as dest or dest is not defined
    // we use DefaultImageFormat
    if DestFormat in [ifDefault, ifUnknown] then
      DestFormat := DefaultImageFormat;
    SrcInfo := ImageFormatInfos[Format];
    DstInfo := ImageFormatInfos[DestFormat];
    if SrcInfo = DstInfo then
    begin
      // There is nothing to convert - src is alredy in dest format
      Result := True;
      Exit;
    end;
    // Exit Src or Dest format is invalid 
    if (SrcInfo = nil) or (DstInfo = nil) then Exit;
    // If dest format is just src with swapped channels we call
    // SwapChannels instead
    if (SrcInfo.RBSwapFormat = DestFormat) and
      (DstInfo.RBSwapFormat = SrcInfo.Format) then
    begin
      Result := SwapChannels(Image, ChannelRed, ChannelBlue);
      Exit;
    end;

    if (not SrcInfo.IsSpecial) and (not DstInfo.IsSpecial) then
    begin
      NumPixels := Width * Height;
      NewSize := NumPixels * DstInfo.BytesPerPixel;
      GetMem(NewData, NewSize);
      GetMem(NewPal, DstInfo.PaletteEntries * SizeOf(TColor32Rec));

      // Source: indexed format
      if SrcInfo.IsIndexed then
      begin
        if DstInfo.IsIndexed then
          IndexToIndex(NumPixels, Bits, NewData, SrcInfo, DstInfo, Palette,
            NewPal)
        else
          if DstInfo.HasGrayChannel then
            IndexToGray(NumPixels, Bits, NewData, SrcInfo, DstInfo, Palette)
          else
            if DstInfo.IsFloatingPoint then
              IndexToFloat(NumPixels, Bits, NewData, SrcInfo, DstInfo, Palette)
            else
              IndexToChannel(NumPixels, Bits, NewData, SrcInfo, DstInfo,
                Palette)
      end
      else
        // Source: grayscale format
        if SrcInfo.HasGrayChannel then
        begin
          if DstInfo.IsIndexed then
            GrayToIndex(NumPixels, Bits, NewData, SrcInfo, DstInfo, NewPal)
          else
            if DstInfo.HasGrayChannel then
              GrayToGray(NumPixels, Bits, NewData, SrcInfo, DstInfo)
            else
              if DstInfo.IsFloatingPoint then
                GrayToFloat(NumPixels, Bits, NewData, SrcInfo, DstInfo)
              else
                GrayToChannel(NumPixels, Bits, NewData, SrcInfo, DstInfo);
        end
        else
          // Source: floating point format
          if SrcInfo.IsFloatingPoint then
          begin
            if DstInfo.IsIndexed then
              FloatToIndex(NumPixels, Bits, NewData, SrcInfo, DstInfo, NewPal)
            else
              if DstInfo.HasGrayChannel then
                FloatToGray(NumPixels, Bits, NewData, SrcInfo, DstInfo)
              else
                if DstInfo.IsFloatingPoint then
                  FloatToFloat(NumPixels, Bits, NewData, SrcInfo, DstInfo)
                else
                  FloatToChannel(NumPixels, Bits, NewData, SrcInfo, DstInfo);
          end              
          else
            // Source: standard multi channel image
          begin
            if DstInfo.IsIndexed then
              ChannelToIndex(NumPixels, Bits, NewData, SrcInfo, DstInfo, NewPal)
            else
              if DstInfo.HasGrayChannel then
                ChannelToGray(NumPixels, Bits, NewData, SrcInfo, DstInfo)
              else
                if DstInfo.IsFloatingPoint then
                  ChannelToFloat(NumPixels, Bits, NewData, SrcInfo, DstInfo)
                else
                  ChannelToChannel(NumPixels, Bits, NewData, SrcInfo, DstInfo);
          end;

      FreeMemNil(Bits);
      FreeMemNil(Palette);
      Format := DestFormat;
      Bits := NewData;
      Size := NewSize;
      Palette := NewPal;
    end
    else
      ConvertSpecial(Image, SrcInfo, DstInfo);

    Result := True;
  except
    RaiseImaging(SErrorConvertImage, [GetFormatName(DestFormat),
      ImageToStr(Image)]);
  end;
end;

function FlipImage(var Image: TImageData): Boolean;
var
  P1, P2, Buff: Pointer;
  WidthBytes, I: LongInt;
  OldFmt: TImageFormat;
begin
  Result := False;
  OldFmt := Image.Format;
  if TestImage(Image) then
  with Image do
  try
    if ImageFormatInfos[OldFmt].IsSpecial then
      ConvertImage(Image, ifDefault);
    WidthBytes := Width * ImageFormatInfos[Format].BytesPerPixel;
    GetMem(Buff, WidthBytes);
    try
      // swap all scanlines of image
      for I := 0 to Height div 2 - 1 do
      begin
        P1 := @PByteArray(Bits)[I * WidthBytes];
        P2 := @PByteArray(Bits)[(Height - I - 1) * WidthBytes];
        Move(P1^, Buff^, WidthBytes);
        Move(P2^, P1^, WidthBytes);
        Move(Buff^, P2^, WidthBytes);
      end;
      Result := True;
    finally
      FreeMemNil(Buff);
    end;
    if OldFmt <> Format then
      ConvertImage(Image, OldFmt);
  except
    RaiseImaging(SErrorFlipImage, [ImageToStr(Image)]);
  end;
end;

function MirrorImage(var Image: TImageData): Boolean;
var
  Scanline: PByte;
  Buff: TColorFPRec;
  Bpp, Y, X, WidthDiv2, WidthBytes, XLeft, XRight: LongInt;
  OldFmt: TImageFormat;
begin
  Result := False;
  OldFmt := Image.Format;
  if TestImage(Image) then
  with Image do
  try
    if ImageFormatInfos[OldFmt].IsSpecial then
      ConvertImage(Image, ifDefault);
    Bpp := ImageFormatInfos[Format].BytesPerPixel;
    WidthDiv2 := Width div 2;
    WidthBytes := Width * Bpp;
    // mirror all pixels on each scanline of image
    for Y := 0 to Height - 1 do
    begin
      Scanline := @PByteArray(Bits)[Y * WidthBytes];
      XLeft := 0;
      XRight := (Width - 1) * Bpp;
      for X := 0 to WidthDiv2 - 1 do
      begin
        CopyPixel(@PByteArray(Scanline)[XLeft], @Buff, Bpp);
        CopyPixel(@PByteArray(Scanline)[XRight],
          @PByteArray(Scanline)[XLeft], Bpp);
        CopyPixel(@Buff, @PByteArray(Scanline)[XRight], Bpp);
        Inc(XLeft, Bpp);
        Dec(XRight, Bpp);
      end;
    end;
    Result := True;
    if OldFmt <> Format then
      ConvertImage(Image, OldFmt);
  except
    RaiseImaging(SErrorMirrorImage, [ImageToStr(Image)]);
  end;
end;

function ResizeImage(var Image: TImageData; NewWidth, NewHeight: LongInt;
  Filter: TResizeFilter): Boolean;
var
  WorkImage: TImageData;
begin
  Result := False;
  if TestImage(Image) and (NewWidth > 0) and (NewHeight > 0) and
    ((Image.Width <> NewWidth) or (Image.Height <> NewHeight)) then
  with Image do
  try
    InitImage(WorkImage);
    // Create new image with desired dimensions
    NewImage(NewWidth, NewHeight, Image.Format, WorkImage);
    // Stretch pixels from old image to new one
    StretchRect(Image, 0, 0, Image.Width, Image.Height,
      WorkImage, 0, 0, WorkImage.Width, WorkImage.Height, Filter);
    // Free old image and assign new image to it
    FreeMemNil(Image.Bits);
    if Image.Palette <> nil then
      WorkImage.Palette := Image.Palette;
    Image := WorkImage;
    Result := True;
  except
    RaiseImaging(SErrorResizeImage, [ImageToStr(Image)]);
  end;
end;

function SwapChannels(var Image: TImageData; SrcChannel, DstChannel: LongInt): Boolean;
var
  I, NumPixels: LongInt;
  Info: PImageFormatInfo;
  Swap, Alpha: Word;
  Data: PByte;
  Pix64: TColor64Rec;
  PixF: TColorFPRec;
  SwapF: Single;
begin
  Result := False;
  if TestImage(Image) then
  with Image do
  try
    NumPixels := Width * Height;
    Info := ImageFormatInfos[Format];
    Data := Bits;

    // first swap channels of most common formats
    if (Info.Format = ifA8R8G8B8) or ((Info.Format = ifR8G8B8) and
       (SrcChannel <> ChannelAlpha) and (DstChannel <> ChannelAlpha)) then
      for I := 0 to NumPixels - 1 do
        with PColor24Rec(Data)^ do
        begin
          Swap := Channels[SrcChannel];
          Channels[SrcChannel] := Channels[DstChannel];
          Channels[DstChannel] := Swap;
          Inc(Data, Info.BytesPerPixel);
        end
    else
      // swap palette channels of indexed images
      if Info.IsIndexed then
      begin
        SwapChannelsOfPalette(Palette, Info.PaletteEntries, SrcChannel,
          DstChannel)
      end
      else
        // swap channels of floating point images
        if Info.IsFloatingPoint then
        begin
          for I := 0 to NumPixels - 1 do
          begin
            FloatGetSrcPixel(Data, Info, PixF);
            with PixF do
            begin
              SwapF := Channels[SrcChannel];
              Channels[SrcChannel] := Channels[DstChannel];
              Channels[DstChannel] := SwapF;
            end;
            FloatSetDstPixel(Data, Info, PixF);
            Inc(Data, Info.BytesPerPixel);
          end;
        end
        else
          // swap channels of special format images
          if Info.IsSpecial then
          begin
            ConvertImage(Image, ifDefault);
            SwapChannels(Image, SrcChannel, DstChannel);
            ConvertImage(Image, Info.Format);
          end
          else
            if Info.HasGrayChannel and Info.HasAlphaChannel and
              ((SrcChannel = ChannelAlpha) or (DstChannel = ChannelAlpha)) then
              begin
                for I := 0 to NumPixels - 1 do
                begin
                  // if we have grayscale image with alpha and alpha is channel
                  // to be swapped, we swap it
                  GrayGetSrcPixel(Data, Info, Pix64, Alpha);
                  Swap := Alpha;
                  Alpha := Pix64.A;
                  Pix64.A := Swap;
                  GraySetDstPixel(Data, Info, Pix64, Alpha);
                  Inc(Data, Info.BytesPerPixel);
                end;
              end
            else
              // then do general swap on other channel image formats
              for I := 0 to NumPixels - 1 do
              begin
                ChannelGetSrcPixel(Data, Info, Pix64);
                with Pix64 do
                begin
                  Swap := Channels[SrcChannel];
                  Channels[SrcChannel] := Channels[DstChannel];
                  Channels[DstChannel] := Swap;
                end;
                ChannelSetDstPixel(Data, Info, Pix64);
                Inc(Data, Info.BytesPerPixel);
              end;
    Result := True;
  except
    RaiseImaging(SErrorSwapImage, [ImageToStr(Image)]);
  end;
end;

function ReduceColors(var Image: TImageData; MaxColors: LongInt): Boolean;
var
  TmpInfo: TImageFormatInfo;
  Data, Index: PWord;
  I, NumPixels: LongInt;
  Pal: PPalette32;
  Col:PColor32Rec;
  OldFmt: TImageFormat;
begin
  Result := False;
  if TestImage(Image) then
  with Image do
  try
    // first create temp image info and allocate output bits and palette
    MaxColors := Iff(MaxColors > $FFFF, $FFFF, MaxColors);
    OldFmt := Format;
    FillChar(TmpInfo, SizeOf(TmpInfo), 0);
    TmpInfo.PaletteEntries := MaxColors;
    TmpInfo.BytesPerPixel := 2;
    NumPixels := Width * Height;
    GetMem(Data, NumPixels * TmpInfo.BytesPerPixel);
    GetMem(Pal, MaxColors * SizeOf(TColor32Rec));
    ConvertImage(Image, ifA8R8G8B8);
    // we use median cut algorithm to create reduced palette and to
    // fill Data with indices to this palette
    ReduceColorsMedianCut(NumPixels, Bits, PByte(Data),
      ImageFormatInfos[Format], @TmpInfo, MaxColors, ColorReductionMask, Pal);
    Col := Bits;
    Index := Data;
    // then we write reduced colors to the input image
    for I := 0 to NumPixels - 1 do
    begin
      Col.Color := Pal[Index^].Color;
      Inc(Col);
      Inc(Index);
    end;
    FreeMemNil(Data);
    FreeMemNil(Pal);
    // and convert it to its original format
    ConvertImage(Image, OldFmt);
    Result := True;
  except
    RaiseImaging(SErrorReduceColors, [MaxColors, ImageToStr(Image)]);
  end;
end;

function GenerateMipMaps(const Image: TImageData; Levels: LongInt;
  var MipMaps: TDynImageDataArray): Boolean;
var
  Width, Height, I, Count: LongInt;
begin
  Result := False;
  if TestImage(Image) then
  try
    Width := Image.Width;
    Height := Image.Height;
    // We compute number of possible mipmap levels and if
    // the given levels are invalid or zero we use this value
    Count := GetNumMipMapLevels(Width, Height);
    if (Levels <= 0) or (Levels > Count) then
      Levels := Count;

    FreeImagesInArray(MipMaps);
    SetLength(MipMaps, Levels);
    CloneImage(Image, MipMaps[0]);

    for I := 1 to Levels - 1 do
    begin
      Width := Width shr 1;
      Height := Height shr 1;
      if Width < 1 then Width := 1;
      if Height < 1 then Height := 1;
      FillMipMapLevel(MipMaps[I - 1], Width, Height, MipMaps[I]);
    end;
    Result := True;
  except
    RaiseImaging(SErrorGenerateMipMaps, [Levels, ImageToStr(Image)]);
  end;
end;

function MapImageToPalette(var Image: TImageData; Pal: PPalette32;
  Entries: LongInt): Boolean;

  function FindNearestColor(Pal: PPalette32; Entries: LongInt; Col: TColor32Rec): LongInt;
  var
    I, MinDif, Dif: LongInt;
  begin
    Result := 0;
    MinDif := 1020;
    for I := 0 to Entries - 1 do
      with Pal[I] do
      begin
        Dif := Abs(R - Col.R);
        if Dif > MinDif then Continue;
        Dif := Dif + Abs(G - Col.G);
        if Dif > MinDif then Continue;
        Dif := Dif + Abs(B - Col.B);
        if Dif > MinDif then Continue;
        Dif := Dif + Abs(A - Col.A);
        if Dif < MinDif then
        begin
          MinDif := Dif;
          Result := I;
        end;
      end;
  end;

var
  I, MaxEntries: LongInt;
  PIndex: PByte;
  PColor: PColor32Rec;
  CloneARGB: TImageData;
  Info: PImageFormatInfo;
begin
  Result := False;
  if TestImage(Image) and (Entries <= 256) then
  try
    // we create clone of source image in A8R8G8B8 and
    // then recreate source image in ifIndex8 format
    // with palette taken from Pal parameter
    InitImage(CloneARGB);
    CloneImage(Image, CloneARGB);
    ConvertImage(CloneARGB, ifA8R8G8B8);
    FreeImage(Image);
    NewImage(CloneARGB.Width, CloneARGB.Height, ifIndex8, Image);

    Info := ImageFormatInfos[Image.Format];
    MaxEntries := Min(Info.PaletteEntries, Entries);
    Move(Pal^, Image.Palette^, MaxEntries * SizeOf(TColor32Rec));
    PIndex := Image.Bits;
    PColor := CloneARGB.Bits;

    // for every pixel of ARGB clone we find closest color in
    // given palette and assign its index to resulting image's pixel
    // procedure used here is very slow but simple and memory usage friendly
    // (contrary to other methods)
    for I := 0 to Image.Width * Image.Height - 1 do
    begin
      PIndex^ := Byte(FindNearestColor(Image.Palette, MaxEntries, PColor^));
      Inc(PIndex);
      Inc(PColor);
    end;

    FreeImage(CloneARGB);
    Result := True;
  except
    RaiseImaging(SErrorMapImage, [ImageToStr(Image)]);
  end;
end;

function SplitImage(var Image: TImageData; var Chunks: TDynImageDataArray;
  ChunkWidth, ChunkHeight: LongInt; var XChunks, YChunks: LongInt;
  PreserveSize: Boolean; Fill: Pointer): Boolean;
var
  X, Y, XTrunc, YTrunc: LongInt;
  NotOnEdge: Boolean;
  Info: PImageFormatInfo;
  OldFmt: TImageFormat;
begin
  OldFmt := Image.Format;
  Result := False;
  if TestImage(Image) then
  try
    Info := ImageFormatInfos[Image.Format];
    if Info.IsSpecial then
      ConvertImage(Image, ifDefault);

    // we compute make sure that chunks are not larger than source image or negative
    ChunkWidth := ClampInt(ChunkWidth, 0, Image.Width);
    ChunkHeight := ClampInt(ChunkHeight, 0, Image.Height);
    // number of chunks along X and Y axes is computed
    XChunks := Trunc(Ceil(Image.Width / ChunkWidth));
    YChunks := Trunc(Ceil(Image.Height / ChunkHeight));

    FreeImagesInArray(Chunks);
    SetLength(Chunks, XChunks * YChunks);
    // for every chunk we create new image and copy a portion of
    // the source image to it. If chunk is on the edge of the source image
    // we fill enpty space with Fill pixel data if PreserveSize is set or
    // make the chunk smaller if it is not set
    for Y := 0 to YChunks - 1 do
      for X := 0 to XChunks - 1 do
      begin
        NotOnEdge := ((X < XChunks - 1) and (Y < YChunks - 1)) or
          ((Image.Width mod ChunkWidth = 0) and (Image.Height mod ChunkHeight = 0));

        if PreserveSize or NotOnEdge then
        begin
          NewImage(ChunkWidth, ChunkHeight, Image.Format, Chunks[Y * XChunks + X]);
          if (not NotOnEdge) and (Fill <> nil) then
            FillRect(Chunks[Y * XChunks + X], 0, 0, ChunkWidth, ChunkHeight, Fill);
          CopyRect(Image, X * ChunkWidth, Y * ChunkHeight, ChunkWidth, ChunkHeight,
            Chunks[Y * XChunks + X], 0, 0);
        end
        else
        begin
          XTrunc := Image.Width - (Image.Width div ChunkWidth) * ChunkWidth;
          YTrunc := Image.Height - (Image.Height div ChunkHeight) * ChunkHeight;
          NewImage(XTrunc, YTrunc, Image.Format, Chunks[Y * XChunks + X]);
          CopyRect(Image, X * ChunkWidth, Y * ChunkHeight, XTrunc, YTrunc,
            Chunks[Y * XChunks + X], 0, 0);
        end;
        // if source image is in indexed format we copy its palette to chunk
        if Info.IsIndexed then
        begin
          Move(Image.Palette^, Chunks[Y * XChunks + X].Palette^,
            Info.PaletteEntries * SizeOf(TColor32Rec));
        end;
      end;

    if OldFmt <> Image.Format then
    begin
      ConvertImage(Image, OldFmt);
      for X := 0 to Length(Chunks) - 1 do
        ConvertImage(Chunks[X], OldFmt);
    end;

    Result := True;
  except
    RaiseImaging(SErrorSplitImage, [ImageToStr(Image), ChunkWidth, ChunkHeight]);
  end;
end;

function MakePaletteForImages(var Images: TDynImageDataArray; Pal: PPalette32;
  MaxColors: LongInt; ConvertImages: Boolean): Boolean;
var
  I: LongInt;
  SrcInfo, DstInfo: PImageFormatInfo;
  Target: TImageData;
  DstFormat: TImageFormat;
begin
  Result := False;
  if TestImagesInArray(Images) then
  try
    // null the color histogram
    ReduceColorsMedianCut(0, nil, nil, nil, nil, 0, 0, nil, [raCreateHistogram]);
    for I := 0 to Length(Images) - 1 do
    begin
      SrcInfo := ImageFormatInfos[Images[I].Format];
      // update histogram with colors of each input image
      ReduceColorsMedianCut(Images[I].Width * Images[I].Height, Images[I].Bits,
        nil, SrcInfo, nil, MaxColors, ColorReductionMask, nil, [raUpdateHistogram]);
    end;
    // construct reduced color map from the histogram
    ReduceColorsMedianCut(0, nil, nil, nil, nil, MaxColors, ColorReductionMask,
      Pal, [raMakeColorMap]);

    if ConvertImages then
    begin
      DstFormat := ifIndex8;
      DstInfo := ImageFormatInfos[DstFormat];
      MaxColors := Min(DstInfo.PaletteEntries, MaxColors);
      for I := 0 to Length(Images) - 1 do
      begin
        SrcInfo := ImageFormatInfos[Images[I].Format];
        InitImage(Target);
        NewImage(Images[I].Width, Images[I].Height, DstFormat, Target);
        // we map each input image to reduced palette and replace
        // image in array with mapped image
        ReduceColorsMedianCut(Images[I].Width * Images[I].Height, Images[I].Bits,
          Target.Bits, SrcInfo, DstInfo, MaxColors, 0, nil, [raMapImage]);
        Move(Pal^, Target.Palette^, MaxColors * SizeOf(TColor32Rec));
        FreeImage(Images[I]);
        Images[I] := Target;
      end;
    end;
    Result := True;
  except
    RaiseImaging(SErrorMakePaletteForImages, [MaxColors, Length(Images)]);
  end;
end;

function RotateImage(var Image: TImageData; Angle: LongInt): Boolean;
var
  X, Y, BytesPerPixel: LongInt;
  RotImage: TImageData;
  Pix, RotPix: PByte;
  OldFmt: TImageFormat;
begin
  Result := False;
  if TestImage(Image) then
  try
    if (Angle < -360) or (Angle > 360) then Angle := Angle mod 360;
    if (Angle = 0) or (Abs(Angle) = 360) then
    begin
      Result := True;
      Exit;
    end;

    Angle := Iff(Angle = -90, 270, Angle);
    Angle := Iff(Angle = -270, 90, Angle);
    Angle := Iff(Angle = -180, 180, Angle);

    OldFmt := Image.Format;
    if ImageFormatInfos[Image.Format].IsSpecial then
      ConvertImage(Image, ifDefault);

    InitImage(RotImage);
    BytesPerPixel := ImageFormatInfos[Image.Format].BytesPerPixel;

    if ((Angle = 90) or (Angle = 270)) and (Image.Width <> Image.Height) then
      NewImage(Image.Height, Image.Width, Image.Format, RotImage)
    else
      NewImage(Image.Width, Image.Height, Image.Format, RotImage);

    RotPix := RotImage.Bits;
    case Angle of
      90:
        begin
          for Y := 0 to RotImage.Height - 1 do
          begin
            Pix := @PByteArray(Image.Bits)[(Image.Width - Y - 1) * BytesPerPixel];
            for X := 0 to RotImage.Width - 1 do
            begin
              CopyPixel(Pix, RotPix, BytesPerPixel);
              Inc(RotPix, BytesPerPixel);
              Inc(Pix, Image.Width * BytesPerPixel);
            end;
          end;
        end;
      180:
        begin
          Pix := @PByteArray(Image.Bits)[((Image.Height - 1) * Image.Width +
            (Image.Width - 1)) * BytesPerPixel];
          for Y := 0 to RotImage.Height - 1 do
            for X := 0 to RotImage.Width - 1 do
            begin
              CopyPixel(Pix, RotPix, BytesPerPixel);
              Inc(RotPix, BytesPerPixel);
              Dec(Pix, BytesPerPixel);
            end;
        end;
      270:
        begin
          for Y := 0 to RotImage.Height - 1 do
          begin
            Pix := @PByteArray(Image.Bits)[((Image.Height - 1) * Image.Width +
              Y) * BytesPerPixel];
            for X := 0 to RotImage.Width - 1 do
            begin
              CopyPixel(Pix, RotPix, BytesPerPixel);
              Inc(RotPix, BytesPerPixel);
              Dec(Pix, Image.Width * BytesPerPixel);
            end;
          end;
        end;
    end;

    FreeMemNil(Image.Bits);
    RotImage.Palette := Image.Palette;
    Image := RotImage;

    if OldFmt <> Image.Format then
      ConvertImage(Image, OldFmt);

    Result := True;
  except
    RaiseImaging(SErrorRotateImage, [ImageToStr(Image), Angle]);
  end;
end;

{ Drawing/Pixel functions }

function CopyRect(const SrcImage: TImageData; SrcX, SrcY, Width, Height: LongInt;
  var DstImage: TImageData; DstX, DstY: LongInt): Boolean;
var
  Info: PImageFormatInfo;
  I, SrcWidthBytes, DstWidthBytes, MoveBytes: LongInt;
  SrcPointer, DstPointer: PByte;
  WorkImage: TImageData;
  OldFormat: TImageFormat;
begin
  Result := False;
  OldFormat := ifUnknown;
  if TestImage(SrcImage) and TestImage(DstImage) then
  try
    Info := ImageFormatInfos[DstImage.Format];
    if Info.IsSpecial then
    begin
      // if dest image is in special format we convert it to default
      OldFormat := Info.Format;
      ConvertImage(DstImage, ifDefault);
      Info := ImageFormatInfos[DstImage.Format];
    end;
    if SrcImage.Format <> DstImage.Format then
    begin
      // If images are in different format source is converted to dest's format
      InitImage(WorkImage);
      CloneImage(SrcImage, WorkImage);
      ConvertImage(WorkImage, DstImage.Format);
    end
    else
      WorkImage := SrcImage;

    // make sure we are still copying image to image, not invalid pointer to protected memory
    ClipCopyBounds(SrcX, SrcY, Width, Height, DstX, DstY, SrcImage.Width, SrcImage.Height,
      Rect(0, 0, DstImage.Width, DstImage.Height));
  
    if (Width > 0) and (Height > 0) then
    begin
      MoveBytes := Width * Info.BytesPerPixel;
      DstWidthBytes := DstImage.Width * Info.BytesPerPixel;
      DstPointer := @PByteArray(DstImage.Bits)[DstY * DstWidthBytes +
        DstX * Info.BytesPerPixel];
      SrcWidthBytes := WorkImage.Width * Info.BytesPerPixel;
      SrcPointer := @PByteArray(WorkImage.Bits)[SrcY * SrcWidthBytes +
        SrcX * Info.BytesPerPixel];

      for I := 0 to Height - 1 do
      begin
        Move(SrcPointer^, DstPointer^, MoveBytes);
        Inc(SrcPointer, SrcWidthBytes);
        Inc(DstPointer, DstWidthBytes);
      end;
      // If dest image was in special format we convert it back
      if OldFormat <> ifUnknown then
        ConvertImage(DstImage, OldFormat);
      // Working image must be freed if it is not the same as source image
      if WorkImage.Bits <> SrcImage.Bits then
        FreeImage(WorkImage);
    end;
    Result := True;
  except
    RaiseImaging(SErrorCopyRect, [ImageToStr(SrcImage), ImageToStr(DstImage)]);
  end;
end;

function FillRect(var Image: TImageData; X, Y, Width, Height: LongInt;
  FillColor: Pointer): Boolean;
var
  Info: PImageFormatInfo;
  I, J, ImageWidthBytes, RectWidthBytes, Bpp: Longint;
  LinePointer, PixPointer: PByte;
  OldFmt: TImageFormat;
begin
  Result := False;
  if TestImage(Image) then
  try
    ClipRectBounds(X, Y, Width, Height, Rect(0, 0, Image.Width, Image.Height));

    if (Width > 0) and (Height > 0) then
    begin
      OldFmt := Image.Format;
      if ImageFormatInfos[OldFmt].IsSpecial then
        ConvertImage(Image, ifDefault);

      Info := ImageFormatInfos[Image.Format];
      Bpp := Info.BytesPerPixel;
      ImageWidthBytes := Image.Width * Bpp;
      RectWidthBytes := Width * Bpp;
      LinePointer := @PByteArray(Image.Bits)[Y * ImageWidthBytes + X * Bpp];

      for I := 0 to Height - 1 do
      begin
        case Bpp of
          1: FillMemory(LinePointer, RectWidthBytes, PByte(FillColor)^);
          2: FillMemoryWord(LinePointer, RectWidthBytes, PWord(FillColor)^);
          4: FillMemoryLongWord(LinePointer, RectWidthBytes, PLongWord(FillColor)^);
        else
          PixPointer := LinePointer;
          for J := 0 to Width - 1 do
          begin
            CopyPixel(FillColor, PixPointer, Bpp);
            Inc(PixPointer, Bpp);
          end;
        end;
        Inc(LinePointer, ImageWidthBytes);
      end;

      if OldFmt <> Image.Format then
        ConvertImage(Image, OldFmt);
    end;

    Result := True;
  except
    RaiseImaging(SErrorFillRect, [X, Y, Width, Height, ImageToStr(Image)]);
  end;
end;

function ReplaceColor(var Image: TImageData; X, Y, Width, Height: LongInt;
  OldColor, NewColor: Pointer): Boolean;
var
  Info: PImageFormatInfo;
  I, J, WidthBytes, Bpp: Longint;
  LinePointer, PixPointer: PByte;
  OldFmt: TImageFormat;
begin
  Result := False;
  if TestImage(Image) then
  try
    ClipRectBounds(X, Y, Width, Height, Rect(0, 0, Image.Width, Image.Height));

    if (Width > 0) and (Height > 0) then
    begin
      OldFmt := Image.Format;
      if ImageFormatInfos[OldFmt].IsSpecial then
        ConvertImage(Image, ifDefault);

      Info := ImageFormatInfos[Image.Format];
      Bpp := Info.BytesPerPixel;
      WidthBytes := Image.Width * Bpp;
      LinePointer := @PByteArray(Image.Bits)[Y * WidthBytes + X * Bpp];

      for I := 0 to Height - 1 do
      begin
        PixPointer := LinePointer;
        for J := 0 to Width - 1 do
        begin
          if ComparePixels(PixPointer, OldColor, Bpp) then
            CopyPixel(NewColor, PixPointer, Bpp);
          Inc(PixPointer, Bpp);
        end;
        Inc(LinePointer, WidthBytes);
      end;

      if OldFmt <> Image.Format then
        ConvertImage(Image, OldFmt);
    end;

    Result := True;
  except
    RaiseImaging(SErrorReplaceColor, [X, Y, Width, Height, ImageToStr(Image)]);
  end;
end;

function StretchRect(const SrcImage: TImageData; SrcX, SrcY, SrcWidth,
  SrcHeight: LongInt; var DstImage: TImageData; DstX, DstY, DstWidth,
  DstHeight: LongInt; Filter: TResizeFilter): Boolean;
var
  Info: PImageFormatInfo;
  WorkImage: TImageData;
  OldFormat: TImageFormat;
begin
  Result := False;
  OldFormat := ifUnknown;
  if (SrcWidth <> DstWidth) or (SrcHeight <> DstHeight) then
  begin
    // If source and dest rectangles don't have the same size we do stretch
    if TestImage(SrcImage) and TestImage(DstImage) then
    try
      Info := ImageFormatInfos[DstImage.Format];

      if Info.IsSpecial then
      begin
        // If dest image is in special format we convert it to default
        OldFormat := Info.Format;
        ConvertImage(DstImage, ifDefault);
        Info := ImageFormatInfos[DstImage.Format];
      end;

      if SrcImage.Format <> DstImage.Format then
      begin
        // If images are in different format source is converted to dest's format
        InitImage(WorkImage);
        CloneImage(SrcImage, WorkImage);
        ConvertImage(WorkImage, DstImage.Format);
      end
      else
        WorkImage := SrcImage;

      // Make sure we are still copying image to image, not invalid pointer to protected memory
      ClipStretchBounds(SrcX, SrcY, SrcWidth, SrcHeight, DstX, DstY, DstWidth, DstHeight,
        SrcImage.Width, SrcImage.Height, Rect(0, 0, DstImage.Width, DstImage.Height));

      // Only pixel resize is supported for indexed images
      if Info.IsIndexed then
        Filter := rfNearest;

      case Filter of
        rfNearest: StretchNearest(WorkImage, SrcX, SrcY, SrcWidth, SrcHeight,
          DstImage, DstX, DstY, DstWidth, DstHeight);
        rfBilinear: StretchResample(WorkImage, SrcX, SrcY, SrcWidth, SrcHeight,
          DstImage, DstX, DstY, DstWidth, DstHeight, sfLinear);
        rfBicubic: StretchResample(WorkImage, SrcX, SrcY, SrcWidth, SrcHeight,
          DstImage, DstX, DstY, DstWidth, DstHeight, sfCatmullRom);
      end;

      // If dest image was in special format we convert it back
      if OldFormat <> ifUnknown then
        ConvertImage(DstImage, OldFormat);
      // Working image must be freed if it is not the same as source image
      if WorkImage.Bits <> SrcImage.Bits then
        FreeImage(WorkImage);

      Result := True;
    except
      RaiseImaging(SErrorStretchRect, [ImageToStr(SrcImage), ImageToStr(DstImage)]);
    end;
  end
  else
  begin
    // If source and dest rectangles have the same size call CopyRect
    Result := CopyRect(SrcImage, SrcX, SrcY, SrcWidth, SrcHeight, DstImage, DstX, DstY)
  end;
end;

procedure GetPixelDirect(const Image: TImageData; X, Y: LongInt; Pixel: Pointer);
var
  BytesPerPixel: LongInt;
begin
  BytesPerPixel := ImageFormatInfos[Image.Format].BytesPerPixel;
  CopyPixel(@PByteArray(Image.Bits)[(Y * Image.Width + X) * BytesPerPixel],
    Pixel, BytesPerPixel);
end;

procedure SetPixelDirect(const Image: TImageData; X, Y: LongInt; Pixel: Pointer);
var
  BytesPerPixel: LongInt;
begin
  BytesPerPixel := ImageFormatInfos[Image.Format].BytesPerPixel;
  CopyPixel(Pixel, @PByteArray(Image.Bits)[(Y * Image.Width + X) * BytesPerPixel],
    BytesPerPixel);
end;

function GetPixel32(const Image: TImageData; X, Y: LongInt): TColor32Rec;
var
  Info: PImageFormatInfo;
  Data: PByte;
begin
  Info := ImageFormatInfos[Image.Format];
  Data := @PByteArray(Image.Bits)[(Y * Image.Width + X) * Info.BytesPerPixel];
  Result := GetPixel32Generic(Data, Info, Image.Palette);
end;

procedure SetPixel32(const Image: TImageData; X, Y: LongInt; const Color: TColor32Rec);
var
  Info: PImageFormatInfo;
  Data: PByte;
begin
  Info := ImageFormatInfos[Image.Format];
  Data := @PByteArray(Image.Bits)[(Y * Image.Width + X) * Info.BytesPerPixel];
  SetPixel32Generic(Data, Info, Image.Palette, Color);
end;

function GetPixelFP(const Image: TImageData; X, Y: LongInt): TColorFPRec;
var
  Info: PImageFormatInfo;
  Data: PByte;
begin
  Info := ImageFormatInfos[Image.Format];
  Data := @PByteArray(Image.Bits)[(Y * Image.Width + X) * Info.BytesPerPixel];
  Result := GetPixelFPGeneric(Data, Info, Image.Palette);
end;

procedure SetPixelFP(const Image: TImageData; X, Y: LongInt; const Color: TColorFPRec);
var
  Info: PImageFormatInfo;
  Data: PByte;
begin
  Info := ImageFormatInfos[Image.Format];
  Data := @PByteArray(Image.Bits)[(Y * Image.Width + X) * Info.BytesPerPixel];
  SetPixelFPGeneric(Data, Info, Image.Palette, Color);
end;

{ Palette Functions }

function NewPalette(Entries: LongInt; var Pal: PPalette32): Boolean;
begin
  Result := False;
  try
    GetMem(Pal, Entries * SizeOf(TColor32Rec));
    FillChar(Pal^, Entries * SizeOf(TColor32Rec), $FF);
    Result := True;
  except
    RaiseImaging(SErrorNewPalette, [Entries]);
  end;
end;

function FreePalette(var Pal: PPalette32): Boolean;
begin
  Result := False;
  try
    FreeMemNil(Pal);
    Result := True;
  except
    RaiseImaging(SErrorFreePalette, [Pal]);
  end;
end;

function CopyPalette(SrcPal, DstPal: PPalette32; SrcIdx, DstIdx, Count: LongInt): Boolean;
begin
  Result := False;
  try
    Move(SrcPal[SrcIdx], DstPal[DstIdx], Count * SizeOf(TColor32Rec));
    Result := True;
  except
    RaiseImaging(SErrorCopyPalette, [Count, SrcPal, DstPal]);
  end;
end;

function FindColor(Pal: PPalette32; Entries: LongInt; Color: TColor32):
  LongInt;
var
  Col: TColor32Rec;
  I, MinDif, Dif: LongInt;
begin
  Result := 0;
  Col.Color := Color;
  if Pal <> nil then
  try
    // first try to find exact match
    for I := 0 to Entries - 1 do
      with Pal[I] do
      begin
        if (A = Col.A) and (R = Col.R) and
          (G = Col.G) and (B = Col.B) then
        begin
          Result := I;
          Exit;
        end;
      end;

    // if exact match was not found, find nearest color
    MinDif := 1020;
    for I := 0 to Entries - 1 do
      with Pal[I] do
      begin
        Dif := Abs(R - Col.R);
        if Dif > MinDif then Continue;
        Dif := Dif + Abs(G - Col.G);
        if Dif > MinDif then Continue;
        Dif := Dif + Abs(B - Col.B);
        if Dif > MinDif then Continue;
        Dif := Dif + Abs(A - Col.A);
        if Dif < MinDif then
        begin
          MinDif := Dif;
          Result := I;
        end;
      end;
  except
    RaiseImaging(SErrorFindColor, [Pal, Entries]);
  end;
end;

function FillGrayscalePalette(Pal: PPalette32; Entries: LongInt): Boolean;
var
  I: LongInt;
begin
  Result := False;
  if Pal <> nil then
  try
    for I := 0 to Entries - 1 do
      with Pal[I] do
      begin
        A := $FF;
        R := Byte(I);
        G := Byte(I);
        B := Byte(I);
      end;
      Result := True;
  except
     RaiseImaging(SErrorGrayscalePalette, [Pal, Entries]);
  end;
end;

function FillCustomPalette(Pal: PPalette32; Entries: LongInt; RBits, GBits,
  BBits: Byte; Alpha: Byte = $FF): Boolean;
var
  I, TotalBits, MaxEntries: LongInt;
begin
  Result := False;
  TotalBits := RBits + GBits + BBits;
  MaxEntries := Min(Pow2Int(TotalBits), Entries);
  FillChar(Pal^, Entries * SizeOf(TColor32Rec), 0);  
  if Pal <> nil then
  try
    for I := 0 to MaxEntries - 1 do
      with Pal[I] do
      begin
        A := Alpha;
        if RBits > 0 then
          R := ((I shr Max(0, GBits + BBits - 1)) and (1 shl RBits - 1)) * 255 div (1 shl RBits - 1);
        if GBits > 0 then
          G := ((I shr Max(0, BBits - 1)) and (1 shl GBits - 1)) * 255 div (1 shl GBits - 1);
        if BBits > 0 then
          B := ((I shr 0) and (1 shl BBits - 1)) * 255 div (1 shl BBits - 1);
      end;
      Result := True;
  except
     RaiseImaging(SErrorCustomPalette, [Pal, Entries]);
  end;
end;

function SwapChannelsOfPalette(Pal: PPalette32; Entries, SrcChannel,
  DstChannel: LongInt): Boolean;
var
  I: LongInt;
  Swap: Byte;
begin
  Result := False;
  if Pal <> nil then
  try
    for I := 0 to Entries - 1 do
      with Pal[I] do
      begin
        Swap := Channels[SrcChannel];
        Channels[SrcChannel] := Channels[DstChannel];
        Channels[DstChannel] := Swap;
      end;
      Result := True;
  except
     RaiseImaging(SErrorSwapPalette, [Pal, Entries]);
  end;
end;

{ Options Functions }

function SetOption(OptionId, Value: LongInt): Boolean;
begin
  Result := False;
  if (OptionId >= 0) and (OptionId < Length(Options)) and
    (Options[OptionID] <> nil) then
  begin
    Options[OptionID]^ := CheckOptionValue(OptionId, Value);
    Result := True;
  end;
end;

function GetOption(OptionId: LongInt): LongInt;
begin
  Result := InvalidOption;
  if (OptionId >= 0) and (OptionId < Length(Options)) and
    (Options[OptionID] <> nil) then
    Result := Options[OptionID]^;
end;

function PushOptions: Boolean;
begin
  Result := OptionStack.Push;
end;

function PopOptions: Boolean;
begin
  Result := OptionStack.Pop;
end;

{ Image Format Functions }

function GetImageFormatInfo(Format: TImageFormat; var Info: TImageFormatInfo): Boolean;
begin
  FillChar(Info, SizeOf(Info), 0);
  if ImageFormatInfos[Format] <> nil then
  begin
    Info := ImageFormatInfos[Format]^;
    Result := True;
  end
  else
    Result := False;
end;

function GetPixelsSize(Format: TImageFormat; Width, Height: LongInt): LongInt;
begin
  if ImageFormatInfos[Format] <> nil then
    Result := ImageFormatInfos[Format].GetPixelsSize(Format, Width, Height)
  else
    Result := 0;
end;

{ IO Functions }

procedure SetUserFileIO(OpenReadProc: TOpenReadProc; OpenWriteProc:
  TOpenWriteProc;
  CloseProc: TCloseProc; EofProc: TEofProc; SeekProc: TSeekProc; TellProc:
  TTellProc; ReadProc: TReadProc; WriteProc: TWriteProc);
begin
  FileIO.OpenRead := OpenReadProc;
  FileIO.OpenWrite := OpenWriteProc;
  FileIO.Close := CloseProc;
  FileIO.Eof := EofProc;
  FileIO.Seek := SeekProc;
  FileIO.Tell := TellProc;
  FileIO.Read := ReadProc;
  FileIO.Write := WriteProc;
end;

procedure ResetFileIO;
begin
  FileIO := OriginalFileIO;
end;


{ ------------------------------------------------------------------------
                           Other Imaging Stuff
  ------------------------------------------------------------------------}

function GetFormatName(Format: TImageFormat): string;
begin
  if ImageFormatInfos[Format] <> nil then
    Result := ImageFormatInfos[Format].Name
  else
    Result := SUnknownFormat;
end;

function ImageToStr(const Image: TImageData): string;
begin
  if TestImage(Image) then
  begin
    with Image do
      Result := SysUtils.Format(SImageInfo, [@Image, Width, Height,
        GetFormatName(Format), (Size div 1024) + 0.0, Bits, Palette]);
  end
  else
    Result := SysUtils.Format(SImageInfoInvalid, [@Image]);
end;

function GetVersionStr: string;
begin
  Result := Format('%.1d.%.2d.%.1d', [ImagingVersionMajor, ImagingVersionMinor, ImagingVersionPatch]);
end;

function IffFormat(Condition: Boolean; const TruePart, FalsePart: TImageFormat): TImageFormat;
begin
  if Condition then
    Result := TruePart
  else
    Result := FalsePart;
end;

procedure RegisterImageFileFormat(AClass: TImageFileFormatClass);
begin
  Assert(AClass <> nil);
  if ImageFileFormats = nil then
    ImageFileFormats := TList.Create;
  if ImageFileFormats <> nil then
    ImageFileFormats.Add(AClass.Create);
end;

procedure RegisterOption(OptionId: LongInt; Variable: PLongInt);
begin
  if Options = nil then
    InitOptions;

  if Options <> nil then
  begin
    if OptionId >= Length(Options) then
      SetLength(Options, OptionId + InitialOptions);
    if (OptionId >= 0) and (OptionId < Length(Options)) and (Options[OptionId] = nil) then
      Options[OptionId] := Variable;
  end;
end;

function FindImageFileFormat(const Ext: string): TImageFileFormat;
var
  I: LongInt;
begin
  Result := nil;
  for I := 0 to ImageFileFormats.Count - 1 do
    if TImageFileFormat(ImageFileFormats[I]).Extensions.IndexOf(Ext) >= 0 then
    begin
      Result := TImageFileFormat(ImageFileFormats[I]);
      Break;
    end;
end;

function FindImageFileFormat(AClass: TImageFileFormatClass): TImageFileFormat;
var
  I: LongInt;
begin
  Result := nil;
  for I := 0 to ImageFileFormats.Count - 1 do
    if TImageFileFormat(ImageFileFormats[I]) is AClass then
    begin
      Result := TObject(ImageFileFormats[I]) as TImageFileFormat;
      Break;
    end;
end;

function GetImageFileFormatsFilter(AllFilter: Boolean): string;
var
  I, J: LongInt;
  Descriptions: string;
  Filters, CurFilter: string;
  FileFormat: TImageFileFormat;
begin
  Descriptions := '';
  Filters := '';
  for I := 0 to ImageFileFormats.Count - 1 do
  begin
    FileFormat := TObject(ImageFileFormats[I]) as TImageFileFormat;
    CurFilter := '';

    for J := 0 to FileFormat.Extensions.Count - 1 do
    begin
      CurFilter := CurFilter + Format('*.%s', [FileFormat.Extensions[J]]);
      if J < FileFormat.Extensions.Count - 1 then
        CurFilter := CurFilter + ';';
    end;

    FmtStr(Descriptions, '%s%s (%s)|%2:s', [Descriptions, FileFormat.Name, CurFilter]);
    FmtStr(Filters, '%s;%s', [Filters, CurFilter]);

    if I < ImageFileFormats.Count - 1 then
        Descriptions := Descriptions + '|';
  end;

  if (ImageFileFormats.Count > 1) and AllFilter then
    FmtStr(Descriptions, '%s (%s)|%1:s|%s', [SAllFilter, Filters, Descriptions]);

  Result := Descriptions;  
end;

function GetFilterIndexExtension(Index: LongInt; AllFilter: Boolean): string;
var
  FileFormat: TImageFileFormat;
begin
  Index := Index - 1;
  if AllFilter then
  begin
    if Index > 0 then
      Index := Index - 1;
  end;

  if (Index >= 0) and (Index < ImageFileFormats.Count) then
  begin
    FileFormat := TObject(ImageFileFormats[Index]) as TImageFileFormat;
    if FileFormat.Extensions.Count > 0 then
      Result := FileFormat.Extensions[0]
    else
      Result := '';
  end
  else
    Result := '';
end;

function GetExtensionFilterIndex(const Ext: string; AllFilter: Boolean): LongInt;
var
  FileFormat: TImageFileFormat;
begin
  FileFormat := FindImageFileFormat(Ext);
  if FileFormat <> nil then
  begin
    Result := ImageFileFormats.IndexOf(FileFormat) + 1;
    if AllFilter then
      Inc(Result);
  end
  else
    Result := -1;
end;

function GetIO: TIOFunctions;
begin
  Result := IO;
end;

procedure RaiseImaging(const Msg: string; const Args: array of const);
{$IFDEF RAISE_EXCEPTIONS}
var
  WholeMsg: string;
begin
  WholeMsg := Msg;
  if GetExceptObject <> nil then
    WholeMsg := WholeMsg + ' ' + SExceptMsg + ': ' +
      GetExceptObject.Message;
  raise EImagingError.CreateFmt(WholeMsg, Args);
end;
{$ELSE}
begin
end;
{$ENDIF}

{ Internal unit functions }

function CheckOptionValue(OptionId, Value: LongInt): LongInt;
begin
  case OptionId of
    ImagingColorReductionMask:
      Result := ClampInt(Value, 0, $FF);
    ImagingLoadOverrideFormat, ImagingSaveOverrideFormat:
      Result := Iff(ImagingFormats.IsImageFormatValid(TImageFormat(Value)),
        Value, LongInt(ifUnknown));
    ImagingMipMapFilter: Result := ClampInt(Value, Ord(Low(TSamplingFilter)),
        Ord(High(TSamplingFilter)));
  else
    Result := Value;
  end;
end;

procedure SetFileIO;
begin
  IO := FileIO;
end;

procedure SetStreamIO;
begin
  IO := StreamIO;
end;

procedure SetMemoryIO;
begin
  IO := MemoryIO;
end;

procedure InitImageFormats;
begin
  ImagingFormats.InitImageFormats(ImageFormatInfos);
end;

procedure FreeImageFileFormats;
var
  I: LongInt;
begin
  if ImageFileFormats <> nil then
    for I := 0 to ImageFileFormats.Count - 1 do
      TImageFileFormat(ImageFileFormats[I]).Free;
  FreeAndNil(ImageFileFormats);
end;

procedure InitOptions;
begin
  SetLength(Options, InitialOptions);
  OptionStack := TOptionStack.Create;
end;

procedure FreeOptions;
begin
  SetLength(Options, 0);
  FreeAndNil(OptionStack);
end;

{ TImageFileFormat class implementation }

constructor TImageFileFormat.Create;
begin
  inherited Create;
  FName := SUnknownFormat;
  FExtensions := TStringList.Create;
end;

destructor TImageFileFormat.Destroy;
begin
  FExtensions.Free;
  inherited Destroy;
end;

procedure TImageFileFormat.AddExtensions(const AExtensions: string);
begin
  FExtensions.CommaText := AExtensions;
end;

function TImageFileFormat.GetFormatInfo(Format: TImageFormat): PImageFormatInfo;
begin
  Result := ImageFormatInfos[Format];
end;

function TImageFileFormat.GetSupportedFormats: TImageFormats;
begin
  Result := [];
end;

procedure TImageFileFormat.LoadData(Handle: TImagingHandle;
  var Images: TDynImageDataArray; OnlyFirstFrame: Boolean);
begin
  RaiseImaging(SFileFormatCanNotLoad, [FName]);
end;

function TImageFileFormat.LoadFromFile(const FileName: string;
  var Images: TDynImageDataArray; OnlyFirstLevel: Boolean): Boolean;
var
  I: LongInt;
  Handle: TImagingHandle;
begin
  Result := False;
  if FCanLoad then
  try
    // set IO ops to file ops and open given file
    SetFileIO;
    Handle := IO.OpenRead(PChar(FileName));
    try
      // test if file contains valid image and if so then load it
      if TestFormat(Handle) then
      begin
        LoadData(Handle, Images, OnlyFirstlevel);
        Result := True;
      end
      else
        RaiseImaging(SFileNotValid, [FileName, Name]);
    finally
      IO.Close(Handle);
    end;
    // convert to overriden format if set
    if LoadOverrideFormat <> ifUnknown then
      for I := 0 to Length(Images) - 1 do
        ConvertImage(Images[I], LoadOverrideFormat);
  except
    RaiseImaging(SErrorLoadingFile, [FileName]);
  end;
end;

function TImageFileFormat.LoadFromStream(Stream: TStream;
  var Images: TDynImageDataArray; OnlyFirstLevel: Boolean): Boolean;
var
  I: LongInt;
  Handle: TImagingHandle;
  OldPosition: Int64;
begin
  Result := False;
  OldPosition := Stream.Position;
  if FCanLoad then
  try
    // set IO ops to stream ops and "open" given memory
    SetStreamIO;
    Handle := IO.OpenRead(Pointer(Stream));
    if TestFormat(Handle) then
    begin
      // test if stream contains valid image and if so then load it
      LoadData(Handle, Images, OnlyFirstlevel);
      Result := True;
    end
    else
      RaiseImaging(SStreamNotValid, [@Stream, Name]);
    IO.Close(Handle);
    // convert to overriden format if set
    if LoadOverrideFormat <> ifUnknown then
      for I := 0 to Length(Images) - 1 do
        ConvertImage(Images[I], LoadOverrideFormat);
  except
    Stream.Position := OldPosition;
    RaiseImaging(SErrorLoadingStream, [@Stream]);
  end;
end;

function TImageFileFormat.LoadFromMemory(Data: Pointer; Size: LongInt; var
  Images: TDynImageDataArray; OnlyFirstLevel: Boolean): Boolean;
var
  I: LongInt;
  Handle: TImagingHandle;
  IORec: TMemoryIORec;
begin
  Result := False;
  if FCanLoad then
  try
    // set IO ops to memory ops and "open" given memory
    SetMemoryIO;
    IORec.Data := Data;
    IORec.Position := 0;
    IORec.Size := Size;
    Handle := IO.OpenRead(@IORec);
    if TestFormat(Handle) then
    begin
      // test if memory contains valid image and if so then load it
      LoadData(Handle, Images, OnlyFirstlevel);
      Result := True;
    end
    else
      RaiseImaging(SMemoryNotValid, [Data, Size, Name]);
    IO.Close(Handle);
    // convert to overriden format if set
    if LoadOverrideFormat <> ifUnknown then
      for I := 0 to Length(Images) - 1 do
        ConvertImage(Images[I], LoadOverrideFormat);
  except
    RaiseImaging(SErrorLoadingMemory, [Data, Size]);
  end;
end;

function TImageFileFormat.MakeCompatible(const Image: TImageData;
  var Comp: TImageData): Boolean;
begin
  InitImage(Comp);
  if (SaveOverrideFormat in GetSupportedFormats) and
    (SaveOverrideFormat <> Image.Format) then
  begin
    CloneImage(Image, Comp);
    ConvertImage(Comp, SaveOverrideFormat);
    Result := True;
  end
  else
    if Image.Format in GetSupportedFormats then
    begin
      Comp := Image;
      Result := True;
    end
    else
    begin
      CloneImage(Image, Comp);
      Result := False;
    end;
end;

function TImageFileFormat.TestFormat(Handle: TImagingHandle): Boolean;
begin
  Result := False;
end;

procedure TImageFileFormat.SaveData(Handle: TImagingHandle;
  const Images: TDynImageDataArray; Index: LongInt);
begin
  RaiseImaging(SFileFormatCanNotSave, [FName]);
end;

function TImageFileFormat.SaveToFile(const FileName: string;
  const Images: TDynImageDataArray; OnlyFirstLevel: Boolean): Boolean;
var
  Handle: TImagingHandle;
  Len, I: LongInt;
  Ext, FName: string;
begin
  Result := False;
  if FCanSave and TestImagesInArray(Images) then
  try
    SetFileIO;
    Len := Length(Images);
    if ((not FIsMultiImageFormat) and (OnlyFirstLevel or (Len = 1))) or
      FIsMultiImageFormat then
    begin
      // write multi image to one file
      Handle := IO.OpenWrite(PChar(FileName));
      try
        if OnlyFirstLevel then
          SaveData(Handle, Images, 0)
        else
          SaveData(Handle, Images);
      finally
        IO.Close(Handle);
      end;
    end
    else
    begin
      // write multi image to file sequence
      Ext := ExtractFileExt(FileName);
      FName := ChangeFileExt(FileName, '');
      for I := 0 to Len - 1 do
      begin
        Handle := IO.OpenWrite(PChar(Format(FName + '%.3d' + Ext, [I])));
        try
          SaveData(Handle, Images, I);
        finally
          IO.Close(Handle);
        end;
      end;
    end;
    Result := True;
  except
    RaiseImaging(SErrorSavingFile, [FileName]);
  end;
end;

function TImageFileFormat.SaveToStream(Stream: TStream;
  const Images: TDynImageDataArray; OnlyFirstLevel: Boolean): Boolean;
var
  Handle: TImagingHandle;
  Len, I: LongInt;
  OldPosition: Int64;
begin
  Result := False;
  OldPosition := Stream.Position;
  if FCanSave and TestImagesInArray(Images) then
  try
    SetStreamIO;
    Len := Length(Images);
    Handle := IO.OpenWrite(PChar(Stream));
    if ((not FIsMultiImageFormat) and (OnlyFirstLevel or (Len = 1))) or
      FIsMultiImageFormat then
    begin
      if OnlyFirstLevel then
        SaveData(Handle, Images, 0)
      else
        SaveData(Handle, Images);
    end
    else
      for I := 0 to Len - 1 do
        SaveData(Handle, Images, I);
    IO.Close(Handle);
    Result := True;
  except
    Stream.Position := OldPosition;
    RaiseImaging(SErrorSavingStream, [@Stream]);
  end;
end;

function TImageFileFormat.SaveToMemory(Data: Pointer; var Size: LongInt;
  const Images: TDynImageDataArray; OnlyFirstLevel: Boolean): Boolean;
var
  Handle: TImagingHandle;
  Len, I: LongInt;
  IORec: TMemoryIORec;
begin
  Result := False;
  if FCanSave and TestImagesInArray(Images) then
  try
    SetMemoryIO;
    IORec.Data := Data;
    IORec.Position := 0;
    IORec.Size := Size;
    IORec.Written := 0;
    Len := Length(Images);
    Handle := IO.OpenWrite(PChar(@IORec));
    if ((not FIsMultiImageFormat) and (OnlyFirstLevel or (Len = 1))) or
      FIsMultiImageFormat then
    begin
      if OnlyFirstLevel then
        SaveData(Handle, Images, 0)
      else
        SaveData(Handle, Images);
    end
    else
      for I := 0 to Len - 1 do
        SaveData(Handle, Images, I);
    IO.Close(Handle);
    Size := IORec.Written;
    Result := True;
  except
    RaiseImaging(SErrorSavingMemory, [Data, Size]);
  end;
end;


{ TOptionStack  class implementation }

constructor TOptionStack.Create;
begin
  inherited Create;
  FPosition := -1;
end;

destructor TOptionStack.Destroy;
var
  I: LongInt;
begin
  for I := 0 to OptionStackDepth - 1 do
    SetLength(FStack[I], 0);
  inherited Destroy;
end;

function TOptionStack.Pop: Boolean;
var
  I: LongInt;
begin
  Result := False;
  if FPosition >= 0  then
  begin
    SetLength(Options, Length(FStack[FPosition]));
    for I := 0 to Length(FStack[FPosition]) - 1 do
      if Options[I] <> nil then
        Options[I]^ := FStack[FPosition, I];
    Dec(FPosition);
    Result := True;
  end;
end;

function TOptionStack.Push: Boolean;
var
  I: LongInt;
begin
  Result := False;
  if FPosition < OptionStackDepth - 1 then
  begin
    Inc(FPosition);
    SetLength(FStack[FPosition], Length(Options));
    for I := 0 to Length(Options) - 1 do
      if Options[I] <> nil then
        FStack[FPosition, I] := Options[I]^;
    Result := True;
  end;
end;

initialization
{$IFDEF MEMCHECK}
  {$IF CompilerVersion >= 18}
    System.ReportMemoryLeaksOnShutdown := True;
  {$IFEND}
{$ENDIF}
  InitImageFormats;
  RegisterOption(ImagingColorReductionMask, @ColorReductionMask);
  RegisterOption(ImagingLoadOverrideFormat, @LoadOverrideFormat);
  RegisterOption(ImagingSaveOverrideFormat, @SaveOverrideFormat);
  RegisterOption(ImagingMipMapFilter, @MipMapFilter);
finalization
  FreeOptions;
  FreeImageFileFormats;

{
  File Notes:

  -- TODOS ----------------------------------------------------
    - make searching for the closest color in palette much faster - MapImageToPal
    - investigate CopyPixel and ComparePixels inline problems - line 550
    - add to low level interface function
      CreateImageFromRawData(W, H, Bpp, Data, Align, Flipped, Endian, ...)
      and CreateRawDataFromImage() - use these in BMP loading (align)
      and PNG loading (endian)
    - remove cloning of SrcImage in CopyRect for
      incompatible formats - use CopyPixel rather? test speeds
    - return additional info about loaded image like this
        TicksPerSecond := PMNGDetails(GetOption(ImagingMNGFileDetails)).TicksPerSecond;
    - add some file format enumeration functions (to low level)
    - add loading of multi images from file sequence
    - add some color functions - create, convert, add, merge, ...
    - do not load all frames when only one is required, possible?
      (LoadImageFromFile on MNG/DDS)

  -- 0.19 Changes/Bug Fixes -----------------------------------
    - fixed bug in NewImage: if given format was ifDefault it wasn't
      replaced with DefaultImageFormat constant which caused problems later
      in other units 
    - fixed bug in RotateImage which caused that rotated special format
      images were whole black
    - LoadImageFromXXX and LoadMultiImageFromXXX now use DetermineXXXFormat
      when choosing proper loader, this eliminated need for Ext parameter
      in stream and memory loading functions
    - added GetVersionStr function
    - fixed bug in ResizeImage which caued indexed images to lose their
      palette during process resulting in whole black image
    - Clipping in ...Rect functions now uses clipping procs from ImagingUtility,
      it also works better
    - FillRect optimization for 8, 16, and 32 bit formats
    - added pixel set/get functions to low level interface:
      GetPixelDirect, SetPixelDirect, GetPixel32, SetPixel32,
      GetPixelFP, SetPixelFP
    - removed GetPixelBytes low level intf function - redundant
      (same data can be obtained by GetImageFormatInfo)
    - made small changes in many parts of library to compile
      on AMD64 CPU (Linux with FPC) 
    - changed InitImage to procedure (function was pointless)
    - Method TestFormat of TImageFileFormat class made public
      (was protected)
    - added function IsFileFormatSupported to low level interface
      (contributed by Paul Michell)
    - fixed some missing format arguments from error strings
      which caused Format function to raise exception
    - removed forgotten debug code that disabled filtered resizing of images with
      channel bitcounts > 8

  -- 0.17 Changes/Bug Fixes -----------------------------------
    - changed order of parameters of CopyRect function  
    - GenerateMipMaps now filters mipmap levels
    - ResizeImage functions was extended to allow bilinear and bicubic filtering
    - added StretchRect function to low level interface
    - added functions GetImageFileFormatsFilter, GetFilterIndexExtension,
      and GetExtensionFilterIndex

  -- 0.15 Changes/Bug Fixes -----------------------------------
    - added function RotateImage to low level interface
    - moved TImageFormatInfo record and types required by it to
      ImagingTypes unit, changed GetImageFormatInfo low level
      interface function to return TImageFormatInfo instead of short info
    - added checking of options values validity before they are used
    - fixed possible memory leak in CloneImage
    - added ReplaceColor function to low level interface
    - new function FindImageFileFormat by class added

  -- 0.13 Changes/Bug Fixes -----------------------------------
    - added DetermineFileFormat, DetermineStreamFormat, DetermineMemoryFormat,
      GetPixelsSize functions to low level interface
    - added NewPalette, CopyPalette, FreePalette functions
      to low level interface
    - added MapImageToPalette, FillRect, SplitImage, MakePaletteForImages
      functions to low level interface
    - fixed buggy FillCustomPalette function (possible div by zero and others)
    - added CopyRect function to low level interface
    - Member functions of TImageFormatInfo record implemented for all formats
    - before saving images TestImagesInArray is called now
    - added TestImagesInArray function to low level interface
    - added GenerateMipMaps function to low level interface
    - stream position in load/save from/to stream is now set to position before
      function was called if error occurs
    - when error occured during load/save from/to file file handle
      was not released
    - CloneImage returned always False

}
end.

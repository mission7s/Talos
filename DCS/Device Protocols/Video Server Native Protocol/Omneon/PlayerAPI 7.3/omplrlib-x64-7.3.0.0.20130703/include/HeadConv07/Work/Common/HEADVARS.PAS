{******************************************************************}
{                                                                  }
{   Dr. Bob's Head Converter Combined Console/GUI Version          }
{ 			                                                           }
{ Copyright (C) 1997-2006 Bob Swart (A.K.A. Dr. Bob).          	   }
{                                                                  }
{ Contributor(s): Alan C. Moore (acmdoc@aol.com)                   }
{                 Marcel van Brakel  (brakelm@chello.nl)           }
{                 Michael Beck (mbeck1@zoomtown.com)               }
{                 Bob Cousins (bobcousins34@hotmail.com)           }
{                                                                  }
{                                                                  }
{ Obtained through:                                                }
{ Joint Endeavour of Delphi Innovators (Project JEDI)              }
{                                                                  }
{ You may retrieve the latest version of this file at the Project  }
{ JEDI home page, located at http://delphi-jedi.org                }
{ Maintained by the Project JEDI DARTH Team; To join or to report  }
{ bugs, contact Alan C. Moore at acmdoc@aol.com                    }
{                                                                  }
{ The contents of this file are used with permission, subject to   }
{ the Mozilla Public License Version 1.1 (the "License"); you may  }
{ not use this file except in compliance with the License. You may }
{ obtain a copy of the License at                                  }
{ http://www.mozilla.org/MPL/MPL-1.1.html                          }
{                                                                  }
{ Software distributed under the License is distributed on an      }
{ "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either expressed or }
{ implied. See the License for the specific language governing     }
{ rights and limitations under the License.                        }
{                                                                  }
{******************************************************************}


unit HeadVars;
{$A+,B-,C-,D-,E-,F-,G-,H-,I-,J+,L-,N-,O+,P-,Q-,R-,S-,T-,V-,X-}
interface

{$IFDEF MSDOS}
type
  ShortString = String;
{$ENDIF}

const
  Arguments = 3;
  {!ACM -- Seems like these choices should go in a Wizard? }
  {!RES -- Yes, I'm working on a Wizard dialog form/unit }
  Argument: Array[0..Arguments] of String[62] = (
    'Command-line Arguments:',
    '  -o to force overwrite of pascal unit on disk'#13,
    '  -x to force generation of eXplicit import unit (dynamic)',
    '  -m to force generation of iMplicit import unit (static)');

const
  IdentSet = ['A'..'Z','a'..'z','_','0'..'9'];

type
  Str02 = String[2];

const
  Maxtype = 103 {$IFDEF WIZARD}+47{$ENDIF};
type
  TTypes = record
             Ctype: String[22];
             Ptype: String[23];
           end;

const
  Types: Array[1..Maxtype] of Ttypes =
     ((Ctype: 'INT';                Ptype: 'Integer'),
      (Ctype: 'UNSIGNED';           Ptype: 'Word'),
      (Ctype: 'UNSIGNED INT';       Ptype: 'Word'),
      (Ctype: 'UINT';               Ptype: 'Word'),
      (Ctype: 'WORD';               Ptype: 'Word'),
      (Ctype: 'UNSIGNED SHORT';     Ptype: 'Word'), {was: 'Byte'), }
      (Ctype: 'UNSIGNED SHORT INT'; Ptype: 'Word'), {was: 'Byte'), }
      (Ctype: 'SHORT';              Ptype: 'SmallInt'), {was: ShortInt'), }
      (Ctype: 'SHORT INT';          Ptype: 'SmallInt'), {was: ShortInt'), }
      (Ctype: 'DWORD';              Ptype: 'LongInt'),
      (Ctype: 'LONG';               Ptype: 'LongInt'),
      (Ctype: 'LONG INT';           Ptype: 'LongInt'),
      (Ctype: 'UNSIGNED LONG';      Ptype: 'LongInt'),
      (Ctype: 'UNSIGNED LONG INT';  Ptype: 'LongInt'),
      (Ctype: 'CHAR';               Ptype: 'Char'),
      (Ctype: 'UNSIGNED CHAR';      Ptype: 'Byte'),
      (Ctype: 'CHAR*';              Ptype: 'PChar'),
      (Ctype: 'LPSTR';             Ptype: 'PChar'),
      (Ctype: 'PSTR';              Ptype: 'PChar'),
      (Ctype: 'LPWSTR';            Ptype: 'PWideChar'), { 3.12 fix }
      (Ctype: 'PWSTR';             Ptype: 'PWideChar'), { 3.12 fix }
      (Ctype: 'VOID*';              Ptype: 'Pointer'),
      (Ctype: 'BOOL';               Ptype: 'Bool'),
      (Ctype: 'FLOAT';              Ptype: 'Single'),
      (Ctype: 'DOUBLE';             Ptype: 'Double'),
      (Ctype: 'LONG DOUBLE';        Ptype: 'Extended'),
     { Wintypes:: LP,NP,PP,P ervoor of erachter => 1e T = P; anders P ervoor }
      (Ctype: 'HANDLE';             Ptype: 'THandle'),
      (Ctype: 'FARPROC';            Ptype: 'TFarProc'),
      (Ctype: 'ATOM';               Ptype: 'TAtom'),
      (Ctype: 'TPOINT';             Ptype: 'TPoint'),
      (Ctype: 'TRECT';              Ptype: 'TRect'),
      (Ctype: 'COLORREF';           Ptype: 'TColorRef'),
      (Ctype: 'OFSTRUCT';           Ptype: 'TOFStruct'),
      (Ctype: 'DEBUGHOOKINFO';      Ptype: 'TDebugHookInfo'),
      (Ctype: 'BITMAP';             Ptype: 'TBitMap'),
      (Ctype: 'RGBTRIPLE';          Ptype: 'TRGBTriple'),
      (Ctype: 'RGBQUAD';            Ptype: 'TRGBQuad'),
      (Ctype: 'BITMAPCOREHEADER';   Ptype: 'TBitmapCoreHeader'),
      (Ctype: 'BITMAPINFOHEADER';   Ptype: 'TBitmapInfoHeader'),
      (Ctype: 'BITMAPINFO';         Ptype: 'TBitmapInfo'),
      (Ctype: 'BITMAPCOREINFO';     Ptype: 'TBitmapCoreInfo'),
      (Ctype: 'BITMAPFILEHEADER';   Ptype: 'TBitmapFileHeader'),
      (Ctype: 'HANDLETABLE';        Ptype: 'THandleTable'),
      (Ctype: 'METARECORD';         Ptype: 'TMetaRecord'),
      (Ctype: 'METAHEADER';         Ptype: 'TMetaHeader'),
      (Ctype: 'METAFILEPICT';       Ptype: 'TMetaFilePict'),
      (Ctype: 'TEXTMETRIC';         Ptype: 'TTextMetric'),
      (Ctype: 'NEWTEXTMETRIC';      Ptype: 'TNewTextMetric'),
      (Ctype: 'LOGBRUSH';           Ptype: 'TLogBrush'),
      (Ctype: 'LOGPEN';             Ptype: 'TLogPen'),
      (Ctype: 'PATTERN';            Ptype: 'TPattern'), { TLogBrush }
      (Ctype: 'PALETTEENTRY';       Ptype: 'TPaletteEntry'),
      (Ctype: 'LOGPALETTE';         Ptype: 'TLogPalette'),
      (Ctype: 'LOGFONT';            Ptype: 'TLogFont'),
      (Ctype: 'ENUMLOGFONT';        Ptype: 'TEnumLogFont'),
      (Ctype: 'PANOSE';             Ptype: 'TPanose'),
      (Ctype: 'KERNINGPAIR';        Ptype: 'TKerningPair'),
      (Ctype: 'OUTLINETEXTMETRIC';  Ptype: 'TOutlineTextMetric'),
      (Ctype: 'FIXED';              Ptype: 'TFixed'),
      (Ctype: 'MAT2';               Ptype: 'TMat2'),
      (Ctype: 'GLYPHMETRICS';       Ptype: 'TGlyphMetrics'),
      (Ctype: 'POINTFX';            Ptype: 'TPointFX'),
      (Ctype: 'TTPOLYCURVE';        Ptype: 'TTTPolyCurve'),
      (Ctype: 'TTPOLYGONHEADER';    Ptype: 'TPolygonHeader'),
      (Ctype: 'ABC';                Ptype: 'TABC'),
      (Ctype: 'RASTERIZER_STATUS';  Ptype: 'TRasterizer_Status'),
      (Ctype: 'MOUSEHOOKSTRUCT';    Ptype: 'TMouseHookStruct'),
      (Ctype: 'CBTACTIVATESTRUCT';  Ptype: 'TCBTActivateStruct'),
      (Ctype: 'HARDWAREHOOKSTRUCT'; Ptype: 'THardwareHookStruct'),
      (Ctype: 'EVENTMSG';           Ptype: 'TEventMsg'),
      (Ctype: 'WNDCLASS';           Ptype: 'TWndClass'),
      (Ctype: 'MSG';                Ptype: 'TMsg'),
      (Ctype: 'MINMAXINFO';         Ptype: 'TMinMaxInfo'),
      (Ctype: 'SEGINFO';            Ptype: 'TSegInfo'),
      (Ctype: 'ACCEL';              Ptype: 'TAccel'),
      (Ctype: 'PAINTSTRUCT';        Ptype: 'TPaintStruct'),
      (Ctype: 'CREATESTRUCT';       Ptype: 'TCreateStruct'),
      (Ctype: 'CBT_CREATEWND';      Ptype: 'TCBT_CreateWnd'),
      (Ctype: 'MEASUREITEMSTRUCT';  Ptype: 'TMeasureItemStruct'),
      (Ctype: 'DRAWITEMSTRUCT';     Ptype: 'TDrawItemStruct'),
      (Ctype: 'DELETEITEMSTRUCT';   Ptype: 'TDeleteItemStruct'),
      (Ctype: 'COMPAREITEMSTRUCT';  Ptype: 'TCompareItemStruct'),
      (Ctype: 'WINDOWPOS';          Ptype: 'TWindowPos'),
      (Ctype: 'WINDOWPLACEMENT';    Ptype: 'TWindowPlacement'),
      (Ctype: 'NCCALCSIZE_PARAMS';  Ptype: 'TNCCalcSize_Params'),
      (Ctype: 'SIZE';               Ptype: 'TSize'),
      (Ctype: 'MENUITEMTEMPLATEHEADER'; Ptype: 'TMenuItemTemplateHeader'),
      (Ctype: 'MENUITEMTEMPLATE';   Ptype: 'TMenuItemTemplate'),
      (Ctype: 'DCB';                Ptype: 'TDCB'),
      (Ctype: 'COMSTAT';            Ptype: 'TComStat'),
      (Ctype: 'MDICREATESTRUCT';    Ptype: 'TMDICreateStruct'),
      (Ctype: 'CLIENTCREATESTRUCT'; Ptype: 'TClientCreateStruct'),
      (Ctype: 'MULTIKEYHELP';       Ptype: 'TMultiKeyHelp'),
      (Ctype: 'HELPWININFO';        Ptype: 'THelpWinInfo'),
      (Ctype: 'CTLSTYLE';           Ptype: 'TCtlStyle'),
      (Ctype: 'CTLtype';            Ptype: 'TCtltype'),
      (Ctype: 'CTLINFO';            Ptype: 'TCtlInfo'),
      (Ctype: 'DDEADVISE';          Ptype: 'TDDEAdvise'),
      (Ctype: 'DDEDATA';            Ptype: 'TDDEData'),
      (Ctype: 'DDEPOKE';            Ptype: 'TDDEPoke'),
      (Ctype: 'DDEAACK';            Ptype: 'TDDEAck'),
      (Ctype: 'DEVMODE';            Ptype: 'TDevMode'),
      (Ctype: 'KANJISTRUCT';        Ptype: 'TKanjiStruct')
{!ACM -- Why all these empty entries in the table for the Wizard? }
{!RES -- So people can enter their own additional conversions too }
    {$IFDEF WIZARD},
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: ''),
      (CType: '';                   PType: '')
    {$ENDIF});

const
  MaxVoid = 19;
  PasVoid =  7;
type
  TVoid = String[8];
const
  Void: array[1..MaxVoid] of TVoid =
    ('PASCAL',
     'WINGAPI',
     'WINAPI',
     'APIENTRY',
     'EXPENTRY',
     'EXPORT',
     'CDECL',  { cdecl = 7 }
     'EXTERN',
     'HUGE',
     'FAR',
     'NEAR',
     'INLINE',
     'AUTO',
     'EXTERN',
     'REGISTER',
     'STATIC',
     'VOLATILE',
     'SIGNED',
     'STRUCT');
{!ACM -- Suggest putting all boolean switches in once place with comments }
{!ACM -- that explain what they do; see below for some suggestions on this }
const
  LeadingSpace: Boolean = TRUE; { 3.10 }
  InArray: Boolean = FALSE;
  Comment: Boolean = FALSE; {!ACM -- processing a comment }
  CDECL: Boolean = FALSE; {!ACM -- seems to be a reserved word }
  Emptytype: Word = 0;
  Nested: Integer = 0; {!ACM -- current level of nesting }

const
  MaxLine = 64;
type
  PDynaLines = ^TDynaLines;
  TDynaLines = Array[1..MaxLine+1] of ShortString;
var
  Str: ShortString;
  Len: Byte absolute Str;
  Commentaar: ShortString; {!ACM -- Don't know this term; is there an }
                           {!ACM -- equivalent? }
  LastEmptyType: String[7];
  Number: String[3];
  Line: TDynaLines;
  Dir,DLL: ShortString;
  Name: ShortString;
  Intype,Union: Boolean;
  header: System.Text;
  def: System.text;
  tmp: System.Text;
  {!ACM -- suggest renaming some of these variables to make them more }
  {!ACM -- descriptive of their function.  Com could be CurrentLocationInFile }
  {!ACM -- Com1 could be ReferencePositionInFile.  Other ideas? }
  trailing,com,com1: Integer;

{!ACM -- Move to beginning }
{!RES -- Only one person was using this feature
         anyway, so we could decide to remove it }
const
  _STOP = '__DR_BOB_HEADCONV_STOP';
  _START= '__DR_BOB_HEADCONV_START';
  Start: Boolean = True;

implementation

end.

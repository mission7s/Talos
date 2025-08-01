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




program HeadConv;
//{$A+,B-,C-,D-,E-,F-,G-,H-,I-,L-,N-,O+,P-,Q-,R-,S-,T-,V-,X-}
{$IFNDEF MSDOS}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  HeadPars;

const
  VerDate = '2000/09/17';
  Version = 27;
  Changes: Array[0..Version+1] of String[60] = (
    '3.00 - 97/10/03 - first HeadConv command-line edition!',
    '3.01 - 97/10/10 - generate only "dynamic" import units',
    '3.02 - 97/10/13 - 3rd pass: convert all ": P" to "var"',
    '3.03 - 97/10/13 - 3rd pass: don''t do 3.02 for "PChar"s',
    '3.04 - 97/10/14 - skip list of un-needed pointer types',
    '3.05 - 97/10/15 - add a real typename to "_1" typedefs',
    '3.06 - 97/10/15 - adjust the indentation (2) for types',
    '3.07 - 97/10/15 - make "DLLHandle" of the THandle type',
    '3.08 - 97/10/15 - 3rd pass: skip 3.02 within all types',
    '3.09 - 97/10/16 - fixed problem with arrays and spaces',
    '3.10 - 97/10/17 - fixed the typedef "_" prefix problem',
    '3.11 - 97/10/17 - added multiple typedef names support',
    '3.12 - 97/10/17 - added LPWSTR -> PWideChar conversion',
    '3.13 - 97/11/03 - Pointer doesn''t become "var :ointer"',
    '3.14 - 97/11/04 - "cdecl" and optional win32 "stdcall"',
    '3.15 - 97/11/04 - accepting a "void *" function result',
    '3.16 - 97/11/07 - fixed a bug in comments for typedefs',
    '3.17 - 97/11/11 - skip used comments in implementation',
    '3.18 - 97/11/12 - added argument -o to force overwrite',
    '3.19 - 97/11/12 - fixed problem with multiple typedefs',
    '3.20 - 97/11/12 - suspend after __DR_BOB_HEADCONV_STOP',
    '                  restart with __DR_BOB_HEADCONV_START',
    '3.21 - 97/11/13 - GetProcAddress case-sensitive import',
    '3.22 - 97/11/14 - Assert around GetProcAddress results',
    '3.23 - 97/11/14 - Created "procedure LoadDLL" for init',
    '3.24 - 97/11/21 - re-introduced "static" import units!',
    '3.25 - 98/04/12 - fixed a rare "type" conversion issue',
    '4.00 - 99/07/17 - final HeadConv command-line edition!',
    '4.01 - 00/09/17 - HeadConv command-line units edition!');

const
  Arguments = 3;
  {!ACM -- Seems like these choices should go in a Wizard? }
  Argument: Array[0..Arguments] of String[62] = (
    'Command-line Arguments:',
    '  -o to force overwrite of pascal unit on disk'#13,
    '  -x to force generation of eXplicit import unit (dynamic)',
    '  -m to force generation of iMplicit import unit (static)');

var
  i: Integer;

procedure main;
begin
  if (ParamCount < 1) or (Pos('?',ParamStr(1)) > 0) then
  begin
    writeln;
    writeln('*** HeadConv 4.01 (c) ',VerDate,' by Bob Swart (aka Dr.Bob - www.drbob42.com) ***');
    writeln('    FINAL DELPHI-JEDI COMMANDLINE EDITION');
    writeln;
    if ParamCount > 0 then
    begin
      writeln(' ':4,'version  date     comments');
      writeln(' ':4,'==========================----------------------------');
      for i:=0 to Version+1 do writeln(' ':4,Changes[i]);
      writeln
    end;
    writeln('Usage: HeadConv filename');
    writeln('  will generate the explicit (dynamic) Delphi import unit,');
    writeln('  where filename.H is the C DLL header file.');
    writeln;
    for i:=0 to Arguments do writeln(Argument[i]);
    writeln;
    writeln('Example: HeadConv SAMPLE -o');
    writeln;
    writeln;
    write('Hit <enter> to continue...');
    readln;
  end
  else
    case HeadConvert(ParamStr(1),((ParamStr(2) <> '-m') and
                                  (ParamStr(3) <> '-m') and
                                  (ParamStr(4) <> '-m'))) of
      1: writeln('Error: could not open header file!');
      2: writeln('Error: output file already exists!')
    end
  end;

begin
   main;
end.

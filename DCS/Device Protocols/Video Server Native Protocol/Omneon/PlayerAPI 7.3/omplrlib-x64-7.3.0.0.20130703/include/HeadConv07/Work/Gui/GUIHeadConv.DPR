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




program GUIHeadConv;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  frmAbout in 'frmAbout.pas' {frmAbout1};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'GUI C Header Converter Utility';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.

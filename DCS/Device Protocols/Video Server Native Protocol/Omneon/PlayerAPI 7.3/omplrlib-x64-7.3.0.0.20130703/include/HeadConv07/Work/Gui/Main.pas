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




unit Main;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, Menus, ActnList, ImgList,
  ComCtrls, ToolWin, IniFiles, StdActns;

type
  TMainForm = class(TForm)
    MainMenu: TMainMenu;
    FileOpenItem: TMenuItem;
    FileSaveItem: TMenuItem;
    FileSaveAsItem: TMenuItem;
    FilePrintItem: TMenuItem;
    FilePrintSetupItem: TMenuItem;
    FileExitItem: TMenuItem;
    EditUndoItem: TMenuItem;
    EditCutItem: TMenuItem;
    EditCopyItem: TMenuItem;
    EditPasteItem: TMenuItem;
    HelpContentsItem: TMenuItem;
    HelpAboutItem: TMenuItem;
    StatusLine: TStatusBar;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    PrintDialog: TPrintDialog;
    PrintSetupDialog: TPrinterSetupDialog;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    btnSave: TToolButton;
    btnSaveAs: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ActionList1: TActionList;
    PageControl1: TPageControl;
    ImageList1: TImageList;
    actAbout: TAction;
    actOpen: TAction;
    actSave: TAction;
    actSaveAs: TAction;
    actPrint: TAction;
    actPrintSetup: TAction;
    actExit: TAction;
    actHelp: TAction;
    TabSheet1: TTabSheet;
    ListView1: TListView;
    mnuOptions: TMenuItem;
    mnuImplicit: TMenuItem;
    mnuExplicit: TMenuItem;
    ToolButton12: TToolButton;
    btnPrint: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    N5: TMenuItem;
    mnuOverwrite: TMenuItem;
    Memo1: TMemo;
    Splitter1: TSplitter;
    Splitter2: TSplitter;
    MemoC: TMemo;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    EditSelectAll1: TEditSelectAll;
    EditUndo1: TEditUndo;
    ToolButton16: TToolButton;
    N6: TMenuItem;
    SelectAll1: TMenuItem;
    ToolButton17: TToolButton;
    ToolButton18: TToolButton;
    Search1: TMenuItem;
    Find1: TMenuItem;
    FindFirst1: TMenuItem;
    FindNext1: TMenuItem;
    N7: TMenuItem;
    Replace1: TMenuItem;
    ToolButton23: TToolButton;
    PageControl2: TPageControl;
    Splitter3: TSplitter;
    TabSheet3: TTabSheet;
    MemoPas: TMemo; { &About... }
    procedure FormCreate(Sender: TObject);
    procedure ShowHint(Sender: TObject);
    procedure FileNew(Sender: TObject);
    procedure FileOpen(Sender: TObject);
    procedure FileSave(Sender: TObject);
    procedure FileSaveAs(Sender: TObject);
    procedure FilePrint(Sender: TObject);
    procedure FilePrintSetup(Sender: TObject);
    procedure FileExit(Sender: TObject);
    procedure EditUndo(Sender: TObject);
    procedure EditCut(Sender: TObject);
    procedure EditCopy(Sender: TObject);
    procedure EditPaste(Sender: TObject);
    procedure HelpContents(Sender: TObject);
    procedure HelpSearch(Sender: TObject);
    procedure HelpHowToUse(Sender: TObject);
    procedure actAboutExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure MemoPasEnter(Sender: TObject);
    procedure MemoPasExit(Sender: TObject);
    procedure mnuImplicitClick(Sender: TObject);
    procedure mnuExplicitClick(Sender: TObject);
  private
    procedure LoadOptions;
    procedure SaveOptions;

  end;

var
  MainForm: TMainForm;

implementation

uses frmAbout, HeadPars;

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Application.HelpFile := ExtractFileDir(Application.ExeName) + '\GUIHeadConv.hlp';
  Application.OnHint := ShowHint;
  LoadOptions;
end;

procedure TMainForm.ShowHint(Sender: TObject);
begin
  StatusLine.SimpleText := Application.Hint;
end;

procedure TMainForm.FileNew(Sender: TObject);
begin
  { Add code to create a new file }
end;

procedure TMainForm.FileOpen(Sender: TObject);
var
  i: integer;
  o, m, x: string;
  Item: TListItem;
begin
  o := '';
  m := '';
  x := '';
{!rmc  ListView1.Clear;}

  if mnuImplicit.Checked then
    m := '-m'
  else
    x := '-x';
  if mnuOverwrite.Checked then
    o := '-o';

  OpenDialog.InitialDir := GetCurrentDir; {!rmc}  
  if OpenDialog.Execute then
    begin
    { Add code to open OpenDialog.FileName }

      for I := 0 to OpenDialog.Files.Count - 1 do // Iterate
        begin
          case HeadConvert(OpenDialog.Files[i], (o <> '-m') and
            (m <> '-m') and
            (x <> '-m')) of
            1: Memo1.Lines.Add('Error: could not open ' + OpenDialog.Files[i] + ' header file!');
            2: Memo1.Lines.Add('Error: output file for ' + OpenDialog.Files[i] + ' already exists!')
          end;
          with ListView1.Items.Add do
            Caption := ExtractFileName(OpenDialog.Files[i]);
        end; // for
      item := ListView1.Items[0];
      MemoC.Lines.LoadFromFile(item.Caption);
      MemoPAS.Lines.LoadFromFile(copy(item.Caption, 0, length(item.caption) - 2) + '.pas');
    end;
  OpenDialog.Files.Clear;
end;

procedure TMainForm.FileSave(Sender: TObject);
var
  Filestring: string;
begin
   { Add code to save current file under current name }
  Filestring := ListView1.Selected.Caption;
  if MemoPAS.Focused then
    MemoPAS.Lines.SaveToFile(copy(Filestring, 0, length(Filestring) - 2) + '.pas');
end;

procedure TMainForm.FileSaveAs(Sender: TObject);
begin

  if MemoPAS.Focused then
    if SaveDialog.Execute then
        MemoPAS.Lines.SaveToFile(SaveDialog.FileName);
end;

procedure TMainForm.FilePrint(Sender: TObject);
begin
  if PrintDialog.Execute then
    begin
    { Add code to print current file }
    end;
end;

procedure TMainForm.FilePrintSetup(Sender: TObject);
begin
  PrintSetupDialog.Execute;
end;

procedure TMainForm.FileExit(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.EditUndo(Sender: TObject);
begin
  { Add code to perform Edit Undo }
end;

procedure TMainForm.EditCut(Sender: TObject);
begin
  { Add code to perform Edit Cut }
end;

procedure TMainForm.EditCopy(Sender: TObject);
begin
  { Add code to perform Edit Copy }

end;

procedure TMainForm.EditPaste(Sender: TObject);
begin
  { Add code to perform Edit Paste }
end;

procedure TMainForm.HelpContents(Sender: TObject);
begin
  ShowMessage('Help not yet developed');
  //Application.HelpCommand(HELP_CONTENTS, 0);
end;

procedure TMainForm.HelpSearch(Sender: TObject);
const
  EmptyString: PChar = '';
begin
  Application.HelpCommand(HELP_PARTIALKEY, Longint(EmptyString));
end;

procedure TMainForm.HelpHowToUse(Sender: TObject);
begin
  Application.HelpCommand(HELP_HELPONHELP, 0);
end;

procedure TMainForm.actAboutExecute(Sender: TObject);
begin
  with TfrmAbout1.create(nil) do
    try
      showModal;
    finally // wrap up
      free;
    end; // try/finally
end;

procedure TMainForm.LoadOptions;
var
  l, t, w, h: integer;
begin
  with TIniFile.create(changefileext(paramstr(0), '.ini')) do
    try
      l := ReadInteger('Options', 'Bounds.Left', 0);
      t := ReadInteger('Options', 'Bounds.Top', 0);
      w := ReadInteger('Options', 'Bounds.Width', -1);
      h := ReadInteger('Options', 'Bounds.Height', -1);

      OpenDialog.InitialDir := ReadString('Options', 'OpenDialog.path', extractfilepath(paramstr(0)));
      mnuImplicit.Checked := ReadBool('Options', 'Implicit', True);
      mnuOverwrite.Checked := ReadBool('Options', 'Overwrite', True);

    finally
      free;
    end;

  //make sure the form is positioned on screen ...
  //(ie make sure nobody's fiddled with the INI file!)
  if (w > 0) and (h > 0) and
    (l < screen.Width) and (t < screen.Height) and
    (l + w > 0) and (t + h > 0) then
    setbounds(l, t, w, h);

end;

procedure TMainForm.SaveOptions;
begin
  with TIniFile.create(changefileext(paramstr(0), '.ini')) do
    try
      if windowState = wsNormal then
        begin
          WriteInteger('Options', 'Bounds.Left', self.Left);
          WriteInteger('Options', 'Bounds.Top', self.Top);
          WriteInteger('Options', 'Bounds.Width', self.Width);
          WriteInteger('Options', 'Bounds.Height', self.Height);
        end;
      WriteString('Options', 'OpenDialog.path', OpenDialog.InitialDir);
      WriteBool('Options', 'Implicit', mnuImplicit.Checked);
      WriteBool('Options', 'Overwrite', mnuOverwrite.Checked);
    finally
      free;
    end;

end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveOptions;
  Application.HelpCommand(HELP_QUIT, 0);
end;

procedure TMainForm.ListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  MemoC.Lines.LoadFromFile(item.Caption);
  MemoPAS.Lines.LoadFromFile(copy(item.Caption, 0, length(item.caption) - 2) + '.pas');
end;

procedure TMainForm.MemoPasEnter(Sender: TObject);
begin
btnSaveAs.Enabled:=True;
btnSave.Enabled:=True
end;

procedure TMainForm.MemoPasExit(Sender: TObject);
begin
btnSaveAs.Enabled:=False;
btnSave.Enabled:=False;
end;

procedure TMainForm.mnuImplicitClick(Sender: TObject);
begin
mnuImplicit.Checked:=True;
end;

procedure TMainForm.mnuExplicitClick(Sender: TObject);
begin
mnuExplicit.Checked:=True;
end;

end.


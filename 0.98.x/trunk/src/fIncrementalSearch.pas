// Copyright (c) 2009, ConTEXT Project Ltd
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
// Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
// Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
// Neither the name of ConTEXT Project Ltd nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

unit fIncrementalSearch;

interface

{$I ConTEXT.inc}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ActnList, TB2Dock, TB2Toolbar, TBX, TB2Item,
  TBXDkPanels, SynEditTypes, uMultilanguage, uCommon, uSafeRegistry,
  JclSysInfo;

type
  TfmIncrementalSearch = class(TForm)
    eFindText: TEdit;
    timClose: TTimer;
    TBXToolbar1: TTBXToolbar;
    alIncrementalSearch: TActionList;
    acFindNext: TAction;
    acFindPrevious: TAction;
    acEmphasize: TAction;
    miEmphasize: TTBXItem;
    TBXItem3: TTBXItem;
    TBXItem4: TTBXItem;
    procedure timCloseTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure eFindTextKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure acFindNextExecute(Sender: TObject);
    procedure acFindPreviousExecute(Sender: TObject);
    procedure acEmphasizeExecute(Sender: TObject);
    procedure acCloseExecute(Sender: TObject);
    procedure eFindTextChange(Sender: TObject);
    procedure alIncrementalSearchUpdate(Action: TBasicAction;
      var Handled: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    fInitialCaretXY: TBufferCoord;
    fEditor: TObject;
    procedure ResetTimer;
    procedure LoadSettings;
    procedure SaveSettings;
  public
    constructor Create(AOwner: TComponent; Editor: TObject); reintroduce;
    destructor Destroy; override;
  end;

  TIncrementalSearchPanel = class(TTBXDockablePanel)
  private
    fEditor: TObject;
    fIncrementalSearchDialog: TfmIncrementalSearch;
    procedure OnCloseEvent(Sender: TObject);
  protected
    procedure WndProc(var Message: TMessage); override;
  public
    constructor Create(AOwner: TComponent; Editor: TObject); reintroduce;
    destructor Destroy; override;
    procedure PasteFromClipboard;
  end;


implementation

{$R *.dfm}

uses
  fMain, fEditor, fFind;

const
  DEFAULT_CLOSE_INTERVAL = 5000;
  REG_KEY = CONTEXT_REG_KEY + 'IncrementalSearch\';

////////////////////////////////////////////////////////////////////////////////////////////
//                                     Functions
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------
procedure TfmIncrementalSearch.LoadSettings;
begin
  with TSafeRegistry.Create do
    try
      if OpenKey(REG_KEY, TRUE) then begin
        eFindText.Text:=ReadString('SearchText', '');
      end;
    finally
      Free;
    end;
end;
//------------------------------------------------------------------------------------------
procedure TfmIncrementalSearch.SaveSettings;
begin
  with TSafeRegistry.Create do
    try
      if OpenKey(REG_KEY, TRUE) then begin
        WriteString('SearchText', eFindText.Text);
      end;
    finally
      Free;
    end;
end;
//------------------------------------------------------------------------------------------
procedure TfmIncrementalSearch.ResetTimer;
begin
  timClose.Enabled:=FALSE;
  timClose.Enabled:=TRUE;
end;
//------------------------------------------------------------------------------------------


////////////////////////////////////////////////////////////////////////////////////////////
//                                      Actions
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------
procedure TfmIncrementalSearch.alIncrementalSearchUpdate(Action: TBasicAction; var Handled: Boolean);
begin
  TfmEditor(fEditor).EmphasizeWord:=acEmphasize.Checked;
end;
//------------------------------------------------------------------------------------------
procedure TfmIncrementalSearch.acFindNextExecute(Sender: TObject);
begin
  with TfmEditor(fEditor) do begin
    memo.SearchEngine:=fmFind.SearchEngine;
    memo.SearchReplace(eFindText.Text, '', []);
    fmFind.cbFind.Text:=eFindText.Text;
  end;

  ResetTimer;
end;
//------------------------------------------------------------------------------------------
procedure TfmIncrementalSearch.acFindPreviousExecute(Sender: TObject);
begin
  with TfmEditor(fEditor) do begin
    memo.SearchEngine:=fmFind.SearchEngine;
    memo.SearchReplace(eFindText.Text, '', [ssoBackwards]);
    fmFind.cbFind.Text:=eFindText.Text;
  end;

  ResetTimer;
end;
//------------------------------------------------------------------------------------------
procedure TfmIncrementalSearch.acEmphasizeExecute(Sender: TObject);
begin
  acEmphasize.Checked:=not acEmphasize.Checked;
  ResetTimer;
end;
//------------------------------------------------------------------------------------------
procedure TfmIncrementalSearch.acCloseExecute(Sender: TObject);
begin
  Close;
end;
//------------------------------------------------------------------------------------------


////////////////////////////////////////////////////////////////////////////////////////////
//                                      Events
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------
procedure TfmIncrementalSearch.eFindTextKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  ResetTimer;

  case Key of
//    VK_ESCAPE:
//      Close;
    VK_RETURN:
      acFindNextExecute(SELF);
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmIncrementalSearch.eFindTextChange(Sender: TObject);
begin
  ResetTimer;
  TfmEditor(fEditor).EmphasizedWord:=eFindText.Text;
  TfmEditor(fEditor).memo.CaretXY:=fInitialCaretXY;
  acFindNextExecute(SELF);
end;
//------------------------------------------------------------------------------------------
procedure TfmIncrementalSearch.timCloseTimer(Sender: TObject);
begin
  Close;
end;
//------------------------------------------------------------------------------------------


////////////////////////////////////////////////////////////////////////////////////////////
//                                   Form events
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------
constructor TfmIncrementalSearch.Create(AOwner: TComponent; Editor: TObject);
begin
  fEditor:=Editor;
  inherited Create(AOwner);

  LoadSettings;

  timClose.Interval:=DEFAULT_CLOSE_INTERVAL;

  acEmphasize.Checked:=TfmEditor(fEditor).EmphasizeWord;
  fInitialCaretXY:=TfmEditor(fEditor).memo.CaretXY;

  mlApplyLanguageToForm(SELF, Name);
end;
//------------------------------------------------------------------------------------------
destructor TfmIncrementalSearch.Destroy;
begin
  SaveSettings;
  TIncrementalSearchPanel(Owner).fIncrementalSearchDialog:=nil;
  inherited;
end;
//------------------------------------------------------------------------------------------
procedure TfmIncrementalSearch.FormShow(Sender: TObject);
begin
  eFindText.SetFocus;
end;
//------------------------------------------------------------------------------------------
procedure TfmIncrementalSearch.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caNone;
  PostMessage(Parent.Handle, WM_CLOSE_PARENT_WINDOW, 0, 0);
end;
//------------------------------------------------------------------------------------------


////////////////////////////////////////////////////////////////////////////////////////////
//                                TIncrementalSearchPanel
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------
procedure TIncrementalSearchPanel.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_CLOSE_PARENT_WINDOW:
      Close;
    else
      inherited;
  end;
end;
//------------------------------------------------------------------------------------------
constructor TIncrementalSearchPanel.Create(AOwner: TComponent; Editor: TObject);
begin
  fEditor:=Editor;

  inherited Create(AOwner);

  DockMode:=dmCannotFloat;
  Resizable:=FALSE;
  OnClose:=OnCloseEvent;
  MinClientHeight:=0;
  DockedHeight:=26;

  Parent:=TWinControl(AOwner);

  fIncrementalSearchDialog:=TfmIncrementalSearch.Create(SELF, Editor);
  with fIncrementalSearchDialog do begin
    Parent:=SELF;
    Show;
  end;
end;
//------------------------------------------------------------------------------------------
procedure TIncrementalSearchPanel.PasteFromClipboard;
begin
  if Assigned(fIncrementalSearchDialog) then
    fIncrementalSearchDialog.eFindText.PasteFromClipboard;
end;
//------------------------------------------------------------------------------------------
destructor TIncrementalSearchPanel.Destroy;
begin
  if Assigned(fIncrementalSearchDialog) then
    fIncrementalSearchDialog.Free;

  TfmEditor(fEditor).IncrementalSearchPanel:=nil;
  TfmEditor(fEditor).SetFocusToEditor;
  inherited;
end;
//------------------------------------------------------------------------------------------
procedure TIncrementalSearchPanel.OnCloseEvent(Sender: TObject);
begin
  Free;
end;
//------------------------------------------------------------------------------------------

end.

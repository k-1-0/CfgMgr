unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Menus, ExtCtrls, ShellAPI, ImgList;


const

  INFO_TEXT = 'Configs Manager' + #13#10 +
              'version 1.0'     + #13#10#13#10 +
              'coded by K10';

  HELP_TEXT = 'Command line parameters:' + #13#10#13#10 +
              'CfgMgr.exe [profile.ini] [-launch:"config_name"]' + #13#10#13#10 +
              'profile.ini - profile config file for auto load at start' + #13#10 +
              'config_name - config name for auto launch with auto load profile';

  WM_TRAYICONNOTIFY          = WM_USER + 123;
  WM_CLOSE_CURRENT_PROFILE   = WM_USER + 124;
  WM_MAIN_FORM_ACTION        = WM_USER + 125;


type
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    Profile1: TMenuItem;
    Newprofile1: TMenuItem;
    Closecurrentprofile1: TMenuItem;
    Exit1: TMenuItem;
    Editcurrentprofile1: TMenuItem;
    Configs1: TMenuItem;
    Add1: TMenuItem;
    Delete1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Movedown1: TMenuItem;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    StaticText1: TStaticText;
    Button5: TButton;
    Button6: TButton;
    StaticText2: TStaticText;
    Panel2: TPanel;
    ListBox1: TListBox;
    Bevel1: TBevel;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Openprofile1: TMenuItem;
    Help1: TMenuItem;
    Help2: TMenuItem;
    N4: TMenuItem;
    About1: TMenuItem;
    N5: TMenuItem;
    Launch1: TMenuItem;
    N1: TMenuItem;
    ImageList1: TImageList;
    PopupMenu1: TPopupMenu;
    ShowCFGMGR1: TMenuItem;
    N6: TMenuItem;
    Exit2: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Newprofile1Click(Sender: TObject);
    procedure Editcurrentprofile1Click(Sender: TObject);
    procedure Add1Click(Sender: TObject);
    procedure Closecurrentprofile1Click(Sender: TObject);
    procedure Delete1Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure Movedown1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Openprofile1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Launch1Click(Sender: TObject);
    procedure ListBox1DrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure ShowCFGMGR1Click(Sender: TObject);
    procedure Exit2Click(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure Help2Click(Sender: TObject);
  private
    { Private declarations }
    procedure MenuUpdateState;
    procedure CreateNewProfile;
    procedure CloseCurrentProfile;
    procedure ApplyCurrentProfile;
    procedure ActivateSelectedConfig;
    procedure DeleteTrayIcon;
    procedure RestoreFromTray;
    procedure MinimizeToTray;
    procedure ProfileIconToItemIcon;
  public
    procedure WmIconNotify(var Msg: TMessage); message WM_TRAYICONNOTIFY;
    procedure WmCloseCurrentProfile(var Msg: TMessage); message WM_CLOSE_CURRENT_PROFILE;
    procedure WmMainFormAction(var Msg: TMessage); message WM_MAIN_FORM_ACTION;
  end;


var
  MainForm: TMainForm;

implementation

{$R *.DFM}

uses Unit2, Unit3, ProfileType, ConfigActivation, Utils, SxMenu, CustomMB;

{$I dbg.inc}

const
  CFG_MGR_PROFILE_FILENAME = 'CfgMgr.ini';

var
  CurrentProfile: TProfile;
  WndIcon, AppIcon, ItemIcon: TIcon;
  ItemBitmap: TBitmap;
  dwFormAction: DWORD = 0;
  bTray: Boolean = false;



//procedure SetProfileTestData(var Profile: TProfile);
//begin
//with Profile do
//  begin
//  ProfileName:='Test profile';
//  ProfileDirectory:='C:\_PROJECTS\ConfigsManager\test\cfg_mgr\';
//  TargetConfig:='C:\_PROJECTS\ConfigsManager\test\wallet.dat';
//  Password:='123';
//  end;
//end;




procedure MainFormAction(const dwAction: DWORD);
begin
dwFormAction:=dwAction;
if hMainForm <> 0 then SendMessage(hMainForm, WM_MAIN_FORM_ACTION, dwAction, 0)
else if dwAction = AFTER_LAUNCH_APP_ACTION_EXIT then ExitProcess(0); // если формы еще нет
end;



procedure TMainForm.WmMainFormAction(var Msg: TMessage);
begin
case Msg.wParam of

  AFTER_LAUNCH_APP_ACTION_MINIMIZE: Application.Minimize;

  AFTER_LAUNCH_APP_ACTION_HIDE: begin
                                MainForm.Hide;
                                Application.ShowMainForm:=false;
                                end;

  AFTER_LAUNCH_APP_ACTION_TRAY: MinimizeToTray;

  MAIN_FORM_ACTION_RESTORE: begin
                            if Visible then Application.Restore
                            else
                              begin
                              if bTray then RestoreFromTray else
                                begin
                                MainForm.Show;
                                Application.ShowMainForm:=true;
                                end;
                              end;
                            end;

  AFTER_LAUNCH_APP_ACTION_EXIT: begin
                                if bTray then DeleteTrayIcon;
                                Close;
                                end;
  end;
end;



procedure TMainForm.WmCloseCurrentProfile(var Msg: TMessage);
begin
CloseCurrentProfile;
end;


procedure CloseCurrentProfileAsync;
begin
if hMainForm <> 0 then SendMessage(hMainForm, WM_CLOSE_CURRENT_PROFILE, 0, 0);
end;



procedure TMainForm.DeleteTrayIcon;
var
TrayIconData: TNotifyIconData;
begin
TrayIconData.cbSize:=SizeOf(TNotifyIconData);
TrayIconData.Wnd:=hMainForm;
TrayIconData.uID:=1;
Shell_NotifyIcon(NIM_DELETE, @TrayIconData);
end;

procedure TMainForm.RestoreFromTray;
begin
bTray:=false;
DeleteTrayIcon;
Application.ShowMainForm:=true;
MainForm.Show;
Application.Restore;
SetForegroundWindow(Handle);
end;

procedure TMainForm.MinimizeToTray;
var
TrayIconData: TNotifyIconData;
begin
bTray:=true;
TrayIconData.cbSize:=SizeOf(TNotifyIconData);
TrayIconData.Wnd:=hMainForm;
TrayIconData.uID:=1;
TrayIconData.uFlags:=NIF_ICON OR NIF_MESSAGE OR NIF_TIP;
TrayIconData.uCallBackMessage:=WM_TRAYICONNOTIFY;
if (CurrentProfile <> nil) AND
   CurrentProfile.bIconPresented then TrayIconData.hIcon:=ItemIcon.Handle
                                 else TrayIconData.hIcon:=WndIcon.Handle;
CopyMemory(@TrayIconData.szTip, PChar(Caption), length(Caption) + 1);
Shell_NotifyIcon(NIM_ADD, @TrayIconData);
Application.ShowMainForm:=false;
MainForm.Hide;
end;


procedure TMainForm.WmIconNotify(var Msg: TMessage);
var
P: TPoint;
begin
  case Msg.LParam of
    WM_RBUTTONUP:
      begin
      if GetCursorPos(p) then
        begin
        SetForegroundWindow(Handle);
        PopupMenu1.Popup(P.X, P.Y);
        PostMessage(Handle, WM_NULL, 0, 0);
        end;
      end;
    //WM_LBUTTONDBLCLK : ShowMainForm;
    WM_LBUTTONUP : RestoreFromTray;
    //WM_LBUTTONDOWN : ShowMainForm;
  end;
end;



procedure TMainForm.ActivateSelectedConfig;
var
i: Integer;
begin
if CurrentProfile = nil then Exit;
i:=ListBox1.ItemIndex;
if (i >= 0) then ActivateProfileConfig(CurrentProfile, i);
end;


procedure ActivateConfigByName(const ConfigName: WideString);
var
i: Integer;
CfgName: string;
begin
if (CurrentProfile = nil) OR (length(CurrentProfile.Configs) = 0) then Exit;
CfgName:=LowerCase(ConfigName);
for i:=0 to length(CurrentProfile.Configs) - 1 do
  begin
  if CfgName = LowerCase(CurrentProfile.Configs[i].CfgName) then
    begin
    ActivateProfileConfig(CurrentProfile, i);
    Exit;
    end;
  end;
ShowError('Config "' + ConfigName + '" not found.');
end;




procedure TMainForm.MenuUpdateState;
var
bProfileFound: Boolean;
begin
bProfileFound:=(CurrentProfile <> nil);

Closecurrentprofile1.Enabled:=bProfileFound;
Editcurrentprofile1.Enabled:=bProfileFound;
if bProfileFound then Editcurrentprofile1.ImageIndex:=2
                 else Editcurrentprofile1.ImageIndex:=5;

Launch1.Enabled:=bProfileFound AND (ListBox1.ItemIndex >= 0);
Button1.Enabled:=Launch1.Enabled;
if Launch1.Enabled then Launch1.ImageIndex:=14 else Launch1.ImageIndex:=15;

Add1.Enabled:=bProfileFound;
Button2.Enabled:=Add1.Enabled;
if bProfileFound then Add1.ImageIndex:=6 else Add1.ImageIndex:=7; 

Delete1.Enabled:=bProfileFound AND (ListBox1.ItemIndex >= 0);
Button3.Enabled:=Delete1.Enabled;
if Button3.Enabled then Delete1.ImageIndex:=8 else Delete1.ImageIndex:=9;

N3.Enabled:=bProfileFound AND (ListBox1.Items.Count <> 0) AND (ListBox1.ItemIndex > 0);
Button4.Enabled:=N3.Enabled;
if N3.Enabled then N3.ImageIndex:=12 else N3.ImageIndex:=13;

Movedown1.Enabled:=bProfileFound AND (ListBox1.Items.Count <> 0) AND
                   (ListBox1.ItemIndex >= 0) AND (ListBox1.ItemIndex < ListBox1.Items.Count - 1);

Button5.Enabled:=Movedown1.Enabled;
if Movedown1.Enabled then Movedown1.ImageIndex:=10 else Movedown1.ImageIndex:=11;
end;


procedure TMainForm.CloseCurrentProfile;
begin
if CurrentProfile <> nil then FreeAndNil(CurrentProfile);
ListBox1.Clear;
ListBox1.Enabled:=false;
ListBox1.Color:=clBtnFace;
MenuUpdateState;
end;



procedure TMainForm.ApplyCurrentProfile;
var
i: Integer;
begin       
if CurrentProfile = nil then
  begin
  CloseCurrentProfile;
  Exit;
  end;

Caption:=CurrentProfile.ProfileName + ' - CFG MGR';
ListBox1.Clear;
ListBox1.Enabled:=true;
ListBox1.Color:=clWindow;
MenuUpdateState;

if CurrentProfile.bIconPresented then
  begin
  ProfileIconToItemIcon;
  MainForm.Icon:=ItemIcon;
  Application.Icon:=ItemIcon;
  end
else
  begin
  MainForm.Icon:=WndIcon;
  Application.Icon:=AppIcon;
  end;

if length(CurrentProfile.Configs) > 0 then
  begin
  for i:=0 to length(CurrentProfile.Configs) - 1 do
    ListBox1.Items.Add(CurrentProfile.Configs[i].CfgName);
  end;
end;




procedure TMainForm.CreateNewProfile;
var
dwRes: DWORD;
begin
if CurrentProfile <> nil then CloseCurrentProfile;

CurrentProfile:=TProfile.Create;

//SetProfileTestData(CurrentProfile);

if ShowProfileForm(true, CurrentProfile) then
  begin
  dwRes:=CurrentProfile.SaveNewProfile;
  if dwRes <> PROFILE_ERR_SUCCESS then
    begin
    CloseCurrentProfile;
    ShowError('Saving profile failed.' + #13#10 +
              'Error: ' + ProfileErrToStr(dwRes));
    end
  else ApplyCurrentProfile;
  end
else CloseCurrentProfile;
end;



procedure TMainForm.ProfileIconToItemIcon;
var
x, y: Integer;
ImgList: TImageList;
begin
if CurrentProfile = nil then Exit;
for x:=0 to 15 do
  begin
  for y:=0 to 15 do
    ItemBitmap.Canvas.Pixels[x, y]:=CurrentProfile.IconData.Pixels[x, y];
  end;
ItemBitmap.TransparentColor:=CurrentProfile.IconData.dwTransparentColor;
ImgList:=TImageList.CreateSize(16, 16);
try
  ImgList.AddMasked(ItemBitmap, ItemBitmap.TransparentColor);
  ImgList.GetIcon(0, ItemIcon);
finally
  ImgList.Free;
  end;
end;



function LoadProfile(const ConfigFileName: WideString): Boolean;
var
dwRes: DWORD;
Password: WideString;
begin
result:=false;

if CurrentProfile <> nil then CloseCurrentProfileAsync;

repeat
  CurrentProfile:=TProfile.Create;
  
  if NOT ShowPasswordForm('Enter keyword for profile:', Password) then
    begin
    FreeAndNil(CurrentProfile);
    Exit;
    end;
  CurrentProfile.Password:=Password;
  Password:='';

  dwRes:=CurrentProfile.Load(ConfigFileName);
  result:=dwRes = PROFILE_ERR_SUCCESS;
  if result then
    begin
    //
    end
  else
    begin
    if dwRes = PROFILE_ERR_AUTH_FAILED then ShowError('Incorrect password.')
    else
      begin
      FreeAndNil(CurrentProfile);
      ShowError('Load profile failed.' + #13#10 + 'Error: ' + ProfileErrToStr(dwRes));
      Break;
      end;
    end;
until dwRes <> PROFILE_ERR_AUTH_FAILED;
end;





procedure TMainForm.FormCreate(Sender: TObject);
var
IniFile: WideString;
i: Integer;
bForeground: Boolean;
begin
hMainForm:=Handle;

if CurrentProfile <> nil then
  begin
  ApplyCurrentProfile;
  MenuUpdateState;
  end;

bForeground:=false;
case dwFormAction of
  AFTER_LAUNCH_APP_ACTION_MINIMIZE: Application.Minimize;
  AFTER_LAUNCH_APP_ACTION_HIDE: begin
                                Application.ShowMainForm:=false;
                                MainForm.Hide;
                                end;
  AFTER_LAUNCH_APP_ACTION_TRAY: MinimizeToTray;
  else bForeground:=true;
  end;
dwFormAction:=AFTER_LAUNCH_APP_ACTION_NONE;

IniFile:=SelfDir + CFG_MGR_PROFILE_FILENAME;
i:=IniGetInt(IniFile, 'Window', 'width', 0);
if i <> 0 then Width:=i;
i:=IniGetInt(IniFile, 'Window', 'height', 0);
if i <> 0 then Height:=i;
i:=IniGetInt(IniFile, 'Window', 'left', 0);
if i <> 0 then Left:=i;
i:=IniGetInt(IniFile, 'Window', 'top', 0);
if i <> 0 then Top:=i;

ModifyMenu(MainMenu1.Handle, 2, MF_BYPOSITION OR MF_POPUP OR MF_HELP,
           Help1.Handle, 'Help');

SxMenu_Initialize(@MainForm);
SxMenu_SetDefaultColors;
SxMenu_AddMenu(MainMenu1);
SxMenu_AddMenu(PopupMenu1);

if bForeground then SetForegroundWindow(Handle);
end;


procedure TMainForm.Exit1Click(Sender: TObject);
begin
Close;
end;

procedure TMainForm.Newprofile1Click(Sender: TObject);
begin
CreateNewProfile;
end;

procedure TMainForm.Editcurrentprofile1Click(Sender: TObject);
var
dwRes: DWORD;
begin
if ShowProfileForm(false, CurrentProfile) then
  begin
  dwRes:=CurrentProfile.UpdateProfileFile;
  if dwRes <> PROFILE_ERR_SUCCESS then ShowError('Saving profile failed.' + #13#10 +
                                                 'Error: ' + ProfileErrToStr(dwRes))
                                  else ApplyCurrentProfile;
  end;
end;


procedure TMainForm.Add1Click(Sender: TObject);
var
FileName: WideString;
ConfigName: string;
dwRes: DWORD;
begin
if CurrentProfile = nil then Exit;

if NOT GetFileNameW(true, Handle, FileName, 'Select file to add...',
                    'All Files (*.*)'#0'*.*'#0#0, '',
                    CurrentProfile.ProfileDirectory, 0) then Exit;

ConfigName:='';
if NOT InputQuery('New Config', 'Config name:', ConfigName) then Exit;

if ListBox1.Items.IndexOf(ConfigName) >= 0 then
  begin
  ShowError('Config "' + ConfigName + '" already exists.');
  Exit;
  end;

dwRes:=CurrentProfile.AddConfig(ConfigName, FileName);

if dwRes = PROFILE_ERR_SUCCESS then ApplyCurrentProfile
else
  begin
  if dwRes = PROFILE_ERR_CONFIG_NAME_EXISTS
    then ShowError('Config "' + ConfigName + '" already exists.')
    else ShowError('Add config failed.' + #13#10 + 'Error: ' + ProfileErrToStr(dwRes));
  end;
end;


procedure TMainForm.Closecurrentprofile1Click(Sender: TObject);
begin
CloseCurrentProfile;
end;


procedure TMainForm.Delete1Click(Sender: TObject);
var
i: Integer;
dwRes: DWORD;
begin
if CurrentProfile = nil then Exit;
i:=ListBox1.ItemIndex;
if (ListBox1.Items.Count < 1) OR (i < 0) then Exit;

if MessageBox(Handle, PChar('Delete config "' + ListBox1.Items[i] + '" ?'),
              'Delete Config', MB_YESNO OR MB_ICONQUESTION) <> ID_YES then Exit;

dwRes:=CurrentProfile.DeleteConfig(i);
if dwRes = PROFILE_ERR_SUCCESS then
  begin
  ApplyCurrentProfile;
  if ListBox1.Items.Count > 0 then
    begin
    if i > ListBox1.Items.Count - 1 then ListBox1.ItemIndex:=ListBox1.Items.Count - 1
    else ListBox1.ItemIndex:=i;
    end;
  MenuUpdateState;
  end
else ShowError('Delete config failed.' + #13#10 + 'Error: ' + ProfileErrToStr(dwRes));
end;


procedure TMainForm.ListBox1Click(Sender: TObject);
begin
MenuUpdateState;
end;


procedure TMainForm.N3Click(Sender: TObject);
var
i: Integer;
dwRes: DWORD;
begin
if CurrentProfile = nil then Exit;
i:=ListBox1.ItemIndex;
if (ListBox1.Items.Count < 1) OR (i < 1) then Exit;

dwRes:=CurrentProfile.MoveConfigUp(i);
if dwRes = PROFILE_ERR_SUCCESS then
  begin
  ApplyCurrentProfile;
  ListBox1.ItemIndex:=i - 1;
  MenuUpdateState;
  end
else ShowError('Action failed.' + #13#10 + 'Error: ' + ProfileErrToStr(dwRes));
end;


procedure TMainForm.Movedown1Click(Sender: TObject);
var
i: Integer;
dwRes: DWORD;
begin
if CurrentProfile = nil then Exit;
i:=ListBox1.ItemIndex;
if (ListBox1.Items.Count < 1) OR (i > ListBox1.Items.Count - 1) then Exit;

dwRes:=CurrentProfile.MoveConfigDown(i);
if dwRes = PROFILE_ERR_SUCCESS then
  begin
  ApplyCurrentProfile;
  ListBox1.ItemIndex:=i + 1;
  MenuUpdateState;
  end
else ShowError('Action failed.' + #13#10 + 'Error: ' + ProfileErrToStr(dwRes));
end;



procedure TMainForm.FormResize(Sender: TObject);
begin
Button6.Top:=Height - 91;

end;

procedure TMainForm.Openprofile1Click(Sender: TObject);
var
FileName: WideString;
begin
if NOT GetFileNameW(true, Handle, FileName, 'Open Profile...',
                    'INI Files (*.ini)'#0'*.ini'#0'All Files (*.*)'#0'*.*'#0#0,
                    '', SelfDir, 0) then Exit;

if LoadProfile(FileName) then
  begin
  ApplyCurrentProfile;
  MenuUpdateState;
  end;
end;


procedure TMainForm.FormDestroy(Sender: TObject);
var
IniFile: WideString;
begin
IniFile:=SelfDir + CFG_MGR_PROFILE_FILENAME;
IniSetInt(IniFile, 'Window', 'width', Width);
IniSetInt(IniFile, 'Window', 'height', Height);
IniSetInt(IniFile, 'Window', 'left', Left);
IniSetInt(IniFile, 'Window', 'top', Top);
SxMenu_Finalize;
end;


procedure TMainForm.Button2Click(Sender: TObject);
begin
Add1Click(Sender);
end;

procedure TMainForm.Button3Click(Sender: TObject);
begin
Delete1Click(Sender);
end;

procedure TMainForm.Button4Click(Sender: TObject);
begin
N3Click(Sender);
end;

procedure TMainForm.Button5Click(Sender: TObject);
begin
Movedown1Click(Sender);
end;

procedure TMainForm.Button6Click(Sender: TObject);
begin
Close;
end;


procedure TMainForm.Button1Click(Sender: TObject);
begin
ActivateSelectedConfig;
end;

procedure TMainForm.Launch1Click(Sender: TObject);
begin
ActivateSelectedConfig;
end;

procedure TMainForm.About1Click(Sender: TObject);
var
hApplicationIcon: HICON;
begin
hApplicationIcon:=LoadIcon(hInstance, 'MAINICON');
CustomMessageBox(Handle, INFO_TEXT, 'About...', hApplicationIcon, MainForm.Font.Handle);
DestroyIcon(hApplicationIcon);
end;


procedure TMainForm.ListBox1DrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
begin
with (Control as TListBox).Canvas do
  begin
  FillRect(Rect);
  if CurrentProfile.bIconPresented
    then BrushCopy(Bounds(Rect.Left + 4, Rect.Top + 2, 16, 16),
                   ItemBitmap, Bounds(0, 0, 16, 16),
                   ItemBitmap.TransparentColor)
    else Draw(Rect.Left + 4, Rect.Top + 2, WndIcon);

  TextOut(Rect.Left + 28, Rect.Top + 2, ListBox1.Items[Index]);
  end;
end;


procedure TMainForm.ShowCFGMGR1Click(Sender: TObject);
begin
if bTray then RestoreFromTray;
end;


procedure TMainForm.Exit2Click(Sender: TObject);
begin
if bTray then DeleteTrayIcon;
Close;
end;


procedure TMainForm.ListBox1DblClick(Sender: TObject);
begin
ActivateSelectedConfig;
end;


procedure TMainForm.Help2Click(Sender: TObject);
begin
MessageBox(Handle, HELP_TEXT, 'Help', MB_OK OR MB_ICONINFORMATION);
end;


////////////////////////////////////////////////////////////////////////////////


procedure AppInit;
var
Param: string;
begin
SelfDir:=GetSelfDir;

@MainFormActionProc:=@MainFormAction;

AppIcon:=TIcon.Create;
AppIcon.Handle:=LoadImage(hInstance, 'MAINICON', IMAGE_ICON, 32, 32, 0);

WndIcon:=TIcon.Create;
WndIcon.Handle:=LoadImage(hInstance, 'MAINICON', IMAGE_ICON, 16, 16, 0);

ItemIcon:=TIcon.Create;
ItemIcon.Width:=16;
ItemIcon.Height:=16;
ItemIcon.Transparent:=True;

ItemBitmap:=TBitmap.Create;
ItemBitmap.Width:=16;
ItemBitmap.Height:=16;
ItemBitmap.TransparentMode:=tmFixed;
ItemBitmap.Transparent:=true;

if (ParamCount > 0) AND FileExists(ParamStr(1)) then
  begin
  if LoadProfile(ParamStr(1)) then
    begin
    if ParamCount > 1 then
      begin
      Param:=ParamStr(2);
      if (length(Param) > 9) AND (copy(Param, 1, 8) = '-launch:') then
        ActivateConfigByName(copy(Param, 9, length(Param) - 8));
      end;
    end;
  end;
end;

procedure AppFinal;
begin
if CurrentProfile <> nil then FreeAndNil(CurrentProfile);
DestroyIcon(AppIcon.Handle);
DestroyIcon(WndIcon.Handle);
AppIcon.Free;
WndIcon.Free;
ItemIcon.Free;
ItemBitmap.Free;
end;


initialization
  IsMultiThread:=true;
  AppInit;

finalization
  AppFinal;


end.

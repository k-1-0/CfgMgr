unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ProfileType, ExtCtrls;

const

  PRESETS_VARS_INFO = 'In target profile path, deleting filenames, application path and application args you may use this embedded variables:' + #13#10#13#10 +
                      '%PROFILE_DIR% .................... profile DB directory' + #13#10 +
                      '%TARGET_CONFIG% ............ target config filename' + #13#10 +
                      '%TARGET_CONFIG_DIR% .... target config directory' + #13#10 +
                      '%APP_FILE% .......................... launching application filename' + #13#10 +
                      '%APP_DIR% ........................... launching application directory' + #13#10#13#10 +
                      'Also system environment variables.';


type
  TProfileForm = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit3: TEdit;
    Label3: TLabel;
    Edit2: TEdit;
    CheckBox1: TCheckBox;
    Edit4: TEdit;
    CheckBox2: TCheckBox;
    Label5: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    Label6: TLabel;
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    Button1: TButton;
    Button2: TButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    GroupBox2: TGroupBox;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    Edit5: TEdit;
    Label7: TLabel;
    Label4: TLabel;
    GroupBox3: TGroupBox;
    Button3: TButton;
    StaticText1: TStaticText;
    CheckBox3: TCheckBox;
    SpeedButton1: TSpeedButton;
    Bevel1: TBevel;
    Label8: TLabel;
    Image1: TImage;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    RadioButton8: TRadioButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure RadioButton8Click(Sender: TObject);
  private
    { Private declarations }
    FProfile: TProfile;
    FbIconChanged, FbIconPresented: Boolean;
    procedure SetControlsState;
  public
    { Public declarations }
  end;


function ShowProfileForm(const bNewProfile: Boolean; var Profile: TProfile): Boolean;


implementation

{$R *.DFM}

uses Utils, Unit3;


function ShowProfileForm(const bNewProfile: Boolean; var Profile: TProfile): Boolean;
var
ProfileForm: TProfileForm;
i, x, y: Integer;
begin
ProfileForm:=TProfileForm.Create(Application);
try
  with ProfileForm do
    begin
    if bNewProfile then Caption:='New Profile'
                   else Caption:='Edit Profile "' + Profile.ProfileName + '"';
    FProfile:=Profile;
    Edit2.Text:=FProfile.ProfileName;
    Edit1.Text:=FProfile.ProfileDirectory;
    Edit3.Text:=FProfile.TargetConfig;
    Edit4.Text:=FProfile.AppPath;
    Edit5.Text:=FProfile.AppArgs;

    FbIconChanged:=false;
    FbIconPresented:=FProfile.bIconPresented;
    if FProfile.bIconPresented then
      begin
      Image1.Picture.Bitmap.Width:=16;
      Image1.Picture.Bitmap.Height:=16;
      Image1.Picture.Bitmap.TransparentMode:=tmFixed;
      Image1.Picture.Bitmap.Transparent:=true;
      Image1.Picture.Bitmap.TransparentColor:=FProfile.IconData.dwTransparentColor;
      for x:=0 to 15 do
        begin
        for y:=0 to 15 do
          Image1.Picture.Bitmap.Canvas.Pixels[x, y]:=FProfile.IconData.Pixels[x, y];
        end;
      end;

    CheckBox1.Checked:=FProfile.bLaunchApplication;
    CheckBox2.Checked:=FProfile.bDeleteConfigAfterAppEnded;
    CheckBox3.Checked:=FProfile.bUpdateConfigAfterAppEnded;
    case FProfile.AfterLaunchAppAction of
      AFTER_LAUNCH_APP_ACTION_NONE     : RadioButton1.Checked:=true;
      AFTER_LAUNCH_APP_ACTION_MINIMIZE : RadioButton2.Checked:=true;
      AFTER_LAUNCH_APP_ACTION_TRAY     : RadioButton3.Checked:=true;
      AFTER_LAUNCH_APP_ACTION_HIDE     : RadioButton7.Checked:=true;
      AFTER_LAUNCH_APP_ACTION_EXIT     : RadioButton8.Checked:=true;
      end;
    case FProfile.AfterEndingAppAction of
      AFTER_ENDING_APP_ACTION_NONE     : RadioButton4.Checked:=true;
      AFTER_ENDING_APP_ACTION_RESTORE  : RadioButton5.Checked:=true;
      AFTER_ENDING_APP_ACTION_EXIT     : RadioButton6.Checked:=true;
      end;
    Memo1.Lines:=FProfile.FilesDeletingBeforeLaunchApp;
    Memo2.Lines:=FProfile.FilesDeletingAfterEndingApp;

    if FProfile.Password <> '' then
      begin
      StaticText1.Caption:='Keyword found';
      StaticText1.Font.Color:=clGreen;
      end;
    Button3.Enabled:=bNewProfile;

    result:=ShowModal = mrOK;

    if result then
      begin
      FProfile.ProfileName:=Edit2.Text;
      FProfile.ProfileDirectory:=NormalizeDirName(Edit1.Text);
      FProfile.TargetConfig:=Edit3.Text;
      FProfile.AppPath:=Edit4.Text;
      FProfile.AppArgs:=Edit5.Text;
      FProfile.bLaunchApplication:=CheckBox1.Checked;
      FProfile.bDeleteConfigAfterAppEnded:=CheckBox2.Checked;
      FProfile.bUpdateConfigAfterAppEnded:=CheckBox3.Checked;

           if RadioButton2.Checked then FProfile.AfterLaunchAppAction:=AFTER_LAUNCH_APP_ACTION_MINIMIZE
      else if RadioButton3.Checked then FProfile.AfterLaunchAppAction:=AFTER_LAUNCH_APP_ACTION_TRAY
      else if RadioButton7.Checked then FProfile.AfterLaunchAppAction:=AFTER_LAUNCH_APP_ACTION_HIDE
      else if RadioButton8.Checked then FProfile.AfterLaunchAppAction:=AFTER_LAUNCH_APP_ACTION_EXIT
      else FProfile.AfterLaunchAppAction:=AFTER_LAUNCH_APP_ACTION_NONE;

           if RadioButton5.Checked then FProfile.AfterEndingAppAction:=AFTER_ENDING_APP_ACTION_RESTORE
      else if RadioButton6.Checked then FProfile.AfterEndingAppAction:=AFTER_ENDING_APP_ACTION_EXIT
      else FProfile.AfterEndingAppAction:=AFTER_ENDING_APP_ACTION_NONE;

      FProfile.FilesDeletingBeforeLaunchApp.Clear;
      for i:=0 to Memo1.Lines.Count - 1 do
        begin
        if Memo1.Lines[i] <> '' then FProfile.FilesDeletingBeforeLaunchApp.Add(Memo1.Lines[i]);
        end;

      FProfile.FilesDeletingAfterEndingApp.Clear;
      for i:=0 to Memo2.Lines.Count - 1 do
        begin
        if Memo2.Lines[i] <> '' then FProfile.FilesDeletingAfterEndingApp.Add(Memo2.Lines[i]);
        end;

      //ShowError(IntToStr(FProfile.FilesDeletingBeforeLaunchApp.Count));
      end;
    end;
finally
  ProfileForm.Free;
  end;
end;



procedure TProfileForm.SetControlsState;
var
bLaunchApp: Boolean;
begin
bLaunchApp:=CheckBox1.Checked;
CheckBox2.Enabled:=bLaunchApp;
CheckBox3.Enabled:=bLaunchApp;
Label4.Enabled:=bLaunchApp;
Label5.Enabled:=bLaunchApp;
Label6.Enabled:=bLaunchApp;
Label7.Enabled:=bLaunchApp;
Edit4.Enabled:=bLaunchApp;
Edit5.Enabled:=bLaunchApp;
SpeedButton4.Enabled:=bLaunchApp;
Memo1.Enabled:=bLaunchApp;
Memo2.Enabled:=bLaunchApp;
RadioButton1.Enabled:=bLaunchApp;
RadioButton2.Enabled:=bLaunchApp;
RadioButton3.Enabled:=bLaunchApp;
GroupBox1.Enabled:=bLaunchApp;
RadioButton4.Enabled:=bLaunchApp;
RadioButton5.Enabled:=bLaunchApp;
RadioButton6.Enabled:=bLaunchApp;
RadioButton7.Enabled:=bLaunchApp;
GroupBox2.Enabled:=bLaunchApp;
Label6.Enabled:=NOT RadioButton8.Checked;
Memo2.Enabled:=NOT RadioButton8.Checked;
end;


procedure TProfileForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
Action:=caFree;
end;

procedure TProfileForm.FormCreate(Sender: TObject);
begin
GroupBox1.Ctl3D:=false;
GroupBox2.Ctl3D:=false;
GroupBox3.Ctl3D:=false;
SetControlsState;
end;

procedure TProfileForm.CheckBox1Click(Sender: TObject);
begin
SetControlsState;
end;

procedure TProfileForm.SpeedButton2Click(Sender: TObject);
var
Dir: WideString;
begin
if SelectDir(Handle, 'Select profile directory...', Dir) then
  begin
  FProfile.ProfileDirectory:=Dir;
  Edit1.Text:=Dir;
  end;
Edit1.SetFocus;
Edit1.SelStart:=length(Edit1.Text);
Edit1.SelLength:=0;
end;

procedure TProfileForm.SpeedButton3Click(Sender: TObject);
var
FileName: WideString;
begin
if GetFileNameW(True, Handle, FileName, 'Select target config file...',
                '', '', SelfDir, 0) then
  begin
  Edit3.Text:=FileName;
  FProfile.TargetConfig:=FileName;
  end;
Edit3.SetFocus;
Edit3.SelStart:=length(Edit3.Text);
Edit3.SelLength:=0;
end;


procedure TProfileForm.SpeedButton1Click(Sender: TObject);
var
FileName: WideString;
Icon: TIcon;
Dir: WideString;
begin
if (Edit1.Text <> '') AND DirectoryExistsW(Edit1.Text) then Dir:=Edit1.Text
                                                       else Dir:=SelfDir;
if NOT GetFileNameW(true, Handle, FileName, 'Select config icon file (16 x 16 pixels)...',
                    'Icon Files (*.ico)'#0'*.ico'#0'All Files (*.*)'#'*.*'#0#0,
                    '', Dir, 0) then Exit;
try
  Icon:=TIcon.Create;
  Icon.Width:=16;
  Icon.Height:=16;
  Icon.Transparent:=false;
  Icon.Handle:=LoadImageW(0, PWideChar(FileName), IMAGE_ICON, 16, 16, LR_LOADFROMFILE);
  Image1.Canvas.FillRect(Image1.Canvas.ClipRect);
  Image1.Canvas.Draw(0, 0, Icon);
  Image1.Height:=16; //  чтоб не обрезалась
  Image1.Width:=16;  //  иконка
  Icon.Free;
  FbIconChanged:=true;
  FbIconPresented:=true;
except
  ShowError('Load icon failed.');
  FbIconChanged:=false;
  end;
end;


procedure TProfileForm.SpeedButton4Click(Sender: TObject);
var
FileName: WideString;
Dir: WideString;
begin
if Edit3.Text <> '' then
  begin
  Dir:=ExtractFilePathW(Edit3.Text);
  if NOT DirectoryExistsW(Dir) then Dir:=SelfDir;
  end
else Dir:=SelfDir;

if GetFileNameW(True, Handle, FileName, 'Select application...',
                'EXE Files (*.exe)'#0'*.exe'#0'All Files (*.*)'#0'*.*'#0#0,
                '', SelfDir, 0) then
  begin
  FProfile.AppPath:=FileName;
  Edit4.Text:=FileName;
  end;
Edit4.SetFocus;
Edit4.SelStart:=length(Edit4.Text);
Edit4.SelLength:=0;
end;



procedure TProfileForm.Button1Click(Sender: TObject);
var
x, y: Integer;
IconData: TIconData;
begin
if Edit2.Text = '' then
  begin
  ShowMessage('Profile name must be specified.');
  Exit;
  end;

if FProfile.ProfileDirectory = '' then
  begin
  if Edit1.Text = '' then
    begin
    ShowMessage('Profile directory must be specified.');
    Exit;
    end
  else FProfile.ProfileDirectory:=Edit1.Text;
  end;

if FProfile.TargetConfig = '' then
  begin
  if Edit3.Text = '' then
    begin
    ShowMessage('Target config must be specified.');
    Exit;
    end
  else FProfile.TargetConfig:=Edit3.Text;
  end;

if FProfile.Password = '' then
  begin
  ShowMessage('Encryption must be specified.');
  Exit;
  end;

if CheckBox1.Checked then
  begin
  if FProfile.AppPath = '' then
    begin
    if Edit4.Text = '' then
      begin
      ShowMessage('Launching application must be specified.');
      Exit;
      end
    else FProfile.AppPath:=Edit4.Text;
    end;
  end;


FProfile.bIconPresented:=FbIconPresented;
FProfile.bIconChanged:=FbIconChanged;
if FbIconChanged then
  begin
  if FbIconPresented then
    begin
    IconData.dwTransparentColor:=Image1.Picture.Bitmap.TransparentColor;
    for x:=0 to 15 do
      begin
      for y:=0 to 15 do IconData.Pixels[x, y]:=GetPixel(Image1.Canvas.Handle, x, y);
      end;
    end
  else ZeroMemory(@IconData, SizeOf(IconData));
  FProfile.IconData:=IconData;
  end;

ModalResult:=mrOK;
end;



procedure TProfileForm.Button3Click(Sender: TObject);
var
Password1, Password2: WideString;
begin
if NOT ShowPasswordForm('Enter keyword for profile:', Password1) then Exit;
if NOT ShowPasswordForm('Confirm keyword:', Password2) then Exit;
if Password1 = Password2 then
  begin
  FProfile.Password:=Password1;
  StaticText1.Caption:='Keyword found';
  StaticText1.Font.Color:=clGreen;
  end
else ShowMessage('Keywords not equal.');
end;


procedure TProfileForm.SpeedButton5Click(Sender: TObject);
begin
Image1.Canvas.FillRect(Image1.Canvas.ClipRect);
FbIconPresented:=false;
FbIconChanged:=true;
end;

procedure TProfileForm.SpeedButton6Click(Sender: TObject);
begin
MessageBox(Handle, PRESETS_VARS_INFO, 'Info', MB_OK OR MB_ICONINFORMATION);
end;

procedure TProfileForm.RadioButton1Click(Sender: TObject);
begin
SetControlsState;
end;

procedure TProfileForm.RadioButton2Click(Sender: TObject);
begin
SetControlsState;
end;

procedure TProfileForm.RadioButton3Click(Sender: TObject);
begin
SetControlsState;
end;

procedure TProfileForm.RadioButton8Click(Sender: TObject);
begin
SetControlsState;
end;

end.

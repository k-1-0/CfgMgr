unit ProfileType;

interface

uses Windows, SysUtils, Classes, Crypt, Utils, Graphics;


const

  AFTER_LAUNCH_APP_ACTION_NONE                 = 0;
  AFTER_LAUNCH_APP_ACTION_MINIMIZE             = 1;
  AFTER_LAUNCH_APP_ACTION_TRAY                 = 2;
  AFTER_LAUNCH_APP_ACTION_HIDE                 = 3;
  AFTER_LAUNCH_APP_ACTION_EXIT                 = 4;

  AFTER_ENDING_APP_ACTION_NONE                 = 0;
  AFTER_ENDING_APP_ACTION_RESTORE              = 1;
  AFTER_ENDING_APP_ACTION_EXIT                 = 2;

  MAIN_FORM_ACTION_RESTORE                     = 10;

  PROFILE_ERR_SUCCESS                          = 0;
  PROFILE_ERR_AUTH_FAILED                      = 1;
  PROFILE_ERR_PROFILE_DIRECTORY_NOT_FOUND      = 2;
  PROFILE_ERR_PROFILE_FILE_NOT_FOUND           = 3;
  PROFILE_ERR_CONFIG_FILE_NOT_FOUND            = 4;
  PROFILE_ERR_DELETE_PROFILE_FILE_FAILED       = 5;
  PROFILE_ERR_SAVE_VALUE_FAILED                = 6;
  PROFILE_ERR_READ_VALUE_FAILED                = 7;
  PROFILE_ERR_CONFIG_NAME_EXISTS               = 8;
  PROFILE_ERR_DELETE_INI_SECTION_FAILED        = 9;
  PROFILE_ERR_INVALID_CONFIG_INDEX             = 10;
  PROFILE_ERR_DELETE_CONFIG_FILE_FAILED        = 11;
  PROFILE_ERR_CRYPT_COPY_FAILED                = 100;


function ProfileErrToStr(dwErrCode: DWORD): AnsiString;


type

  TCfgFile = record
    CfgName: WideString;
    FileName: WideString;
    PlainFileHash: T128bit;
    IV: T128bit;
    end;

  TCfgFileList = Array of TCfgFile;

  TIcon16x16Pixels = packed Array[0..15, 0..15] of COLORREF;

  TIconData = packed record
                dwTransparentColor: COLORREF;
                Pixels: TIcon16x16Pixels;
              end;
  PIConData = ^TIconData;

  TCryptedIconData = packed record
                       IV: T128bit;
                       IconData: TIconData;
                     end;
  PCryptedIconData = ^TCryptedIconData;

{ TProfile }

  TProfile = class
  private
    FProfileName: WideString;
    FProfileDirectory: WideString;
    FProfileFileName: WideString;
    FTargetConfig: WideString;
    FbIconPresented: Boolean;
    FbIconChanged: Boolean;
    FIconData: TIconData;
    FPassword: WideString;
    FSalt: WideString;
    FAppPath: WideString;
    FAppArgs: WideString;
    FbLaunchApplication: Boolean;
    FbUpdateConfigAfterAppEnded: Boolean;
    FbDeleteConfigAfterAppEnded: Boolean;
    FAfterLaunchAppAction: Integer;
    FAfterEndingAppAction: Integer;
    FFilesDeletingBeforeLaunchApp: TStringList;
    FFilesDeletingAfterEndingApp: TStringList;
    FConfigs: TCfgFileList;
    function SaveCryptedExpandedStrWHex(const Section, Key, Value: WideString): Boolean;
    function SaveCryptedIconData(const Section, Key: WideString): Boolean;
    function ReadCryptedIconData(const Section, Key: WideString): Boolean;
  public
    property ProfileName: WideString read FProfileName write FProfileName;
    property ProfileDirectory: WideString read FProfileDirectory write FProfileDirectory;
    property TargetConfig: WideString read FTargetConfig write FTargetConfig;
    property bIconPresented: Boolean read FbIconPresented write FbIconPresented;
    property bIconChanged: Boolean read FbIconChanged write FbIconChanged;
    property IconData: TIconData read FIconData write FIconData;
    property AppPath: WideString read FAppPath write FAppPath;
    property AppArgs: WideString read FAppArgs write FAppArgs;
    property Password: WideString read FPassword write FPassword;
    property bLaunchApplication: Boolean read FbLaunchApplication write FbLaunchApplication;
    property bUpdateConfigAfterAppEnded: Boolean read FbUpdateConfigAfterAppEnded write FbUpdateConfigAfterAppEnded;
    property bDeleteConfigAfterAppEnded: Boolean read FbDeleteConfigAfterAppEnded write FbDeleteConfigAfterAppEnded;
    property AfterLaunchAppAction: Integer read FAfterLaunchAppAction write FAfterLaunchAppAction;
    property AfterEndingAppAction: Integer read FAfterEndingAppAction write FAfterEndingAppAction;
    property FilesDeletingBeforeLaunchApp: TStringList read FFilesDeletingBeforeLaunchApp write FFilesDeletingBeforeLaunchApp;
    property FilesDeletingAfterEndingApp: TStringList read FFilesDeletingAfterEndingApp write FFilesDeletingAfterEndingApp;
    property Configs: TCfgFileList read FConfigs write FConfigs;
    constructor Create;
    destructor Destroy; override;
    function UpdateProfileFile: DWORD;
    function SaveNewProfile: DWORD;
    function Load(const FileName: WideString): DWORD;
    function AddConfig(const NewConfigName, NewConfigFileName: WideString): DWORD;
    function UpdateConfigsInProfileFile: DWORD;
    function DeleteConfig(const Index: Integer): DWORD;
    function MoveConfigUp(const Index: Integer): DWORD;
    function MoveConfigDown(const Index: Integer): DWORD;
  published

  end;

  PProfile = ^TProfile;



implementation


const

  CFG_MGR_PROFILE_FILENAME       = 'cfg_mgr_profile.ini';
  INI_PROFILE_SECTION            = 'Profile';
  INI_AUTH_SECTION               = 'Auth';
  INI_DEL_FILES_BEFORE_SECTION   = 'FilesDeletingBeforeLaunchApp';
  INI_DEL_FILES_AFTER_SECTION    = 'FilesDeletingAfterEndingApp';
  INI_CONFIG_SECTION             = 'config_';


  
function ProfileErrToStr(dwErrCode: DWORD): AnsiString;
begin
if dwErrCode >= PROFILE_ERR_CRYPT_COPY_FAILED
  then  result:='PROFILE_ERR_CRYPT_COPY_FAILED / ' +
                Crypt_ErrToStr(dwErrCode - PROFILE_ERR_CRYPT_COPY_FAILED)
else
  begin
  case dwErrCode of
    PROFILE_ERR_SUCCESS                     : result:='PROFILE_ERR_SUCCESS';
    PROFILE_ERR_AUTH_FAILED                 : result:='PROFILE_ERR_AUTH_FAILED';
    PROFILE_ERR_PROFILE_DIRECTORY_NOT_FOUND : result:='PROFILE_ERR_PROFILE_DIRECTORY_NOT_FOUND';
    PROFILE_ERR_PROFILE_FILE_NOT_FOUND      : result:='PROFILE_ERR_PROFILE_FILE_NOT_FOUND';
    PROFILE_ERR_CONFIG_FILE_NOT_FOUND       : result:='PROFILE_ERR_CONFIG_FILE_NOT_FOUND';
    PROFILE_ERR_DELETE_PROFILE_FILE_FAILED  : result:='PROFILE_ERR_DELETE_PROFILE_FILE_FAILED';
    PROFILE_ERR_SAVE_VALUE_FAILED           : result:='PROFILE_ERR_SAVE_VALUE_FAILED';
    PROFILE_ERR_READ_VALUE_FAILED           : result:='PROFILE_ERR_READ_VALUE_FAILED';
    PROFILE_ERR_CONFIG_NAME_EXISTS          : result:='PROFILE_ERR_CONFIG_NAME_EXISTS';
    PROFILE_ERR_DELETE_INI_SECTION_FAILED   : result:='PROFILE_ERR_DELETE_INI_SECTION_FAILED';
    PROFILE_ERR_INVALID_CONFIG_INDEX        : result:='PROFILE_ERR_INVALID_CONFIG_INDEX';
    PROFILE_ERR_DELETE_CONFIG_FILE_FAILED   : result:='PROFILE_ERR_DELETE_CONFIG_FILE_FAILED';
    PROFILE_ERR_CRYPT_COPY_FAILED           : result:='PROFILE_ERR_CRYPT_COPY_FAILED / ' +
                                                      Crypt_ErrToStr(dwErrCode - PROFILE_ERR_CRYPT_COPY_FAILED);
    else                                      result:=' # ' + IntToStr(dwErrCode);
    end;
  end;
end;


constructor TProfile.Create;
begin
SetLength(FProfileName, 0);
SetLength(FProfileDirectory, 0);
SetLength(FTargetConfig, 0);
SetLength(FPassword, 0);
SetLength(FSalt, 0);
SetLength(FAppPath, 0);
SetLength(FAppArgs, 0);
FbLaunchApplication:=false;
FbDeleteConfigAfterAppEnded:=false;
FbUpdateConfigAfterAppEnded:=false;
FAfterLaunchAppAction:=AFTER_LAUNCH_APP_ACTION_NONE;
FAfterEndingAppAction:=AFTER_ENDING_APP_ACTION_NONE;
FFilesDeletingBeforeLaunchApp:=TStringList.Create;
FFilesDeletingAfterEndingApp:=TStringList.Create;
SetLength(FConfigs, 0);
FbIconPresented:=false;
FbIconChanged:=false;
ZeroMemory(@FIconData, SizeOf(FIconData));
end;


destructor TProfile.Destroy;
var
i: Integer;

  procedure ZeroWideString(var Value: WideString);
  begin
  if length(Value) > 0 then
    begin
    ZeroMemory(PWideChar(Value), length(Value) shl 1);
    SetLength(Value, 0);
    end;
  end;

  procedure ZeroConfigsRecord(Index: Integer);
  begin
  ZeroMemory(PWideChar(FConfigs[Index].CfgName), length(FConfigs[Index].CfgName) shl 1);
  SetLength(FConfigs[Index].CfgName, 0);
  ZeroMemory(PWideChar(FConfigs[Index].FileName), length(FConfigs[Index].FileName) shl 1);
  SetLength(FConfigs[Index].FileName, 0);
  ZeroMemory(@FConfigs[Index].PlainFileHash, SizeOf(FConfigs[Index].PlainFileHash));
  ZeroMemory(@FConfigs[Index].IV, SizeOf(FConfigs[Index].IV));
  end;

begin
ZeroWideString(FProfileName);
ZeroWideString(FProfileDirectory);
ZeroWideString(FTargetConfig);
ZeroWideString(FPassword);
ZeroWideString(FSalt);
ZeroWideString(FAppPath);
ZeroWideString(FAppArgs);
FbLaunchApplication:=false;
FbUpdateConfigAfterAppEnded:=false;
FbDeleteConfigAfterAppEnded:=false;
FAfterLaunchAppAction:=AFTER_LAUNCH_APP_ACTION_NONE;
FAfterEndingAppAction:=AFTER_ENDING_APP_ACTION_NONE;
FFilesDeletingBeforeLaunchApp.Free;
FFilesDeletingAfterEndingApp.Free;

if length(FConfigs) > 0 then
  begin
  for i:=0 to length(FConfigs) - 1 do ZeroConfigsRecord(i);
  end;
SetLength(FConfigs, 0);

FbIconPresented:=false;
FbIconChanged:=false;
ZeroMemory(@FIconData, SizeOf(FIconData));

inherited;
end;




function TProfile.SaveCryptedExpandedStrWHex(const Section, Key, Value: WideString): Boolean;

  function EncryptExpandedStrWHex(const SrcStr: WideString): WideString;
  begin
  if length(SrcStr) < 96 then
    begin
    SetLength(result, 96);
    ZeroMemory(PWideChar(result), 96 shl 1);
    CopyMemory(PWideChar(result), PWideChar(SrcStr), length(SrcStr) shl 1);
    end
  else result:=SrcStr;
  result:=StrWToHexW(Crypt_EncryptStringW(result));
  end;

begin
result:=IniSetStrW(FProfileFileName, Section, Key, EncryptExpandedStrWHex(Value));
end;




function TProfile.SaveCryptedIconData(const Section, Key: WideString): Boolean;
var
pData: PCryptedIconData;
begin
GetMem(pData, SizeOf(pData^));
try     
  pData^.IconData.dwTransparentColor:=FIconData.dwTransparentColor;
  CopyMemory(@pData^.IconData.Pixels, @FIconData.Pixels, SizeOf(FIconData.Pixels));
  Crypt_GenerateRandom128bit(@pData^.IV);
  Crypt_CryptMemory_CTR(@pData^.IconData, SizeOf(pData^.IconData), @pData^.IV);
  result:=WritePrivateProfileStructW(PWideChar(Section), PWideChar(Key), pData,
                                     SizeOf(pData^), PWideChar(FProfileFileName));
finally
  FreeMem(pData, SizeOf(pData^));
  end;
end;





function TProfile.ReadCryptedIconData(const Section, Key: WideString): Boolean;
var
pData: PCryptedIconData;
begin
GetMem(pData, SizeOf(pData^));
try
  result:=GetPrivateProfileStructW(PWideChar(Section), PWideChar(Key), pData,
                                   SizeOf(pData^), PWideChar(FProfileFileName));
  if result then
    begin
    Crypt_CryptMemory_CTR(@pData^.IconData, SizeOf(pData^.IconData), @pData^.IV);
    CopyMemory(@FIconData.Pixels, @pData^.IconData.Pixels, SizeOf(pData^.IconData.Pixels));
    FIconData.dwTransparentColor:=pData^.IconData.dwTransparentColor;
    end;
finally
  FreeMem(pData, SizeOf(pData^));
  end;
end;


function TProfile.UpdateProfileFile: DWORD;
var
i: Integer;
begin
if NOT DirectoryExistsW(FProfileDirectory) then
  begin
  result:=PROFILE_ERR_PROFILE_DIRECTORY_NOT_FOUND;
  Exit;
  end;

if NOT FileExistsW(FProfileFileName) then
  begin
  result:=PROFILE_ERR_PROFILE_FILE_NOT_FOUND;
  Exit;
  end;

if NOT SaveCryptedExpandedStrWHex(INI_PROFILE_SECTION, 'Name', FProfileName) then
  begin
  result:=PROFILE_ERR_SAVE_VALUE_FAILED;
  Exit;
  end;

if NOT SaveCryptedExpandedStrWHex(INI_PROFILE_SECTION, 'Directory', FProfileDirectory) then
  begin
  result:=PROFILE_ERR_SAVE_VALUE_FAILED;
  Exit;
  end;

if NOT SaveCryptedExpandedStrWHex(INI_PROFILE_SECTION, 'Target', FTargetConfig) then
  begin
  result:=PROFILE_ERR_SAVE_VALUE_FAILED;
  Exit;
  end;

if NOT SaveCryptedExpandedStrWHex(INI_PROFILE_SECTION, 'AppPath', FAppPath) then
  begin
  result:=PROFILE_ERR_SAVE_VALUE_FAILED;
  Exit;
  end;

if NOT SaveCryptedExpandedStrWHex(INI_PROFILE_SECTION, 'AppArgs', FAppArgs) then
  begin
  result:=PROFILE_ERR_SAVE_VALUE_FAILED;
  Exit;
  end;

if NOT SaveCryptedExpandedStrWHex(INI_PROFILE_SECTION, 'AppArgs', FAppArgs) then
  begin
  result:=PROFILE_ERR_SAVE_VALUE_FAILED;
  Exit;
  end;

if NOT IniSetBool(FProfileFileName, INI_PROFILE_SECTION, 'LaunchApplication', FbLaunchApplication) then
  begin
  result:=PROFILE_ERR_SAVE_VALUE_FAILED;
  Exit;
  end;

if NOT IniSetBool(FProfileFileName, INI_PROFILE_SECTION, 'UpdateConfigAfterAppEnded', FbUpdateConfigAfterAppEnded) then
  begin
  result:=PROFILE_ERR_SAVE_VALUE_FAILED;
  Exit;
  end;

if NOT IniSetBool(FProfileFileName, INI_PROFILE_SECTION, 'DeleteConfigAfterAppEnded', FbDeleteConfigAfterAppEnded) then
  begin
  result:=PROFILE_ERR_SAVE_VALUE_FAILED;
  Exit;
  end;

if NOT IniSetInt(FProfileFileName, INI_PROFILE_SECTION, 'AfterLaunchAppAction', FAfterLaunchAppAction) then
  begin
  result:=PROFILE_ERR_SAVE_VALUE_FAILED;
  Exit;
  end;

if NOT IniSetInt(FProfileFileName, INI_PROFILE_SECTION, 'AfterEndingAppAction', FAfterEndingAppAction) then
  begin
  result:=PROFILE_ERR_SAVE_VALUE_FAILED;
  Exit;
  end;

IniDeleteSection(FProfileFileName, INI_DEL_FILES_BEFORE_SECTION);
if FFilesDeletingBeforeLaunchApp.Count > 0 then
  begin
  for i:=0 to FFilesDeletingBeforeLaunchApp.Count - 1 do
    begin
    if NOT SaveCryptedExpandedStrWHex(INI_DEL_FILES_BEFORE_SECTION, IntToStr(i),
                                      FFilesDeletingBeforeLaunchApp[i]) then
      begin
      result:=PROFILE_ERR_SAVE_VALUE_FAILED;
      Exit;
      end;
    end;
  end;

IniDeleteSection(FProfileFileName, INI_DEL_FILES_AFTER_SECTION);
if FFilesDeletingAfterEndingApp.Count > 0 then
  begin
  for i:=0 to FFilesDeletingAfterEndingApp.Count - 1 do
    begin
    if NOT SaveCryptedExpandedStrWHex(INI_DEL_FILES_AFTER_SECTION, IntToStr(i),
                                      FFilesDeletingAfterEndingApp[i]) then
      begin
      result:=PROFILE_ERR_SAVE_VALUE_FAILED;
      Exit;
      end;
    end;
  end;

if FbIconChanged then
  begin
  if FbIconPresented then
    begin
    if NOT SaveCryptedIconData(INI_PROFILE_SECTION, 'Icon') then
      begin
      result:=PROFILE_ERR_SAVE_VALUE_FAILED;
      Exit;
      end;
    end
  else IniDeleteValueW(FProfileFileName, INI_PROFILE_SECTION, 'Icon');
  end;

result:=PROFILE_ERR_SUCCESS;
end;



function TProfile.SaveNewProfile: DWORD;
var
PlainCheckingData, CheckingValue: T128bit;
begin
if NOT DirectoryExistsW(FProfileDirectory) then
  begin
  result:=PROFILE_ERR_PROFILE_DIRECTORY_NOT_FOUND;
  Exit;
  end;

FProfileFileName:=FProfileDirectory + CFG_MGR_PROFILE_FILENAME;;

if FileExistsW(FProfileFileName) then
  begin
  if NOT DeleteFileW(PWideChar(FProfileFileName)) then
    begin
    result:=PROFILE_ERR_DELETE_PROFILE_FILE_FAILED;
    Exit;
    end;
  end;

if FSalt = '' then FSalt:=Crypt_GenerateSalt;

Crypt_SetKey(FPassword, FSalt);

if NOT IniSetStrW(FProfileFileName, INI_AUTH_SECTION, 'Salt', StrWToHexW(FSalt)) then
  begin
  EraseFileW(FProfileFileName);
  result:=PROFILE_ERR_SAVE_VALUE_FAILED;
  Exit;
  end;

Crypt_SetKey(FPassword, FSalt);

Crypt_GenerateRandom128bit(@PlainCheckingData);

if NOT IniSet128bit(FProfileFileName, INI_AUTH_SECTION, 'SrcData', @PlainCheckingData) then
  begin
  EraseFileW(FProfileFileName);
  result:=PROFILE_ERR_SAVE_VALUE_FAILED;
  Exit;
  end;

Crypt_CipherBlock(@PlainCheckingData);

Crypt_Hash128(@PlainCheckingData, SizeOf(PlainCheckingData), 1, @CheckingValue);

if NOT IniSet128bit(FProfileFileName, INI_AUTH_SECTION, 'CheckingValue', @CheckingValue) then
  begin
  EraseFileW(FProfileFileName);
  result:=PROFILE_ERR_SAVE_VALUE_FAILED;
  Exit;
  end;

result:=UpdateProfileFile;
if result <> PROFILE_ERR_SUCCESS then EraseFileW(FProfileFileName);
end;




function TProfile.Load(const FileName: WideString): DWORD;
var
PlainCheckingData, IniCheckingValue, CalcCheckingValue: T128bit;
i: Integer;
sw: WideString;

  function ReadHexStrW(const Section, Key: WideString; var Res: WideString): Boolean;
  begin
  Res:=IniGetStrW(FileName, Section, Key, '');
  result:=length(Res) > 1;
  if result then Res:=HexStrWToStrW(Res);
  result:=length(Res) > 0;
  end;

  function ReadEncryptedExpandedStrW(const Section, Key: WideString; var Res: WideString): Boolean;
  var
  Len: Integer;
  begin
  result:=ReadHexStrW(Section, Key, Res);
  if NOT result then Exit;
  Res:=Crypt_DecryptStringW(Res);
  Len:=lstrlenW(PWideChar(Res));
  if Len < length(Res) then delete(Res, Len + 1, length(Res) - Len);
  end;

begin
if NOT FileExists(FileName) then
  begin
  result:=PROFILE_ERR_PROFILE_FILE_NOT_FOUND;
  Exit;
  end;

FProfileFileName:=FileName;

if NOT ReadHexStrW(INI_AUTH_SECTION, 'Salt', FSalt) then
  begin
  result:=PROFILE_ERR_READ_VALUE_FAILED;
  Exit;
  end;

if NOT IniGet128bit(FProfileFileName, INI_AUTH_SECTION, 'SrcData', @PlainCheckingData) then
  begin
  result:=PROFILE_ERR_READ_VALUE_FAILED;
  Exit;
  end;

if NOT IniGet128bit(FProfileFileName, INI_AUTH_SECTION, 'CheckingValue', @IniCheckingValue) then
  begin
  result:=PROFILE_ERR_READ_VALUE_FAILED;
  Exit;
  end;

//==============================================================================
//                           Crypto processing
//==============================================================================

Crypt_SetKey(FPassword, FSalt);

Crypt_CipherBlock(@PlainCheckingData);

Crypt_Hash128(@PlainCheckingData, SizeOf(PlainCheckingData), 1, @CalcCheckingValue);

if NOT CompareMem128(@IniCheckingValue, @CalcCheckingValue) then
  begin
  result:=PROFILE_ERR_AUTH_FAILED;
  Exit;
  end;

//==============================================================================

if NOT ReadEncryptedExpandedStrW(INI_PROFILE_SECTION, 'Name', FProfileName) then
  begin
  result:=PROFILE_ERR_READ_VALUE_FAILED;
  Exit;
  end;

if NOT ReadEncryptedExpandedStrW(INI_PROFILE_SECTION, 'Directory', FProfileDirectory) then
  begin
  result:=PROFILE_ERR_READ_VALUE_FAILED;
  Exit;
  end;

if NOT ReadEncryptedExpandedStrW(INI_PROFILE_SECTION, 'Directory', FProfileDirectory) then
  begin
  result:=PROFILE_ERR_READ_VALUE_FAILED;
  Exit;
  end;

if NOT ReadEncryptedExpandedStrW(INI_PROFILE_SECTION, 'Target', FTargetConfig) then
  begin
  result:=PROFILE_ERR_READ_VALUE_FAILED;
  Exit;
  end;

if NOT ReadEncryptedExpandedStrW(INI_PROFILE_SECTION, 'AppPath', FAppPath) then
  begin
  result:=PROFILE_ERR_READ_VALUE_FAILED;
  Exit;
  end;

if NOT ReadEncryptedExpandedStrW(INI_PROFILE_SECTION, 'AppArgs', FAppArgs) then
  begin
  result:=PROFILE_ERR_READ_VALUE_FAILED;
  Exit;
  end;

FbLaunchApplication:=IniGetBool(FileName, INI_PROFILE_SECTION, 'LaunchApplication');

FbUpdateConfigAfterAppEnded:=IniGetBool(FileName, INI_PROFILE_SECTION, 'UpdateConfigAfterAppEnded');

FbDeleteConfigAfterAppEnded:=IniGetBool(FileName, INI_PROFILE_SECTION, 'DeleteConfigAfterAppEnded');

FAfterLaunchAppAction:=IniGetInt(FileName, INI_PROFILE_SECTION, 'AfterLaunchAppAction', AFTER_LAUNCH_APP_ACTION_NONE);

FAfterEndingAppAction:=IniGetInt(FileName, INI_PROFILE_SECTION, 'AfterEndingAppAction', AFTER_ENDING_APP_ACTION_NONE);

i:=0;
while ReadEncryptedExpandedStrW(INI_DEL_FILES_BEFORE_SECTION, IntToStr(i), sw) do
  begin
  FFilesDeletingBeforeLaunchApp.Add(sw);
  inc(i);
  end;

i:=0;
while ReadEncryptedExpandedStrW(INI_DEL_FILES_AFTER_SECTION, IntToStr(i), sw) do
  begin
  FFilesDeletingAfterEndingApp.Add(sw);
  inc(i);
  end;

SetLength(FConfigs, 0);
i:=0;
sw:=INI_CONFIG_SECTION + IntToStr(i);
while IniSectionExists(FProfileFileName, sw) do
  begin
  SetLength(FConfigs, length(FConfigs) + 1);
  FConfigs[High(FConfigs)].FileName:=IniGetStrW(FProfileFileName, sw, 'File', '');
  if NOT ((FConfigs[High(FConfigs)].FileName <> '') AND
          ReadEncryptedExpandedStrW(sw, 'Name', FConfigs[High(FConfigs)].CfgName) AND
          IniGet128bit(FProfileFileName, sw, 'IV', @FConfigs[High(FConfigs)].IV) AND
          IniGet128bit(FProfileFileName, sw, 'PlainFileHash', @FConfigs[High(FConfigs)].PlainFileHash)) then
    SetLength(FConfigs, length(FConfigs) - 1);
  inc(i);
  sw:=INI_CONFIG_SECTION + IntToStr(i);
  end;

FbIconPresented:=ReadCryptedIconData(INI_PROFILE_SECTION, 'Icon');
FbIconChanged:=false;

result:=PROFILE_ERR_SUCCESS;
end;



function TProfile.UpdateConfigsInProfileFile: DWORD;
var
i: Integer;
Section: WideString;
begin
result:=PROFILE_ERR_SUCCESS;
// delete all "config" sections
i:=0;
Section:=INI_CONFIG_SECTION + IntToStr(i);
while IniSectionExists(FProfileFileName, Section) do
  begin
  if NOT IniDeleteSection(FProfileFileName, Section)
    then result:=PROFILE_ERR_DELETE_INI_SECTION_FAILED;
  inc(i);
  Section:=INI_CONFIG_SECTION + IntToStr(i);
  end;

if result = PROFILE_ERR_SUCCESS then
  begin
  // write all "config" sections
  for i:=0 to length(FConfigs) - 1 do
    begin
    Section:=INI_CONFIG_SECTION + IntToStr(i);
    if NOT SaveCryptedExpandedStrWHex(Section, 'Name', FConfigs[i].CfgName) then
      begin
      result:=PROFILE_ERR_SAVE_VALUE_FAILED;
      Exit;
      end;
    if NOT IniSetStrW(FProfileFileName, Section, 'File', FConfigs[i].FileName) then
      begin
      result:=PROFILE_ERR_SAVE_VALUE_FAILED;
      Exit;
      end;
    if NOT IniSet128bit(FProfileFileName, Section, 'IV', @FConfigs[i].IV) then
      begin
      result:=PROFILE_ERR_SAVE_VALUE_FAILED;
      Exit;
      end;
    if NOT IniSet128bit(FProfileFileName, Section, 'PlainFileHash', @FConfigs[i].PlainFileHash) then
      begin
      result:=PROFILE_ERR_SAVE_VALUE_FAILED;
      Exit;
      end;
    end;
  end;
end;



function TProfile.AddConfig(const NewConfigName, NewConfigFileName: WideString): DWORD;
var
i: Integer;
FileName: WideString;
dwFileName, dwRes: DWORD;
IV, SrcFileHash: T128bit;

  function CfgFileNameExists: Boolean;
  var
  j: Integer;
  begin
  result:=false;
  for j:=0 to length(FConfigs) - 1 do
    begin
    result:=FConfigs[j].FileName = FileName;
    if result then Break;
    end;
  end;

  function CfgIVExists: Boolean;
  var
  k: Integer;
  begin
  result:=false;
  for k:=0 to length(FConfigs) - 1 do
    begin
    result:=CompareMem128(@FConfigs[k].IV, @IV);
    if result then Break;
    end;
  end;


begin
if length(FConfigs) > 0 then
  begin
  for i:=0 to length(FConfigs) - 1 do
    begin
    if NewConfigName = FConfigs[i].CfgName then
      begin
      result:=PROFILE_ERR_CONFIG_NAME_EXISTS;
      Exit;
      end;
    end;
  end;

if NOT FileExistsW(NewConfigFileName) then
  begin
  result:=PROFILE_ERR_PROFILE_FILE_NOT_FOUND;
  Exit;
  end;

repeat
  Crypt_GenRandom(@dwFileName, SizeOf(dwFileName));
  FileName:=LowerCase(IntToHex(dwFileName, 8));
until NOT CfgFileNameExists;

repeat
  Crypt_GenerateRandom128bit(@IV);
until NOT CfgIVExists;
                       
dwRes:=Crypt_CryptAndCopyFile(NewConfigFileName,
                              FProfileDirectory + FileName + CFG_EXTENSION,
                              @IV, @SrcFileHash, nil);
if dwRes <> CRYPT_ERR_SUCCESS then
  begin
  result:=PROFILE_ERR_CRYPT_COPY_FAILED + dwRes;
  Exit;
  end;

SetLength(FConfigs, length(FConfigs) + 1);
FConfigs[High(FConfigs)].CfgName:=NewConfigName;
FConfigs[High(FConfigs)].FileName:=FileName;
FConfigs[High(FConfigs)].IV[0]:=IV[0];
FConfigs[High(FConfigs)].IV[1]:=IV[1];
FConfigs[High(FConfigs)].IV[2]:=IV[2];
FConfigs[High(FConfigs)].IV[3]:=IV[3];
FConfigs[High(FConfigs)].PlainFileHash[0]:=SrcFileHash[0];
FConfigs[High(FConfigs)].PlainFileHash[1]:=SrcFileHash[1];
FConfigs[High(FConfigs)].PlainFileHash[2]:=SrcFileHash[2];
FConfigs[High(FConfigs)].PlainFileHash[3]:=SrcFileHash[3];

result:=UpdateConfigsInProfileFile;
end;



function TProfile.DeleteConfig(const Index: Integer): DWORD;
var
i: Integer;
begin
if Index > length(FConfigs) - 1 then
  begin
  result:=PROFILE_ERR_INVALID_CONFIG_INDEX;
  Exit;
  end;

if NOT EraseFileW(FProfileDirectory + FConfigs[Index].FileName + CFG_EXTENSION) then
  begin
  result:=PROFILE_ERR_DELETE_CONFIG_FILE_FAILED;
  Exit;
  end;

for i:=Index to High(FConfigs) - 1 do FConfigs[i]:=FConfigs[i + 1];
SetLength(FConfigs, length(FConfigs) - 1);

result:=UpdateConfigsInProfileFile;
end;


function TProfile.MoveConfigUp(const Index: Integer): DWORD;
var
TmpConfig: TCfgFile;
begin
if (Index > length(FConfigs) - 1) OR (Index < 1) then
  begin
  result:=PROFILE_ERR_INVALID_CONFIG_INDEX;
  Exit;
  end;

TmpConfig:=FConfigs[Index - 1];
FConfigs[Index - 1]:=FConfigs[Index];
FConfigs[Index]:=TmpConfig;

result:=UpdateConfigsInProfileFile;
end;


function TProfile.MoveConfigDown(const Index: Integer): DWORD;
var
TmpConfig: TCfgFile;
begin
if (Index > length(FConfigs) - 1) OR (Index > length(FConfigs) - 1) then
  begin
  result:=PROFILE_ERR_INVALID_CONFIG_INDEX;
  Exit;
  end;

TmpConfig:=FConfigs[Index + 1];
FConfigs[Index + 1]:=FConfigs[Index];
FConfigs[Index]:=TmpConfig;

result:=UpdateConfigsInProfileFile;
end;







end.

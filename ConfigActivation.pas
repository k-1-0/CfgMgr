unit ConfigActivation;

interface

uses Forms, Windows, SysUtils, Classes, ShellAPI,
     ProfileType, Crypt, Utils;



procedure ActivateProfileConfig(var Profile: TProfile; const Index: Integer);


implementation


type

  TWaitThreadParams = packed record
    hAppProcess: THandle;
    CfgIndex: Integer;
    pProf: PProfile;
  end;
  PWaitThreadParams = ^TWaitThreadParams;


function ExpandVars(const SrcStr: WideString; var Profile: TProfile): WideString;
var
Str: WideString;
begin
result:=SrcStr;
repeat
  Str:=result;
  result:=StringReplaceW(result, '%PROFILE_DIR%', Profile.ProfileDirectory);
  result:=StringReplaceW(result, '%TARGET_CONFIG%', Profile.TargetConfig);
  result:=StringReplaceW(result, '%TARGET_CONFIG_DIR%', ExtractFilePathW(Profile.TargetConfig));
  result:=StringReplaceW(result, '%APP_FILE%', Profile.AppPath);
  result:=StringReplaceW(result, '%APP_DIR%', ExtractFilePathW(Profile.AppPath));
  result:=ExpandPathW(result);
until result = Str;
end;



function StartApp(const AppFile, Args: WideString; var hAppProcess: THandle): Boolean;
var
SeInfoW: SHELLEXECUTEINFOW;
begin
ZeroMemory(@SeInfoW, SizeOf(SeInfoW));
SeInfoW.cbSize:=SizeOf(SHELLEXECUTEINFOW);
SeInfoW.Wnd:=HWND_DESKTOP;
SeInfoW.lpVerb:='open';
SeInfoW.lpFile:=PWideChar(AppFile);
SeInfoW.lpDirectory:=PWideChar(ExtractFilePathW(AppFile));
if length(Args) > 0 then SeInfoW.lpParameters:=PWideChar(Args);
SeInfoW.nShow:=SW_SHOWNORMAL;
SeInfoW.fMask:=SEE_MASK_NOCLOSEPROCESS;
result:=ShellExecuteExW(@SeInfoW);
hAppProcess:=SeInfoW.hProcess;
end;



procedure WaitAppThreadProc(pParams: PWaitThreadParams); stdcall;
var
dwRes: DWORD;
i: Integer;
PlainFileHash: T128bit;
EncryptedConfig: WideString;
begin
WaitForSingleObject(pParams^.hAppProcess, INFINITE);
CloseHandle(pParams^.hAppProcess);

//------------------------------------------------------------------------------
//          Update encrypted config after application ended
//------------------------------------------------------------------------------
if pParams^.pProf^.bUpdateConfigAfterAppEnded then
  begin
  if FileExistsW(pParams^.pProf^.TargetConfig) then
    begin
    EncryptedConfig:=pParams^.pProf^.ProfileDirectory + pParams^.pProf^.Configs[pParams^.CfgIndex].FileName + CFG_EXTENSION;
    EraseFileW(EncryptedConfig);
    dwRes:=Crypt_CryptAndCopyFile(pParams^.pProf^.TargetConfig,
                                  EncryptedConfig,
                                  @pParams^.pProf^.Configs[pParams^.CfgIndex].IV,
                                  @PlainFileHash,
                                  nil);
    if dwRes = CRYPT_ERR_SUCCESS then
      begin
      pParams^.pProf^.Configs[pParams^.CfgIndex].PlainFileHash[0]:=PlainFileHash[0];
      pParams^.pProf^.Configs[pParams^.CfgIndex].PlainFileHash[1]:=PlainFileHash[1];
      pParams^.pProf^.Configs[pParams^.CfgIndex].PlainFileHash[2]:=PlainFileHash[2];
      pParams^.pProf^.Configs[pParams^.CfgIndex].PlainFileHash[3]:=PlainFileHash[3];
      dwRes:=pParams^.pProf^.UpdateConfigsInProfileFile;
      if dwRes <> PROFILE_ERR_SUCCESS
        then ShowError('Update profile failed.' + #13#10 + 'Error: ' + Crypt_ErrToStr(dwRes));
      end
    else ShowError('Update config failed.' + #13#10 + 'Error: ' + Crypt_ErrToStr(dwRes));
    end;
  end;

//------------------------------------------------------------------------------
//          Delete plain config after application ended
//------------------------------------------------------------------------------
if pParams^.pProf^.bDeleteConfigAfterAppEnded
  then EraseFileW(ExpandVars(pParams^.pProf^.TargetConfig, pParams^.pProf^));

//------------------------------------------------------------------------------
//          Deleting files after ended application
//------------------------------------------------------------------------------
if pParams^.pProf^.FilesDeletingAfterEndingApp.Count > 0 then
  begin
  for i:=0 to pParams^.pProf^.FilesDeletingAfterEndingApp.Count - 1 do
    EraseFileW(ExpandVars(pParams^.pProf^.FilesDeletingAfterEndingApp[i], pParams^.pProf^));
  end;

if pParams^.pProf^.AfterEndingAppAction = AFTER_ENDING_APP_ACTION_EXIT
  then MainFormActionProc(AFTER_LAUNCH_APP_ACTION_EXIT)
else if pParams^.pProf^.AfterEndingAppAction = AFTER_ENDING_APP_ACTION_RESTORE
  then MainFormActionProc(MAIN_FORM_ACTION_RESTORE);

FreeMem(pParams, SizeOf(pParams^));
end;




procedure ActivateProfileConfig(var Profile: TProfile; const Index: Integer);
var
i: Integer;
PlainFileHash: T128bit;
dwRes: DWORD;
bWait: Boolean;
hApp: THandle;
hThread: THandle;
dwThreadID: DWORD;
pParams: PWaitThreadParams;
begin
//------------------------------------------------------------------------------
//          Deleting files before launch application
//------------------------------------------------------------------------------
if Profile.FilesDeletingBeforeLaunchApp.Count > 0 then
  begin
  for i:=0 to Profile.FilesDeletingBeforeLaunchApp.Count - 1 do
    EraseFileW(ExpandVars(Profile.FilesDeletingBeforeLaunchApp[i], Profile));
  end;

//------------------------------------------------------------------------------
//          Decrypt and copy config
//------------------------------------------------------------------------------
EraseFileW(Profile.TargetConfig);

dwRes:=Crypt_CryptAndCopyFile(Profile.ProfileDirectory + Profile.Configs[Index].FileName + CFG_EXTENSION,
                              ExpandVars(Profile.TargetConfig, Profile),
                              @Profile.Configs[Index].IV,
                              nil,
                              @PlainFileHash);
if dwRes <> CRYPT_ERR_SUCCESS then
  begin
  ShowError('Decrypt and copy config failed.' + #13#10 + 'Error: ' + Crypt_ErrToStr(dwRes));
  Exit;
  end;

if NOT CompareMem128(@PlainFileHash, @Profile.Configs[Index].PlainFileHash) then
  begin
  ShowError('Decrypted config file hash not equal saved hash.');
  Exit;
  end;

if Profile.bLaunchApplication then
  begin
  bWait:=(Profile.AfterLaunchAppAction <> AFTER_LAUNCH_APP_ACTION_EXIT) AND
         ((Profile.FilesDeletingAfterEndingApp.Count > 0) OR
         Profile.bDeleteConfigAfterAppEnded OR Profile.bUpdateConfigAfterAppEnded);

  if NOT StartApp(ExpandVars(Profile.AppPath, Profile),
                  ExpandVars(Profile.AppArgs, Profile), hApp) then
    begin
    ShowError('Start application "' + Profile.AppPath + '" failed.');
    Exit;
    end;

  if Profile.AfterLaunchAppAction = AFTER_LAUNCH_APP_ACTION_EXIT then CloseHandle(hApp);

  MainFormActionProc(Profile.AfterLaunchAppAction);

  if bWait then
    begin
    GetMem(pParams, SizeOf(pParams^));
    pParams^.hAppProcess:=hApp;
    pParams^.pProf:=@Profile;
    pParams^.CfgIndex:=Index;
    hThread:=CreateThread(nil, 0, @WaitAppThreadProc, pParams, 0, dwThreadID);
    if hThread <> 0 then CloseHandle(hThread) else ShowError('Start thread failed.');
    end;
  end;

end;



end.

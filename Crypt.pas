unit Crypt;

interface

uses Windows, SysUtils;


const

  PASSWORD_EXPAND_ITERATIONS = 500000;   // 500k - 5 per sec; 300k - 8 per sec;

  HARDCODED_SALT             = 'sPz1x3u3vyU4yr';


  CRYPT_ERR_SUCCESS                                     = 0;
  CRYPT_ERR_UNKNOWN                                     = 1;
  CRYPT_ERR_FILE_NOT_FOUND                              = 2;
  CRYPT_ERR_DELETE_OUTPUT_FILE_FAILED                   = 3;
  CRYPT_ERR_OPEN_INPUT_FILE_FAILED                      = 4;
  CRYPT_ERR_CREATE_OUTPUT_FILE_FAILED                   = 5;
  CRYPT_ERR_INPUT_FILE_IS_EMPTY                         = 6;
  CRYPT_ERR_READ_FILE_FAILED                            = 7;
  CRYPT_ERR_WRITE_FILE_FAILED                           = 8;
  CRYPT_ERR_FILE_MAPPING_FAILED                         = 9;
  CRYPT_ERR_FILE_MAP_VIEW_FAILED                        = 10;

type

  TByteArray = Array [0..0] of Byte;
  PByteArray = ^TByteArray;

  T128bit = packed Array[0..3] of DWORD; // 128 bits
  P128bit = ^T128bit;



function Crypt_GenerateSalt: WideString;

procedure Crypt_GenRandom(const pData: Pointer; const dwSize: DWORD);

procedure Crypt_GenerateRandom128bit(const pValue: P128bit);

function Crypt_GenerateRndNameW(const Len: Integer): WideString;

procedure Crypt_SetKey(const Password, Salt: WideString);

procedure Crypt_CipherBlock(const pBlock: P128bit);

procedure Crypt_Hash128(const pData: Pointer;
                        const dwSize, dwIterationsCount: LongWord;
                        const pHash: P128bit);

procedure Crypt_CryptMemory_CTR(const pData: Pointer; const dwSize: DWORD;
                                const pIV: P128bit);

function Crypt_EncryptStringW(const SrcString: WideString): WideString;

function Crypt_DecryptStringW(const SrcString: WideString): WideString;

function Crypt_CryptAndCopyFile(const InFileName, OutFileName: WideString;
                                const pIV, pInFileHash, pOutFileHash: P128bit): DWORD;

function Crypt_ErrToStr(const dwErrorCode: DWORD): string;

function CompareMem128(const pMem1, pMem2: P128Bit): Boolean;



implementation

uses RC6, Tiger, Utils;


function RtlGenRandom(RandomBuffer: PBYTE;
                      RandomBufferLength: ULONG): Boolean; stdcall; external advapi32 name 'SystemFunction036';




function Crypt_ErrToStr(const dwErrorCode: DWORD): string;
begin
case dwErrorCode of
  CRYPT_ERR_SUCCESS                   : result:='CRYPT_ERR_SUCCESS';
  CRYPT_ERR_UNKNOWN                   : result:='CRYPT_ERR_UNKNOWN';
  CRYPT_ERR_FILE_NOT_FOUND            : result:='CRYPT_ERR_FILE_NOT_FOUND';
  CRYPT_ERR_DELETE_OUTPUT_FILE_FAILED : result:='CRYPT_ERR_DELETE_OUTPUT_FILE_FAILED';
  CRYPT_ERR_OPEN_INPUT_FILE_FAILED    : result:='CRYPT_ERR_OPEN_INPUT_FILE_FAILED';
  CRYPT_ERR_CREATE_OUTPUT_FILE_FAILED : result:='CRYPT_ERR_CREATE_OUTPUT_FILE_FAILED';
  CRYPT_ERR_INPUT_FILE_IS_EMPTY       : result:='CRYPT_ERR_INPUT_FILE_IS_EMPTY';
  CRYPT_ERR_READ_FILE_FAILED          : result:='CRYPT_ERR_READ_FILE_FAILED';
  CRYPT_ERR_WRITE_FILE_FAILED         : result:='CRYPT_ERR_WRITE_FILE_FAILED';
  CRYPT_ERR_FILE_MAPPING_FAILED       : result:='CRYPT_ERR_FILE_MAPPING_FAILED';
  CRYPT_ERR_FILE_MAP_VIEW_FAILED      : result:='CRYPT_ERR_FILE_MAP_VIEW_FAILED';
  else                                  result:='# ' + IntToStr(dwErrorCode);
  end;
end;



procedure Crypt_GenRandom(const pData: Pointer; const dwSize: DWORD);
begin
RtlGenRandom(pData, dwSize);
end;


procedure Crypt_GenerateRandom128bit(const pValue: P128bit);
begin
RtlGenRandom(Pointer(pValue), SizeOf(pValue^));
Hash_128(pValue, SizeOf(pValue^), 1, pValue);
end;



function Crypt_GenerateSalt: WideString;
const
  CHARSET: Array[0..86] of WideChar =
    ('a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
     'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
     '1','2','3','4','5','6','7','8','9','0',
     '_',')','(','*','&','^','%','$','#','@','!','~','?','>','<',',','.','/','[',']','{','}',';','"',':');
var
Len, i, j: DWORD;
begin
RtlGenRandom(@Len, SizeOf(Len));
Len:=(Len AND $00000007) + 5;            // Len = 5..12
SetLength(result, Len);
i:=1;
while i <= Len do
  begin
  RtlGenRandom(@j, SizeOf(j));
  j:=j AND $000000FF;
  if j <= High(CHARSET) then
    begin
    result[i]:=CHARSET[j];
    inc(i);
    end;
  end;
end;



function Crypt_GenerateRndNameW(const Len: Integer): WideString;
const
  CHARSET: Array[0..61] of WideChar =
    ('a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
     'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
     '1','2','3','4','5','6','7','8','9','0');
var
i, j: Integer;
begin
SetLength(result, Len);
i:=1;
while i <= Len do
  begin
  RtlGenRandom(@j, SizeOf(j));
  j:=j AND $000000FF;
  if j <= High(CHARSET) then
    begin
    result[i]:=CHARSET[j];
    inc(i);
    end;
  end;
end;



procedure Crypt_SetKey(const Password, Salt: WideString);
var
_Password: WideString;
Hash: T128bit;
len: Integer;
begin
_Password:=Password + Salt + HARDCODED_SALT;
len:=length(_Password);
while len < 128 do
  begin
  _Password:=_Password + IntToStr(len) + WChar(len) + _Password;
  len:=length(_Password);
  end;

Hash_128(PWideChar(_Password), length(_Password) shl 1, PASSWORD_EXPAND_ITERATIONS, @Hash);

RC6_Init(@Hash);
end;




procedure Crypt_CryptMemory_CTR(const pData: Pointer; const dwSize: DWORD;
                                const pIV: P128bit);
const
  BLOCK_SIZE = 16;
var
pBlock: PByte;
dwInSize, i: DWORD;
Counter: T128bit;
begin
if (pData = nil) OR (dwSize = 0) then Exit;

Counter[0]:=pIV^[0];
Counter[1]:=pIV^[1];
Counter[2]:=pIV^[2];
Counter[3]:=pIV^[3];

pBlock:=pData;
dwInSize:=dwSize;
i:=0;
while dwInSize > 0 do
  begin
  if i mod BLOCK_SIZE = 0 then // generating new gamma block, every 128 bits input data
    begin
    Hash_128(@Counter, SizeOf(Counter), 1, @Counter);
    RC6_EncryptBlock(@Counter);
    end;

  pBlock^:=pBlock^ XOR PByte(Cardinal(@Counter) + (i mod 16))^;

  inc(i);
  inc(pBlock);
  dec(dwInSize);
  end;
end;




function Crypt_EncryptStringW(const SrcString: WideString): WideString;
var
IV: T128bit;
begin
RtlGenRandom(@IV, SizeOf(IV));
Hash_128(@IV, SizeOf(IV), 1, @IV);

result:=#0#0#0#0#0#0#0#0 + SrcString;  //  8 wide chars = 16 Bytes - IV

Crypt_CryptMemory_CTR(@result[9], length(SrcString) shl 1, @IV);

PDWORD(@result[1])^:=IV[0];
PDWORD(@result[3])^:=IV[1];
PDWORD(@result[5])^:=IV[2];
PDWORD(@result[7])^:=IV[3];
end;


function Crypt_DecryptStringW(const SrcString: WideString): WideString;
var
IV: T128bit;
begin
result:=SrcString;
if length(result) < 9 then Exit;

IV[0]:=PDWORD(@result[1])^;
IV[1]:=PDWORD(@result[3])^;
IV[2]:=PDWORD(@result[5])^;
IV[3]:=PDWORD(@result[7])^;

delete(result, 1, 8); // remove IV

Crypt_CryptMemory_CTR(PWideChar(result), length(result) shl 1, @IV);
end;




function Crypt_GetFileHandleHash(const hTargetFile: HFILE; const dwFileSize: DWORD;
                                 const pHash: P128bit): DWORD;
var
hMapping: THandle;
pData: Pointer;
begin
hMapping:=CreateFileMapping(hTargetFile, nil, PAGE_READONLY, 0, 0, nil);
if hMapping = 0 then
  begin
  result:=CRYPT_ERR_FILE_MAPPING_FAILED;
  Exit;
  end;

pData:=MapViewOfFile(hMapping, FILE_MAP_READ, 0, 0, 0);
if pData = nil then
  begin
  CloseHandle(hMapping);
  result:=CRYPT_ERR_FILE_MAP_VIEW_FAILED;
  Exit;
  end;

Hash_128(pData, dwFileSize, 1, pHash);

UnmapViewOfFile(pData);
CloseHandle(hMapping);

result:=CRYPT_ERR_SUCCESS;
end;



procedure Crypt_CipherBlock(const pBlock: P128bit);
begin
RC6_EncryptBlock(pBlock);
end;


procedure Crypt_Hash128(const pData: Pointer;
                        const dwSize, dwIterationsCount: LongWord;
                        const pHash: P128bit);
begin
Hash_128(pData, dwSize, dwIterationsCount, pHash);
end;



function Crypt_CryptAndCopyFile(const InFileName, OutFileName: WideString;
                                const pIV, pInFileHash, pOutFileHash: P128bit): DWORD;
var
hInFile, hOutFile: HFILE;
FileSize: Integer;
dwSavedFileSize, dwReaded, dwWritten: DWORD;
Block, Counter: T128bit;
begin
if NOT FileExistsW(InFileName) then
  begin
  result:=CRYPT_ERR_FILE_NOT_FOUND;
  Exit;
  end;

if FileExistsW(OutFileName) then
  begin     
  if NOT (DeleteFileW(PWideChar(OutFileName)) AND
         (NOT FileExistsW(OutFileName))) then
    begin
    result:=CRYPT_ERR_DELETE_OUTPUT_FILE_FAILED;
    Exit;
    end;
  end;

hInFile:=CreateFileW(PWideChar(InFileName), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);
if hInFile = INVALID_HANDLE_VALUE then
  begin
  result:=CRYPT_ERR_OPEN_INPUT_FILE_FAILED;
  Exit;
  end;

hOutFile:=CreateFileW(PWideChar(OutFileName), GENERIC_ALL, 0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
if hOutFile = INVALID_HANDLE_VALUE then
  begin
  CloseHandle(hInFile);
  result:=CRYPT_ERR_CREATE_OUTPUT_FILE_FAILED;
  Exit;
  end;

dwSavedFileSize:=GetFileSize(hInFile, nil);
if dwSavedFileSize = 0 then
  begin
  CloseHandle(hInFile);
  CloseHandle(hOutFile);
  result:=CRYPT_ERR_INPUT_FILE_IS_EMPTY;
  Exit;
  end;

FileSize:=dwSavedFileSize;

Counter[0]:=pIV^[0];
Counter[1]:=pIV^[1];
Counter[2]:=pIV^[2];
Counter[3]:=pIV^[3];

while FileSize > 0 do
  begin
  if NOT ReadFile(hInFile, Block, SizeOf(Block), dwReaded, nil) then
    begin
    CloseHandle(hInFile);
    CloseHandle(hOutFile);
    result:=CRYPT_ERR_READ_FILE_FAILED;
    Exit;
    end;

  // Generate new CTR state
  Hash_128(@Counter, SizeOf(Counter), 1, @Counter);

  // Cipher CTR state
  RC6_EncryptBlock(@Counter);

  // Encrypt data block
  Block[0]:=Block[0] XOR Counter[0];
  Block[1]:=Block[1] XOR Counter[1];
  Block[2]:=Block[2] XOR Counter[2];
  Block[3]:=Block[3] XOR Counter[3];

  if ((NOT WriteFile(hOutFile, Block, dwReaded, dwWritten, nil)) OR
      (dwReaded <> dwWritten)) then
    begin
    CloseHandle(hInFile);
    CloseHandle(hOutFile);
    result:=CRYPT_ERR_WRITE_FILE_FAILED;
    Exit;
    end;

  dec(FileSize, dwReaded);
  end;

if pInFileHash <> nil then
  begin
  result:=Crypt_GetFileHandleHash(hInFile, dwSavedFileSize, pInFileHash);
  if result <> CRYPT_ERR_SUCCESS then
    begin
    CloseHandle(hInFile);
    CloseHandle(hOutFile);
    Exit;
    end;
  end;

if pOutFileHash <> nil then
  begin
  result:=Crypt_GetFileHandleHash(hOutFile, dwSavedFileSize, pOutFileHash);
  if result <> CRYPT_ERR_SUCCESS then
    begin
    CloseHandle(hInFile);
    CloseHandle(hOutFile);
    Exit;
    end;
  end;

CloseHandle(hInFile);
CloseHandle(hOutFile);

result:=CRYPT_ERR_SUCCESS;
end;




function CompareMem128(const pMem1, pMem2: P128Bit): Boolean;
begin
result:=(PDWORD(pMem1)^ = PDWORD(pMem2)^) AND
        (PDWORD(Cardinal(pMem1) +  4)^ = PDWORD(Cardinal(pMem2) +  4)^) AND
        (PDWORD(Cardinal(pMem1) +  8)^ = PDWORD(Cardinal(pMem2) +  8)^) AND
        (PDWORD(Cardinal(pMem1) + 12)^ = PDWORD(Cardinal(pMem2) + 12)^);
end;



end.

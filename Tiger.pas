unit Tiger;

interface

uses WinTypes, Crypt;



procedure Hash_128(const pSrcBuf: Pointer;
                   const dwSrcBufSize, dwIterationsCount: LongWord;
                   const pHash: P128bit);

function Tiger_SelfTest: Boolean;



implementation


type

  T192 = Array[0..2] of Int64;
  P192 = ^T192;

  T64 = Array[0..63] of Byte;
  P64 = ^T64;


const
  t1: array[0..255] of int64= (
    $02AAB17CF7E90C5E,    $AC424B03E243A8EC,
    $72CD5BE30DD5FCD3,    $6D019B93F6F97F3A,
    $CD9978FFD21F9193,    $7573A1C9708029E2,
    $B164326B922A83C3,    $46883EEE04915870,
    $EAACE3057103ECE6,    $C54169B808A3535C,
    $4CE754918DDEC47C,    $0AA2F4DFDC0DF40C,
    $10B76F18A74DBEFA,    $C6CCB6235AD1AB6A,
    $13726121572FE2FF,    $1A488C6F199D921E,
    $4BC9F9F4DA0007CA,    $26F5E6F6E85241C7,
    $859079DBEA5947B6,    $4F1885C5C99E8C92,
    $D78E761EA96F864B,    $8E36428C52B5C17D,
    $69CF6827373063C1,    $B607C93D9BB4C56E,
    $7D820E760E76B5EA,    $645C9CC6F07FDC42,
    $BF38A078243342E0,    $5F6B343C9D2E7D04,
    $F2C28AEB600B0EC6,    $6C0ED85F7254BCAC,
    $71592281A4DB4FE5,    $1967FA69CE0FED9F,
    $FD5293F8B96545DB,    $C879E9D7F2A7600B,
    $860248920193194E,    $A4F9533B2D9CC0B3,
    $9053836C15957613,    $DB6DCF8AFC357BF1,
    $18BEEA7A7A370F57,    $037117CA50B99066,
    $6AB30A9774424A35,    $F4E92F02E325249B,
    $7739DB07061CCAE1,    $D8F3B49CECA42A05,
    $BD56BE3F51382F73,    $45FAED5843B0BB28,
    $1C813D5C11BF1F83,    $8AF0E4B6D75FA169,
    $33EE18A487AD9999,    $3C26E8EAB1C94410,
    $B510102BC0A822F9,    $141EEF310CE6123B,
    $FC65B90059DDB154,    $E0158640C5E0E607,
    $884E079826C3A3CF,    $930D0D9523C535FD,
    $35638D754E9A2B00,    $4085FCCF40469DD5,
    $C4B17AD28BE23A4C,    $CAB2F0FC6A3E6A2E,
    $2860971A6B943FCD,    $3DDE6EE212E30446,
    $6222F32AE01765AE,    $5D550BB5478308FE,
    $A9EFA98DA0EDA22A,    $C351A71686C40DA7,
    $1105586D9C867C84,    $DCFFEE85FDA22853,
    $CCFBD0262C5EEF76,    $BAF294CB8990D201,
    $E69464F52AFAD975,    $94B013AFDF133E14,
    $06A7D1A32823C958,    $6F95FE5130F61119,
    $D92AB34E462C06C0,    $ED7BDE33887C71D2,
    $79746D6E6518393E,    $5BA419385D713329,
    $7C1BA6B948A97564,    $31987C197BFDAC67,
    $DE6C23C44B053D02,    $581C49FED002D64D,
    $DD474D6338261571,    $AA4546C3E473D062,
    $928FCE349455F860,    $48161BBACAAB94D9,
    $63912430770E6F68,    $6EC8A5E602C6641C,
    $87282515337DDD2B,    $2CDA6B42034B701B,
    $B03D37C181CB096D,    $E108438266C71C6F,
    $2B3180C7EB51B255,    $DF92B82F96C08BBC,
    $5C68C8C0A632F3BA,    $5504CC861C3D0556,
    $ABBFA4E55FB26B8F,    $41848B0AB3BACEB4,
    $B334A273AA445D32,    $BCA696F0A85AD881,
    $24F6EC65B528D56C,    $0CE1512E90F4524A,
    $4E9DD79D5506D35A,    $258905FAC6CE9779,
    $2019295B3E109B33,    $F8A9478B73A054CC,
    $2924F2F934417EB0,    $3993357D536D1BC4,
    $38A81AC21DB6FF8B,    $47C4FBF17D6016BF,
    $1E0FAADD7667E3F5,    $7ABCFF62938BEB96,
    $A78DAD948FC179C9,    $8F1F98B72911E50D,
    $61E48EAE27121A91,    $4D62F7AD31859808,
    $ECEBA345EF5CEAEB,    $F5CEB25EBC9684CE,
    $F633E20CB7F76221,    $A32CDF06AB8293E4,
    $985A202CA5EE2CA4,    $CF0B8447CC8A8FB1,
    $9F765244979859A3,    $A8D516B1A1240017,
    $0BD7BA3EBB5DC726,    $E54BCA55B86ADB39,
    $1D7A3AFD6C478063,    $519EC608E7669EDD,
    $0E5715A2D149AA23,    $177D4571848FF194,
    $EEB55F3241014C22,    $0F5E5CA13A6E2EC2,
    $8029927B75F5C361,    $AD139FABC3D6E436,
    $0D5DF1A94CCF402F,    $3E8BD948BEA5DFC8,
    $A5A0D357BD3FF77E,    $A2D12E251F74F645,
    $66FD9E525E81A082,    $2E0C90CE7F687A49,
    $C2E8BCBEBA973BC5,    $000001BCE509745F,
    $423777BBE6DAB3D6,    $D1661C7EAEF06EB5,
    $A1781F354DAACFD8,    $2D11284A2B16AFFC,
    $F1FC4F67FA891D1F,    $73ECC25DCB920ADA,
    $AE610C22C2A12651,    $96E0A810D356B78A,
    $5A9A381F2FE7870F,    $D5AD62EDE94E5530,
    $D225E5E8368D1427,    $65977B70C7AF4631,
    $99F889B2DE39D74F,    $233F30BF54E1D143,
    $9A9675D3D9A63C97,    $5470554FF334F9A8,
    $166ACB744A4F5688,    $70C74CAAB2E4AEAD,
    $F0D091646F294D12,    $57B82A89684031D1,
    $EFD95A5A61BE0B6B,    $2FBD12E969F2F29A,
    $9BD37013FEFF9FE8,    $3F9B0404D6085A06,
    $4940C1F3166CFE15,    $09542C4DCDF3DEFB,
    $B4C5218385CD5CE3,    $C935B7DC4462A641,
    $3417F8A68ED3B63F,    $B80959295B215B40,
    $F99CDAEF3B8C8572,    $018C0614F8FCB95D,
    $1B14ACCD1A3ACDF3,    $84D471F200BB732D,
    $C1A3110E95E8DA16,    $430A7220BF1A82B8,
    $B77E090D39DF210E,    $5EF4BD9F3CD05E9D,
    $9D4FF6DA7E57A444,    $DA1D60E183D4A5F8,
    $B287C38417998E47,    $FE3EDC121BB31886,
    $C7FE3CCC980CCBEF,    $E46FB590189BFD03,
    $3732FD469A4C57DC,    $7EF700A07CF1AD65,
    $59C64468A31D8859,    $762FB0B4D45B61F6,
    $155BAED099047718,    $68755E4C3D50BAA6,
    $E9214E7F22D8B4DF,    $2ADDBF532EAC95F4,
    $32AE3909B4BD0109,    $834DF537B08E3450,
    $FA209DA84220728D,    $9E691D9B9EFE23F7,
    $0446D288C4AE8D7F,    $7B4CC524E169785B,
    $21D87F0135CA1385,    $CEBB400F137B8AA5,
    $272E2B66580796BE,    $3612264125C2B0DE,
    $057702BDAD1EFBB2,    $D4BABB8EACF84BE9,
    $91583139641BC67B,    $8BDC2DE08036E024,
    $603C8156F49F68ED,    $F7D236F7DBEF5111,
    $9727C4598AD21E80,    $A08A0896670A5FD7,
    $CB4A8F4309EBA9CB,    $81AF564B0F7036A1,
    $C0B99AA778199ABD,    $959F1EC83FC8E952,
    $8C505077794A81B9,    $3ACAAF8F056338F0,
    $07B43F50627A6778,    $4A44AB49F5ECCC77,
    $3BC3D6E4B679EE98,    $9CC0D4D1CF14108C,
    $4406C00B206BC8A0,    $82A18854C8D72D89,
    $67E366B35C3C432C,    $B923DD61102B37F2,
    $56AB2779D884271D,    $BE83E1B0FF1525AF,
    $FB7C65D4217E49A9,    $6BDBE0E76D48E7D4,
    $08DF828745D9179E,    $22EA6A9ADD53BD34,
    $E36E141C5622200A,    $7F805D1B8CB750EE,
    $AFE5C7A59F58E837,    $E27F996A4FB1C23C,
    $D3867DFB0775F0D0,    $D0E673DE6E88891A,
    $123AEB9EAFB86C25,    $30F1D5D5C145B895,
    $BB434A2DEE7269E7,    $78CB67ECF931FA38,
    $F33B0372323BBF9C,    $52D66336FB279C74,
    $505F33AC0AFB4EAA,    $E8A5CD99A2CCE187,
    $534974801E2D30BB,    $8D2D5711D5876D90,
    $1F1A412891BC038E,    $D6E2E71D82E56648,
    $74036C3A497732B7,    $89B67ED96361F5AB,
    $FFED95D8F1EA02A2,    $E72B3BD61464D43D,
    $A6300F170BDC4820,    $EBC18760ED78A77A);
    
  t2: array[0..255] of int64= (
    $E6A6BE5A05A12138,    $B5A122A5B4F87C98,
    $563C6089140B6990,    $4C46CB2E391F5DD5,
    $D932ADDBC9B79434,    $08EA70E42015AFF5,
    $D765A6673E478CF1,    $C4FB757EAB278D99,
    $DF11C6862D6E0692,    $DDEB84F10D7F3B16,
    $6F2EF604A665EA04,    $4A8E0F0FF0E0DFB3,
    $A5EDEEF83DBCBA51,    $FC4F0A2A0EA4371E,
    $E83E1DA85CB38429,    $DC8FF882BA1B1CE2,
    $CD45505E8353E80D,    $18D19A00D4DB0717,
    $34A0CFEDA5F38101,    $0BE77E518887CAF2,
    $1E341438B3C45136,    $E05797F49089CCF9,
    $FFD23F9DF2591D14,    $543DDA228595C5CD,
    $661F81FD99052A33,    $8736E641DB0F7B76,
    $15227725418E5307,    $E25F7F46162EB2FA,
    $48A8B2126C13D9FE,    $AFDC541792E76EEA,
    $03D912BFC6D1898F,    $31B1AAFA1B83F51B,
    $F1AC2796E42AB7D9,    $40A3A7D7FCD2EBAC,
    $1056136D0AFBBCC5,    $7889E1DD9A6D0C85,
    $D33525782A7974AA,    $A7E25D09078AC09B,
    $BD4138B3EAC6EDD0,    $920ABFBE71EB9E70,
    $A2A5D0F54FC2625C,    $C054E36B0B1290A3,
    $F6DD59FF62FE932B,    $3537354511A8AC7D,
    $CA845E9172FADCD4,    $84F82B60329D20DC,
    $79C62CE1CD672F18,    $8B09A2ADD124642C,
    $D0C1E96A19D9E726,    $5A786A9B4BA9500C,
    $0E020336634C43F3,    $C17B474AEB66D822,
    $6A731AE3EC9BAAC2,    $8226667AE0840258,
    $67D4567691CAECA5,    $1D94155C4875ADB5,
    $6D00FD985B813FDF,    $51286EFCB774CD06,
    $5E8834471FA744AF,    $F72CA0AEE761AE2E,
    $BE40E4CDAEE8E09A,    $E9970BBB5118F665,
    $726E4BEB33DF1964,    $703B000729199762,
    $4631D816F5EF30A7,    $B880B5B51504A6BE,
    $641793C37ED84B6C,    $7B21ED77F6E97D96,
    $776306312EF96B73,    $AE528948E86FF3F4,
    $53DBD7F286A3F8F8,    $16CADCE74CFC1063,
    $005C19BDFA52C6DD,    $68868F5D64D46AD3,
    $3A9D512CCF1E186A,    $367E62C2385660AE,
    $E359E7EA77DCB1D7,    $526C0773749ABE6E,
    $735AE5F9D09F734B,    $493FC7CC8A558BA8,
    $B0B9C1533041AB45,    $321958BA470A59BD,
    $852DB00B5F46C393,    $91209B2BD336B0E5,
    $6E604F7D659EF19F,    $B99A8AE2782CCB24,
    $CCF52AB6C814C4C7,    $4727D9AFBE11727B,
    $7E950D0C0121B34D,    $756F435670AD471F,
    $F5ADD442615A6849,    $4E87E09980B9957A,
    $2ACFA1DF50AEE355,    $D898263AFD2FD556,
    $C8F4924DD80C8FD6,    $CF99CA3D754A173A,
    $FE477BACAF91BF3C,    $ED5371F6D690C12D,
    $831A5C285E687094,    $C5D3C90A3708A0A4,
    $0F7F903717D06580,    $19F9BB13B8FDF27F,
    $B1BD6F1B4D502843,    $1C761BA38FFF4012,
    $0D1530C4E2E21F3B,    $8943CE69A7372C8A,
    $E5184E11FEB5CE66,    $618BDB80BD736621,
    $7D29BAD68B574D0B,    $81BB613E25E6FE5B,
    $071C9C10BC07913F,    $C7BEEB7909AC2D97,
    $C3E58D353BC5D757,    $EB017892F38F61E8,
    $D4EFFB9C9B1CC21A,    $99727D26F494F7AB,
    $A3E063A2956B3E03,    $9D4A8B9A4AA09C30,
    $3F6AB7D500090FB4,    $9CC0F2A057268AC0,
    $3DEE9D2DEDBF42D1,    $330F49C87960A972,
    $C6B2720287421B41,    $0AC59EC07C00369C,
    $EF4EAC49CB353425,    $F450244EEF0129D8,
    $8ACC46E5CAF4DEB6,    $2FFEAB63989263F7,
    $8F7CB9FE5D7A4578,    $5BD8F7644E634635,
    $427A7315BF2DC900,    $17D0C4AA2125261C,
    $3992486C93518E50,    $B4CBFEE0A2D7D4C3,
    $7C75D6202C5DDD8D,    $DBC295D8E35B6C61,
    $60B369D302032B19,    $CE42685FDCE44132,
    $06F3DDB9DDF65610,    $8EA4D21DB5E148F0,
    $20B0FCE62FCD496F,    $2C1B912358B0EE31,
    $B28317B818F5A308,    $A89C1E189CA6D2CF,
    $0C6B18576AAADBC8,    $B65DEAA91299FAE3,
    $FB2B794B7F1027E7,    $04E4317F443B5BEB,
    $4B852D325939D0A6,    $D5AE6BEEFB207FFC,
    $309682B281C7D374,    $BAE309A194C3B475,
    $8CC3F97B13B49F05,    $98A9422FF8293967,
    $244B16B01076FF7C,    $F8BF571C663D67EE,
    $1F0D6758EEE30DA1,    $C9B611D97ADEB9B7,
    $B7AFD5887B6C57A2,    $6290AE846B984FE1,
    $94DF4CDEACC1A5FD,    $058A5BD1C5483AFF,
    $63166CC142BA3C37,    $8DB8526EB2F76F40,
    $E10880036F0D6D4E,    $9E0523C9971D311D,
    $45EC2824CC7CD691,    $575B8359E62382C9,
    $FA9E400DC4889995,    $D1823ECB45721568,
    $DAFD983B8206082F,    $AA7D29082386A8CB,
    $269FCD4403B87588,    $1B91F5F728BDD1E0,
    $E4669F39040201F6,    $7A1D7C218CF04ADE,
    $65623C29D79CE5CE,    $2368449096C00BB1,
    $AB9BF1879DA503BA,    $BC23ECB1A458058E,
    $9A58DF01BB401ECC,    $A070E868A85F143D,
    $4FF188307DF2239E,    $14D565B41A641183,
    $EE13337452701602,    $950E3DCF3F285E09,
    $59930254B9C80953,    $3BF299408930DA6D,
    $A955943F53691387,    $A15EDECAA9CB8784,
    $29142127352BE9A0,    $76F0371FFF4E7AFB,
    $0239F450274F2228,    $BB073AF01D5E868B,
    $BFC80571C10E96C1,    $D267088568222E23,
    $9671A3D48E80B5B0,    $55B5D38AE193BB81,
    $693AE2D0A18B04B8,    $5C48B4ECADD5335F,
    $FD743B194916A1CA,    $2577018134BE98C4,
    $E77987E83C54A4AD,    $28E11014DA33E1B9,
    $270CC59E226AA213,    $71495F756D1A5F60,
    $9BE853FB60AFEF77,    $ADC786A7F7443DBF,
    $0904456173B29A82,    $58BC7A66C232BD5E,
    $F306558C673AC8B2,    $41F639C6B6C9772A,
    $216DEFE99FDA35DA,    $11640CC71C7BE615,
    $93C43694565C5527,    $EA038E6246777839,
    $F9ABF3CE5A3E2469,    $741E768D0FD312D2,
    $0144B883CED652C6,    $C20B5A5BA33F8552,
    $1AE69633C3435A9D,    $97A28CA4088CFDEC,
    $8824A43C1E96F420,    $37612FA66EEEA746,
    $6B4CB165F9CF0E5A,    $43AA1C06A0ABFB4A,
    $7F4DC26FF162796B,    $6CBACC8E54ED9B0F,
    $A6B7FFEFD2BB253E,    $2E25BC95B0A29D4F,
    $86D6A58BDEF1388C,    $DED74AC576B6F054,
    $8030BDBC2B45805D,    $3C81AF70E94D9289,
    $3EFF6DDA9E3100DB,    $B38DC39FDFCC8847,
    $123885528D17B87E,    $F2DA0ED240B1B642,
    $44CEFADCD54BF9A9,    $1312200E433C7EE6,
    $9FFCC84F3A78C748,    $F0CD1F72248576BB,
    $EC6974053638CFE4,    $2BA7B67C0CEC4E4C,
    $AC2F4DF3E5CE32ED,    $CB33D14326EA4C11,
    $A4E9044CC77E58BC,    $5F513293D934FCEF,
    $5DC9645506E55444,    $50DE418F317DE40A,
    $388CB31A69DDE259,    $2DB4A83455820A86,
    $9010A91E84711AE9,    $4DF7F0B7B1498371,
    $D62A2EABC0977179,    $22FAC097AA8D5C0E);

  t3: array[0..255] of int64= (
    $F49FCC2FF1DAF39B,    $487FD5C66FF29281,
    $E8A30667FCDCA83F,    $2C9B4BE3D2FCCE63,
    $DA3FF74B93FBBBC2,    $2FA165D2FE70BA66,
    $A103E279970E93D4,    $BECDEC77B0E45E71,
    $CFB41E723985E497,    $B70AAA025EF75017,
    $D42309F03840B8E0,    $8EFC1AD035898579,
    $96C6920BE2B2ABC5,    $66AF4163375A9172,
    $2174ABDCCA7127FB,    $B33CCEA64A72FF41,
    $F04A4933083066A5,    $8D970ACDD7289AF5,
    $8F96E8E031C8C25E,    $F3FEC02276875D47,
    $EC7BF310056190DD,    $F5ADB0AEBB0F1491,
    $9B50F8850FD58892,    $4975488358B74DE8,
    $A3354FF691531C61,    $0702BBE481D2C6EE,
    $89FB24057DEDED98,    $AC3075138596E902,
    $1D2D3580172772ED,    $EB738FC28E6BC30D,
    $5854EF8F63044326,    $9E5C52325ADD3BBE,
    $90AA53CF325C4623,    $C1D24D51349DD067,
    $2051CFEEA69EA624,    $13220F0A862E7E4F,
    $CE39399404E04864,    $D9C42CA47086FCB7,
    $685AD2238A03E7CC,    $066484B2AB2FF1DB,
    $FE9D5D70EFBF79EC,    $5B13B9DD9C481854,
    $15F0D475ED1509AD,    $0BEBCD060EC79851,
    $D58C6791183AB7F8,    $D1187C5052F3EEE4,
    $C95D1192E54E82FF,    $86EEA14CB9AC6CA2,
    $3485BEB153677D5D,    $DD191D781F8C492A,
    $F60866BAA784EBF9,    $518F643BA2D08C74,
    $8852E956E1087C22,    $A768CB8DC410AE8D,
    $38047726BFEC8E1A,    $A67738B4CD3B45AA,
    $AD16691CEC0DDE19,    $C6D4319380462E07,
    $C5A5876D0BA61938,    $16B9FA1FA58FD840,
    $188AB1173CA74F18,    $ABDA2F98C99C021F,
    $3E0580AB134AE816,    $5F3B05B773645ABB,
    $2501A2BE5575F2F6,    $1B2F74004E7E8BA9,
    $1CD7580371E8D953,    $7F6ED89562764E30,
    $B15926FF596F003D,    $9F65293DA8C5D6B9,
    $6ECEF04DD690F84C,    $4782275FFF33AF88,
    $E41433083F820801,    $FD0DFE409A1AF9B5,
    $4325A3342CDB396B,    $8AE77E62B301B252,
    $C36F9E9F6655615A,    $85455A2D92D32C09,
    $F2C7DEA949477485,    $63CFB4C133A39EBA,
    $83B040CC6EBC5462,    $3B9454C8FDB326B0,
    $56F56A9E87FFD78C,    $2DC2940D99F42BC6,
    $98F7DF096B096E2D,    $19A6E01E3AD852BF,
    $42A99CCBDBD4B40B,    $A59998AF45E9C559,
    $366295E807D93186,    $6B48181BFAA1F773,
    $1FEC57E2157A0A1D,    $4667446AF6201AD5,
    $E615EBCACFB0F075,    $B8F31F4F68290778,
    $22713ED6CE22D11E,    $3057C1A72EC3C93B,
    $CB46ACC37C3F1F2F,    $DBB893FD02AAF50E,
    $331FD92E600B9FCF,    $A498F96148EA3AD6,
    $A8D8426E8B6A83EA,    $A089B274B7735CDC,
    $87F6B3731E524A11,    $118808E5CBC96749,
    $9906E4C7B19BD394,    $AFED7F7E9B24A20C,
    $6509EADEEB3644A7,    $6C1EF1D3E8EF0EDE,
    $B9C97D43E9798FB4,    $A2F2D784740C28A3,
    $7B8496476197566F,    $7A5BE3E6B65F069D,
    $F96330ED78BE6F10,    $EEE60DE77A076A15,
    $2B4BEE4AA08B9BD0,    $6A56A63EC7B8894E,
    $02121359BA34FEF4,    $4CBF99F8283703FC,
    $398071350CAF30C8,    $D0A77A89F017687A,
    $F1C1A9EB9E423569,    $8C7976282DEE8199,
    $5D1737A5DD1F7ABD,    $4F53433C09A9FA80,
    $FA8B0C53DF7CA1D9,    $3FD9DCBC886CCB77,
    $C040917CA91B4720,    $7DD00142F9D1DCDF,
    $8476FC1D4F387B58,    $23F8E7C5F3316503,
    $032A2244E7E37339,    $5C87A5D750F5A74B,
    $082B4CC43698992E,    $DF917BECB858F63C,
    $3270B8FC5BF86DDA,    $10AE72BB29B5DD76,
    $576AC94E7700362B,    $1AD112DAC61EFB8F,
    $691BC30EC5FAA427,    $FF246311CC327143,
    $3142368E30E53206,    $71380E31E02CA396,
    $958D5C960AAD76F1,    $F8D6F430C16DA536,
    $C8FFD13F1BE7E1D2,    $7578AE66004DDBE1,
    $05833F01067BE646,    $BB34B5AD3BFE586D,
    $095F34C9A12B97F0,    $247AB64525D60CA8,
    $DCDBC6F3017477D1,    $4A2E14D4DECAD24D,
    $BDB5E6D9BE0A1EEB,    $2A7E70F7794301AB,
    $DEF42D8A270540FD,    $01078EC0A34C22C1,
    $E5DE511AF4C16387,    $7EBB3A52BD9A330A,
    $77697857AA7D6435,    $004E831603AE4C32,
    $E7A21020AD78E312,    $9D41A70C6AB420F2,
    $28E06C18EA1141E6,    $D2B28CBD984F6B28,
    $26B75F6C446E9D83,    $BA47568C4D418D7F,
    $D80BADBFE6183D8E,    $0E206D7F5F166044,
    $E258A43911CBCA3E,    $723A1746B21DC0BC,
    $C7CAA854F5D7CDD3,    $7CAC32883D261D9C,
    $7690C26423BA942C,    $17E55524478042B8,
    $E0BE477656A2389F,    $4D289B5E67AB2DA0,
    $44862B9C8FBBFD31,    $B47CC8049D141365,
    $822C1B362B91C793,    $4EB14655FB13DFD8,
    $1ECBBA0714E2A97B,    $6143459D5CDE5F14,
    $53A8FBF1D5F0AC89,    $97EA04D81C5E5B00,
    $622181A8D4FDB3F3,    $E9BCD341572A1208,
    $1411258643CCE58A,    $9144C5FEA4C6E0A4,
    $0D33D06565CF620F,    $54A48D489F219CA1,
    $C43E5EAC6D63C821,    $A9728B3A72770DAF,
    $D7934E7B20DF87EF,    $E35503B61A3E86E5,
    $CAE321FBC819D504,    $129A50B3AC60BFA6,
    $CD5E68EA7E9FB6C3,    $B01C90199483B1C7,
    $3DE93CD5C295376C,    $AED52EDF2AB9AD13,
    $2E60F512C0A07884,    $BC3D86A3E36210C9,
    $35269D9B163951CE,    $0C7D6E2AD0CDB5FA,
    $59E86297D87F5733,    $298EF221898DB0E7,
    $55000029D1A5AA7E,    $8BC08AE1B5061B45,
    $C2C31C2B6C92703A,    $94CC596BAF25EF42,
    $0A1D73DB22540456,    $04B6A0F9D9C4179A,
    $EFFDAFA2AE3D3C60,    $F7C8075BB49496C4,
    $9CC5C7141D1CD4E3,    $78BD1638218E5534,
    $B2F11568F850246A,    $EDFABCFA9502BC29,
    $796CE5F2DA23051B,    $AAE128B0DC93537C,
    $3A493DA0EE4B29AE,    $B5DF6B2C416895D7,
    $FCABBD25122D7F37,    $70810B58105DC4B1,
    $E10FDD37F7882A90,    $524DCAB5518A3F5C,
    $3C9E85878451255B,    $4029828119BD34E2,
    $74A05B6F5D3CECCB,    $B610021542E13ECA,
    $0FF979D12F59E2AC,    $6037DA27E4F9CC50,
    $5E92975A0DF1847D,    $D66DE190D3E623FE,
    $5032D6B87B568048,    $9A36B7CE8235216E,
    $80272A7A24F64B4A,    $93EFED8B8C6916F7,
    $37DDBFF44CCE1555,    $4B95DB5D4B99BD25,
    $92D3FDA169812FC0,    $FB1A4A9A90660BB6,
    $730C196946A4B9B2,    $81E289AA7F49DA68,
    $64669A0F83B1A05F,    $27B3FF7D9644F48B,
    $CC6B615C8DB675B3,    $674F20B9BCEBBE95,
    $6F31238275655982,    $5AE488713E45CF05,
    $BF619F9954C21157,    $EABAC46040A8EAE9,
    $454C6FE9F2C0C1CD,    $419CF6496412691C,
    $D3DC3BEF265B0F70,    $6D0E60F5C3578A9E);

  t4: array[0..255] of int64= (
    $5B0E608526323C55,    $1A46C1A9FA1B59F5,
    $A9E245A17C4C8FFA,    $65CA5159DB2955D7,
    $05DB0A76CE35AFC2,    $81EAC77EA9113D45,
    $528EF88AB6AC0A0D,    $A09EA253597BE3FF,
    $430DDFB3AC48CD56,    $C4B3A67AF45CE46F,
    $4ECECFD8FBE2D05E,    $3EF56F10B39935F0,
    $0B22D6829CD619C6,    $17FD460A74DF2069,
    $6CF8CC8E8510ED40,    $D6C824BF3A6ECAA7,
    $61243D581A817049,    $048BACB6BBC163A2,
    $D9A38AC27D44CC32,    $7FDDFF5BAAF410AB,
    $AD6D495AA804824B,    $E1A6A74F2D8C9F94,
    $D4F7851235DEE8E3,    $FD4B7F886540D893,
    $247C20042AA4BFDA,    $096EA1C517D1327C,
    $D56966B4361A6685,    $277DA5C31221057D,
    $94D59893A43ACFF7,    $64F0C51CCDC02281,
    $3D33BCC4FF6189DB,    $E005CB184CE66AF1,
    $FF5CCD1D1DB99BEA,    $B0B854A7FE42980F,
    $7BD46A6A718D4B9F,    $D10FA8CC22A5FD8C,
    $D31484952BE4BD31,    $C7FA975FCB243847,
    $4886ED1E5846C407,    $28CDDB791EB70B04,
    $C2B00BE2F573417F,    $5C9590452180F877,
    $7A6BDDFFF370EB00,    $CE509E38D6D9D6A4,
    $EBEB0F00647FA702,    $1DCC06CF76606F06,
    $E4D9F28BA286FF0A,    $D85A305DC918C262,
    $475B1D8732225F54,    $2D4FB51668CCB5FE,
    $A679B9D9D72BBA20,    $53841C0D912D43A5,
    $3B7EAA48BF12A4E8,    $781E0E47F22F1DDF,
    $EFF20CE60AB50973,    $20D261D19DFFB742,
    $16A12B03062A2E39,    $1960EB2239650495,
    $251C16FED50EB8B8,    $9AC0C330F826016E,
    $ED152665953E7671,    $02D63194A6369570,
    $5074F08394B1C987,    $70BA598C90B25CE1,
    $794A15810B9742F6,    $0D5925E9FCAF8C6C,
    $3067716CD868744E,    $910AB077E8D7731B,
    $6A61BBDB5AC42F61,    $93513EFBF0851567,
    $F494724B9E83E9D5,    $E887E1985C09648D,
    $34B1D3C675370CFD,    $DC35E433BC0D255D,
    $D0AAB84234131BE0,    $08042A50B48B7EAF,
    $9997C4EE44A3AB35,    $829A7B49201799D0,
    $263B8307B7C54441,    $752F95F4FD6A6CA6,
    $927217402C08C6E5,    $2A8AB754A795D9EE,
    $A442F7552F72943D,    $2C31334E19781208,
    $4FA98D7CEAEE6291,    $55C3862F665DB309,
    $BD0610175D53B1F3,    $46FE6CB840413F27,
    $3FE03792DF0CFA59,    $CFE700372EB85E8F,
    $A7BE29E7ADBCE118,    $E544EE5CDE8431DD,
    $8A781B1B41F1873E,    $A5C94C78A0D2F0E7,
    $39412E2877B60728,    $A1265EF3AFC9A62C,
    $BCC2770C6A2506C5,    $3AB66DD5DCE1CE12,
    $E65499D04A675B37,    $7D8F523481BFD216,
    $0F6F64FCEC15F389,    $74EFBE618B5B13C8,
    $ACDC82B714273E1D,    $DD40BFE003199D17,
    $37E99257E7E061F8,    $FA52626904775AAA,
    $8BBBF63A463D56F9,    $F0013F1543A26E64,
    $A8307E9F879EC898,    $CC4C27A4150177CC,
    $1B432F2CCA1D3348,    $DE1D1F8F9F6FA013,
    $606602A047A7DDD6,    $D237AB64CC1CB2C7,
    $9B938E7225FCD1D3,    $EC4E03708E0FF476,
    $FEB2FBDA3D03C12D,    $AE0BCED2EE43889A,
    $22CB8923EBFB4F43,    $69360D013CF7396D,
    $855E3602D2D4E022,    $073805BAD01F784C,
    $33E17A133852F546,    $DF4874058AC7B638,
    $BA92B29C678AA14A,    $0CE89FC76CFAADCD,
    $5F9D4E0908339E34,    $F1AFE9291F5923B9,
    $6E3480F60F4A265F,    $EEBF3A2AB29B841C,
    $E21938A88F91B4AD,    $57DFEFF845C6D3C3,
    $2F006B0BF62CAAF2,    $62F479EF6F75EE78,
    $11A55AD41C8916A9,    $F229D29084FED453,
    $42F1C27B16B000E6,    $2B1F76749823C074,
    $4B76ECA3C2745360,    $8C98F463B91691BD,
    $14BCC93CF1ADE66A,    $8885213E6D458397,
    $8E177DF0274D4711,    $B49B73B5503F2951,
    $10168168C3F96B6B,    $0E3D963B63CAB0AE,
    $8DFC4B5655A1DB14,    $F789F1356E14DE5C,
    $683E68AF4E51DAC1,    $C9A84F9D8D4B0FD9,
    $3691E03F52A0F9D1,    $5ED86E46E1878E80,
    $3C711A0E99D07150,    $5A0865B20C4E9310,
    $56FBFC1FE4F0682E,    $EA8D5DE3105EDF9B,
    $71ABFDB12379187A,    $2EB99DE1BEE77B9C,
    $21ECC0EA33CF4523,    $59A4D7521805C7A1,
    $3896F5EB56AE7C72,    $AA638F3DB18F75DC,
    $9F39358DABE9808E,    $B7DEFA91C00B72AC,
    $6B5541FD62492D92,    $6DC6DEE8F92E4D5B,
    $353F57ABC4BEEA7E,    $735769D6DA5690CE,
    $0A234AA642391484,    $F6F9508028F80D9D,
    $B8E319A27AB3F215,    $31AD9C1151341A4D,
    $773C22A57BEF5805,    $45C7561A07968633,
    $F913DA9E249DBE36,    $DA652D9B78A64C68,
    $4C27A97F3BC334EF,    $76621220E66B17F4,
    $967743899ACD7D0B,    $F3EE5BCAE0ED6782,
    $409F753600C879FC,    $06D09A39B5926DB6,
    $6F83AEB0317AC588,    $01E6CA4A86381F21,
    $66FF3462D19F3025,    $72207C24DDFD3BFB,
    $4AF6B6D3E2ECE2EB,    $9C994DBEC7EA08DE,
    $49ACE597B09A8BC4,    $B38C4766CF0797BA,
    $131B9373C57C2A75,    $B1822CCE61931E58,
    $9D7555B909BA1C0C,    $127FAFDD937D11D2,
    $29DA3BADC66D92E4,    $A2C1D57154C2ECBC,
    $58C5134D82F6FE24,    $1C3AE3515B62274F,
    $E907C82E01CB8126,    $F8ED091913E37FCB,
    $3249D8F9C80046C9,    $80CF9BEDE388FB63,
    $1881539A116CF19E,    $5103F3F76BD52457,
    $15B7E6F5AE47F7A8,    $DBD7C6DED47E9CCF,
    $44E55C410228BB1A,    $B647D4255EDB4E99,
    $5D11882BB8AAFC30,    $F5098BBB29D3212A,
    $8FB5EA14E90296B3,    $677B942157DD025A,
    $FB58E7C0A390ACB5,    $89D3674C83BD4A01,
    $9E2DA4DF4BF3B93B,    $FCC41E328CAB4829,
    $03F38C96BA582C52,    $CAD1BDBD7FD85DB2,
    $BBB442C16082AE83,    $B95FE86BA5DA9AB0,
    $B22E04673771A93F,    $845358C9493152D8,
    $BE2A488697B4541E,    $95A2DC2DD38E6966,
    $C02C11AC923C852B,    $2388B1990DF2A87B,
    $7C8008FA1B4F37BE,    $1F70D0C84D54E503,
    $5490ADEC7ECE57D4,    $002B3C27D9063A3A,
    $7EAEA3848030A2BF,    $C602326DED2003C0,
    $83A7287D69A94086,    $C57A5FCB30F57A8A,
    $B56844E479EBE779,    $A373B40F05DCBCE9,
    $D71A786E88570EE2,    $879CBACDBDE8F6A0,
    $976AD1BCC164A32F,    $AB21E25E9666D78B,
    $901063AAE5E5C33C,    $9818B34448698D90,
    $E36487AE3E1E8ABB,    $AFBDF931893BDCB4,
    $6345A0DC5FBBD519,    $8628FE269B9465CA,
    $1E5D01603F9C51EC,    $4DE44006A15049B7,
    $BF6C70E5F776CBB1,    $411218F2EF552BED,
    $CB0C0708705A36A3,    $E74D14754F986044,
    $CD56D9430EA8280E,    $C12591D7535F5065,
    $C83223F1720AEF96,    $C3A0396F7363A51F);



procedure Tiger_Compress(var CurrentHash: T192; var HashBuffer: T64; var dwIndex: DWORD);
var
  a, b, c, aa, bb, cc: int64;
  x: Array[0..7] of int64;
begin
a:=CurrentHash[0]; aa:=a;
b:=CurrentHash[1]; bb:=b;
c:=CurrentHash[2]; cc:=c;

PDWORD(@x)^:=PDWORD(@HashBuffer[0])^;
PDWORD(Cardinal(@x) + 4)^:=PDWORD(@HashBuffer[4])^;
PDWORD(Cardinal(@x) + 8)^:=PDWORD(@HashBuffer[8])^;
PDWORD(Cardinal(@x) + 12)^:=PDWORD(@HashBuffer[12])^;
PDWORD(Cardinal(@x) + 16)^:=PDWORD(@HashBuffer[16])^;
PDWORD(Cardinal(@x) + 20)^:=PDWORD(@HashBuffer[20])^;
PDWORD(Cardinal(@x) + 24)^:=PDWORD(@HashBuffer[24])^;
PDWORD(Cardinal(@x) + 28)^:=PDWORD(@HashBuffer[28])^;
PDWORD(Cardinal(@x) + 32)^:=PDWORD(@HashBuffer[32])^;
PDWORD(Cardinal(@x) + 36)^:=PDWORD(@HashBuffer[36])^;
PDWORD(Cardinal(@x) + 40)^:=PDWORD(@HashBuffer[40])^;
PDWORD(Cardinal(@x) + 44)^:=PDWORD(@HashBuffer[44])^;
PDWORD(Cardinal(@x) + 48)^:=PDWORD(@HashBuffer[48])^;
PDWORD(Cardinal(@x) + 52)^:=PDWORD(@HashBuffer[52])^;
PDWORD(Cardinal(@x) + 56)^:=PDWORD(@HashBuffer[56])^;
PDWORD(Cardinal(@x) + 60)^:=PDWORD(@HashBuffer[60])^;

c:= c xor x[0];
a:= a - (t1[c and $FF] xor t2[(c shr 16) and $FF] xor t3[(c shr 32) and $FF] xor t4[(c shr 48) and $FF]);
b:= b + (t4[(c shr 8) and $FF] xor t3[(c shr 24) and $FF] xor t2[(c shr 40) and $FF] xor t1[(c shr 56) and $FF]);
b:= b * 5;
a:= a xor x[1];
b:= b - (t1[a and $FF] xor t2[(a shr 16) and $FF] xor t3[(a shr 32) and $FF] xor t4[(a shr 48) and $FF]);
c:= c + (t4[(a shr 8) and $FF] xor t3[(a shr 24) and $FF] xor t2[(a shr 40) and $FF] xor t1[(a shr 56) and $FF]);
c:= c * 5;
b:= b xor x[2];
c:= c - (t1[b and $FF] xor t2[(b shr 16) and $FF] xor t3[(b shr 32) and $FF] xor t4[(b shr 48) and $FF]);
a:= a + (t4[(b shr 8) and $FF] xor t3[(b shr 24) and $FF] xor t2[(b shr 40) and $FF] xor t1[(b shr 56) and $FF]);
a:= a * 5;
c:= c xor x[3];
a:= a - (t1[c and $FF] xor t2[(c shr 16) and $FF] xor t3[(c shr 32) and $FF] xor t4[(c shr 48) and $FF]);
b:= b + (t4[(c shr 8) and $FF] xor t3[(c shr 24) and $FF] xor t2[(c shr 40) and $FF] xor t1[(c shr 56) and $FF]);
b:= b * 5;
a:= a xor x[4];
b:= b - (t1[a and $FF] xor t2[(a shr 16) and $FF] xor t3[(a shr 32) and $FF] xor t4[(a shr 48) and $FF]);
c:= c + (t4[(a shr 8) and $FF] xor t3[(a shr 24) and $FF] xor t2[(a shr 40) and $FF] xor t1[(a shr 56) and $FF]);
c:= c * 5;
b:= b xor x[5];
c:= c - (t1[b and $FF] xor t2[(b shr 16) and $FF] xor t3[(b shr 32) and $FF] xor t4[(b shr 48) and $FF]);
a:= a + (t4[(b shr 8) and $FF] xor t3[(b shr 24) and $FF] xor t2[(b shr 40) and $FF] xor t1[(b shr 56) and $FF]);
a:= a * 5;
c:= c xor x[6];
a:= a - (t1[c and $FF] xor t2[(c shr 16) and $FF] xor t3[(c shr 32) and $FF] xor t4[(c shr 48) and $FF]);
b:= b + (t4[(c shr 8) and $FF] xor t3[(c shr 24) and $FF] xor t2[(c shr 40) and $FF] xor t1[(c shr 56) and $FF]);
b:= b * 5;
a:= a xor x[7];
b:= b - (t1[a and $FF] xor t2[(a shr 16) and $FF] xor t3[(a shr 32) and $FF] xor t4[(a shr 48) and $FF]);
c:= c + (t4[(a shr 8) and $FF] xor t3[(a shr 24) and $FF] xor t2[(a shr 40) and $FF] xor t1[(a shr 56) and $FF]);
c:= c * 5;
x[0]:= x[0] - (x[7] xor $A5A5A5A5A5A5A5A5);
x[1]:= x[1] xor x[0];
x[2]:= x[2] + x[1];
x[3]:= x[3] - (x[2] xor ((not x[1]) shl 19));
x[4]:= x[4] xor x[3];
x[5]:= x[5] + x[4];
x[6]:= x[6] - (x[5] xor ((not x[4]) shr 23));
x[7]:= x[7] xor x[6];
x[0]:= x[0] + x[7];
x[1]:= x[1] - (x[0] xor ((not x[7]) shl 19));
x[2]:= x[2] xor x[1];
x[3]:= x[3] + x[2];
x[4]:= x[4] - (x[3] xor ((not x[2]) shr 23));
x[5]:= x[5] xor x[4];
x[6]:= x[6] + x[5];
x[7]:= x[7] - (x[6] xor $0123456789ABCDEF);
b:= b xor x[0];
c:= c - (t1[b and $FF] xor t2[(b shr 16) and $FF] xor t3[(b shr 32) and $FF] xor t4[(b shr 48) and $FF]);
a:= a + (t4[(b shr 8) and $FF] xor t3[(b shr 24) and $FF] xor t2[(b shr 40) and $FF] xor t1[(b shr 56) and $FF]);
a:= a * 7;
c:= c xor x[1];
a:= a - (t1[c and $FF] xor t2[(c shr 16) and $FF] xor t3[(c shr 32) and $FF] xor t4[(c shr 48) and $FF]);
b:= b + (t4[(c shr 8) and $FF] xor t3[(c shr 24) and $FF] xor t2[(c shr 40) and $FF] xor t1[(c shr 56) and $FF]);
b:= b * 7;
a:= a xor x[2];
b:= b - (t1[a and $FF] xor t2[(a shr 16) and $FF] xor t3[(a shr 32) and $FF] xor t4[(a shr 48) and $FF]);
c:= c + (t4[(a shr 8) and $FF] xor t3[(a shr 24) and $FF] xor t2[(a shr 40) and $FF] xor t1[(a shr 56) and $FF]);
c:= c * 7;
b:= b xor x[3];
c:= c - (t1[b and $FF] xor t2[(b shr 16) and $FF] xor t3[(b shr 32) and $FF] xor t4[(b shr 48) and $FF]);
a:= a + (t4[(b shr 8) and $FF] xor t3[(b shr 24) and $FF] xor t2[(b shr 40) and $FF] xor t1[(b shr 56) and $FF]);
a:= a * 7;
c:= c xor x[4];
a:= a - (t1[c and $FF] xor t2[(c shr 16) and $FF] xor t3[(c shr 32) and $FF] xor t4[(c shr 48) and $FF]);
b:= b + (t4[(c shr 8) and $FF] xor t3[(c shr 24) and $FF] xor t2[(c shr 40) and $FF] xor t1[(c shr 56) and $FF]);
b:= b * 7;
a:= a xor x[5];
b:= b - (t1[a and $FF] xor t2[(a shr 16) and $FF] xor t3[(a shr 32) and $FF] xor t4[(a shr 48) and $FF]);
c:= c + (t4[(a shr 8) and $FF] xor t3[(a shr 24) and $FF] xor t2[(a shr 40) and $FF] xor t1[(a shr 56) and $FF]);
c:= c * 7;
b:= b xor x[6];
c:= c - (t1[b and $FF] xor t2[(b shr 16) and $FF] xor t3[(b shr 32) and $FF] xor t4[(b shr 48) and $FF]);
a:= a + (t4[(b shr 8) and $FF] xor t3[(b shr 24) and $FF] xor t2[(b shr 40) and $FF] xor t1[(b shr 56) and $FF]);
a:= a * 7;
c:= c xor x[7];
a:= a - (t1[c and $FF] xor t2[(c shr 16) and $FF] xor t3[(c shr 32) and $FF] xor t4[(c shr 48) and $FF]);
b:= b + (t4[(c shr 8) and $FF] xor t3[(c shr 24) and $FF] xor t2[(c shr 40) and $FF] xor t1[(c shr 56) and $FF]);
b:= b * 7;
x[0]:= x[0] - (x[7] xor $A5A5A5A5A5A5A5A5);
x[1]:= x[1] xor x[0];
x[2]:= x[2] + x[1];
x[3]:= x[3] - (x[2] xor ((not x[1]) shl 19));
x[4]:= x[4] xor x[3];
x[5]:= x[5] + x[4];
x[6]:= x[6] - (x[5] xor ((not x[4]) shr 23));
x[7]:= x[7] xor x[6];
x[0]:= x[0] + x[7];
x[1]:= x[1] - (x[0] xor ((not x[7]) shl 19));
x[2]:= x[2] xor x[1];
x[3]:= x[3] + x[2];
x[4]:= x[4] - (x[3] xor ((not x[2]) shr 23));
x[5]:= x[5] xor x[4];
x[6]:= x[6] + x[5];
x[7]:= x[7] - (x[6] xor $0123456789ABCDEF);
a:= a xor x[0];
b:= b - (t1[a and $FF] xor t2[(a shr 16) and $FF] xor t3[(a shr 32) and $FF] xor t4[(a shr 48) and $FF]);
c:= c + (t4[(a shr 8) and $FF] xor t3[(a shr 24) and $FF] xor t2[(a shr 40) and $FF] xor t1[(a shr 56) and $FF]);
c:= c * 9;
b:= b xor x[1];
c:= c - (t1[b and $FF] xor t2[(b shr 16) and $FF] xor t3[(b shr 32) and $FF] xor t4[(b shr 48) and $FF]);
a:= a + (t4[(b shr 8) and $FF] xor t3[(b shr 24) and $FF] xor t2[(b shr 40) and $FF] xor t1[(b shr 56) and $FF]);
a:= a * 9;
c:= c xor x[2];
a:= a - (t1[c and $FF] xor t2[(c shr 16) and $FF] xor t3[(c shr 32) and $FF] xor t4[(c shr 48) and $FF]);
b:= b + (t4[(c shr 8) and $FF] xor t3[(c shr 24) and $FF] xor t2[(c shr 40) and $FF] xor t1[(c shr 56) and $FF]);
b:= b * 9;
a:= a xor x[3];
b:= b - (t1[a and $FF] xor t2[(a shr 16) and $FF] xor t3[(a shr 32) and $FF] xor t4[(a shr 48) and $FF]);
c:= c + (t4[(a shr 8) and $FF] xor t3[(a shr 24) and $FF] xor t2[(a shr 40) and $FF] xor t1[(a shr 56) and $FF]);
c:= c * 9;
b:= b xor x[4];
c:= c - (t1[b and $FF] xor t2[(b shr 16) and $FF] xor t3[(b shr 32) and $FF] xor t4[(b shr 48) and $FF]);
a:= a + (t4[(b shr 8) and $FF] xor t3[(b shr 24) and $FF] xor t2[(b shr 40) and $FF] xor t1[(b shr 56) and $FF]);
a:= a * 9;
c:= c xor x[5];
a:= a - (t1[c and $FF] xor t2[(c shr 16) and $FF] xor t3[(c shr 32) and $FF] xor t4[(c shr 48) and $FF]);
b:= b + (t4[(c shr 8) and $FF] xor t3[(c shr 24) and $FF] xor t2[(c shr 40) and $FF] xor t1[(c shr 56) and $FF]);
b:= b * 9;
a:= a xor x[6];
b:= b - (t1[a and $FF] xor t2[(a shr 16) and $FF] xor t3[(a shr 32) and $FF] xor t4[(a shr 48) and $FF]);
c:= c + (t4[(a shr 8) and $FF] xor t3[(a shr 24) and $FF] xor t2[(a shr 40) and $FF] xor t1[(a shr 56) and $FF]);
c:= c * 9;
b:= b xor x[7];
c:= c - (t1[b and $FF] xor t2[(b shr 16) and $FF] xor t3[(b shr 32) and $FF] xor t4[(b shr 48) and $FF]);
a:= a + (t4[(b shr 8) and $FF] xor t3[(b shr 24) and $FF] xor t2[(b shr 40) and $FF] xor t1[(b shr 56) and $FF]);
a:= a * 9;

CurrentHash[0]:=a xor aa;
CurrentHash[1]:=b - bb;
CurrentHash[2]:=c + cc;
dwIndex:=0;
FillChar(HashBuffer, Sizeof(HashBuffer), 0);
end;




procedure Hash_128(const pSrcBuf: Pointer;
                   const dwSrcBufSize, dwIterationsCount: LongWord;
                   const pHash: P128bit);
var
dwIndex, dwBufSize, i: DWORD;
Len: Int64;
HashBuffer: T64;
CurrentHash: T192;
PBuf: ^byte;
begin
//   ***************************  Init  ***************************

Len:=0;
dwIndex:=0;
ZeroMemory(@HashBuffer, SizeOf(HashBuffer));
CurrentHash[0]:=$0123456789ABCDEF;
CurrentHash[1]:=$FEDCBA9876543210;
CurrentHash[2]:=$F096A5B4C3B2E187;

//   ***************************  Update  ***************************

inc(Len,dwSrcBufSize shl 3);

PBuf:=pSrcBuf;
dwBufSize:=dwSrcBufSize;
  while dwBufSize> 0 do
  begin
  if (Sizeof(HashBuffer)-dwIndex)<= dwBufSize then
    begin
    Move(PBuf^, HashBuffer[dwIndex], Sizeof(HashBuffer) - dwIndex);
    dec(dwBufSize, Sizeof(HashBuffer) - dwIndex);
    inc(PBuf, Sizeof(HashBuffer) - dwIndex);
    Tiger_Compress(CurrentHash, HashBuffer, dwIndex);
    end
  else
    begin
    Move(PBuf^, HashBuffer[dwIndex], dwBufSize);
    inc(dwIndex, dwBufSize);
    dwBufSize:=0;
    end;
  end;

//   ***************************  Final  ***************************

HashBuffer[dwIndex]:=$01;
if dwIndex >= 56 then Tiger_Compress(CurrentHash, HashBuffer, dwIndex);
Pint64(@HashBuffer[56])^:=Len;

for i:=1 to dwIterationsCount do Tiger_Compress(CurrentHash, HashBuffer, dwIndex);

pHash^[0]:=PDWORD(@CurrentHash)^;
pHash^[1]:=PDWORD(Cardinal(@CurrentHash) + 4)^;
pHash^[2]:=PDWORD(Cardinal(@CurrentHash) + 8)^;
pHash^[3]:=PDWORD(Cardinal(@CurrentHash) + 12)^;

//Len:=0;
dwIndex:=0;
ZeroMemory(@HashBuffer, SizeOf(HashBuffer));
ZeroMemory(@CurrentHash, SizeOf(CurrentHash));
end;





function Tiger_SelfTest: Boolean;
const
  Test1Out: array[0..2] of int64=
    ($87FB2A9083851CF7,$470D2CF810E6DF9E,$B586445034A5A386);
  Test2Out: array[0..2] of int64=
    ($0C410A042968868A,$1671DA5A3FD29A72,$5EC1E457D3CDB303);
var
Hash: T128bit;
s: AnsiString;
begin
s:='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+-';
Hash_128(PAnsiChar(s), length(s), 1, @Hash);
result:=CompareMem128(@Hash, @Test1Out);

s:='Tiger - A Fast New Hash Function, by Ross Anderson and Eli Biham';
Hash_128(PAnsiChar(s), length(s), 1, @Hash);
result:=result AND CompareMem128(@Hash, @Test2Out);
end;





end.

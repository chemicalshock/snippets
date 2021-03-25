//
// Simple HTML decoding
// Author: Colin J.D. Stewart
// Usage: writeLn( htmlReplaceCodes('Hello&nbsp;World!') );
//

//
// replacement codes
//
function html_entity2char(const code: string): Char;
const
  html_code: array of string = [
    'nbsp', 'quot', 'amp', 'apos', 'lt', 'gt', 'iexcl', 'cent',
    'pound', 'curren', 'yen', 'brvbar', 'sect', 'uml', 'copy', 'ordf', 'laquo',
    'not', 'shy', 'reg', 'macr', 'deg', 'plusmn', 'sup2', 'sup3', 'acute',
    'micro', 'para', 'middot', 'cedil', 'sup1', 'ordm', 'raquo', 'frac14', 'frac12',
    'frac34', 'iquest', 'Agrave', 'Aacute', 'Acirc', 'Atilde', 'Auml', 'Aring', 'AElig',
    'Ccedil', 'Egrave', 'Eacute', 'Ecirc', 'Euml', 'Igrave', 'Iacute', 'Icirc', 'Iuml',
    'ETH', 'Ntilde', 'Ograve', 'Oacute', 'Ocirc', 'Otilde', 'Ouml', 'times', 'Oslash',
    'Ugrave', 'Uacute', 'Ucirc', 'Uuml', 'Yacute', 'THORN', 'szlig', 'agrave', 'aacute',
    'acirc', 'atilde', 'auml', 'aring', 'aelig', 'ccedil', 'egrave', 'eacute', 'ecirc',
    'euml', 'igrave', 'iacute', 'icirc', 'iuml', 'eth', 'ntilde', 'ograve', 'oacute',
    'ocirc', 'otilde', 'ouml', 'divide', 'oslash', 'ugrave', 'uacute', 'ucirc', 'uuml',
    'yacute', 'thorn', 'yuml', 'amp', 'bull', 'deg', 'infin', 'permil', 'sdot',
    'plusmn', 'dagger', 'mdash', 'not', 'micro', 'perp', 'par', 'euro', 'pound',
    'yen', 'cent', 'copy', 'reg', 'trade', 'alpha', 'beta', 'gamma', 'delta',
    'epsilon', 'zeta', 'eta', 'theta', 'iota', 'kappa', 'lambda', 'mu', 'nu',
    'xi', 'omicron', 'pi', 'rho', 'sigma', 'tau', 'upsilon', 'phi', 'chi',
    'psi', 'omega', 'Alpha', 'Beta', 'Gamma', 'Delta', 'Epsilon', 'Zeta', 'Eta',
    'Theta', 'Iota', 'Kappa', 'Lambda', 'Mu', 'Nu', 'Xi', 'Omicron', 'Pi',
    'Rho', 'Sigma', 'Tau', 'Upsilon', 'Phi', 'Chi', 'Psi', 'Omega'
  ];

  chars: array of Cardinal = [
    32, 34, 38, 39, 60, 62, 161, 162,
    163, 164, 165, 166, 167, 168, 169, 170, 171,
    172, 173, 174, 175, 176, 177, 178, 179, 180,
    181, 182, 183, 184, 185, 186, 187, 188, 189,
    190, 191, 192, 193, 194, 195, 196, 197, 198,
    199, 200, 201, 202, 203, 204, 205, 206, 207,
    208, 209, 210, 211, 212, 213, 214, 215, 216,
    217, 218, 219, 220, 221, 222, 223, 224, 225,
    226, 227, 228, 229, 230, 231, 232, 233, 234,
    235, 236, 237, 238, 239, 240, 241, 242, 243,
    244, 245, 246, 247, 248, 249, 250, 251, 252,
    253, 254, 255, 38, 8226, 176, 8734, 8240, 8901,
    177, 8224, 8212, 172, 181, 8869, 8741, 8364, 163,
    165, 162, 169, 174, 8482, 945, 946, 947, 948,
    949, 950, 951, 952, 953, 954, 955, 956, 957,
    958, 959, 960, 961, 963, 964, 965, 966, 967,
    968, 969, 913, 914, 915, 916, 917, 918, 919,
    920, 921, 922, 923, 924, 925, 926, 927, 928,
    929, 931, 932, 933, 934, 935, 936, 937
  ];

var
  i: Integer;


  function UCS4ToString(uch: UCS4Char): string; inline;
  var
    s: UCS4String;
  begin
    SetLength(s, 2);
    s[0] := uch;
    s[1] := 0;
    Result := UCS4StringToUnicodeString(s);
  end;
begin
  Result := Char(' ');
  if Length(code) < 2 then exit;
    //
  if code[1] = '#' then begin
    Result := UCS4ToString(StrToUInt(code.Substring(1)))[1];
  end else begin
    for i := Low(html_code) to High(html_code) do begin
      if html_code[i] = code then exit(UCS4ToString(chars[i])[1]);
    end;
  end;
end;


//
// run through the input and replace html codes
//
function html_replace_entities(const input: string): string;
var
  startPos, endPos: Integer;
begin
  startPos := 0;
  endPos := 0;

  Result := '';
  repeat
    endPos := input.IndexOf('&', startPos);
    if endPos = -1 then break;

    Result := Result + input.Substring(startPos, endPos-startPos);

    startPos := input.IndexOf(';', endPos);
    if startPos = -1 then break;

    Result := Result + html_entity2char(input.Substring(endPos+1, startPos-endPos-1));
  until False;

  if startPos = 0 then
    Result := input
  else
    Result := Result + input.Substring(startPos+1);
end;

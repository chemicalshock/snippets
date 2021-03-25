//
// Convert a string to name case, e.g. my name -> My Name
// Author: Colin J.D. Stewart
// Usage: toNameCase( 'my name' );
//
function toNameCase(const input: string): string;
var
  i: Integer;
  b: boolean;
begin
  b := true;
  Result := input;
  for i := 1 to Length(Result) do begin
    if b = true then begin

      case Result[i] of
        'a'..'z': Result[i] := Char(Word(Result[i]) - 32);
        'à'..'ö': Result[i] := Char(Word(Result[i]) - 32);
        'ø'..'ÿ': Result[i] := Char(Word(Result[i]) - 34);
        'ā'..'ň', 'ŋ'..'ž': Result[i] := Char(Word(Result[i]) - 1);
        'а'..'я': Result[i] := Char(Word(Result[i]) - 32);
      end;

      if not (Result[i] in [' ', '.', ',', '-', '''']) then b := false;
    end else begin
      if (Result[i] in [' ', '.', ',', '-', '''']) then b := true;
    end;
  end;
end;

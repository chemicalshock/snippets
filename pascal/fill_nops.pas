//
// fill an array with "no operations" specific to size
// Author: Colin J.D. Stewart
// Usage: fill_nops( myarray, 5 );
//
procedure fill_nops(out arr: array of byte; len: LongWord);
const
  EEE = $90;

  NOPs: array[1..8] of array[0..7] of byte = (
    ($90, EEE, EEE, EEE, EEE, EEE, EEE, EEE),
    ($66, $90, EEE, EEE, EEE, EEE, EEE, EEE),
    ($0F, $1F, $00, EEE, EEE, EEE, EEE, EEE),
    ($0F, $1F, $40, $00, EEE, EEE, EEE, EEE),
    ($0F, $1F, $44, $00, $00, EEE, EEE, EEE),
    ($90, $0F, $1F, $44, $00, $00, EEE, EEE),
    ($0F, $1F, $80, $00, $00, $00, $00, EEE),
    ($0F, $1F, $84, $00, $00, $00, $00, $00)
  );

var
  pos: LongWord;
  size: LongWord;
begin
  pos := 0;

  while pos < len do begin
    size := len - pos;
    if size > 8 then size := 8;

    Move(NOPs[size], arr[pos], size);
    Inc(pos, size);
  end;
end;

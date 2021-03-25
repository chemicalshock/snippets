//
// Format a float-point number. e.g. 5233255.12 => 5,233,255.12
// Copyright (c) Colin J.D. Stewart. All rights reserved.
// MIT License.
// Example: [_number, 2, ".", ","] call PX_fnc_formatNumber;
//
PX_fnc_formatNumber = {
	params ["_number", "_decimals", "_decsym", "_thsym"];
	private ["_arr", "_str", "_count"];
	
	_str = "";
	_count = 0;
	
	_arr = toArray (_number toFixed _decimals);
	reverse _arr;	
	{
		_x = toString [_x];
		
		if (_forEachIndex == _decimals) then {
			_str = _decsym + _str;
		} else {
			if (_forEachIndex < _decimals) then {
				_str = _x + _str;
			} else {
				if (_count == 3) then {
					_count = 0;
					_str = _thsym + _str;
				};
					
				_str = _x + _str;
				_count = _count + 1;			
			};
		};
	} forEach _arr;

	_str;
};

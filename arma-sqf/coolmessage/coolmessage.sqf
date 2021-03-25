/////////////////////////////////////////////////////////////////////////////////
//
// Cool Message - part of PixeL_GaMMa library.
// A function that displays a cool fading message log.
// Copyright (c) Colin J.D. Stewart. All rights reserved
// APL-ND License - https://www.bistudio.com/community/licenses/arma-public-license-nd
//
/////////////////////////////////////////////////////////////////////////////////

if (hasInterface) then {
	msglines = [];
		
	func_pxCoolMsg = {			
		disableSerialization;
		_ctrl = (findDisplay 46) ctrlCreate ["RscStructuredText", -1];
		msgLines pushBack _ctrl;
		_ctrl ctrlSetFont "PuristaMedium";					
		_ctrl ctrlSetPosition [safeZoneX, safeZoneY + safeZoneH - 0.05, safeZoneW, safeZoneH];	
		_ctrl ctrlSetStructuredText parseText format["<t align='right'>%1</t>", _this];			
		_ctrl ctrlCommit 0;
		
		_ctrlCount = (count msglines) -1; 
		
		_deleteCount = 0;
		
		_pos = 0.05 + (_ctrlCount * 0.03); //[0,0];
		{
			if (ctrlFade _x == 1) then {
				_deleteCount = _deleteCount + 1;
				ctrlDelete _x;
			} else {
				_x ctrlSetPosition [safeZoneX, safeZoneY + safeZoneH - _pos, safeZoneW, safeZoneH];	
				_x ctrlCommit 1;		
			};
			
			_pos = _pos - 0.03;			
		} foreach msgLines;		

		_ctrl ctrlSetFade 1;
		_ctrl ctrlCommit 20;	
		
		// remove any old...
		msgLines deleteRange [0, _deleteCount];
	};
};

if (isServer) then {
	func_pxSendCoolMsg = {
		_this remoteExec ["func_pxCoolMsg", 0]; 
	};
};

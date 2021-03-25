////////////////////////////////////////////////////////////////////////////////////////
//
// Team Tags rev.01 - part of PixeL_GaMMa library.
// Display rank insignia, title and name when aiming at team members with head visible
// Copyright (c) Colin J.D. Stewart. All rights reserved
// APL-ND License - https://www.bistudio.com/community/licenses/arma-public-license-nd
//
////////////////////////////////////////////////////////////////////////////////////////


//
// The following code can be moved to your init or config file but should be placed before executing this script
//
PX_TAGS_VIEW_DIST = 2000; //change this to desired max view distance of tags
publicVariable "PX_TAGS_VIEW_DIST";	


//
// Linear Interoplate rgba. Usage: [[_r1,_g1,_b1,_a1],[_r2,_g2,_b2,_a2],0.5] call PX_fnc_LerpRGBA;
//
PX_fnc_LerpRGBA = {
	params ["_from", "_to", "_t"]; // array [0,0,0,0], array [0,0,0,0], float
	
	_r = (_from select 0) + ((_to select 0) - (_from select 0)) * _t;
	_g = (_from select 1) + ((_to select 1) - (_from select 1)) * _t;
	_b = (_from select 2) + ((_to select 2) - (_from select 2)) * _t;
	_a = (_from select 3) + ((_to select 3) - (_from select 3)) * _t;
	
	[_r,_g,_b,_a];
};

if (hasInterface) then {
	addMissionEventHandler ["EachFrame", {
		{
			private ["_offset", "_xdist", "_iconSize", "_colour", "_rankIcon", "_rankTitle", "_name"];
			
			if (side _x == side player) then {			
				// height offset
				if (_x == vehicle _x) then {
					_offset = ((_x modelToWorld (_x selectionPosition 'head')) select 2) + 0.4;
				} else {
					_offset = 1;
				};
			
				_dist = _x distance player;
				//				
				_xdist = _dist / PX_TAGS_VIEW_DIST;
				_colour = getArray (configFile/'CfgInGameUI'/'SideColors'/'colorFriendly');
				_colour = [_colour, [255,0,0,1], damage _x] call PX_fnc_LerpRGBA;															
				_rankIcon = [_x, "texture"] call BIS_fnc_rankParams;
				_iconSize = 1.0 - _xdist;			
									
				if ((cursorTarget == _x) && ([objNull, "VIEW", objNull] checkVisibility [eyePos player, eyePos _x] > 0)) then {
					_rankTitle = [_x, "displayNameShort"] call BIS_fnc_rankParams;				
					_name = format["%1. %2", _rankTitle, name _x];
					drawIcon3D [_rankIcon, _colour, [visiblePosition _x select 0, visiblePosition _x select 1, (visiblePosition _x select 2) + _offset], _iconSize, _iconSize, 45, _name, 2, 0.03, 'PuristaMedium'];
				} else {						
					if (_dist < PX_TAGS_VIEW_DIST) then {
						_colour set [3, 1.0 - _xdist];
				
						drawIcon3D [_rankIcon, _colour, [visiblePosition _x select 0, visiblePosition _x select 1, (visiblePosition _x select 2) + _offset], _iconSize, _iconSize, 45, "", 2];					
					};
				};
			};
		} count allUnits - [player];
	}];
};

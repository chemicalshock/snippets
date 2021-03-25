/////////////////////////////////////////////////////////////////////////////////
//
// ViewDist - part of PixeL_GaMMa library.
// Allow users to adjust their view distance using - and + from min to max.
// Copyright (c) Colin J.D. Stewart. All rights reserved
// APL-ND License - https://www.bistudio.com/community/licenses/arma-public-license-nd
//
/////////////////////////////////////////////////////////////////////////////////

////
//// you can move these into a config file
////
#define VD_MIN 500			// min view distance a user can use for this mission
#define VD_MAX 5000			// max view distance a user can use for this mission
#define VD_DEFAULT 3000		// the default view distance when they enter for first time
////	
	
	
if (hasInterface) then {
	PX_getTG = {
		_lvl = _this select 0; // 0-4
		if (_lvl < 0) then { _lvl = 0; };
		if (_lvl > 4) then { _lvl = 4; };
		
		_res = switch (_lvl) do {
			case 0: {[50, "Very Low"]};
			case 1: {[25, "Low"]};
			case 2: {[12.5, "Normal"]};
			case 3: {[6.25, "High"]};
			case 4: {[3.125, "Very High"]};	
			
			default {[12.5, "Normal"]};
		};		
		
		_res;
	};

	PX__changeViewDistance = {
		params["_source", "_keyCode", "_isShift", "_isCtrl", "_isAlt"];
		private['_handled', '_prevVD', "_tg"];
		_prevVD = PX__myViewDistance;
		
		_handled = false;
		
		if (_isAlt) then {
			switch (_keyCode) do {
				case (0x0C): { PX__myViewDistance = PX__myViewDistance - 100; _handled = true; };		
				case (0x0D): { PX__myViewDistance = PX__myViewDistance + 100; _handled = true; };
			};
			
			if (_handled) then {
				if (!(_prevVD == PX__myViewDistance)) then {
					if (PX__myViewDistance > VD_MAX) then {
						PX__myViewDistance = VD_MAX;
					} else {
						if (PX__myViewDistance < VD_MIN) then { PX__myViewDistance = VD_MIN; };
					};
					setViewDistance PX__myViewDistance;
					setObjectViewDistance [(PX__myViewDistance * 0.90), 100];
							
					profileNamespace setVariable ["px_viewdist", PX__myViewDistance];
					hint format ["Your view distance was updated to: %1", PX__myViewDistance];
				};
			};
		} else {
			if (_isCtrl) then {
				switch (_keyCode) do {
					case (0x0C): { PX__myTerrainGrid = PX__myTerrainGrid - 1; _handled = true; };		
					case (0x0D): { PX__myTerrainGrid = PX__myTerrainGrid + 1; _handled = true; };
				};
				
				if (_handled) then {
					if (PX__myTerrainGrid < 0) then { PX__myTerrainGrid = 0; };
					if (PX__myTerrainGrid > 4) then { PX__myTerrainGrid = 4; };
					
					_tg = [PX__myTerrainGrid] call PX_getTG;
					setTerrainGrid (_tg select 0);	

					profileNamespace setVariable ["px_terraingrid", PX__myTerrainGrid];
					hint format ["Your terrain grid detail was updated to: %1", (_tg select 1)];				
				};
			};
		};
		_handled;
	};

	[] spawn {
		disableSerialization;
		waituntil {!(isNull (findDisplay 46))};
		(findDisplay 46) displayAddEventHandler ["KeyDown","_this call PX__changeViewDistance"];
	};
	
	if (!isNil{profileNamespace getVariable "px_viewdist"}) then {
		PX__myViewDistance = (profileNamespace getVariable "px_viewdist");
	} else {
		PX__myViewDistance = VD_DEFAULT;
	};
	
	if (!isNil{profileNamespace getVariable "px_terraingrid"}) then {
		PX__myTerrainGrid = (profileNamespace getVariable "px_terraingrid");
	} else {
		PX__myTerrainGrid = 1;
	};	

	// set default
	setViewDistance (PX__myViewDistance * 0.90);
	setObjectViewDistance [PX__myViewDistance, 100];
	
	_tg = [PX__myTerrainGrid] call PX_getTG;
	setTerrainGrid (_tg select 0);
	
	hint format ["View distance: %1, Terrain Grid: %2", PX__myViewDistance, (_tg select 1)];
	
	addMissionEventHandler ["PlayerDisconnected", {
		saveProfileNamespace;
	}];	
};

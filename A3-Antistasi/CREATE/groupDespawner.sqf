private ["_grupo","_lado","_eny1","_eny2"];
_grupo = _this select 0;
_lado = side _grupo;
_eny1 = enemySide;
_eny2 = oppositionSide;
if (_lado == enemySide) then {_eny1 = friendlySide} else {if (_lado == oppositionSide) then {_eny2 = friendlySide}};

{_unit = _x;
if (!([spawnDistanceDefault,1,_unit,_eny1] call A3A_fnc_distanceUnits) and !([spawnDistanceDefault,1,_unit,_eny2] call A3A_fnc_distanceUnits)) then {deleteVehicle _unit}} forEach units _grupo;

{_unit = _x;
waitUntil {sleep 1;!([spawnDistanceDefault,1,_unit,_eny1] call A3A_fnc_distanceUnits) and !([spawnDistanceDefault,1,_unit,_eny2] call A3A_fnc_distanceUnits)};deleteVehicle _unit} forEach units _grupo;

deleteGroup _grupo;
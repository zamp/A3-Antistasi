if (!isServer) exitWith {};

private ["_marcador","_lado","_salir","_enemy1","_enemy2","_winner"];

_marcador = _this select 0;
_lado = _this select 1;
if ((isNil "_marcador") or (isNil "_lado")) exitWith {};
waitUntil {!zoneCheckInProgress};
zoneCheckInProgress = true;
_salir = true;
_enemy1 = "";
_enemy2 = "";

if ((_lado == friendlySide) and (lados getVariable [_marcador,sideUnknown] == friendlySide)) then
	{
	_salir = false;
	_enemy1 = oppositionSide;
	_enemy2 = enemySide;
	}
else
	{
	if ((_lado == enemySide) and (lados getVariable [_marcador,sideUnknown] == enemySide)) then
		{
		_salir = false;
		_enemy1 = oppositionSide;
		_enemy2 = friendlySide;
		}
	else
		{
		if ((_lado == oppositionSide) and (lados getVariable [_marcador,sideUnknown] == oppositionSide)) then
			{
			_salir = false;
			_enemy1 = enemySide;
			_enemy2 = friendlySide;
			};
		};
	};

if (_salir) exitWith {zoneCheckInProgress = false};
_salir = true;

if ({((_x getVariable ["spawner",false]) and ((side group _x) in [_enemy1,_enemy2])) and ([_x,_marcador] call A3A_fnc_canConquer)} count allUnits > 3*({([_x,_marcador] call A3A_fnc_canConquer) and (_x getVariable ["marcador",""] == _marcador)} count allUnits)) then
	{
	_salir = false;
	};
if (_salir) exitWith {zoneCheckInProgress = false};

_winner = _enemy1;
if ({(_x getVariable ["spawner",false]) and (side group _x == _enemy1) and ([_x,_marcador] call A3A_fnc_canConquer)} count allUnits <= {(_x getVariable ["spawner",false]) and (side group _x == _enemy2) and ([_x,_marcador] call A3A_fnc_canConquer)} count allUnits) then {_winner = _enemy2};

[_winner,_marcador] remoteExec ["A3A_fnc_markerChange",2];

waitUntil {sleep 1; lados getVariable [_marcador,sideUnknown] == _winner};
zoneCheckInProgress = false;

if (!isServer) exitWith {};

private ["_marcador","_pos","_roads","_road","_posroad","_cercano","_cuenta"];

_marcador = _this select 0;

_pos = getMarkerPos _marcador;
_cuenta = 0;

{if (getMarkerPos _x distance _pos < 1000) then {_cuenta = _cuenta + 1}} forEach controles;

if (_cuenta > 3) exitWith {};

_roads = _pos nearRoads 500;

_roads = _roads call BIS_Fnc_arrayShuffle;
{
_road = _x;
_posroad = getPos _road;
if (_cuenta > 4) exitWith {};

if (_posroad distance _pos > 400) then
	{
        _roadsCon = roadsConnectedto _road;
        if (count _roadsCon > 0) then
                {
        	_cercano = [controles,_posroad] call BIS_fnc_nearestPosition;
        	if (getMarkerPos _cercano distance _posroad > 1000) then
        		{
        		_name = format ["control_%1", count controles];
        		_mrk = createmarker [format ["%1", _name], _posroad];
                        _mrk setMarkerSize [30,30];
                        _mrk setMarkerShape "RECTANGLE";
                        _mrk setMarkerBrush "SOLID";
                        _mrk setMarkerColor friendlyColor;
                        _mrk setMarkerText _name;
                        if (not debug) then {_mrk setMarkerAlpha 0};
                        if (lados getVariable [_marcador,sideUnknown] == enemySide) then
                                {
                                lados setVariable [_name,enemySide,true];
                                }
                        else
                                {
                                if (lados getVariable [_marcador,sideUnknown] == oppositionSide) then {lados setVariable [_name,oppositionSide,true]} else {lados setVariable [_name,friendlySide,true]};
                                };
                        controles pushBackUnique _name;
                        marcadores pushBackUnique _name;
                        spawner setVariable [_name,2,true];
                        _cuenta = _cuenta + 1;
        		};
                };
	};
} forEach _roads;
private _soldados = _this;

waitUntil {sleep 10;{([_x] call A3A_fnc_canFight) and (vehicle _x == _x)} count _soldados == {[_x] call A3A_fnc_canFight} count _soldados};

if ({[_x] call A3A_fnc_canFight} count _soldados == 0) exitWith {};
private _lado = side (group (_soldados select 0));
private _eny = [friendlySide];
if (_lado == enemySide) then {_eny pushBack oppositionSide} else {_eny pushBack enemySide};

while {true} do
	{
	sleep 10;//poner 10
	_soldados = _soldados select {[_x] call A3A_fnc_canFight};
	if (_soldados isEqualTo []) exitWith {};
	_exit = false;
	_enemigos = [];
	{
	_soldado = _x;
	{
	if ((_x distance _soldado < (2*spawnDistanceDefault)) and (isPlayer _x)) then
		{
		_exit = true
		}
	else
		{
		if ((_x distance _soldado < (spawnDistanceDefault/2)) and {[_x] call A3A_fnc_canFight} and {side group _x in _eny} and {vehicle _x == _x}) then
			{
			_enemigos pushBackUnique _x;
			};
		};
	} forEach (allUnits - _soldados);
	} forEach _soldados;
	if (_exit) exitWith {};
	if !(_enemigos isEqualTo []) then
		{
		_chanceToKill = 50 * ((count _soldados) / (count _enemigos));
		if (random 100 <= _chanceToKill) then
			{
			(selectRandom _enemigos) setDamage 1;
			}
		else
			{
			(selectRandom _soldados) setDamage 1;
			};
		};
	};
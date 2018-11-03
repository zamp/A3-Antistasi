private ["_type","_cost","_group","_unit","_team","_roads","_road","_pos","_truck","_text","_mrk","_hr","_exists","_clickPos","_escarretera","_tipogrupo","_resourcesFIA","_hrFIA"];

if (["PuestosFIA"] call BIS_fnc_taskExists) exitWith 
{
	hint HINT_ONLY_ONE_DEPLAY_AT_ONCE
};

if (!([player] call A3A_fnc_hasRadio)) exitWith 
{
	if !(isFIA) then 
	{
		hint HINT_NEED_RADIO
	} 
	else 
	{
		hint HINT_NEED_RADIO_MAN
	}
};

_type = _this select 0;

if (!visibleMap) then 
{
	openMap true
};

if (_type != "delete") then
{
	hint "Click on the position you wish to build the Observation Post or Roadblock. \n Remember: to build Roadblocks you must click exactly on a road map section"
} 
else 
{
	hint "Click on the Observation Post or Roadblock to delete."
};

clickPos = [];
onMapSingleClick "clickPos = _pos;";

waitUntil {sleep 1; (count clickPos > 0) or (not visiblemap)};
onMapSingleClick "";

if (!visibleMap) exitWith {};

_clickPos = clickPos;
_pos = [];

if ((_type == "delete") and (count puestosFIA < 1)) exitWith 
{
	hint "No Posts or Roadblocks deployed to delete"
};
if ((_type == "delete") and ({(alive _x) and (!captive _x) and ((side _x == enemySide) 
	or (side _x == oppositionSide)) and (_x distance _clickPos < 500)} count allUnits > 0)) exitWith 
{
	hint "You cannot delete a Post while enemies are near it"
};

_cost = 0;
_hr = 0;

if (_type != "delete") then
{
	_escarretera = isOnRoad _clickPos;

	_tipogrupo = gruposSDKSniper;

	if (_escarretera) then
		{
		_tipogrupo = gruposSDKAT;
		_cost = _cost + ([vehSDKLightArmed] call A3A_fnc_vehiclePrice) + (server getVariable staticCrewBuenos);
		_hr = _hr + 1;
		};

	//_formato = (configfile >> "CfgGroups" >> "friendlySide" >> "Guerilla" >> "Infantry" >> _tipogrupo);
	//_unidades = [_formato] call groupComposition;
	{_cost = _cost + (server getVariable (_x select 0)); _hr = _hr +1} forEach _tipoGrupo;
}
else
{
	_mrk = [puestosFIA,_clickPos] call BIS_fnc_nearestPosition;
	_pos = getMarkerPos _mrk;
	if (_clickPos distance _pos >10) exitWith {hint "No post nearby"};
};

_resourcesFIA = server getVariable "resourcesFIA";
_hrFIA = server getVariable "hr";

if (((_resourcesFIA < _cost) or (_hrFIA < _hr)) and (_type!= "delete")) exitWith {hint format ["You lack of resources to build this Outpost or Roadblock \n %1 HR and %2 € needed",_hr,_cost]};

if (_type != "delete") then
{
	[-_hr,-_cost] remoteExec ["A3A_fnc_resourcesFIA",2];
}
else 
{
	hint "Some fuckery here."
	//[[_type,_clickPos],"A3A_fnc_crearPuestosFIA"] call BIS_fnc_MP
};

//function Initialize()
//{
	
function Hex(col, row) constructor
{
	colX = col;
	rowY = row;
	cost = 1;
	occupied = false;
	garrisoned = false;
	occupiedBy2 = false;
	occupant = 0;
	occupant2 = 0;
	terrain = Terrain.Clear 
	road = RoadExit.NoRoad;
	city = Urban.NotUrban;
	airfield = false;
	port = false;
	defense = 1;
	offense = 1;
	playerBuff = 0;
	opponentBuff = 0;
	ownedBy = Bloc.Allied;
	howFarAway = 0;
	combatStrength = 0;
	victoryPoints = 0;
	strategicValue = 0;
	tacticalValue = 0;
	description = "Desert";
}

function LCU() constructor
{
	designation = "Unit";
	side = Bloc.Allied;
	nationality = Nation.Britain;
	branch = Type.Infantry;
	size = Formation.Division;
	movement = 3;
	combat = 3;
	orders[0] = 0;
	ordersSet = false;
	picture = sIt23InfDiv;
	onMap = true;
	coordX = 0;
	coordY = 0;
	topUnit = true;
}

function HexContainer() constructor 
{
    hexes = [];
    static add = function(hex) 
	{
        hexes[array_length(hexes)] = hex;
		return self;
    };
    static setAll = function(field, val) {
        for (var i = array_length(hexes)-1; i >= 0; --i) {
            variable_struct_set(hexes[i], field, val);
        }
    };
}

function UnitContainer() constructor 
{
    units = [];
    static add = function(unit) 
	{
        units[array_length(units)] = unit;
		return self;
    };
    static setAll = function(field, val) {
        for (var i = array_length(units)-1; i >= 0; --i) {
            variable_struct_set(units[i], field, val);
        }
    };
}

	
function PutUnitInHex(col, row, unit)
{
	var targetHex = oMap.map[col][row];
	if ! targetHex.occupied
	{
		targetHex.occupied = true;
		targetHex.occupant = unit;
		targetHex.occupant.coordX = col;
		targetHex.occupant.coordY = row;
		targetHex.occupant.topUnit = true;
		targetHex.occupant.onMap = true;
		oMap.map[col][row] = targetHex;
	}
	else
	{
		targetHex.occupant2 = unit;
		targetHex.occupant2.coordX = col;
		targetHex.occupant2.coordY = row;
		targetHex.occupant2.topUnit = false;
		targetHex.occupant2.onMap = true;
		targetHex.occupiedBy2 = true;
	}
}



/// @description Insert description here
// You can write your code in this editor

x = 0;
y = 120;

// x "axis" is 26 hex columns.  y has 15 qolumns.  15 z-axis?
// Will follow Amit & use cube coordinates for algorithms, maybe.
// But for storage, good ol' offset coordinates. Pointy top, so odd-r.

#region Initialize Variables

map[25][14] = 0;
mapCoordinates[0] = 0;
mapCoordinates[1] = 0;

AIPosture = AIState.GeneratingMoves;

alliedVPs = 0;
alliedStrategicPosition = 0;
axisVPs = 0;
axisStrategicPosition = 0;

highlightedHexes = ds_list_create();
unitOrders = ds_list_create();
whoHasOrders = ds_list_create();
possibleMoves = ds_list_create();
possibleThreats = ds_list_create();
actualThreats = ds_list_create();

enemiesOnMap = ds_list_create();

needPath = false;
hexAlreadySelected = false;
spriteAlpha = 1;

turn = 1;
impulse = 0;
combatMessage = "Awaiting orders";
firstImpulse = false;
longestOrder = 0;
// parentHex = 0;
parentHex = new HexContainer();

//addedHex = new Hex(0, 0);  // not needed?
//addedHex.playerBuff = 0;   // not needed?

// parentUnit = 0;
parentUnit = new UnitContainer();

displayControl = false;
displayInfluence = false;
displayStrategic = false;
hexOverlay = true;

var emptyHex;   // initialize map; add VP values & AI weights
for (var col = 0; col < 26; col += 1;)
{
	for (var row = 0; row < 15; row += 1;)
	{
		emptyHex = new Hex(col,row);
		map[col][row] = emptyHex;
		if col <= 13	{ map[col][row].ownedBy = Bloc.Axis; }
		else { map[col][row].ownedBy = Bloc.Allied;}
	}
}

	map[0][4].description = "El Agheila";
	//map[0][4].victoryPoints = 5;
	//map[0][4].strategicValue = 5;
	map[0][4].ownedBy = Bloc.Axis;
	
	map[1][1].description = "Benghazi";
	//map[1][1].victoryPoints = 40;
	//map[1][1].strategicValue = 40;
	map[1][1].port = 1;
	map[1][1].ownedBy = Bloc.Axis;
	
	map[2][0].description = "Just northeast of Benghazi";
	// map[2][0].strategicValue = 30;
	map[2][0].ownedBy = Bloc.Axis;
	
	map[2][1].description = "Just east of Benghazi";
	// map[2][1].strategicValue = 30;
	map[2][1].ownedBy = Bloc.Axis;
	
	map[2][2].description = "Just southeast of Benghazi";
	// map[2][2].strategicValue = 30;
	map[2][2].ownedBy = Bloc.Axis;
	
	map[1][2].description = "Just southwest of Benghazi";
	// map[1][2].strategicValue = 30;
	map[1][2].ownedBy = Bloc.Axis;
	
	map[5][0].description = "Derna";
	map[5][0].strategicValue = 30;
	map[5][0].victoryPoints = 30;
	map[5][0].ownedBy = Bloc.Axis;
	
	map[5][1].description = "Gazala";
	map[5][1].strategicValue = 10;
	map[5][1].victoryPoints = 10;
	map[5][1].ownedBy = Bloc.Axis;
	
	map[6][1].description = "Tobruk";
	map[6][1].victoryPoints = 70;
	map[6][1].strategicValue = 70;
	map[6][1].port = 1;
	map[6][1].ownedBy = Bloc.Axis;
	
	map[6][2].description = "Just southwest of Tobruk";
	map[6][2].strategicValue = 40;
	map[6][2].ownedBy = Bloc.Axis;
	
	map[7][1].description = "Just northeast of Tobruk";
	map[7][1].strategicValue = 40;
	map[7][1].ownedBy = Bloc.Axis;
	
	map[7][2].description = "Just southeast of Tobruk";
	map[7][2].strategicValue = 40;
	map[7][2].ownedBy = Bloc.Axis;
	
	map[7][3].description = "Fort Madellena";
	// map[7][3].strategicValue = 30;
	map[7][2].ownedBy = Bloc.Axis;
	
	map[8][2].description = "Bardia";
	// map[8][2].strategicValue = 30;
	map[8][2].port = 1;
	// map[8][2].victoryPoints = 30;
	map[8][2].ownedBy = Bloc.Axis;
	
	map[8][3].description = "South of Bardia";
	//map[8][3].strategicValue = 10;
	
	//map[8][4].strategicValue = 10;
	//map[8][5].strategicValue = 5;
	
	map[7][4].description = "South of Fort Madellena";
	//map[7][4].strategicValue = 10;
	map[7][4].ownedBy = Bloc.Axis;
	
	map[6][4].description = "Far south of Fort Madellena";
	//map[6][4].strategicValue = 10;
	map[7][4].ownedBy = Bloc.Axis;
	
	map[9][2].description = "Sidi Barrani";
	//map[9][2].strategicValue = 10;
	//map[9][2].victoryPoints = 10;
	map[9][2].ownedBy = Bloc.Allied;
	
	//map[9][3].strategicValue = 10;
	//map[9][4].strategicValue = 5;
	//map[9][5].strategicValue = 2;
	
	//map[10][2].strategicValue = 15;
	//map[10][3].strategicValue = 5;
	
	map[11][2].description = "Mersa Matruh";
	//map[11][2].strategicValue = 20;
	//map[11][2].victoryPoints = 20;
	map[11][2].ownedBy = Bloc.Allied;
	
	map[11][3].description = "Baggush";
	// map[11][3].strategicValue = 20;
	// map[11][3].victoryPoints = 20;
	map[11][3].ownedBy = Bloc.Allied;
	
	map[12][3].description = "El Daba";
	// map[12][3].strategicValue = 20;
	// map[12][3].victoryPoints = 20;
	map[12][3].ownedBy = Bloc.Allied;
	
	map[13][3].description = "El Alamein";
	// map[13][3].strategicValue = 40;
	// map[13][3].victoryPoints = 40;
	map[13][3].strategicValue = 0;
	map[13][3].ownedBy = Bloc.Allied;
	
	
	
	
	
	show_debug_message("Important hex is " + string(map[6][1].strategicValue));
	
	show_debug_message("It is " + (map[6][1].description));

#endregion

#region Create Units

Brit7Arm8Hus = new LCU();
Brit7Arm8Hus.designation = "British 6th Royal Tank Regiment";
Brit7Arm8Hus.side = Bloc.Allied;
Brit7Arm8Hus.branch = Type.Armor;
Brit7Arm8Hus.movement = 6;
Brit7Arm8Hus.combat = 6;
Brit7Arm8Hus.size = Formation.Batallion;
Brit7Arm8Hus.picture = sBr7Arm8Hus;
PutUnitInHex(18, 11, Brit7Arm8Hus);

Brit7Arm6RTR = new LCU();
Brit7Arm6RTR.designation = "British 8th Hussars Batallion";
Brit7Arm6RTR.side = Bloc.Allied;
Brit7Arm6RTR.branch = Type.Armor;
Brit7Arm6RTR.movement = 5;
Brit7Arm6RTR.combat = 8;
Brit7Arm6RTR.size = Formation.Batallion;
Brit7Arm6RTR.picture = sBr6RTR;
PutUnitInHex(19, 10, Brit7Arm6RTR);



//India4Inf = new LCU();
//India4Inf.designation = "Indian 4th Infantry Corps";
//India4Inf.combat = 5;
//India4Inf.nationality = Nation.India;
//India4Inf.picture = sIndian4Inf;
//PutUnitInHex(10, 2, India4Inf);

//Wavell = new LCU();
//Wavell.designation = "Wavell HQ";
//Wavell.combat = 5;
//Wavell.picture = sUKWavell;
//PutUnitInHex(9, 3, Wavell);

//Austr6Inf = new LCU();
//Austr6Inf.designation = "Australian 6th Infantry Corps";
//Austr6Inf.combat = 5;
//Austr6Inf.nationality = Nation.Australia;
//Austr6Inf.picture = sAustr6Inf;
//PutUnitInHex(8, 5, Austr6Inf);

Italy23Inf = new LCU();
Italy23Inf.designation = "Italian 23rd Infantry Division";
Italy23Inf.side = Bloc.Axis;
Italy23Inf.nationality = Nation.Italy;
Italy23Inf.picture = sIt23InfDiv; 
PutUnitInHex(13, 4, Italy23Inf);

Italy28Oct = new LCU();
Italy28Oct.designation = "Italian Blackshirt (28th Oct.) Division";
Italy28Oct.side = Bloc.Axis;
Italy28Oct.nationality = Nation.Italy;
Italy28Oct.picture = sIt28Oct; 
PutUnitInHex(14, 6, Italy28Oct);

//Italy22Inf = new LCU();
//Italy22Inf.designation = "Italian 22nd Infantry Corps";
//Italy22Inf.side = Bloc.Axis;
//Italy22Inf.nationality = Nation.Italy;
//Italy22Inf.combat = 4;
//Italy22Inf.picture = sItaly22Inf; 
//PutUnitInHex(4, 3, Italy22Inf);

//Italy21Inf = new LCU();
//Italy21Inf.designation = "Italian 21st Infantry Corps";
//Italy21Inf.side = Bloc.Axis;
//Italy21Inf.nationality = Nation.Italy;
//Italy21Inf.picture = sItaly21Inf; 
//PutUnitInHex(7, 4, Italy21Inf);

//Italy20Mot = new LCU();
//Italy20Mot.designation = "Italian 20th Motorized Corps";
//Italy20Mot.side = Bloc.Axis;
//Italy20Mot.nationality = Nation.Italy;
//Italy20Mot.branch = Type.Motorized;
//Italy20Mot.picture = sItaly20Mot;
//Italy20Mot.combat = 4;
//Italy20Mot.movement = 6;
//PutUnitInHex(2, 4, Italy20Mot);

//LibyaPescatore = new LCU();
//LibyaPescatore.designation = "Libyan Pescatore Division";
//LibyaPescatore.side = Bloc.Axis;
//LibyaPescatore.nationality = Nation.Libya;
//LibyaPescatore.size = Formation.Division;
//LibyaPescatore.combat = 1;
//LibyaPescatore.movement = 3;
//LibyaPescatore.picture = sLibPescatore;
//PutUnitInHex(6, 2, LibyaPescatore);

//LibyaSibille = new LCU();
//LibyaSibille.designation = "Libyan Sibille Division";
//LibyaSibille.side = Bloc.Axis;
//LibyaSibille.nationality = Nation.Libya;
//LibyaSibille.size = Formation.Division;
//LibyaSibille.combat = 1;
//LibyaSibille.movement = 3;
//LibyaSibille.picture = sLibSibille;
//PutUnitInHex(8, 2, LibyaSibille);

//ItalyGennaio = new LCU();
//ItalyGennaio.designation = "Italian Gennaio Division";
//ItalyGennaio.side = Bloc.Axis;
//ItalyGennaio.size = Formation.Division;
//ItalyGennaio.combat = 1;
//ItalyGennaio.picture = sItalyGennaio96pxV2;
//PutUnitInHex(7, 4, ItalyGennaio);

//ItalyGuardiaBardia = new LCU();
//ItalyGuardiaBardia.designation = "Guardia Frontera Bardia";
//ItalyGuardiaBardia.side = Bloc.Axis;
//ItalyGuardiaBardia.size = Formation.Division;
//ItalyGuardiaBardia.combat = 1;
//ItalyGuardiaBardia.picture = sItalyGuardiaBardia;
//PutUnitInHex(7, 5, ItalyGuardiaBardia);

//ItalyGuardia = new LCU();
//ItalyGuardia.designation = "Guardia Frontera";
//ItalyGuardia.side = Bloc.Axis;
//ItalyGuardia.size = Formation.Division;
//ItalyGuardia.combat = 1;
//ItalyGuardia.picture = sItalyGuardia;
//PutUnitInHex(5, 0, ItalyGuardia);


ds_list_add(enemiesOnMap,Italy23Inf);  // Eventually: switch 'enemies' depending on Player side
//ds_list_add(enemiesOnMap,Italy21Inf);
//ds_list_add(enemiesOnMap,Italy22Inf);
//ds_list_add(enemiesOnMap,Italy23Inf);
//ds_list_add(enemiesOnMap,LibyaPescatore);
//ds_list_add(enemiesOnMap,LibyaSibille);
//ds_list_add(enemiesOnMap,ItalyGennaio);
//ds_list_add(enemiesOnMap,ItalyGuardia);
//ds_list_add(enemiesOnMap,ItalyGuardiaBardia);

#endregion

#region Weight locations



#endregion


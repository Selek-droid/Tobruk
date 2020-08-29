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
displayUnits = true;

var emptyHex;   // initialize map; add VP values & AI weights
for (var col = 0; col < 27; col += 1;)
{
	for (var row = 0; row < 15; row += 1;)
	{
		emptyHex = new Hex(col,row);
		map[col][row] = emptyHex;
		if col <= 13	{ map[col][row].ownedBy = Bloc.Axis; }
		else { map[col][row].ownedBy = Bloc.Allied;}
	}
}

	map[1][0].description = "Gazala";
	map[1][0].strategicValue = 15;
	map[1][0].road = true;
	map[1][0].roadExit = RoadExit.SE
	
	map[1][2].description = "Alem Hamza";
	map[1][2].strategicValue = 10;
	
	map[2][1].description = "Road from Gazala to Tobruk";
	map[2][1].strategicValue = 10;
	map[2][1].road = true;
	
	map[3][1].description = "Road west of Tobruk";
	map[3][1].strategicValue = 15;
	map[3][1].road = true;
	
	map[4][1].description = "Road immediately west of Tobruk";
	map[4][1].strategicValue = 100;
	map[4][1].road = true;
	
	map[5][1].description = "Tobruk";
	map[5][1].strategicValue = 300;
	map[5][1].road = true;
	
	map[5][2].description = "Road south of Tobruk";
	map[5][2].strategicValue = 100;
	map[5][2].road = true;
	
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
Brit7Arm8Hus.size = Formation.Regiment;
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

Brit7RTR = new LCU();
Brit7RTR.designation = "British 7th Royal Tank Regiment";
Brit7RTR.side = Bloc.Allied;
Brit7RTR.branch = Type.Armor;
Brit7RTR.movement = 3;
Brit7RTR.combat = 6;
Brit7RTR.size = Formation.Regiment;
Brit7RTR.picture = sBr7RTR;
PutUnitInHex(17, 10, Brit7RTR);

Brit2RTR = new LCU();
Brit2RTR.designation = "British 2nd Royal Tank Regiment";
Brit2RTR.side = Bloc.Allied;
Brit2RTR.branch = Type.Armor;
Brit2RTR.movement = 7;
Brit2RTR.combat = 3;
Brit2RTR.size = Formation.Regiment;
Brit2RTR.picture = sBr2RTR;
PutUnitInHex(17, 11, Brit2RTR);

Brit1RTR = new LCU();
Brit1RTR.designation = "British 1st Royal Tank Regiment";
Brit1RTR.side = Bloc.Allied;
Brit1RTR.branch = Type.Armor;
Brit1RTR.movement = 8;
Brit1RTR.combat = 2;
Brit1RTR.size = Formation.Regiment;
Brit1RTR.picture = sBr1RTR;
PutUnitInHex(18, 10, Brit1RTR);

Brit11Hus = new LCU();
Brit11Hus.designation = "British 11th Hussars";
Brit11Hus.side = Bloc.Allied;
Brit11Hus.branch = Type.Armor;
Brit11Hus.movement = 6;
Brit11Hus.combat = 2;
Brit11Hus.size = Formation.Batallion;
Brit11Hus.picture = sBr11Hus;
PutUnitInHex(20, 10, Brit11Hus);

Ind5Bde = new LCU();
Ind5Bde.designation = "Indian 5th Infantry Brigade";
Ind5Bde.side = Bloc.Allied;
Ind5Bde.branch = Type.Infantry;
Ind5Bde.movement = 3;
Ind5Bde.combat = 6;
Ind5Bde.size = Formation.Batallion;
Ind5Bde.picture = sInd5Bde;
PutUnitInHex(19, 8, Ind5Bde);

Ind11Bde = new LCU();
Ind11Bde.designation = "Indian 5th Infantry Brigade";
Ind11Bde.side = Bloc.Allied;
Ind11Bde.branch = Type.Infantry;
Ind11Bde.movement = 3;
Ind11Bde.combat = 6;
Ind11Bde.size = Formation.Batallion;
Ind11Bde.picture = sInd11Bde;
PutUnitInHex(20, 8, Ind5Bde);

Ind7Bde = new LCU();
Ind7Bde.designation = "Indian 5th Infantry Brigade";
Ind7Bde.side = Bloc.Allied;
Ind7Bde.branch = Type.Infantry;
Ind7Bde.movement = 3;
Ind7Bde.combat = 6;
Ind7Bde.size = Formation.Batallion;
Ind7Bde.picture = sInd7Bde;
PutUnitInHex(22, 6, Ind7Bde);

Aus16Bde = new LCU();
Aus16Bde.designation = "Australian 16th Infantry Brigade";
Aus16Bde.side = Bloc.Allied;
Aus16Bde.branch = Type.Infantry;
Aus16Bde.movement = 3;
Aus16Bde.combat = 6;
Aus16Bde.size = Formation.Brigade;
Aus16Bde.picture = sAus16Bde;
PutUnitInHex(22, 7, Aus16Bde);

Aus17Bde = new LCU();
Aus17Bde.designation = "Australian 17th Infantry Brigade";
Aus17Bde.side = Bloc.Allied;
Aus17Bde.branch = Type.Infantry;
Aus17Bde.movement = 3;
Aus17Bde.combat = 6;
Aus17Bde.size = Formation.Brigade;
Aus17Bde.picture = sAus17Bde;
PutUnitInHex(23, 7, Aus17Bde);

Aus19Bde = new LCU();
Aus19Bde.designation = "Australian 19th Infantry Brigade";
Aus19Bde.side = Bloc.Allied;
Aus19Bde.branch = Type.Infantry;
Aus19Bde.movement = 3;
Aus19Bde.combat = 6;
Aus19Bde.size = Formation.Brigade;
Aus19Bde.picture = sAus19Bde;
PutUnitInHex(24, 7, Aus19Bde);

OConnor = new LCU();
OConnor.designation = "O'Connor (Western Desert Corps HQ)";
OConnor.side = Bloc.Allied;
OConnor.branch = Type.HQ;
OConnor.movement = 4;
OConnor.combat = 0;
OConnor.size = Formation.Brigade;
OConnor.picture = sOConnor;
PutUnitInHex(19, 9, OConnor);

Creagh = new LCU();
Creagh.designation = "Creagh (7th Armoured Div HQ)";
Creagh.side = Bloc.Allied;
Creagh.branch = Type.HQ;
Creagh.movement = 5;
Creagh.combat = 0;
Creagh.size = Formation.Brigade;
Creagh.picture = sCreagh;
PutUnitInHex(19, 11, Creagh);

BPeirse = new LCU();
BPeirse.designation = "Beresford-Peirse (4th Indian Div HQ)";
BPeirse.side = Bloc.Allied;
BPeirse.branch = Type.HQ;
BPeirse.movement = 3;
BPeirse.combat = 0;
BPeirse.size = Formation.Brigade;
BPeirse.picture = sHQBPeirse;
PutUnitInHex(20, 9, BPeirse);

Mackay = new LCU();
Mackay.designation = "Mackay (6th Australian Div HQ)";
Mackay.side = Bloc.Allied;
Mackay.branch = Type.HQ;
Mackay.movement = 3;
Mackay.combat = 0;
Mackay.size = Formation.Brigade;
Mackay.picture = sMackay;
PutUnitInHex(23, 8, Mackay);




Italy23Inf = new LCU();
Italy23Inf.designation = "Italian 23rd Infantry Division";
Italy23Inf.side = Bloc.Axis;
Italy23Inf.combat = 8;
Italy23Inf.movement = 3;
Italy23Inf.nationality = Nation.Italy;
Italy23Inf.picture = sIt23InfDiv; 
PutUnitInHex(13, 4, Italy23Inf);

Italy28Oct = new LCU();
Italy28Oct.designation = "Italian Blackshirt (Oct. 28) Division";
Italy28Oct.combat = 6;
Italy28Oct.movement = 3;
Italy28Oct.side = Bloc.Axis;
Italy28Oct.nationality = Nation.Italy;
Italy28Oct.picture = sIt28Oct; 
PutUnitInHex(14, 6, Italy28Oct);

ItalyCatanzaro = new LCU();
ItalyCatanzaro.designation = "Italian Catanzaro Division";
ItalyCatanzaro.combat = 8;
ItalyCatanzaro.movement = 3;
ItalyCatanzaro.side = Bloc.Axis;
ItalyCatanzaro.nationality = Nation.Italy;
ItalyCatanzaro.picture = sItCataznaro; 
PutUnitInHex(17, 7, ItalyCatanzaro);

ItalyJan3 = new LCU();
ItalyJan3.designation = "Italian Blackshirt (Jan. 3) Division";
ItalyJan3.combat = 7;
ItalyJan3.movement = 3;
ItalyJan3.side = Bloc.Axis;
ItalyJan3.nationality = Nation.Italy;
ItalyJan3.picture = sItJan3; 
PutUnitInHex(20, 6, ItalyJan3);



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


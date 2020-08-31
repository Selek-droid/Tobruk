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
waitForAI = false;
impulse = 0;
combatMessage = "Awaiting orders";
combatOdds = "No combat to report";
firstImpulse = false;
longestOrder = 0;
// parentHex = 0;
parentHex = new HexContainer();

addedHex = new Hex(0, 0);  // not needed?
addedHex.playerBuff = 0;   // not needed?

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
		if ValidLocation(col, row)
		{
			if col <= 16	{ map[col][row].ownedBy = Bloc.Axis; }
			else { map[col][row].ownedBy = Bloc.Allied;}
		}
		else map[col][row].ownedBy = Bloc.Neutral;
		
	}
}

	map[1][0].description = "Gazala";
	map[1][0].strategicValue = 15;
	map[1][0].road = true;
	map[1][0].roadExit = RoadExit.SE
	map[1][0].town = true;
	
	map[1][1].description = "Road from Tobruk to Gazala";
	map[1][1].strategicValue = 15;
	map[1][1].road = true;
	
	map[1][2].description = "Alem Hamza";
	map[1][2].strategicValue = 30;
	map[1][2].town = true;
	
	map[2][1].description = "Road from Gazala to Tobruk";
	map[2][1].strategicValue = 10;
	map[2][1].road = true;
	
	map[2][6].description = "Bir Hasheim";
	map[2][6].strategicValue = 40;
	map[2][6].town = true;
	
	map[6][7].description = "Bir el-Ghubi";
	map[6][7].strategicValue = 60;
	map[6][7].town = true;
	
	map[7][12].description = "El Cuasc";
	map[7][12].strategicValue = 10;
	map[7][12].town = true;
	
	map[12][10].description = "Gasr al Abid";
	map[12][10].strategicValue = 30;
	map[12][10].town = true;
	
	map[14][13].description = "Fort Maddalena";
	map[14][13].strategicValue = 0;
	map[14][13].town = true;
	
	map[19][13].description = "Bir Khamsa";
	map[19][13].strategicValue = 0;
	map[19][13].town = true;
	
	map[9][8].description = "Gabr Saleh";
	map[9][8].strategicValue = 50;
	map[9][8].town = true;
	
	map[3][1].description = "Road west of Tobruk";
	map[3][1].strategicValue = 20;
	map[3][1].road = true;
	
	map[4][1].description = "Road immediately west of Tobruk";
	map[4][1].strategicValue = 100;
	map[4][1].road = true;
	
	map[5][1].description = "Tobruk";
	map[5][1].strategicValue = 200;
	map[5][1].road = true;
	map[5][1].town = true;
	map[5][1].victoryPoints = 100;
	
	map[5][2].description = "Road just south of Tobruk";
	map[5][2].strategicValue = 100;
	map[5][2].road = true;
	
	map[5][3].description = "El Adam";
	map[5][3].strategicValue = 50;
	map[5][3].road = true;
	map[5][3].town = true;
	
	map[4][5].description = "Desert near El Adam";
	map[4][5].strategicValue = 0;
	map[4][5].road = true;
	
	map[4][4].description = "Desert near El Adam";
	map[4][4].strategicValue = 0;
	map[4][4].road = true;
	
	map[4][3].description = "Road from Tobruk to El Adam";
	map[4][3].strategicValue = 40;
	map[4][3].road = true;
	
	map[6][3].description = "Road from Tobruk to Bardia";
	map[6][3].strategicValue = 40;
	map[6][3].road = true;
	
	map[7][3].description = "Road from Tobruk to Bardia";
	map[7][3].strategicValue = 30;
	map[7][3].road = true;
	
	map[8][3].description = "Road from Tobruk to Bardia";
	map[8][3].strategicValue = 20;
	map[8][3].road = true;
	
	map[9][3].description = "Gambut";
	map[9][3].strategicValue = 60;
	map[9][3].road = true;
	map[9][3].town = true;
	
	map[10][3].description = "Road from Tobruk to Bardia";
	map[10][3].strategicValue = 30;
	map[10][3].road = true;
	
	map[11][3].description = "Road from Tobruk to Bardia";
	map[11][3].strategicValue = 30;
	map[11][3].road = true;
	
	map[12][3].description = "Road from Tobruk to Bardia";
	map[12][3].strategicValue = 30;
	map[12][3].road = true;
	
	map[13][4].description = "Bardia";
	map[13][4].strategicValue = 100;
	map[13][4].road = true;
	map[13][4].town = true;
	map[13][4].victoryPoints = 60;
	
	map[13][5].description = "Road south of Bardia";
	map[13][5].strategicValue = 50;
	map[13][5].road = true;
	
	map[12][5].description = "Road south of Bardia";
	map[12][5].strategicValue = 40;
	map[12][5].road = true;
	
	map[13][6].description = "Capuzzo";
	map[13][6].strategicValue = 60;
	map[13][6].road = true;
	map[13][6].town = true;
	map[13][6].ownedBy = Bloc.Axis;
	
	map[14][6].description = "Sollum";
	map[14][6].strategicValue = 60;
	map[14][6].road = true;
	map[14][6].town = true;
	map[14][6].ownedBy = Bloc.Axis;
	
	map[13][7].description = "Road from Sollum to Buq Buq";
	map[13][7].strategicValue = 30;
	map[13][7].road = true;
	
	map[14][7].description = "Road from Sollum to Buq Buq";
	map[14][7].strategicValue = 20;
	map[14][7].road = true;
	
	map[15][7].description = "Road from Sollum to Buq Buq";
	map[15][7].strategicValue = 20;
	map[15][7].road = true;
	
	map[16][7].description = "Road from Sollum to Buq Buq";
	map[16][7].strategicValue = 20;
	map[16][7].road = true;
	
	map[17][7].description = "Buq Buq";
	map[17][7].strategicValue = 40;
	map[17][7].road = true;
	map[17][7].town = true;
	map[17][7].ownedBy = Bloc.Axis;
	
	map[18][7].description = "Road from Buq Buq to Sidi Barrani";
	map[18][7].strategicValue = 20;
	map[18][7].road = true;
	map[18][7].ownedBy = Bloc.Axis;
	
	map[19][6].description = "Road from Buq Buq to Sidi Barrani";
	map[19][6].strategicValue = 20;
	map[19][6].road = true;
	map[19][6].ownedBy = Bloc.Axis;
	
	map[20][6].description = "Sidi Barrani";
	map[20][6].strategicValue = 50;
	map[20][6].road = true;
	map[20][6].town = true;
	map[20][6].victoryPoints = 40;
	map[20][6].ownedBy = Bloc.Axis;
	
	map[21][6].description = "Road from Sidi Barrani east";
	map[21][6].strategicValue = 20;
	map[21][6].road = true;
	
	map[22][6].description = "Road from Sidi Barrani east";
	map[22][6].strategicValue = 0;
	map[22][6].road = true;
	
	map[22][7].description = "Road from Sidi Barrani east";
	map[22][7].strategicValue = 0;
	map[22][7].road = true;
	
	map[23][7].description = "Road from Sidi Barrani east";
	map[23][7].strategicValue = 0;
	map[23][7].road = true;
	
	map[24][7].description = "Road from Sidi Barrani east";
	map[24][7].strategicValue = 0;
	map[24][7].road = true;
	
	map[25][7].description = "Road from Sidi Barrani east";
	map[25][7].strategicValue = 0;
	map[25][7].road = true;
	
	map[20][7].description = "Road south from Sidi Barrani";
	map[20][7].strategicValue = 0;
	map[20][7].road = true;
	
	map[20][8].description = "Road south from Sidi Barrani";
	map[20][8].strategicValue = 0;
	map[20][8].road = true;
	
	map[19][8].description = "Desert south of Sidi Barrani";
	map[19][8].strategicValue = 0;
	
	map[19][9].description = "Bir Enba";
	map[19][9].strategicValue = 0;
	map[19][9].road = true;
	map[19][9].town = true;
	
	map[18][9].description = "Road south from Sidi Barrani";
	map[18][9].strategicValue = 0;
	map[18][9].road = true;
	
	map[19][10].description = "Road west of Bir Enba";
	map[19][10].strategicValue = 0;
	map[19][10].road = true;
	
	map[18][10].description = "Road west of Bir Enba";
	map[18][10].strategicValue = 0;
	map[18][10].road = true;
	
	map[17][10].description = "el Hamra";
	map[17][10].strategicValue = 0;
	map[17][10].road = true;
	map[17][10].town = true;
	
	map[16][9].description = "Road to el Hamra";
	map[16][9].strategicValue = 0;
	map[16][9].road = true;
	
	map[15][9].description = "Road to el Hamra";
	map[15][9].strategicValue = 5;
	map[15][9].road = true;
	
	map[15][8].description = "Road south of Sollum";
	map[15][8].strategicValue = 6;
	map[15][8].road = true;
	
	map[14][8].description = "Road south of Sollum";
	map[14][8].strategicValue = 6;
	map[14][8].road = true;
	
	
	
	

	
	
	
	
	
	
	
	

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

// ********************** ITALY ***********************************

Italy23Inf = new LCU();
Italy23Inf.designation = "Italian 23rd Infantry Division";
Italy23Inf.side = Bloc.Axis;
Italy23Inf.combat = 8;
Italy23Inf.movement = 3;
Italy23Inf.nationality = Nation.Italy;
Italy23Inf.picture = sIt23InfDiv; 
PutUnitInHex(13, 5, Italy23Inf);

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

ItalyMar23 = new LCU();
ItalyMar23.designation = "Italian Blackshirt (Mar. 23) Division";
ItalyMar23.combat = 7;
ItalyMar23.movement = 3;
ItalyMar23.side = Bloc.Axis;
ItalyMar23.nationality = Nation.Italy;
ItalyMar23.picture = sItMarch23; 
PutUnitInHex(14, 7, ItalyMar23);

Italy1stLib = new LCU();
Italy1stLib.designation = "1st Libyan Division";
Italy1stLib.combat = 7;
Italy1stLib.movement = 3;
Italy1stLib.side = Bloc.Axis;
Italy1stLib.nationality = Nation.Italy;
Italy1stLib.picture = sIt1stLib; 
PutUnitInHex(21, 6, Italy1stLib);

Italy2ndLib = new LCU();
Italy2ndLib.designation = "2nd Libyan Division";
Italy2ndLib.combat = 8;
Italy2ndLib.movement = 3;
Italy2ndLib.size = Formation.Division;
Italy2ndLib.side = Bloc.Axis;
Italy2ndLib.nationality = Nation.Italy;
Italy2ndLib.picture = sIt2ndLib; 
PutUnitInHex(20, 7, Italy2ndLib);

ItalyGuardiaBardia = new LCU();
ItalyGuardiaBardia.designation = "Guardia Frontera Bardia";
ItalyGuardiaBardia.side = Bloc.Axis;
ItalyGuardiaBardia.size = Formation.Batallion;
ItalyGuardiaBardia.combat = 2;
ItalyGuardiaBardia.movement = 2;
ItalyGuardiaBardia.picture = sItGuardiaBardia;
PutUnitInHex(13, 4, ItalyGuardiaBardia);

ItalyGuardia = new LCU();
ItalyGuardia.designation = "Guardia Frontera Tobruk";
ItalyGuardia.side = Bloc.Axis;
ItalyGuardia.size = Formation.Batallion;
ItalyGuardia.combat = 3;
ItalyGuardia.movement = 1;
ItalyGuardia.picture = sItGuardiaTobruk;
PutUnitInHex(5, 1, ItalyGuardia);

Italy3Med = new LCU();
Italy3Med.designation = "Italian 3rd Medium Tank Batallion";
Italy3Med.side = Bloc.Axis;
Italy3Med.size = Formation.Batallion;
Italy3Med.branch = Type.Armor
Italy3Med.combat = 3;
Italy3Med.movement = 5;
Italy3Med.picture = sItGuardiaTobruk;
PutUnitInHex(10, 3, Italy3Med);

Italy21Light = new LCU();
Italy21Light.designation = "Italian 21st Light Tank Batallion";
Italy21Light.side = Bloc.Axis;
Italy21Light.size = Formation.Batallion;
Italy21Light.branch = Type.Armor;
Italy21Light.combat = 1;
Italy21Light.movement = 5;
Italy21Light.picture = sIt21Light;
PutUnitInHex(8, 3, Italy21Light);

Italy60Light = new LCU();
Italy60Light.designation = "Italian 6oth Light Tank Batallion";
Italy60Light.side = Bloc.Axis;
Italy60Light.size = Formation.Batallion;
Italy60Light.branch = Type.Armor;
Italy60Light.combat = 1;
Italy60Light.movement = 5;
Italy60Light.picture = sIt60Light;
PutUnitInHex(9, 3, Italy60Light);

ItalyAresca = new LCU();
ItalyAresca.designation = "Italian Aresca HQ";
ItalyAresca.side = Bloc.Axis;
ItalyAresca.size = Formation.Batallion;
ItalyAresca.branch = Type.HQ;
ItalyAresca.combat = 0;
ItalyAresca.movement = 4;
ItalyAresca.picture = sItAresca;
PutUnitInHex(12, 3, ItalyAresca);

ItalyMaletti = new LCU();
ItalyMaletti.designation = "Italian Maletti HQ";
ItalyMaletti.side = Bloc.Axis;
ItalyMaletti.size = Formation.Batallion;
ItalyMaletti.branch = Type.HQ;
ItalyMaletti.combat = 0;
ItalyMaletti.movement = 4;
ItalyMaletti.picture = sItMaletti;
PutUnitInHex(5, 3, ItalyMaletti);

ItalyLibyaHQ = new LCU();
ItalyLibyaHQ.designation = "Italian Libya Corps HQ";
ItalyLibyaHQ.side = Bloc.Axis;
ItalyLibyaHQ.size = Formation.Corps;
ItalyLibyaHQ.branch = Type.HQ;
ItalyLibyaHQ.combat = 0;
ItalyLibyaHQ.movement = 4;
ItalyLibyaHQ.picture = sItLibyaHQ;
PutUnitInHex(19, 6, ItalyLibyaHQ);


ds_list_add(enemiesOnMap,Italy23Inf);  // Eventually: switch 'enemies' depending on Player side
ds_list_add(enemiesOnMap,Italy28Oct);
ds_list_add(enemiesOnMap,ItalyCatanzaro);
ds_list_add(enemiesOnMap,ItalyJan3);
ds_list_add(enemiesOnMap,ItalyMar23);
ds_list_add(enemiesOnMap,Italy1stLib);
ds_list_add(enemiesOnMap,Italy2ndLib);
ds_list_add(enemiesOnMap,ItalyGuardia);
ds_list_add(enemiesOnMap,ItalyGuardiaBardia);
ds_list_add(enemiesOnMap,Italy3Med);
ds_list_add(enemiesOnMap,Italy21Light);
ds_list_add(enemiesOnMap,Italy60Light);
ds_list_add(enemiesOnMap,ItalyAresca);
ds_list_add(enemiesOnMap,ItalyMaletti);
ds_list_add(enemiesOnMap,ItalyLibyaHQ);

#endregion

#region Weight locations



#endregion


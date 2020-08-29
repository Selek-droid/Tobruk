// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function Constants(){
	
	// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function Constants(){
	
	#macro HEXWIDTH 42.5 * sqrt(3)
	#macro HEXHEIGHT 85 //               was 154
	#macro HEXRADIUS 42.5 ///              was 77 
	#macro MAPTOPEDGE 120
	
	enum Formation
	{
		Army = 1,
		Corps = 2,
		Division = 3,
		Regiment = 4,
		Batallion = 5,
		Company = 6,
	}
	
	enum Type
	{
		Infantry = 1,
		Armor = 2,
		HQ = 3,
		Motorized = 4,
	}
	
	enum Bloc
	{
		Allied  = 1,
		Axis = 2,
	}
	
	enum Nation
	{
		Britain = 1,
		India = 2,
		Australia = 3,
		Italy = 4,
		Libya = 5,
		Egypt = 6,
	}

	enum Terrain
	{
		Clear = 1,
		Desert = 2,
		Mountain = 3,
		Ocean = 4,
		Lake = 5,
		Forest = 6,
		Swamp = 7,
	}
	
	enum RoadExit
	{
		NE = 1,
		East = 2,
		SE = 3,
		SW = 4,
		West = 5,
		NW = 6,
		NoRoad = 7,
	}
	
	enum Urban	
	{
		City = 1,
		Town = 2,
		Village = 3,
		NotUrban = 4,
	}
	
	enum Outcome
	{
		Loss = 0,
		Win = 1,
		DefenderRetreat = 2,
	}
	
	enum AIState
	{
		FindingThreats = 0,
		GeneratingMoves = 1,
	}
	
}

}
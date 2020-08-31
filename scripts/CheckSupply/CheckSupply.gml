// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function CheckSupply()
{
	oMap.map[15][7].supplyPenalty = 1;
	oMap.map[16][7].supplyPenalty = 1;
	oMap.map[17][7].supplyPenalty = 1;
	oMap.map[18][7].supplyPenalty = 1;
	oMap.map[19][7].supplyPenalty = 1;
	oMap.map[19][6].supplyPenalty = 1;
	oMap.map[20][7].supplyPenalty = 1;
	oMap.map[20][6].supplyPenalty = 1;
	oMap.map[21][6].supplyPenalty = 1;
	oMap.map[21][7].supplyPenalty = 1;
	oMap.map[22][6].supplyPenalty = 1;
	oMap.map[22][7].supplyPenalty = 1;
	
	oMap.map[10][3].supplyPenalty = 1;
	oMap.map[11][3].supplyPenalty = 1;
	oMap.map[12][3].supplyPenalty = 1;
	oMap.map[11][4].supplyPenalty = 1;
	oMap.map[12][4].supplyPenalty = 1;
	oMap.map[13][4].supplyPenalty = 1;
	
	oMap.map[1][1].supplyPenalty = 1;
	oMap.map[2][1].supplyPenalty = 1;
	oMap.map[3][1].supplyPenalty = 1;
	oMap.map[4][1].supplyPenalty = 1;
	oMap.map[5][1].supplyPenalty = 1;
	
	
	if oMap.map[14][7].ownedBy == Bloc.Allied
	{
	
		oMap.map[15][7].supplyPenalty = 1.5;
		oMap.map[16][7].supplyPenalty = 1.5;
		oMap.map[17][7].supplyPenalty = 1.5;
		oMap.map[18][7].supplyPenalty = 1.5;
		oMap.map[19][7].supplyPenalty = 1.5;
		oMap.map[20][7].supplyPenalty = 1.5;
		oMap.map[20][6].supplyPenalty = 1.5;
		oMap.map[21][6].supplyPenalty = 1.5;
		oMap.map[21][7].supplyPenalty = 1.5;
		oMap.map[22][6].supplyPenalty = 1.5;
		oMap.map[22][7].supplyPenalty = 1.5;
		oMap.map[19][6].supplyPenalty = 1.5;
	}
	
	if oMap.map[15][7].ownedBy == Bloc.Allied
	{
	
		oMap.map[16][7].supplyPenalty = 2;
		oMap.map[17][7].supplyPenalty = 2;
		oMap.map[18][7].supplyPenalty = 2;
		oMap.map[19][7].supplyPenalty = 2;
		oMap.map[20][7].supplyPenalty = 1.5;
		oMap.map[20][6].supplyPenalty = 1.5;
		oMap.map[21][6].supplyPenalty = 1.5;
		oMap.map[21][7].supplyPenalty = 1.5;
		oMap.map[22][6].supplyPenalty = 1.5;
		oMap.map[22][7].supplyPenalty = 1.5;
		oMap.map[19][6].supplyPenalty = 1.5;
	}
		
	if oMap.map[16][7].ownedBy == Bloc.Allied
	{
		
		oMap.map[17][7].supplyPenalty = 2;
		oMap.map[18][7].supplyPenalty = 2;
		oMap.map[19][7].supplyPenalty = 2;
		oMap.map[20][7].supplyPenalty = 2;
		oMap.map[20][6].supplyPenalty = 2;
		oMap.map[21][6].supplyPenalty = 2;
		oMap.map[21][7].supplyPenalty = 2;
		oMap.map[22][6].supplyPenalty = 2;
		oMap.map[22][7].supplyPenalty = 2;
		oMap.map[19][6].supplyPenalty = 2;
	}
	
		
	if oMap.map[17][7].ownedBy == Bloc.Allied
	{
		
		oMap.map[18][7].supplyPenalty = 2;
		oMap.map[19][7].supplyPenalty = 2;
		oMap.map[20][7].supplyPenalty = 2;
		oMap.map[20][6].supplyPenalty = 2;
		oMap.map[21][6].supplyPenalty = 2;
		oMap.map[21][7].supplyPenalty = 2;
		oMap.map[22][6].supplyPenalty = 2;
		oMap.map[22][7].supplyPenalty = 2;
		oMap.map[19][6].supplyPenalty = 2;
	}
		
	if oMap.map[18][7].ownedBy == Bloc.Allied
	{
		oMap.map[19][7].supplyPenalty = 1.5;
		oMap.map[20][7].supplyPenalty = 2;
		oMap.map[20][6].supplyPenalty = 2;
		oMap.map[21][6].supplyPenalty = 2;
		oMap.map[21][7].supplyPenalty = 2;
		oMap.map[22][6].supplyPenalty = 2;
		oMap.map[22][7].supplyPenalty = 2;
		oMap.map[19][6].supplyPenalty = 2;
	}
	
		
	if oMap.map[19][6].ownedBy == Bloc.Allied
	{
			
		oMap.map[20][7].supplyPenalty = 1.5;
		oMap.map[20][6].supplyPenalty = 2;
		oMap.map[21][6].supplyPenalty = 2;
		oMap.map[21][7].supplyPenalty = 2;
		oMap.map[22][6].supplyPenalty = 2;
		oMap.map[22][7].supplyPenalty = 2;
	}
	
		
	if oMap.map[20][6].ownedBy == Bloc.Allied  // Sidi Barrani
	{
			
		oMap.map[20][7].supplyPenalty = 2;
		oMap.map[21][6].supplyPenalty = 2;
		oMap.map[21][7].supplyPenalty = 2;
		oMap.map[22][6].supplyPenalty = 2;
		oMap.map[22][7].supplyPenalty = 2;
	}
	
		
	if oMap.map[9][3].ownedBy == Bloc.Allied
	{
			
		oMap.map[10][3].supplyPenalty = 1.5;
		oMap.map[11][3].supplyPenalty = 1.5;
		oMap.map[12][3].supplyPenalty = 1.5;
		oMap.map[11][4].supplyPenalty = 1.5;
		oMap.map[12][4].supplyPenalty = 1.5;
		oMap.map[13][4].supplyPenalty = 1.5;
	}
		
	if oMap.map[10][3].ownedBy == Bloc.Allied
	{
		oMap.map[11][3].supplyPenalty = 1.5;
		oMap.map[12][3].supplyPenalty = 1.5;
		oMap.map[11][4].supplyPenalty = 1.5;
		oMap.map[12][4].supplyPenalty = 1.5;
		oMap.map[13][4].supplyPenalty = 1.5;
	}
		
	if oMap.map[11][3].ownedBy == Bloc.Allied
	{
		oMap.map[12][3].supplyPenalty = 1.5;
		oMap.map[11][4].supplyPenalty = 1.5;
		oMap.map[12][4].supplyPenalty = 1.5;
		oMap.map[13][4].supplyPenalty = 1.5;
	}
			
	if oMap.map[12][3].ownedBy == Bloc.Allied
	{
		oMap.map[11][4].supplyPenalty = 2;
		oMap.map[12][4].supplyPenalty = 2;
		oMap.map[13][4].supplyPenalty = 1.5;
	}

		
	if oMap.map[1][0].ownedBy == Bloc.Allied
	{
		oMap.map[1][1].supplyPenalty = 1.5;
		oMap.map[2][1].supplyPenalty = 1.5;
		oMap.map[3][1].supplyPenalty = 1.5;
		oMap.map[4][1].supplyPenalty = 1.5;
		oMap.map[5][1].supplyPenalty = 1.5;
	}
	
			
	if oMap.map[1][1].ownedBy == Bloc.Allied
	{
		oMap.map[2][1].supplyPenalty = 1.5;
		oMap.map[3][1].supplyPenalty = 1.5;
		oMap.map[4][1].supplyPenalty = 1.5;
		oMap.map[5][1].supplyPenalty = 1.5;
	}
			
	if oMap.map[2][1].ownedBy == Bloc.Allied
	{
		oMap.map[3][1].supplyPenalty = 1.5;
		oMap.map[4][1].supplyPenalty = 1.5;
		oMap.map[5][1].supplyPenalty = 1.5;
	}
				
	if oMap.map[3][1].ownedBy == Bloc.Allied
	{
		oMap.map[4][1].supplyPenalty = 2;
		oMap.map[5][1].supplyPenalty = 1.5;
	}
	
			
	if oMap.map[4][1].ownedBy == Bloc.Allied
	{
		oMap.map[5][1].supplyPenalty = 1.5;  // Tobruk
	}
}




////for (var col = 0; col < 26; col += 1;)
////{
////	for (var row = 0; row < 15; row += 1;)
////	{
////		if oMap.map[col][row].occupied
////		{
////			if oMap.map[col][row].occupant.side == Bloc.Axis
////			{
////				var neighbor = FindNeighbor(col,row,3);
				
////				if is_array(neighbor)
////				{
////					var neighborHex = oMap.map[neighbor[0]][neighbor[1]];
////					if ValidLocation(neighbor[0],neighbor[1])
////					{
////						if !neighborHex.occupied || neighborHex.occupant.side == Bloc.Axis
////						{
////							oMap.map[col][row].occupant.supplied = true;
////						}
						
////						else 
////						{
////							oMap.map[col][row].occupant.supplied = false;
////						}
////					}
////				}				
////			}
			
////			else if map[col][row].occupant.side == Bloc.Allied
////			{
////				neighbor = FindNeighbor(col,row,0);
////				if is_array(neighbor)
////				{
////					neighborHex = oMap.map[neighbor[0]][neighbor[1]];
////					if ValidLocation(neighbor[0],neighbor[1])
////					{
////						if !neighborHex.occupied || neighborHex.occupant.side == Bloc.Allied
////						{
////							oMap.map[col][row].occupant.supplied = true;
////						}
						
////						else 
////						{
////							oMap.map[col][row].occupant.supplied = false;
////						}
////					}
////				}				
////			}
////		}
////	}
////}
//}
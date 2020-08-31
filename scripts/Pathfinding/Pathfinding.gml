// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
// Pathfinding, starting with breadth-First search

function BreadthSearch(col, row, movement)
{
	ds_list_clear(oMap.highlightedHexes); // clear path
	var frontier = ds_list_create();  // far outer edge of search.
	var visited = ds_list_create();  // spots already visited.
    var currentHex;
	currentHex[0] = col;
	currentHex[1] = row;
	var startHex;
	startHex[0] = col;
	startHex[1] = row;
	
	ds_list_add(frontier,currentHex); 
	ds_list_add(visited,currentHex); 
	while (ds_list_size(frontier) > 0) // Loop until (1) reach edge or (2) exceed unit MP
	{
		currentHex = frontier[| 0]; // Get 1st frontier; on 1st loop this is start
		var xx = currentHex[0]; // on all later loops it will be one of later hexes added to frontier
		var yy = currentHex[1];
		for (i = 0; i < 6; i += 1;)
        { 
			var nextHex = FindNeighbor(xx, yy, i); 
			if HowFar(nextHex,startHex) > movement
			{
				// show_debug_message("Breadthsearch halted after mvmt over " + string(movement));
				ds_list_destroy(frontier); 
				ds_list_destroy(visited); 
				exit;
			}
            if ! IsInList(nextHex, visited, ds_list_size(visited))  // unvisited neighbor hex
			{
				if ValidLocation(nextHex[0], nextHex[1])
				{
					ds_list_add(frontier,nextHex); // Add neighbor to the frontier list
					ds_list_add(visited,nextHex); // Add the next position to the visited list
					if oGame.state == "Player Turn"
					{
		     //           oMap.spriteAlpha -= 0.01; // Decrease alpha of drawn hex highlight
		    //          	show_debug_message("Added to list of visited hexes: " + string(nextHex));
			//			show_debug_message("Alpha is " + string(oMap.spriteAlpha));
						var hexCoordX = nextHex[0];
						var hexCoordY = nextHex[1];
						var pixelCoords = HexToPixel(hexCoordX, hexCoordY);
						ds_list_add(oMap.highlightedHexes, pixelCoords);
						oMap.needPath = true;
					}
					else if oGame.state == "Opponent Turn"
					{
						if oMap.AIPosture == AIState.FindingThreats
						{
							ds_list_add(possibleThreats, nextHex);
							oMap.needPath = false;
						}
						else
						{
							ds_list_add(oMap.possibleMoves, nextHex);
							// show_debug_message("Next poss move: " + string(nextHex));
							oMap.needPath = false;
						}
					}
				}
			}
		}
		ds_list_delete(frontier, 0); 
		//if (oMap.spriteAlpha <= 0) 
		//{ 
		//	break;
		//}
	}
	ds_list_destroy(frontier); 
	ds_list_destroy(visited); 
}

function FindPath(startCoords, endCoords) // Puts hex coords array into unitOrders list;
										  // Puts pixel coodrs into HighlightedHexes
{
	ds_list_clear(oMap.highlightedHexes); // replace flood with path
	var frontier = ds_list_create();  // far outer edge of search.
	var visited = ds_list_create();  // spots already visited.
	// var path = ds_list_create();
	
	var linkedHexes = ds_map_create();  // *** holds keys from current to previous hex
	
    var currentHex;
	currentHex[0] = startCoords[0];
	currentHex[1] = startCoords[1];
	ds_list_add(frontier,currentHex); 
	ds_list_add(visited,currentHex); 
	while (ds_list_size(frontier) > 0) // As long as frontier list has something in it, we keep looping
	{
		currentHex = frontier[| 0]; // Get 1st frontier; on 1st loop this is start
		var xx = currentHex[0]; // on all later loops it will be one of later hexes added to frontier
		var yy = currentHex[1];
		for (i = 0; i < 6; i += 1;)
        { 
			var nextHex = FindNeighbor(xx, yy, i); 
            if ! IsInList(nextHex, visited, ds_list_size(visited))  // unvisited neighbor hex
			{
				if ValidLocation(nextHex[0], nextHex[1])
				{
					ds_list_add(frontier,nextHex); // Add neighbor to the frontier list
					ds_list_add(visited,nextHex); // Add the next position to the visited list
					ds_map_add(linkedHexes, nextHex, currentHex);  //  nextHex is key (points) to previous hex
					
	              // 	show_debug_message("Added to list of visited hexes: " + string(nextHex));
					
					if array_equals(nextHex, endCoords)  // found target
					{
						currentHex = nextHex;
						while ! (array_equals(currentHex, startCoords))
						{
							// ds_list_add(path,currentHex);
							var hexCoordX = currentHex[0];
							var hexCoordY = currentHex[1];
							ds_list_add(oMap.unitOrders, currentHex);
							var pixelCoords = HexToPixel(hexCoordX, hexCoordY);
							ds_list_add(oMap.highlightedHexes, pixelCoords);
							oMap.needPath = true;  // change to false during AI turn?
							currentHex = linkedHexes[? currentHex];
						}
			//			show_debug_message("Linked Hex map has entries: " + string(ds_map_size(linkedHexes)));
			//			show_debug_message(string(ds_map_values_to_array(linkedHexes)));
						//for (var i = 0; i < ds_map_size(linkedHexes); i++)
						//{
						//	show_debug_message("Entries: " + string(ds_map_)
						//}
					}
				}
			}
		}
		ds_list_delete(frontier, 0); 
	}
	ds_list_destroy(frontier); 
	ds_list_destroy(visited); 
	ds_map_destroy(linkedHexes);
}
	

function IsInList(hex, hexList, listSize)
{
	for (var i = 0; i < listSize; i += 1;) 
	{
		var listEntry = ds_list_find_value(hexList, i);
		if array_equals(hex, listEntry) return true;
	}
	return false;
}


function FindNeighbor(col, row, direction)
{
	var neighbor;
	var OddrDirections = 
	[
	    [[+1,  0], [ 0, -1], [-1, -1], 
	     [-1,  0], [-1, +1], [ 0, +1]],
	    [[+1,  0], [+1, -1], [ 0, -1], 
	     [-1,  0], [ 0, +1], [+1, +1]],
	];
	
    var parity = row & 1;
    var dir = OddrDirections[parity][direction];
    neighbor[1] = row + dir[1];
	neighbor[0] = col + dir[0];
	return neighbor;
}


function FindDirection(fromX, fromY, toX, toY)
{
	var destHex = [toX, toY];
	for (var i = 0; i < 6; i += 1;)
	{
		var neighbor = FindNeighbor(fromX, fromY, i);
		if array_equals(destHex, neighbor)
		{
			return i;
		}
	}
}


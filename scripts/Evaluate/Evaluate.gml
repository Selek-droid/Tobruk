// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
/// @desc Evaluate strategic position. Mostly unused as of now.
// 
function Evaluate()
{
	//var alliedVPs = 0;  // make local?
	//var alliedStrategicPosition = 0;
	//var axisVPs = 0;
	//var axisStrategicPosition = 0;
	
	for (var col = 0; col < 14; col += 1;)
	{
		for (var row = 0; row < 7; row += 1;)
		{
			if oMap.map[col][row].ownedBy == Bloc.Allied
			{
				oMap.alliedVPs += oMap.map[col][row].victoryPoints;
				oMap.alliedStrategicPosition += oMap.map[col][row].strategicValue;
			}
			else 
			{
				oMap.axisVPs += oMap.map[col][row].victoryPoints;
				oMap.axisStrategicPosition += oMap.map[col][row].strategicValue;
			}
		}
	}
	//show_debug_message("Allied VPs: " + string(oMap.alliedVPs));
	//show_debug_message("Axis VPs: " + string(oMap.axisVPs));
	//show_debug_message("Allied Strategic Position: " + string(oMap.alliedStrategicPosition));
	//show_debug_message("Axis strategic position: " + string(oMap.axisStrategicPosition));
	
}

function Garrison()
{
	// Tobruk.garrisoned = false;
	var Tobruk = oMap.map[6][1];
	if Tobruk.ownedBy == Bloc.Axis
	{
		if Tobruk.occupied || Tobruk.occupiedBy2
		{
			Tobruk.occupant.ordersSet = true;
			// Tobruk.garrisoned = true;
			if Tobruk.occupiedBy2 
			{
				Tobruk.occupant2.ordersSet = true;
				Tobruk.garrisoned = true;
				
				} // don't move garrison
			return;
		}
		else  // find closest; occupy with one. Will fill next turn.
		{
			Tobruk.garrisoned = false;
			var closestDistance = infinity;
			var numberOfUnits = ds_list_size(enemiesOnMap);
			var candidateIndex = 0;
			for (var i = 0; i < numberOfUnits; i += 1;)
			{
				var unit = ds_list_find_value(enemiesOnMap, i);
				var unitCoords = [unit.coordX, unit.coordY];
				if !(array_equals(unitCoords,[6,1]))  // make sure it's not already in Tobruk!
				{
					var unitDistance = HowFar(unitCoords,[6,1]);
					if unitDistance < closestDistance  
					{ 
						closestDistance = unitDistance;
						candidateIndex = i;
						// show_debug_message("Closest unit so far is " + unit.designation);
					}
				}
			}
			var orderedUnit = ds_list_find_value(enemiesOnMap, candidateIndex);
			// show_debug_message("Chosen garrison is " + orderedUnit.designation);
			FindPath([orderedUnit.coordX, orderedUnit.coordY], [6, 1]);
			var	pathLength = ds_list_size(unitOrders);
			if (pathLength > oMap.longestOrder)  { oMap.longestOrder = pathLength;}  // calc longest impulse
			for (var a = 0; a < pathLength; a += 1;)
			{
				orderedUnit.orders[a] = ds_list_find_value(unitOrders, a);
				orderedUnit.ordersSet = true;
				
			}
			// show_debug_message(orderedUnit.designation + " has orders: " + string(orderedUnit.orders));
			ds_list_clear(unitOrders);  // clear orders for next unit
			ds_list_add(whoHasOrders,orderedUnit);  // but keep this for WEGO unit-with-orders count
			if Tobruk.occupiedBy2 { Tobruk.garrisoned = true; }
		}
	}
}

function FindThreats()  // Populates list of actualThreats with hexes containing enemies.  
						// For now, covers only threats to Tobruk [6, 1].
{
	// Find vector from Tobruk to each enemy.  Then put a friendly on each vector, if possible.
	ds_list_clear(possibleThreats);
	ds_list_clear(actualThreats);
	
	BreadthSearch(13, 4, 11);   // populates list of coords (arrays) in ds_list possibleThreats
	var numberSearched = ds_list_size(possibleThreats);
	for (var i = 0; i < numberSearched; i += 1;)
	{
		var coords = ds_list_find_value(possibleThreats, i);  // coords is [x,y] array
		var hex = oMap.map[coords[0]][coords[1]];
		if (hex.occupied) && (hex.occupant.side == Bloc.Allied)  // change to "other side"
		{
			hex.combatStrength = hex.occupant.combat;
			if hex.occupiedBy2 {hex.combatStrength += hex.occupant2.combat;}
			hex.howFarAway = HowFar([6, 1],coords);  
			//show_debug_message("Allied threat at " + string(coords) + " contains " +
			//	string(hex.combatStrength) + " combat points & is this far: " + string(hex.howFarAway));
			ds_list_add(actualThreats,hex);  // compile list of enemy-occupied hexes within range
		}
	}
}

function InfluenceMap()  // now breadth-search radiating from enemies, to generate influence map
					// use list of actualThreats to compute tacticalValue in ALL surrounding hexes
{
	
	var numberOfThreats = ds_list_size(actualThreats); // find# of enemy (Allied) untis
	for (var a = 0; a < numberOfThreats; a += 1;)  // for each enemy allied unit 
	{
		ds_list_clear(possibleThreats);   // clear list of surrounding hexes
		movement = 0;
		var hex = ds_list_find_value(actualThreats, a);  // coords is [x,y] array == loc of Allied unit
		var coords = [hex.colX, hex.rowY];   // coords is allied unit's spot
		// show_debug_message("Tac value should be zero: " + string(hex.tacticalValue));
		// show_debug_message("Check combat val in this hex: " + string(hex.combatStrength));
		if hex.occupied && hex.ownedBy == Bloc.Allied  // change to 'other side'
		{
			var movement = hex.occupant.movement;
			var baseTacticalValue = 10 * hex.occupant.combat;
			hex.tacticalValue = baseTacticalValue;
			// show_debug_message("Added " + hex.description + " tac val of " + string(hex.tacticalValue));
			parentHex.add(hex);  // add to list of hexes to have .tacticalValue set to zero?
		}
		
		else if hex.occupiedBy2 && hex.ownedBy == Bloc.Allied
		{
			var movement = max(hex.occupant.movement, hex.occupant2.movement);
			baseTacticalValue = 10 * (hex.occupant.combat + hex.occupant2.combat);
			hex.tacticalValue = baseTacticalValue;
			parentHex.add(hex);
		}
		
		else movement = 3;
		
		BreadthSearch(coords[0],coords[1], movement ); // populate possibleThreats again. Search in circle.
		var numberSearched = ds_list_size(possibleThreats);  // # searched
		// show_debug_message("InfluenceMap searched " + string(numberSearched) + " hexes around " + string(coords));
		for (var b = 0; b < numberSearched; b += 1;)  // for each searched hex...
		{
			var nearbyCoords = ds_list_find_value(possibleThreats, b);  // nearbyCoords is [x,y] array; a searched hex
			var nearbyHex = oMap.map[nearbyCoords[0]][nearbyCoords[1]];  // the struct containing nearbyCOords
			var howFar = HowFar([ coords[0], coords[1] ] , [ nearbyCoords[0],nearbyCoords[1] ]); // dist from unit to searched hex
			// show_debug_message("HowFar is " + string(howFar));
			if howFar
			{
			nearbyHex.tacticalValue += baseTacticalValue * (1 / (2 * howFar));  // tacVal falls off
			parentHex.add(nearbyHex);
			// show_debug_message(string(nearbyCoords) + " incremented by " + string(nearbyHex.tacticalValue));
			}
		}
	}

}

//function Defend(coords)  // Creates influence map of nearby threats. Coords is hex we're defending.
//{
//	// assign higher tacticalValue to each hex between threat and hex(es) we're defending
//	// expect AI units to flow toward those higher-value hexes
//	// FindPath to each actualThreat, then assign higher values to each hex on path.
//	// Like making a move, only don't make a move -- just assign values.
	
//	// show_debug_message("Starting Defend function");
//	var numberOfThreats = ds_list_size(actualThreats);
//	// show_debug_message("Number of threats: " + string(numberOfThreats));
//	for (var a = 0; a < numberOfThreats; a += 1;)
//	{
//		var threat = ds_list_find_value(actualThreats, a);
//		var threatCoords = [threat.colX, threat.rowY];
//		FindPath(coords,threatCoords); // puts several hex-coord-arrays into unitOrders
//		var	pathLength = ds_list_size(unitOrders);  // count number of hexes in path from D to threat
//		// show_debug_message("distance to threat " + string(threat.description) + " is: " + string(pathLength));
//		for (var b = 0; b < pathLength ; b += 1;)  // increase tac value of each such hex - influence map
//		{
//			var influence = 10 * (pathLength - b);
//			var danger = ds_list_find_value(unitOrders, b); 
//			var hex = oMap.map[danger[0]][danger[1]];
//			hex.tacticalValue += influence * hex.combatStrength;
//			// show_debug_message(hex.description + " has tacVal of " + string(hex.tacticalValue));
//		}
//	}
//}



function ChooseMove(coords)
{
	// show_debug_message("Finding move from: " + string(coords));
	var currentHex = oMap.map[coords[0]][coords[1]];
	var numberOfMoves = ds_list_size(oMap.possibleMoves);
	var maxValue = -infinity;
	var bestMove = coords;  // in case find nothing better?
	for (var i = 0; i < numberOfMoves; i += 1;)
	{
		var proposedMove = ds_list_find_value(oMap.possibleMoves, i);
		
		// show_debug_message("ChooseMove finds this entry in poss moves: " + string(proposedMove));
		
		var targetHex = oMap.map[proposedMove[0]][proposedMove[1]];
		
		// var lengthOfMove = HowFar(coords,proposedMove);
		if targetHex.occupied && targetHex.occupant.side == Bloc.Allied 
			&& targetHex.occupant.combat == 0  && currentHex.occupant.combat > 0
		{
			bestMove = proposedMove;
			ds_list_clear(oMap.possibleMoves);
			return bestMove;
		}
		
		var valueOfStart = currentHex.strategicValue; // + currentHex.tacticalValue;
		var combatDifferential = 5 * (currentHex.combatStrength - targetHex.combatStrength);
		var valueOfEnd = floor ( combatDifferential +
			(targetHex.strategicValue ) ); // - (2 * lengthOfMove)));
			
		
		
		// show_debug_message("Value of " + currentHex.description + " is: " + string(valueOfEnd));
		// show_debug_message("Value of " + targetHex.description + " is: " + string(valueOfEnd));
		
		//if !targetHex.garrisoned 
		//{	
		if (valueOfEnd - valueOfStart) > maxValue
		{
			maxValue = valueOfEnd - valueOfStart;
			bestMove = proposedMove;
		}
		//}
	}
	ds_list_clear(oMap.possibleMoves);
	return bestMove;
}

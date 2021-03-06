/// @desc Manage player input; track game state.

#region Player Turn

if oGame.state == "Player Turn"
{
	if turn == 20 && (oGame.over == false)
	{
		DeclareVictory();
	}
	
	CheckSupply();
	
	//audio_play_sound(aEgyptPubDomain, 10, true);
	
	//if keyboard_check_pressed(ord("M") ) && musicOn
	//{
	//	audio_stop_sound(aEgyptPubDomain);
	//	keyboard_clear(ord("M"));
	//	musicOn = false;
	//}
	
	//else if keyboard_check_pressed(ord("M") ) && !musicOn
	//{
	//audio_play_sound(aEgyptPubDomain, 10, true);
	//musicOn = true;
	//}
	
	if mouse_check_button_pressed(mb_left) && (! hexAlreadySelected)
	{
		oUIBar.eventsMessage = "Once you finish ordering units, hit ENTER.";
		oUIBar.flavorMessage = "Then please give the AI a moment to think!";
		
		needPath = false;  // reset path highlighting after click
		ds_list_clear(highlightedHexes); 
		var coords;
		coords = PixelsToPointyHex(mouse_x, mouse_y);
		if coords[0] < 0 exit;

		var targetHex = map[coords[0]][coords[1]];
		if targetHex.occupied && (targetHex.occupant.side == global.PlayerSide)
		{
			mapCoordinates = coords;  // store location of starting hex. Again, improve var name?
			
			var mapX = mapCoordinates[0];
			var mapY = mapCoordinates[1];
			BreadthSearch(mapX, mapY, targetHex.occupant.movement);
			hexAlreadySelected = true;  // meaning starting (unit) hex already selected. Improve this var name?
			mouse_clear(mb_left);
			
		}
	}

	if (mouse_check_button_pressed(mb_left) && hexAlreadySelected)
	{
		var startCoords = mapCoordinates; // get start hex (in array format (row, col))
		var startX = startCoords[0];
		var startY = startCoords[1];
		var startHex = map[startX][startY]; // hex struct  at that location
		
		var endCoords;
		endCoords = PixelsToPointyHex(mouse_x, mouse_y); // get current hex
		
		if !startHex.occupied || (HowFar(startCoords, endCoords) > startHex.occupant.movement) 
			|| endCoords[0] < 0
		{
			hexAlreadySelected = false;
			mouse_clear(mb_left);
			needPath = false;
			exit;
		}
		
		if array_equals(startCoords, endCoords)  // if same, and if stack, flip
		{
			needPath = false;
			var endX = endCoords[0];
			var endY = endCoords[1];
			var endHex = map[endX][endY];
			if endHex.occupiedBy2
			{
				var tempOccupant = endHex.occupant;
				endHex.occupant = endHex.occupant2;
				endHex.occupant.topUnit = true;
				endHex.occupant2 = tempOccupant;
				endHex.occupant2.topUnit = false;
				BreadthSearch(startX, startY, endHex.occupant.movement);
				mouse_clear(mb_left);
				hexAlreadySelected = true; 
				needPath = true;
				exit;
			}
			else // lone unit clicked twice; deselect
			{
				needPath = false;
				hexAlreadySelected = false;   // So we have an origin hex still, but exit this
				mouse_clear(mb_left);
				exit;  // may need to deselect now and make user re-click to order this guy? Or: run new search.			
		
			}
		}
				
		FindPath(startCoords, endCoords);
		var pathLength = ds_list_size(highlightedHexes);  // now store path
		if (pathLength > longestOrder)  { longestOrder = pathLength;}  // calc longest impulse
		// minor issue: adjust longestOrder if remove longest order?
		
		if startHex.occupied // && ! startHex.occupiedBy2
		{
			if ! startHex.occupant.ordersSet // if already had orders, don't re-add to list of ordered units
			{
				ds_list_add(whoHasOrders,startHex.occupant);
				parentUnit.add(startHex.occupant);
			}
			startHex.occupant.orders = 0;
			startHex.occupant.ordersSet = true;
			for (var i = 0; i < pathLength; i += 1;)
			{
				var mapCoords = ds_list_find_value(unitOrders,i);
				startHex.occupant.orders[i] = mapCoords;
				// show_debug_message("Orders: " + string(startHex.occupant.orders[i] ));
			}
			
	//	else if startHex.occupied & startHex.occupiedBy2
		}
		ds_list_clear(unitOrders);  // orders stored in unit; clear path
		hexAlreadySelected = false;
	}
	
	if keyboard_check_pressed(vk_enter)  // END TURN!
	{
		show_debug_message("End Player Turn");

		waitForAI = true;
		// oMap.combatMessage = "Executing orders; PLEASE WAIT.";
		// show_debug_message("WaitForAI var is " + string(waitForAI));
		keyboard_clear(vk_enter);
		needPath = false;
		// oGame.state = "Wait Popup";
		parentHex.setAll("tacticalValue", 0);
		oGame.state = "Opponent Turn";
	}
}

#endregion 

//if oGame.state == "Wait Popup"
//{
//	waitForAI = true;
//	if keyboard_check_pressed(vk_space)
//	{
//		oGame.state = "Opponent Turn";
//	}
//}

if oGame.state == "Opponent Turn"
{
	show_debug_message("Starting AI Turn");
	
	// Evaluate(); // not doing much yet. For starters, defensive posture.
	// Garrison();
	AIPosture = AIState.FindingThreats;
	FindThreats();  // to Tobruk, for now
	InfluenceMap();
	// Defend([6, 1]);
	AIPosture = AIState.GeneratingMoves;
	
	var numberOfEnemies = ds_list_size(enemiesOnMap);
	for (var a = 0; a < numberOfEnemies; a += 1;)
	{
		var enemyUnit = ds_list_find_value(enemiesOnMap, a);
		if !enemyUnit.ordersSet
		{
			var startX = enemyUnit.coordX;
			var startY = enemyUnit.coordY;
			var coords = [startX, startY];
			// show_debug_message(enemyUnit.designation + "has mvmt of " + string(enemyUnit.movement));
			BreadthSearch(startX, startY, enemyUnit.movement);
		
			chosenMove = ChooseMove(coords);  // must return an array/ can this be a var?
			// show_debug_message(enemyUnit.designation + " has chosen: " + string(chosenMove));
			FindPath(coords, chosenMove);
			pathLength = ds_list_size(unitOrders);
			if (pathLength > longestOrder)  { longestOrder = pathLength;}  // calc longest impulse
			for (var i = 0; i < pathLength; i += 1;)
			{
				enemyUnit.orders[i] = ds_list_find_value(unitOrders,i);
			}
			// show_debug_message(enemyUnit.designation + " init orders: " + string(enemyUnit.orders));
			ds_list_clear(unitOrders);  // clear orders for next unit
			ds_list_add(whoHasOrders,enemyUnit);  // but keep this for WEGO unit-with-orders count
		}
	}
	
	ds_list_clear(possibleMoves);
	
	// oMap.combatMessage = "Press spacebar to proceed to next impulse.";
	waitForAI = false;
	firstImpulse = true;
	oGame.state = "WEGO";
	
}
 
 #region WEGO
 
if oGame.state == "WEGO"
{
	// loop thru units looking for orders? or thru map?
	// quicker to search for units. GIve them an index?
	// For now, will use list of units with orders, created in orders phase.
	// Moves are simultaneous!  We'll do per-hex for now?
	
	
	var numberWithOrders = ds_list_size(whoHasOrders);
	if ! numberWithOrders
	{
		waitForAI = false;
		impulse = 0;
		longestOrder = 0;
		ds_list_clear(whoHasOrders);
		needPath = false;
		firstImpulse = false;
		// show_debug_message("No orders; ending WEGO, starting new Player TUrn");
		oGame.state = "Player Turn";
	}
	// show_debug_message("# of units ordered: " + string(numberWithOrders));
	
	if firstImpulse
	{
		oMap.combatMessage = "To see the first event, press spacebar.";
	}
	
	if firstImpulse || keyboard_check_pressed(vk_space) // || keyboard_check_pressed(vk_right)
	{
		waitForAI = false;
		if (numberWithOrders > 0) && (impulse < 8)
		{
			
			for (var i = 0; i < numberWithOrders; i += 1;)	
			{
				var orderedUnit = ds_list_find_value(whoHasOrders, i);
				
				var moveLength = array_length(orderedUnit.orders); 
				// show_debug_message(orderedUnit.designation + " orders are " + string(orderedUnit.orders));
				
				if moveLength - impulse > 0
				{
					var nextHex = orderedUnit.orders[moveLength - 1 - impulse]; 
					// show_debug_message(orderedUnit.designation + " ordered to " + string(nextHex));
					if is_array(nextHex)  // in case no orders, I guess? Just do nothing?
					{
						var buffedHex = oMap.map[nextHex[0]][nextHex[1]];
						if orderedUnit.side == global.PlayerSide
						{
							buffedHex.playerBuff += 3; // combat buff
							addedHex = parentHex.add(buffedHex); 
						}
						else
						{
							buffedHex.opponentBuff += 3;
							addedHex = parentHex.add(buffedHex); 
						}
						MoveUnitToHex(orderedUnit.coordX,orderedUnit.coordY,
							nextHex[0],nextHex[1],orderedUnit);
					}
				}
			}
			impulse += 1;
			firstImpulse = false;
		
			
			oMap.combatMessage = "Press spacebar to see next impulse or combat.";
	
		}
	}
	
	if (impulse >= 8) || (impulse > longestOrder)
	{                     		// delete all orders; reset impulse to 0
		for (var i = 0; i < numberWithOrders; i += 1;)	
		{
			var orderedUnit = ds_list_find_value(whoHasOrders, i);
			orderedUnit.orders = 0;
		}
		impulse = 0;
		longestOrder = 0;
		ds_list_clear(whoHasOrders);
		needPath = false;
		parentHex.setAll("playerBuff", 0);
		parentHex.setAll("opponentBuff", 0);
		parentHex.setAll("garrisoned", false); 
		parentUnit.setAll("ordersSet", false);
		keyboard_clear(vk_enter);
		keyboard_clear(vk_space);
		show_debug_message("Ending WEGO, starting player turn");
		turn += 1;
		DisplayDate(turn);
		oMap.combatMessage = "Left click to order units. Press Enter to end your turn.";
		oGame.state = "Player Turn";
	}
}

#endregion 



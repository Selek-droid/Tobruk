// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information

function MoveUnitToHex(fromX, fromY, toX, toY, unit)
{
	var targetHex = oMap.map[toX][toY];
	var departedHex = oMap.map[fromX][fromY]; 
		
	if targetHex.occupiedBy2 && (targetHex.occupant.side == unit.side) // if full, don't move.
	{
		unit.orders = 0;
		//show_debug_message(unit.designation + " thinks target hex " + string(toX) + " , " 
		//	+ string(toY) + "is full, so stays in hex " + string(unit.coordX) + " , " + 
		//	string(unit.coordY));

		return false;
	}
	
	if !targetHex.occupied    // empty target; easy case.
	{
		var wasUnitOnTop = unit.topUnit;
		// show_debug_message("Departing unit " + unit.designation + " on top? " + string(unit.topUnit));
		targetHex.occupied = true;
		targetHex.occupiedBy2 = false;
		targetHex.occupant = unit;
		targetHex.ownedBy = unit.side;
		unit.coordX = toX;
		unit.coordY = toY;
		unit.topUnit = true;
		CleanDepartedHex(departedHex, wasUnitOnTop);
		
		return true;
	}
	
	if ( targetHex.occupied && (targetHex.occupant.side == unit.side) && !(targetHex.occupiedBy2) ) // only one friendly, OK
	{
		wasUnitOnTop = unit.topUnit;
		targetHex.occupiedBy2 = true;  
		targetHex.occupied = true;
		targetHex.occupant2 = targetHex.occupant;  // put pre-existing unit on bottom
		targetHex.occupant2.topUnit = false;
		targetHex.occupant = unit;  // put new unit on top
		unit.coordX = toX;
		unit.coordY = toY;
		unit.topUnit = true;
		CleanDepartedHex(departedHex, wasUnitOnTop);	
		return true;
	}
	
	if targetHex.occupant.side != unit.side  // combat. What if 2 enemies?
	{
		var outcome = Battle(unit, targetHex.occupant, fromX, fromY, toX, toY);
		switch outcome
		{
			case Outcome.Inconclusive:
			{
				if keyboard_check_pressed(vk_anykey) 
				{
					oMap.combatMessage = "Attack by " + unit.designation + " was inconclusive";
					oUIBar.flavorMessage = "at " + targetHex.description + ".";
					return false;
				}
				break;
			}
			
			case Outcome.DefenderStepLoss:
			{
				if targetHex.occupant.side == Bloc.Allied
					{
						oMap.axisVPs += targetHex.occupant.victoryValue;
					}
					else 
					{
						oMap.alliedVPs += targetHex.occupant.victoryValue;
					}
				if keyboard_check_pressed(vk_anykey) 
				{
					oUIBar.eventsMessage = (unit.designation + " hits " + targetHex.occupant.designation);
					oUIBar.flavorMessage = "at " + targetHex.description + ".";
				}
				
				targetHex.occupant.steps -= 1;
				
				if targetHex.occupant.steps > 0   // still alive, so exit
				{
					
					
					targetHex.occupant.combat = floor(targetHex.occupant.combat / 2);
					targetHex.occupant.orders = 0;
					
					return true;
				}
				
				if targetHex.occupiedBy2  // Top unit out of steps, so lower takes its place.
				{
					targetHex.occupant.onMap = false; // not using this variable yet
					targetHex.occupant = targetHex.occupant2; // shift lower enemy unit to top
					targetHex.occupant2 = 0;
					targetHex.occupiedBy2 = false;
					targetHex.occupied = true;
					return true;	
					break;
				}
			
				else   // Unit was alone, so eliminate. Permit advance?
				{
					wasUnitOnTop = unit.topUnit;
					targetHex.occupied = true;
					targetHex.occupant.onMap = false; // eliminate D
					targetHex.occupant = unit;  // occupy with A
					targetHex.ownedBy = unit.side;
					unit.coordX = toX;
					unit.coordY = toY;
					unit.topUnit = true;
					CleanDepartedHex(departedHex, wasUnitOnTop);
					return true;
					break;
				}
				break;
			}
			
			case Outcome.AttackerStepLoss:
			{
				unit.steps -= 1;
				
				if unit.side == Bloc.Allied
					{
						oMap.axisVPs += unit.victoryValue;
					}
					else 
					{
						oMap.alliedVPs += unit.victoryValue;
					}
				
				if unit.steps > 0   // still alive, so exit
				{
					unit.combat = floor(unit.combat / 2);
					unit.orders = 0;
					if keyboard_check_pressed(vk_space) 
					{
						oUIBar.eventsMessage = (unit.designation + " damaged by " + targetHex.occupant.designation );
						oUIBar.flavorMessage = "at " + targetHex.description + ".";
					}
					return false;
				}
				
				else  // unit destroyed
				{
					unit.orders = 0;
					unit.onMap = false;
					if keyboard_check_pressed(vk_space) 
					{
						oUIBar.eventsMessage = unit.designation + " destroyed while amking failed assault";
						oUIBar.flavorMessage = "at " + targetHex.description;
					}
					
					CleanDepartedHex(departedHex, true);
				}
				return false;
				break;
			}
		}
	}	
}

function CleanDepartedHex(departedHex, topUnit)
{
	if departedHex.occupiedBy2
	{
		//show_debug_message("Departing hex " + departedHex.description +
		//	" , which still has unit: " + departedHex.occupant2.designation);
		if topUnit  // then shift bottom occupant to top
		{
			// show_debug_message("Shifting " + departedHex.occupant2.designation + " to top");
			departedHex.occupiedBy2 = false;
			departedHex.occupied = true;
			departedHex.occupant = departedHex.occupant2;  
			departedHex.occupant.topUnit = true;
			departedHex.occupant2 = 0;
			return;
		}
		else  // leave existing top occupant alone
		{
			//show_debug_message("Leaving " + departedHex.occupant.designation + " on top");
			//show_debug_message("But this bottom unit should be erased from here: " + 
			//	departedHex.occupant2.designation);
			departedHex.occupiedBy2 = false;
			departedHex.occupied = true;
			departedHex.occupant.topUnit = true;
			departedHex.occupant2 = 0;
			return;
		}
	}
	
	else
	{
		// show_debug_message("Emptying departed hex " + departedHex.description);
		departedHex.occupiedBy2 = false;
		departedHex.occupied = false;   
		departedHex.occupant = 0;   
		return;
	}
}


function Battle(attacker, defender, attackerFromX, attackerFromY, battleX, battleY) // fromX is attacker's origin hex. battleX is battlehex.
{
	var attackPower = attacker.combat;
	var defensePower = defender.combat;
	var battleHex = oMap.map[battleX][battleY];
	
	if defender.combat == 0 && attacker.combat > 0 
	{
		return Outcome.DefenderStepLoss;
	}
	else if defender.combat == 0 
	{
		return Outcome.Inconclusive;
	}
	
	if attacker.side == global.PlayerSide
	{
		attackPower += battleHex.playerBuff;
		defensePower += battleHex.opponentBuff;
	}
	else
	{
		attackPower += battleHex.opponentBuff;
		defensePower += battleHex.playerBuff;
	}
		
	var odds = floor (10 * (attackPower / defensePower)); // so 10 is 1:1 odds; 20 is 2:1
	//	show_debug_message("Odds are " + string(odds/10) + " : 1");
	//oUIBar.combatMessage = attacker.designation + " attacks " + defender.designation + 
	//	" at modified odds of " + string(odds);
	
	if (attackPower < defensePower)
	{
		if odds < 10 && odds >= 6 
		{
			return Outcome.Inconclusive;
		}
		else if odds < 6 && odds >= 0
		{
			var d10Roll = irandom(10);
			// oMap.combatOdds = ( "Die roll: " + string(d10Roll));
			if d10Roll >= 9
			{
				attacker.orders = 0;
				defender.orders = 0;
				oUIBar.eventsMessage = attacker.designation + "takes a step loss after failed attack";
				oUIBar.flavorMessage = " at " + battleHex.description + ".";
				
			}
			else 
			{
				attacker.orders = 0;
				defender.orders = 0;
				oUIBar.eventsMessage = "Combat is inconclusive"
				oUIBar.flavorMessage = " at " + battleHex.description + ".";
				
				return Outcome.Inconclusive;
			}
		}
	}
	
	if (attackPower >= defensePower )
	{
		var dieRoll = irandom(100);
		// oMap.combatOdds = ("d100 roll: " + string(dieRoll));
		if dieRoll < ((2 * odds) - 10 )  // remember, odds is 10 times the odds, so 1:1 is 10, 3:1 is 30.
		{
			oUIBar.eventsMessage = (attacker.designation + " inflicts a hit on " + defender.designation);
			oUIBar.flavorMessage = " at " + battleHex.description + ".";
			defender.orders = 0;
			attacker.orders = 0;
			return Outcome.DefenderStepLoss;
		}
		else
		{
			attacker.orders = 0;
			defender.orders = 0;
			oUIBar.eventsMessage = (attacker.designation + " fails to damage " + defender.designation);
			oUIBar.flavorMessage = " at " + battleHex.description + ".";
			return Outcome.Inconclusive;
		}
	}
}



//function Retreat(retreater, attackerCameFromX, attackerCameFromY, battleX, battleY, wasAttacker)
//{
//	var dir = FindDirection(attackerCameFromX, attackerCameFromY, battleX, battleY);
//	var retreatCoords = FindNeighbor(battleX, battleY, dir);
//	var battleHex = oMap.map[battleX][battleY];
//	oMap.combatMessage = (retreater.designation + " testing retreat to: " + string(retreatCoords));
//	show_debug_message(retreater.designation + " testing retreat to: " + string(retreatCoords));
	
//	if ValidLocation(retreatCoords[0], retreatCoords[1]) &&
//		!EnemyControlled(retreatCoords, retreater.side) &&
//		!FriendlyHexFull(retreatCoords, retreater.side)
//	{
//		ShiftUnit(retreater, battleX, battleY, retreatCoords[0], retreatCoords[1], false);
//		if battleHex.occupied  // second unit remains, so no advance
//		{
//			return false;
//		}
//		else return true;
//	}
			
//	else
//	{
//		var dirAdjust = irandom(1) ;  // try left or right, randomly
//		if dirAdjust
//		{
//			var altDir = dir - dirAdjust;
//			if altDir < 0 {altDir = 5;} 
//			var alt2Dir = altDir + 2;
//			if alt2Dir == 6 {alt2Dir = 0;}
//			if alt2Dir == 7 {alt2Dir = 1;}
//		}
//		else 
//		{
//			altDir = dir + dirAdjust;
//			if altDir > 5 {altDir = 0;}
//			var alt2Dir = altDir - 2;
//			if alt2Dir == -1 {alt2Dir = 5;}
//			if alt2Dir == -2 {alt2Dir = 4;}
//		}
//		retreatCoords = FindNeighbor(battleX, battleY, altDir);
//		if ValidLocation(retreatCoords[0], retreatCoords[1]) &&
//			!EnemyControlled(retreatCoords, retreater.side) &&
//			!FriendlyHexFull(retreatCoords, retreater.side)
//		{
//			ShiftUnit(retreater, battleX, battleY, retreatCoords[0], retreatCoords[1], false);
//			if battleHex.occupied  // second unit remains, so no advance
//			{
//				return false;
//			}
//			else return true;
//		}
//		else retreatCoords = FindNeighbor(battleX, battleY, alt2Dir);
//		if ValidLocation(retreatCoords[0], retreatCoords[1]) &&
//			!EnemyControlled(retreatCoords, retreater.side) &&
//			!FriendlyHexFull(retreatCoords, retreater.side)
//		{
//			ShiftUnit(retreater, battleX, battleY, retreatCoords[0], retreatCoords[1], false);
//			if battleHex.occupied  // second unit remains, so no advance
//			{
//				return false;
//			}
//			else return true;
//		}
//	}
//}

function FindAlternateRetreat(battleX, battleY, altDir)
{
	var retreatCoords = FindNeighbor(battleX, battleY, altDir);
	if ValidLocation(retreatCoords[0], retreatCoords[1]) &&
		!EnemyControlled(retreatCoords, retreater.side) &&
		!FriendlyHexFull(retreatCoords, retreater.side)
	{
		return true;
	}
	else {return false;}
}


function FriendlyHexFull(coords, side)
{
	var targetHex = oMap.map[coords[0]][coords[1]];
	if targetHex.occupiedBy2
	{
		if targetHex.occupant.side == side 
		{
			return true;
		}
		// else return false;
	}
	else return false;
}

function EnemyControlled(coords, side)
{
	var targetHex = oMap.map[coords[0]][coords[1]];
	if targetHex.occupied
	{
		if targetHex.occupant.side != side 
		{
			return true;
		}
		else return false;
	}
	else return false;
}

function ShiftUnit(unit, departX, departY, arriveX, arriveY, wasTopUnit)  // but what if 2 retreaters?
{
	var departHex = oMap.map[departX][departY];
	var arriveHex = oMap.map[arriveX][arriveY];
	
	if !arriveHex.occupied    // empty target; easy case.
	{
		arriveHex.occupied = true;
		arriveHex.occupiedBy2 = false;
		arriveHex.occupant = unit;
		arriveHex.ownedBy = unit.side
		unit.coordX = arriveX;
		unit.coordY = arriveY;
		unit.topUnit = true;
		unit.orders = 0;
		CleanDepartedHex(departHex, wasTopUnit);
		return true;
	}
	
	else if ( arriveHex.occupied && (arriveHex.occupant.side == unit.side)
		&& !(arriveHex.occupiedBy2) ) // only one friendly, OK
	{
		arriveHex.occupiedBy2 = true;  
		arriveHex.occupied = true;
		arriveHex.occupant2 = arriveHex.occupant;  // put pre-existing unit on bottom
		arriveHex.occupant2.topUnit = false;
		arriveHex.occupant = unit;  // put new unit on top
		unit.coordX = arriveX;
		unit.coordY = arriveY;
		unit.topUnit = true;
		CleanDepartedHex(departHex, wasTopUnit);	
		return true;
	}
	
}
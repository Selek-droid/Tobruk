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
		show_debug_message(unit.designation + " thinks target hex " + string(toX) + " , " 
			+ string(toY) + "is full, so stays in hex " + string(unit.coordX) + " , " + 
			string(unit.coordY));

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
			case Outcome.Win:
			{
				oMap.combatMessage = (unit.designation + " defeats " + targetHex.occupant.designation +
				"at " + string(toX) + " , " + string(toY));
		 		
				if targetHex.occupiedBy2  // eliminate only top of stack, no advance
				{
					show_debug_message("No advance because enemy hex still has 1 unit");
					targetHex.occupant.onMap = false; // not using this variable yet
					targetHex.occupant = targetHex.occupant2; // shift lower enemy unit to top
					targetHex.occupant2 = 0;
					targetHex.occupiedBy2 = false;
					targetHex.occupied = true;
					return true;	
					break;
				}
			
				else 
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
			}
			
			case Outcome.DefenderRetreat:
			{
				oMap.combatMessage = (unit.designation + " possibly advanced into " +
					string(toX) + " , " + string(toY) + "after forcing retreat by " +
					targetHex.occupant.designation);
				show_debug_message(unit.designation + " possibly advanced into " +
					string(toX) + " , " + string(toY) + "after forcing retreat by " +
					targetHex.occupant.designation);
				return true;  // Retreat function already did any advance
				break;
			
			}
			
			case Outcome.Loss:
			{
				unit.orders = 0;
				oMap.combatMessage = ("Failed attack by " + unit.designation);
				show_debug_message("Failed attack by " + unit.designation);
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
	//if battleHex.playerBuff {show_debug_message("Player buffed by " + string(battleHex.playerBuff));}
	//if battleHex.opponentBuff {show_debug_message("Opponent buffed by " + string(battleHex.opponentBuff));	}	
	
	if (attackPower >= defensePower )
	{
		var odds = floor (10 * (attackPower / defensePower)); // so 10 is 1:1 odds; 20 is 2:1
		show_debug_message("Odds are " + string(odds/10) + " : 1");
		if odds < 10 
		{
			Retreat(attacker, attackerFromX, attackerFromY, battleX, battleY, true);
			oMap.combatMessage = (attacker.designation + " retreating from failed attack on " +
					defender.designation + " at " + 
					string(battleX) + " , " + string(battleY));
			show_debug_message(attacker.designation + " retreating from failed attack on " +
					defender.designation + " at " + 
					string(battleX) + " , " + string(battleY));
			return Outcome.Loss;
		}
		
		var dieRoll = irandom(10);
		show_debug_message("Die roll: " + string(dieRoll));
		if odds >= 10
		{
			if (odds > 10 * dieRoll )  // nice low DR, defender eliminated
			{
				oMap.combatMessage = (defender.designation + " eliminated by " + attacker.designation);
				show_debug_message(defender.designation + " eliminated by " + attacker.designation);
				defender.onMap = false;
				return Outcome.Win;
			}
			
			else if (odds <= 10 * dieRoll) && (odds >= 3 * dieRoll) // ok roll, D retreat
			{
				defender.orders = 0;  // Retreat will return true if only one D in hex.
				oMap.combatMessage = (defender.designation + " retreating after attacked at " + 
					string(battleX) + " , " + string(battleY));
				show_debug_message(defender.designation + " retreating after attacked at " + 
					string(battleX) + " , " + string(battleY));
					
					// causing too many retreats in one go?  
					
				if Retreat(defender, attackerFromX, attackerFromY, battleX, battleY, false)
				{
					ShiftUnit(attacker,attackerFromX,attackerFromY,battleX,battleY,true);
				}
				else
				{
					attacker.orders = 0;  // target hex not empty, so attacker must halt movement.
				}
				
				return Outcome.DefenderRetreat;  //  D not eliminated, but attacker can advance
			}
			
			else  // bad roll, attacker retreats; maybe add attacker elim later?
			{
				attacker.orders = 0;
				// Retreat(attacker, attackerFromX, attackerFromY, battleX, battleY, true);
				oMap.combatMessage = (attacker.designation + " retreating from failed attack at " + 
					string(battleX) + " , " + string(battleY));
				show_debug_message(attacker.designation + " retreating from failed attack at " + 
					string(battleX) + " , " + string(battleY));
				return Outcome.Loss;
			}
		}
	}
	else // redundant after "odds < 10" above, but may implement more alternatives -- e.g., attacker elim
	{
		// Retreat(attacker, attackerFromX, attackerFromY, battleX, battleY, true);
		show_debug_message(attacker.designation + " auto-retreats because < 1:1 odds.");
		return Outcome.Loss;
	}
}

function Retreat(retreater, attackerCameFromX, attackerCameFromY, battleX, battleY, wasAttacker)
{
	var dir = FindDirection(attackerCameFromX, attackerCameFromY, battleX, battleY);
	var retreatCoords = FindNeighbor(battleX, battleY, dir);
	var battleHex = oMap.map[battleX][battleY];
	oMap.combatMessage = (retreater.designation + " testing retreat to: " + string(retreatCoords));
	show_debug_message(retreater.designation + " testing retreat to: " + string(retreatCoords));
	
	if ValidLocation(retreatCoords[0], retreatCoords[1]) &&
		!EnemyControlled(retreatCoords, retreater.side) &&
		!FriendlyHexFull(retreatCoords, retreater.side)
	{
		ShiftUnit(retreater, battleX, battleY, retreatCoords[0], retreatCoords[1], false);
		if battleHex.occupied  // second unit remains, so no advance
		{
			return false;
		}
		else return true;
	}
			
	else
	{
		var dirAdjust = irandom(1) ;  // try left or right, randomly
		if dirAdjust
		{
			var altDir = dir - dirAdjust;
			if altDir < 0 {altDir = 5;} 
			var alt2Dir = altDir + 2;
			if alt2Dir == 6 {alt2Dir = 0;}
			if alt2Dir == 7 {alt2Dir = 1;}
		}
		else 
		{
			altDir = dir + dirAdjust;
			if altDir > 5 {altDir = 0;}
			var alt2Dir = altDir - 2;
			if alt2Dir == -1 {alt2Dir = 5;}
			if alt2Dir == -2 {alt2Dir = 4;}
		}
		retreatCoords = FindNeighbor(battleX, battleY, altDir);
		if ValidLocation(retreatCoords[0], retreatCoords[1]) &&
			!EnemyControlled(retreatCoords, retreater.side) &&
			!FriendlyHexFull(retreatCoords, retreater.side)
		{
			ShiftUnit(retreater, battleX, battleY, retreatCoords[0], retreatCoords[1], false);
			if battleHex.occupied  // second unit remains, so no advance
			{
				return false;
			}
			else return true;
		}
		else retreatCoords = FindNeighbor(battleX, battleY, alt2Dir);
		if ValidLocation(retreatCoords[0], retreatCoords[1]) &&
			!EnemyControlled(retreatCoords, retreater.side) &&
			!FriendlyHexFull(retreatCoords, retreater.side)
		{
			ShiftUnit(retreater, battleX, battleY, retreatCoords[0], retreatCoords[1], false);
			if battleHex.occupied  // second unit remains, so no advance
			{
				return false;
			}
			else return true;
		}
	}
}

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
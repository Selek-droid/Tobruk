// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function DeclareVictory()
{
	oGame.over = true;
	if oMap.map[5][1].ownedBy == Bloc.Axis // Tobruk
	{
		oMap.axisVPs += 100;
		
	}
	else
	{
		oMap.alliedVPs += 100;
	}
	
	if oMap.map[13][4].ownedBy == Bloc.Axis // Bardia
	{
		oMap.axisVPs += 60;
	}
	else
	{
		oMap.alliedVPs += 60;
	}
	
	if oMap.map[20][6].ownedBy == Bloc.Axis // Sidi Barrani
	{
		oMap.axisVPs += 40;
	}
	else
	{
		oMap.alliedVPs += 40;
	}
	
	if oMap.alliedVPs - oMap.axisVPs >= 200
	{
		oMap.combatMessage = "Decisive Allied Victory!  Congratulations!  On to Tripoli!";
		return;
	}
	
	else if oMap.alliedVPs - oMap.axisVPs >= 100
	{
		oMap.combatMessage = "Substantial Allied Victory!  Congratulations!";
		return;
	}
	
	else if oMap.alliedVPs - oMap.axisVPs > 0
	{
		oMap.combatMessage = "Marginal Allied Victory!  Congratulations!";
		return;
	}
	
	else if oMap.axisVPs - oMap.alliedVPs >= 200
	{
		oMap.combatMessage = "Decisive Axis Victory.  The Suez Canal is in jeopardy.";
		return;
	}
	
	else if oMap.axisVPs - oMap.alliedVPs >= 100
	{
		oMap.combatMessage = "Substantial Axis Victory.  The Axis prepares to invade Egypt.";
		return;
	}
	
	else if oMap.axisVPs - oMap.alliedVPs > 0
	{
		oMap.combatMessage = "Marginal Axis Victory.  The Suez Canal is still safe.";
		return;
	}
	
	else
	{
		oMap.combatMessage = "The campaign ends inconclusively.  The Suez Canal is still safe.";
		return;
	}
	
	
	
	
}
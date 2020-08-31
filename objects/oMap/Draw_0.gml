/// @description Insert description here
// You can write your code in this editor

draw_self();

if hexOverlay
{
	draw_sprite(sHexOverlay, -1, 0, 120);
}



//draw_sprite(sBr7Arm8Hus, -1, 500, 300);
//draw_sprite(sIt23InfDiv, -1, 400, 300);

/// @description Draw map.	

for (var col = 0; col < 26; col += 1;)
{
	for (var row = 0; row < 15; row += 1;)
	{
		if map[col][row]    // convert hex to pixel - now a function
		{
			var yRow = -2 + (HEXHEIGHT * 0.246) + (row * HEXHEIGHT * 0.75);
			var offset = row & 1;
			var xCol =  -5 + (col * HEXWIDTH * 1.01) + (0.45 * HEXWIDTH * offset);
			// 1.002 is a fudge factor. My drawn hexes are a tad wider than regular?
			
			var hexWithUnit = map[col][row];
			
			if displayUnits
			{
				if hexWithUnit.occupant2
				{
					draw_sprite(hexWithUnit.occupant2.picture, -1, xCol, y + 10 + yRow);
				}
				if hexWithUnit.occupied
				{
					if hexWithUnit.occupant.steps == 1
					{
						draw_sprite(hexWithUnit.occupant.pictureDamaged, -1, xCol, y + yRow);
					}
					else
					{
					draw_sprite(hexWithUnit.occupant.picture, -1, xCol, y + yRow);
					}
					
					//if !hexWithUnit.occupant.supplied
					//{
					//	var pixelCoords = HexToPixel(col, row);
					//	draw_sprite_ext(sRedHex, -1, pixelCoords[0], pixelCoords[1], 1, 1, 0, c_white, 0.5);
					//}
				}
				
			}
			
			if displayControl 
			{	
				var pixelCoords = HexToPixel(col, row);
				if hexWithUnit.ownedBy == Bloc.Allied 
				{
					draw_sprite_ext(sOwnedBritHex, -1, pixelCoords[0], pixelCoords[1], 1, 1, 0, c_yellow, 1);
				}
				else if hexWithUnit.ownedBy == Bloc.Axis 
				{
					draw_sprite_ext(sOwnedItalianHex, -1, pixelCoords[0], pixelCoords[1], 1, 1, 0, c_white, 1);
				}
			} 
			
			if displaySupply
			{
				var pixelCoords = HexToPixel(col, row);
				if hexWithUnit.supplyPenalty > 1
				{
					draw_sprite_ext(sRedHex, -1, pixelCoords[0], pixelCoords[1], 1, 1, 0, c_white, 0.5);
				}
				
			}
			
			if displayInfluence
			{
				var pixelCoords = HexToPixel(col, row);
				var influence = hexWithUnit.tacticalValue;
				if influence > 200
				{
					draw_sprite_ext(sBlueHex, -1, pixelCoords[0], pixelCoords[1], 1, 1, 0, c_black, 1);
				}
				
				else if (influence > 150) && (influence <= 200)
				{
					draw_sprite_ext(sBlueHex, -1, pixelCoords[0], pixelCoords[1], 1, 1, 0, c_red, 1);
				}
				
				else if (influence > 100) && (influence <= 150)
				{
					draw_sprite_ext(sBlueHex, -1, pixelCoords[0], pixelCoords[1], 1, 1, 0, c_green, 1);
				}
				
				else if (influence > 50) && (influence <= 100)
				{
					draw_sprite_ext(sBlueHex, -1, pixelCoords[0], pixelCoords[1], 1, 1, 0, c_green, 0.75);
				}
				
				else if (influence > 0) && (influence <= 50)
				{
					draw_sprite_ext(sBlueHex, -1, pixelCoords[0], pixelCoords[1], 1, 1, 0, c_green, 0.5);
				}
				
				else if (influence <= 0) 
				{
					draw_sprite_ext(sBlueHex, -1, pixelCoords[0], pixelCoords[1], 1, 1, 0, c_aqua, 0.25);
				}
				
			}
			
			if displayStrategic
			{
				var pixelCoords = HexToPixel(col, row);
				var influence = hexWithUnit.tacticalValue + hexWithUnit.strategicValue;
				draw_set_color(c_navy);
				draw_text(pixelCoords[0] + 20, pixelCoords[1] + 10, string(col) + 
					" , " + string(row));
				draw_text(pixelCoords[0] + 30, pixelCoords[1] + 30,string(hexWithUnit.tacticalValue));
				draw_set_color(c_white);
				if influence > 200
				{
					draw_sprite_ext(sRedHex, -1, pixelCoords[0], pixelCoords[1], 1, 1, 0, c_white, 0.8);
				}
				
				if influence > 100 && (influence <= 200)
				{
					draw_sprite_ext(sRedHex, -1, pixelCoords[0], pixelCoords[1], 1, 1, 0, c_white, 0.7);
				}
				
				if influence > 80 && (influence <= 100)
				{
					draw_sprite_ext(sRedHex, -1, pixelCoords[0], pixelCoords[1], 1, 1, 0, c_white, 0.6);
				}
				
				else if (influence > 60) && (influence <= 80)
				{
					draw_sprite_ext(sRedHex, -1, pixelCoords[0], pixelCoords[1], 1, 1, 0, c_white, 0.5);
				}
				
				else if (influence > 40) && (influence <= 60)
				{
					draw_sprite_ext(sRedHex, -1, pixelCoords[0], pixelCoords[1], 1, 1, 0, c_white, 0.4);
				}
				
				else if (influence > 20) && (influence <= 40)
				{
					draw_sprite_ext(sRedHex, -1, pixelCoords[0], pixelCoords[1], 1, 1, 0, c_white, 0.3);
				}
				
				else if (influence > 10) && (influence <= 20)
				{
					draw_sprite_ext(sRedHex, -1, pixelCoords[0], pixelCoords[1], 1, 1, 0, c_white, 0.2);
				}
				
				else if (influence > 5) && (influence <= 10)
				{
					draw_sprite_ext(sRedHex, -1, pixelCoords[0], pixelCoords[1], 1, 1, 0, c_white, 0.05);
				}
				
				
				else if (influence > 0) && (influence <= 5)
				{
					draw_sprite_ext(sRedHex, -1, pixelCoords[0], pixelCoords[1], 1, 1, 0, c_white, 0.05);
				}
				
				else if (influence <= 0) 
				{
					draw_sprite_ext(sRedHex, -1, pixelCoords[0], pixelCoords[1], 1, 1, 0, c_white, 0);
				}
				
			}
		}
	}
}

//draw_set_color(c_black);
//draw_text(50,200,string(mapCoordinates));
//// draw_text(50,150,"Neighbor 1: " + string(neighbor));
//draw_text(50,300,string(mouse_x) + " , " + string(mouse_y));
//draw_set_color(c_white);

if needPath
{
	var pathLength = ds_list_size(highlightedHexes);
	for (i = 0; i < pathLength; i += 1;)
	{
		var pixelCoords = ds_list_find_value(highlightedHexes, i);
		// var alpha = (pathLength - i) / pathLength;
		//if i <= 6 
		//{
		//	alpha = 1;
		//}
		//else if (i > 6) && (i <= 12) alpha = 0.8;
		//else if (i > 12) && (i < 24) alpha  = 0.6;
		//else alpha = 0.4;
		
		var color = c_white;
		//if i <= 6 
		//{
		//	color = c_lime;
		//}
		//else if (i > 6) && (i <= 12) color = c_green;
		//else if (i > 12) && (i < 24) color = c_yellow;
		//else color = c_blue;
		draw_sprite(sHighlightedHex, -1, pixelCoords[0], pixelCoords[1]);
		draw_sprite_ext(sHighlightedHex, -1, 
			pixelCoords[0], pixelCoords[1], 1, 1, 0, color, 1);
	}
}

//if waitForAI
//{
//	oMap.combatMessage = "Press spacebar to begin impulse 1" ;
//	draw_sprite(sAIThink2, -1, (room_width / 2) - 256, (room_height/2) - 128);
//	show_debug_message("Wait for AI is true");
//}



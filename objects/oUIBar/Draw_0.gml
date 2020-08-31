/// @description Insert description here
// You can write your code in this editor

draw_self();



draw_set_color(c_navy);
draw_text_transformed(x + 575, y + 3, string(oMap.impulse) + 
	" of " + string(oMap.longestOrder), 1.5, 1.5, 0);
// draw_text_transformed(x + 570, y + 3, " of " + string(oMap.longestOrder), 1.5, 1.5, 0);
draw_text_transformed(x + 339, y + 2, string(oMap.turn) , 1.5, 1.5, 0);

draw_text_transformed(x + 850, y, oMap.combatMessage, 1.5, 1.5, 0);


draw_set_color(c_maroon);
draw_text_transformed(x + 850, y + 25, eventsMessage, 1.5, 1.5, 0);
draw_text_transformed(x + 850, y + 50, flavorMessage, 1.5, 1.5, 0);
draw_set_color(c_black);



draw_text_transformed(x + 75, y + 2, oUIBar.date, 1.5, 1.5, 0);
draw_text_transformed(x + 150, y + 34, oMap.alliedVPs, 1.5, 1.5, 0);
draw_text_transformed(x + 150, y + 68, oMap.axisVPs, 1.5, 1.5, 0);


// draw_text_transformed(x + 850, y + 20, oMap.combatOdds, 1.5, 1.5, 0);

draw_set_color(c_white);




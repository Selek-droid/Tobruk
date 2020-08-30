/// @description Insert description here
// You can write your code in this editor

draw_self();

draw_set_color(c_black);
draw_text_transformed(x + 500, y, string(oMap.impulse), 2.5, 2.5, 0);
draw_text_transformed(x + 520, y, " of " + string(oMap.longestOrder), 2.5, 2.5, 0);
draw_text_transformed(x + 150, y, string(oMap.turn), 2.5, 2.5, 0);
draw_text_transformed(x + 850, y, oMap.combatMessage, 1.5, 1.5, 0);
draw_text_transformed(x + 850, y + 20, oMap.combatOdds, 1.5, 1.5, 0);

draw_set_color(c_white);




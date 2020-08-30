/// @desc Game controller.
// 

if keyboard_check_pressed(vk_escape) game_end();
if keyboard_check_pressed(vk_tab) game_restart();

if keyboard_check_pressed(ord("U")) oMap.displayUnits = !(oMap.displayUnits);
if keyboard_check_pressed(ord("H")) oMap.hexOverlay = !(oMap.hexOverlay);
if keyboard_check_pressed(ord("I")) oMap.displayInfluence = !(oMap.displayInfluence);
if keyboard_check_pressed(ord("C")) oMap.displayControl = !(oMap.displayControl);
if keyboard_check_pressed(ord("S")) oMap.displayStrategic = !(oMap.displayStrategic
);

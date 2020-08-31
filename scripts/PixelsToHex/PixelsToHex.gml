// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function PixelsToHex(col, row)
{
	var coords;
	var yRow = (floor(( (row - MAPTOPEDGE) / (HEXHEIGHT * 0.75)))); // - (HEXHEIGHT * 0.28));
	var offset = yRow & 1;
	var xCol = floor((col / (HEXWIDTH * 1.002))) - offset; //- (0.5 * HEXWIDTH * offset) - 35);
	coords[0] = xCol;
	coords[1] = yRow;
	return coords;
	
	//(HEXHEIGHT * 0.28) + (row * HEXHEIGHT * 0.75);
	//		var offset = row & 1;
	//		var xCol = 35 + (col * HEXWIDTH * 1.002) + (0.5 * HEXWIDTH * offset);
}

function HexToPixel(col, row)
{
	var pixelCoords;
	var yRow = 102 + (HEXHEIGHT * 0.28) + (row * HEXHEIGHT * 0.75);
	var offset = row & 1;
	var xCol = -20 + (col * HEXWIDTH * 1.009) + (0.5 * HEXWIDTH * offset);
	pixelCoords[0] = xCol;
	pixelCoords[1] = yRow;
	return pixelCoords;
}


function PixelsToPointyHex(pointX, pointY)
{
//	var coords;
	var cubeCoords;
	var offsetCoords;
    var q = (sqrt(3)/3 * pointX  -  1./3 * pointY) / HEXRADIUS
    var r = (                        2./3 * (pointY) - MAPTOPEDGE) / HEXRADIUS
//	coords[0] = q;
//	coords[1] = r;
	var s = -(q + r);
	cubeCoords = CubeRound(q, r, s);  // rounds cube coords, returns array of 3 coords
	var cubeQ = cubeCoords[0];
	var cubeR = cubeCoords[1];
	var cubeS = cubeCoords[1];
	// show_debug_message("Cubes are Q: " + string(cubeQ) + " , r: " + string(cubeR) + " , s: " + string(cubeS));
	offsetCoords = CubeToOddr(cubeQ, cubeR, cubeS); // converts 3 cube coords to 2 offset
	offsetCoords[0] += 1;
	// show_debug_message("Offset coords are " + string(offsetCoords));
	
	return offsetCoords;  // an array of 2 coordinates
}

function CubeRound(q, r, s)
{
	var cube;
    var rx = round(q);
    var ry = round(r);
    var rz = round(s);

    var x_diff = abs(rx - q);
    var y_diff = abs(ry - r);
    var z_diff = abs(rz - s);

    if x_diff > y_diff and x_diff > z_diff
	{
        rx = -ry-rz
	}
    else if y_diff > z_diff
	{
		ry = -rx-rz
	}
    else
	{
		rz = -rx-ry
	}
	
	cube[0] = rx;
	cube[1] = ry;
	cube[2] = rz;
    return cube;
}

function CubeToOddr(q, r, s)
{
	var offsetCoords;
    var col = q + (s - (s & 1)) / 2;
    var row = s;
	offsetCoords[0] = col;
	offsetCoords[1] = row;
    return offsetCoords;
}

function OddrToCube(hexArray)
{
    var cubeX = hexArray[0] - (hexArray[1] - (hexArray[1] & 1)) / 2;
    var cubeZ = hexArray[1];
    var cubeY = -cubeX - cubeZ;
	var cube = [cubeX, cubeY, cubeZ];
    return cube;
}

function CubeDistance(a, b)  // a and b are both 3-length arrays (cubes)
{
	var cubeAX = a[0];
	var cubeAY = a[1];
	var cubeAZ = a[2];
	var cubeBX = b[0];
	var cubeBY = b[1];
	var cubeBZ = b[2];
    return (abs(cubeAX - cubeBX) + abs(cubeAY - cubeBY) + abs(cubeAZ - cubeBZ)) / 2; 
}

function HowFar(startCoords, endCoords)
{
	var cube1 = OddrToCube(startCoords);
	var cube2 = OddrToCube(endCoords);
	return CubeDistance(cube1, cube2);
	
}


function ValidLocation(col, row)  // For now, rule out (1) board edge, (2) water, (3) Qattara.
								// Eventually bake terrain etc into map? Array of structs?
{
	if (row < 0) || (row > 14) return false;  // board edges.
	if (col < 0) || (col > 25) return false;  
	if (row == 0) && (col >= 2) return false; // water
	if (row == 1) && (col >= 6) return false;  // water
	if (row == 2) && ((col == 6) || (col == 7)) return false; // water by Tobruk
	if ((row == 2) || (row == 3)) && (col >= 13) return false; // yet more water
	if ((row == 4) || (row == 5)) && (col >= 14) return false; // Qattara
	if (row == 6) && ((col == 15) || (col == 16) || (col == 17)) return false;
	if (row == 6) && (col >= 23) return false;
	else return true;
}
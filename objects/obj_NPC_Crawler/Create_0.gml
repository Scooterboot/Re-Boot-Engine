/// @description Initialize
event_inherited();

mSpeed = 1;
moveDir = 1;
rotation2 = rotation;
initialize = false;

function MoveStickBottom_X(movingTile) { return true; }
function MoveStickBottom_Y(movingTile) { return true; }
function MoveStickTop_X(movingTile) { return true; }
function MoveStickTop_Y(movingTile) { return true; }
function MoveStickRight_X(movingTile) { return true; }
function MoveStickRight_Y(movingTile) { return true; }
function MoveStickLeft_X(movingTile) { return true; }
function MoveStickLeft_Y(movingTile) { return true; }

function Crawler_OnXCollision(fVX)
{
	velX = 0;
	fVelX = 0;
}
function Crawler_OnYCollision(fVY)
{
	velY = 0;
	fVelY = 0;
}

function MovingSolid_OnRightCollision(fVX)
{
	colEdge = Edge.Right;
}
function MovingSolid_OnLeftCollision(fVX)
{
	colEdge = Edge.Left;
}
function MovingSolid_OnBottomCollision(fVY)
{
	colEdge = Edge.Bottom;
}
function MovingSolid_OnTopCollision(fVY)
{
	colEdge = Edge.Top;
}
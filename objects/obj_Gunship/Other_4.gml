/// @description 

var msSizeW = global.mapSquareSizeW,
	msSizeH = global.mapSquareSizeH;
shipIcon[2] = obj_Map.GetMapPosX(x) * msSizeW + msSizeW/2;
shipIcon[3] = obj_Map.GetMapPosY(y) * msSizeH + msSizeH/2;

UpdateShipIcon();
/// @description 

var msSizeW = global.mapSquareSizeW,
	msSizeH = global.mapSquareSizeH;
shipIcon[MapIconInd.XPos] = obj_Map.GetMapPosX(x) * msSizeW + msSizeW/2;
shipIcon[MapIconInd.YPos] = obj_Map.GetMapPosY(y) * msSizeH + msSizeH/2;

UpdateShipIcon();
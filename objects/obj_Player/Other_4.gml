layer = layer_get_id("Player");

//array_fill(mbTrailPosX, noone);
//array_fill(mbTrailPosY, noone);
//array_fill(mbTrailDir, noone);

for(var i = 0; i < ds_list_size(afterImageList); i++)
{
	afterImageList[| i].Clear();
	//ds_list_delete(afterImageList,i);
}

liquid = liquid_place();
liquidPrev = liquid;
liquidTop = liquid_top();
liquidTopPrev = liquidTop;

prevTop = bb_top();
prevBottom = bb_bottom();
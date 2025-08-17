layer = layer_get_id("Player");

for(var i = 0; i < ds_list_size(afterImageList); i++)
{
	afterImageList[| i].Clear();
}

liquid = liquid_place();
liquidPrev = liquid;
liquidTop = liquid_top();
liquidTopPrev = liquidTop;

prevTop = bb_top();
prevBottom = bb_bottom();
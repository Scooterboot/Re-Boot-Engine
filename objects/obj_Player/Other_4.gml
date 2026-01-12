layer = layer_get_id("Player");

for(var i = 0; i < ds_list_size(afterImageList); i++)
{
	afterImageList[| i].Clear();
}

liquid = self.liquid_place();
liquidPrev = liquid;
liquidTop = self.liquid_top();
liquidTopPrev = liquidTop;

prevTop = self.bb_top();
prevBottom = self.bb_bottom();
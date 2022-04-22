/// @description scr_BGParallax
/// @param backgroundLayer
/// @param multX
/// @param multY
/// @param alignment=""
function scr_BGParallax()
{
	var paral = instance_create_depth(0,0,0,obj_BGParallax);
	var bgLayer = layer_get_id(argument[0]);
	paral.bgLayerID = bgLayer;
	paral.bgPosX = layer_get_x(bgLayer);
	paral.bgPosY = layer_get_y(bgLayer);
	paral.multX = argument[1];
	paral.multY = argument[2];
	paral.alignment = "";
	if(argument_count > 3)
	{
		paral.alignment = argument[3];
	}
}
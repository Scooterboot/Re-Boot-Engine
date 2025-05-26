/// @description scr_BGParallax
/// @param layer
/// @param multX
/// @param multY
/// @param alignment=""
function scr_SetParallax(_layer, multX, multY, alignment = "")
{
	var paral = instance_create_depth(0,0,0,obj_LayerParallax);
	var lay = layer_get_id(_layer);
	paral.layerID = lay;
	paral.posX = layer_get_x(lay);
	paral.posY = layer_get_y(lay);
	paral.multX = multX;
	paral.multY = multY;
	paral.alignment = alignment;
}
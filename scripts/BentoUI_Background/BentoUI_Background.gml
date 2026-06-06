function BentoUI_Background(_sprite, _parent = other) : BentoConstrAncestor(_parent) constructor
{
	sprite = _sprite;
	
	BentoLayoutSetSize(global.resWidth, global.resHeight);
	
	eventDraw = function()
	{
		var ww = global.resWidth,
			hh = global.resHeight,
			sprW = sprite_get_width(sprite),
			sprH = sprite_get_height(sprite);
		
		draw_sprite_tiled_ext(sprite,0,ww/2,hh/2,1,1,c_white,image_alpha);
	}
}
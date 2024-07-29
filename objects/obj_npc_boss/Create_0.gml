/// @description Initialize
event_inherited();

boss = true;
tileCollide = false;
passthroughMovingSolids = true;

camPosX = x;
camPosY = y;
function CameraLogic() {}

// making my own sequence code for animation because GM sequences aren't flexible enough -_-
#region AnimBone
function AnimBone(_defaultX, _defaultY, _parentBone = pointer_null) constructor
{
	npc = other;
	
	defaultPosition = new Vector2(_defaultX,_defaultY);
	
	parent = _parentBone;
	children = ds_list_create();
	function Clean()
	{
		ds_list_destroy(children);
	}
	
	if(parent != pointer_null)
	{
		if(!ds_exists(parent.children,ds_type_list))
		{
			parent.children = ds_list_create();
		}
		ds_list_add(parent.children,self);
	}
	
	position = new Vector2();
	offsetPosition = new Vector2();
	
	rotation = 0;
	offsetRotation = 0;
	
	scale = new Vector2();
	dir = 1;
	ignoreParentRot = false;
	
	color = c_white;
	alpha = 1;
	
	function UpdateBone(basePos = pointer_null, overrideDir = pointer_null, overrideScale = pointer_null)
	{
		if(basePos != pointer_null)
		{
			//position = basePos.Add(defaultPosition.Add(offsetPosition).MultiplyVector2(scale));
			// position = basePos + (defaultPosition + offsetPosition) * scale;
			var pos2 = new Vector2(defaultPosition.X,defaultPosition.Y);
			pos2.Add(offsetPosition);
			pos2.MultiplyVector2(scale);
			
			position.Equals(basePos);
			position.Add(pos2);
		}
		if(overrideDir != pointer_null)
		{
			dir = overrideDir;
		}
		if(overrideScale != pointer_null)
		{
			scale = overrideScale;
		}
		
		if(ds_exists(children,ds_type_list) && ds_list_size(children) > 0)
		{
			for(var i = 0; i < ds_list_size(children); i++)
			{
				var child = children[| i];
				//var cpos = child.defaultPosition.Add(child.offsetPosition);
				// var cpos = child.defaultPosition + child.offsetPosition;
				var cpos = new Vector2(child.defaultPosition.X,child.defaultPosition.Y);
				cpos.Add(child.offsetPosition);
				
				var offsetRot = cpos.ToRotation(),
					dist = cpos.Length();
				
				if(!child.ignoreParentRot)
				{
					offsetRot -= rotation;
				}
				//child.position = position.Add(RotationToVector2(AngleFlip(offsetRot, dir)).Multiply(dist)).MultiplyVector2(scale)
				// child.position = position + RotationToVector2(AngleFlip(offsetRot, dir)) * dist * scale;
				
				var cpos2 = RotationToVector2(AngleFlip(offsetRot, dir));
				cpos2.Multiply(dist);
				cpos2.MultiplyVector2(scale);
				
				child.position.Equals(position);
				child.position.Add(cpos2);
				
				if(overrideDir != pointer_null)
				{
					child.dir = overrideDir;
				}
				if(overrideScale != pointer_null)
				{
					child.scale = overrideScale;
				}
				child.UpdateBone(pointer_null,overrideDir,overrideScale);
			}
		}
		
		rotation = offsetRotation;
		if(parent != pointer_null)
		{
			rotation += parent.rotation;
		}
	}
	
	function AnimateRotation(rotArray, frame, transition, loop = false)
	{
		//rotation = lerp(rotation, LerpArray(rotArray,frame,loop), transition);
		offsetRotation = lerp(offsetRotation, LerpArray(rotArray,frame,loop), transition);
	}
	function AnimatePosition(posArray, frame, transition, loop = false)
	{
		//offsetPosition = offsetPosition.Lerp(LerpArrayVector2(posArray,frame,loop),transition);
		// offsetPosition = lerp(offsetPosition, LerpArrayVector2(posArray,frame,loop), transition);
		
		var pos = LerpArrayVector2(posArray,frame,loop);
		offsetPosition.Lerp(pos, transition);
	}
}
#endregion
#region DrawLimb
function DrawLimb(_name, _sprt, _bone, _bone2 = pointer_null) constructor
{
	npc = other;
	
	name = _name;
	sprt = _sprt;
	bone = _bone;
	bone2 = _bone2;
	
	surfW = sprite_get_width(sprt);
	surfH = sprite_get_height(sprt);
	limbSurf = surface_create(surfW,surfH);
	rotScale = 5;
	limbSurf2 = surface_create(surfW*rotScale,surfH*rotScale);
	function Clean()
	{
		if(surface_exists(limbSurf))
		{
			surface_free(limbSurf);
		}
		if(surface_exists(limbSurf2))
		{
			surface_free(limbSurf2);
		}
	}
	
	function Shader() {}
	function Draw(frame = 0, dir = 1)
	{
		var b = bone;
		if(dir == -1 && bone2 != pointer_null)
		{
			b = bone2;
		}
		var rot = scr_round(b.rotation) * dir;
		var scaleX = b.scale.X*dir,
			scaleY = b.scale.Y;
		var xOffset = sprite_get_xoffset(sprt),
			yOffset = sprite_get_yoffset(sprt);
		
		if(surface_exists(limbSurf))
		{
			surface_set_target(limbSurf);
			draw_clear_alpha(c_black,0);
			
			Shader();
			draw_sprite_ext(sprt,frame,xOffset,yOffset,1,1,0,c_white,1);
			shader_reset();
			
			surface_reset_target();
		}
		else
		{
			limbSurf = surface_create(surfW,surfH);
			surface_set_target(limbSurf);
			draw_clear_alpha(c_black,0);
			surface_reset_target();
		}
		if(surface_exists(limbSurf2))
		{
			surface_set_target(limbSurf2);
			draw_clear_alpha(c_black,0);
			
			var shd = sh_better_scaling_5xbrc;
			shader_set(shd);
		    shader_set_uniform_f(shader_get_uniform(shd, "texel_size"), 1 / surface_get_width(limbSurf), 1 / surface_get_height(limbSurf));
		    shader_set_uniform_f(shader_get_uniform(shd, "texture_size"), surface_get_width(limbSurf), surface_get_height(limbSurf));
		    shader_set_uniform_f(shader_get_uniform(shd, "color"), 1, 1, 1, 1);
		    shader_set_uniform_f(shader_get_uniform(shd, "color_to_make_transparent"), 0, 0, 0);
			
			draw_surface_ext(limbSurf,0,0,rotScale,rotScale,0,c_white,1);
			shader_reset();
			
			surface_reset_target();
			
			var sc = dcos(rot),
				ss = dsin(rot),
				sx = xOffset * scaleX,
				sy = yOffset * scaleY;
			var sxx = scr_round(b.position.X)-sc*sx-ss*sy,
				syy = scr_round(b.position.Y)-sc*sy+ss*sx;
			draw_surface_ext(limbSurf2,sxx,syy,scaleX/rotScale,scaleY/rotScale,rot,b.color,b.alpha);
		}
		else
		{
			limbSurf2 = surface_create(surfW*rotScale,surfH*rotScale);
			surface_set_target(limbSurf2);
			draw_clear_alpha(c_black,0);
			surface_reset_target();
		}
	}
}
#endregion

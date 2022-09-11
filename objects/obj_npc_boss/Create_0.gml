/// @description Initialize
event_inherited();

boss = true;

camPosX = x;
camPosY = y;
function CameraLogic() {}

// making my own sequence code for animation because GM sequences aren't flexible enough -_-
#region AnimBone
function AnimBone(_defaultX, _defaultY, _parentBone = noone) constructor
{
	defaultPosition = new Vector2(_defaultX,_defaultY);
	
	parent = _parentBone;
	children = ds_list_create();
	
	if(parent != noone)
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
	scale = new Vector2();
	dir = 1;
	ignoreParentRot = false;
	
	color = c_white;
	alpha = 1;
	
	function UpdateBone(basePos = noone, overrideDir = -2, overrideScale = noone)
	{
		if(basePos != noone)
		{
			//position = basePos.Add(defaultPosition.Add(offsetPosition).MultiplyVector2(scale));
			// position = basePos + (defaultPosition + offsetPosition) * scale;
			var pos2 = new Vector2(defaultPosition.X,defaultPosition.Y);
			pos2.Add(offsetPosition);
			pos2.MultiplyVector2(scale);
			
			position.Equals(basePos);
			position.Add(pos2);
		}
		if(abs(overrideDir) <= 1)
		{
			dir = overrideDir;
		}
		if(overrideScale != noone)
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
				
				offsetRot = scr_round(offsetRot);
				
				var cpos2 = RotationToVector2(AngleFlip(offsetRot, dir));
				cpos2.Multiply(dist);
				cpos2.MultiplyVector2(scale);
				
				child.position.Equals(position);
				child.position.Add(cpos2);
				
				if(overrideDir >= -1 && overrideDir <= 1)
				{
					child.dir = overrideDir;
				}
				if(overrideScale != noone)
				{
					child.scale = overrideScale;
				}
				child.UpdateBone(noone,overrideDir,overrideScale);
			}
		}
	}
	
	function AnimateRotation(rotArray, frame, transition, loop = false)
	{
		rotation = lerp(rotation, LerpArray(rotArray,frame,loop), transition);
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
function DrawLimb(_name, _sprt, _bone, _bone2 = noone) constructor
{
	name = _name;
	sprt = _sprt;
	bone = _bone;
	bone2 = _bone2;
	
	function Draw(frame = 0, dir = 1)
	{
		var b = bone;
		if(dir == -1 && bone2 != noone)
		{
			b = bone2;
		}
		var rot = scr_round(b.rotation) * dir;//scr_round(b.rotation/2.8125)*2.8125;
		draw_sprite_ext(sprt,frame,scr_round(b.position.X),scr_round(b.position.Y),b.scale.X*dir,b.scale.Y,rot,b.color,b.alpha);
	}
}
#endregion

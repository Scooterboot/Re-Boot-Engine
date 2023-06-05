/// @description Reveal logic

if(!visible && !revealTile && object_index != obj_Spikes && object_index != obj_NPCBreakable)
{
    if(place_meeting(x,y,obj_MBBombExplosion) || place_meeting(x,y,obj_PowerBombExplosion) || place_meeting(x,y,obj_MissileExplosion) || place_meeting(x,y,obj_SuperMissileExplosion))
    {
        revealTile = true;
    }
	if(place_meeting(x,y,obj_Projectile) && (object_index == obj_BombBlock || object_index == obj_ChainBlock))
	{
		var shot = instance_place(x,y,obj_Projectile);
		//if(shot.isBeam)
		if(shot.type == ProjType.Beam)
		{
			revealTile = true;
		}
	}
}

if(revealTile)
{
    if(!visible)
    {
        RevealTile();
        visible = true;
    }
    //revealTile = false;
}

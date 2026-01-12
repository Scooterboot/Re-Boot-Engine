/// @description Reveal logic

if(!visible && object_index != obj_NPCBreakable)
{
	if(((object_index == obj_BombBlock || object_index == obj_ChainBlock) && other.type == ProjType.Beam) ||
		other.object_index == obj_MBBombExplosion || other.object_index == obj_PowerBombExplosion || other.object_index == obj_MissileExplosion || other.object_index == obj_SuperMissileExplosion)
	{
		self.RevealTile();
		visible = true;
	}
}
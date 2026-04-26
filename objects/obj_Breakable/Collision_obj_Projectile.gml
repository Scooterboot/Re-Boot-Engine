/// @description Reveal logic

if(!visible && object_index != obj_NPCBreakable)
{
	if(other.blockReveal_Any || (other.blockReveal_Bomb && (object_index == obj_BombBlock || object_index == obj_ChainBlock)))
	{
		self.RevealTile();
		visible = true;
	}
}
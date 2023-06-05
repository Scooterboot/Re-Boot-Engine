/// @description 
event_inherited();

if(part_emitter_exists(obj_Particles.partSystemA,emit))
{
	part_emitter_destroy(obj_Particles.partSystemA,emit);
}
if(part_emitter_exists(obj_Particles.partSystemB,emit))
{
	part_emitter_destroy(obj_Particles.partSystemB,emit);
}
if(part_emitter_exists(obj_Particles.partSystemC,emit))
{
	part_emitter_destroy(obj_Particles.partSystemC,emit);
}
/// @description 

part_emitter_region(obj_Particles.partSystemA,emit,bbox_left,bbox_right,bbox_top,bbox_bottom,ps_shape_rectangle,ps_distr_linear);
part_emitter_burst(obj_Particles.partSystemA,emit,obj_Particles.npcDeath[0],3);
part_emitter_burst(obj_Particles.partSystemA,emit,obj_Particles.npcDeath[2],3);
scr_PlayExplodeSnd(0,false);
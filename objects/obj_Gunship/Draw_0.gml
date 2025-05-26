/// @description 


draw_sprite_ext(sprt_Gunship_Hatch,hatchFrame,x,y+hatchY,1,1,0,c_white,1);
draw_sprite_ext(sprt_Gunship,0,x,y,1,1,0,c_white,1);
draw_sprite_ext(sprt_Gunship_Lights,0,x,y,1,1,0,c_white,lightGlow);

gpu_set_blendmode(bm_add);
draw_sprite_ext(sprt_Gunship_Visor,0,x,y,1,1,0,c_white,visorLightGlow);
gpu_set_blendmode(bm_normal);
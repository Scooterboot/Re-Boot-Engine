//if(instance_exists(obj_Lava))
if(liquidType == LiquidType.Lava)
{
    gpu_set_blendmode(bm_add);
    draw_self();
    gpu_set_blendmode(bm_normal);
}
else
{
    draw_self();
}
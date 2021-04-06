/// -- Draw Self

if (Additive)
{
	gpu_set_blendmode(bm_add);
}

draw_self();

if (Additive)
{
	gpu_set_blendmode(bm_normal);
}
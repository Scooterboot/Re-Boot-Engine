
// shortcuts
function bm_reset()
{
	gpu_set_blendmode(bm_normal);
}
function bm_set_add()
{
	gpu_set_blendmode(bm_add);
}

// Mostly normal-ish blendmode that fixes problems with seeing blackness through transparency.
// Primarily used for the UI layer.
function bm_set_one()
{
	gpu_set_blendmode_ext_sepalpha(bm_src_alpha, bm_inv_src_alpha, bm_src_alpha, bm_one);
}
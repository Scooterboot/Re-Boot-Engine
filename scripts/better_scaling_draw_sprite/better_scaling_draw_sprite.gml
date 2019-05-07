/// @description  better_scaling_draw_sprite(sprite, subimg, x, y, xscale, yscale, rot, colour, alpha, upscale method)
/// @param sprite
/// @param  subimg
/// @param  x
/// @param  y
/// @param  xscale
/// @param  yscale
/// @param  rot
/// @param  colour
/// @param  alpha
/// @param  upscale method
// Like draw_sprite_ext, but with better scaling.
// sprite, subimg, x, y, xscale, yscale, rot, colour, alpha: See draw_sprite_ext in the manual for information on these parameters.
// upscale method: 0: No upscale shader. 1: Bicubic upscale shader. 2: hq4x depixelization (full alpha support, but more jaggy than 5xbr).
//                 3: 5xbra depixelization (round). 4: 5xbrb depixelization (semi-round). 5: 5xbrc depixelization (square).
//                 5xbr does not have full alpha support, but below you can set a color to act as transparency.
// What is meant by better scaling is that images with a scale larger than one will be depixelized or bicubically interpolated while images with a scale smaller than one will be supersampled.
// Depixelization here follows the hqnx and xbr methods, which looks at patterns in an image and tries to vectorize them. Making e.g. square dots next to each other turn into lines.
// Bicubic interpolation looks at the 16 surrounding pixels to mathematically determine a smooth transition between pixels that are being scaled.
// Supersampling is a downscaling technique that takes the average color over regions of the original image. So downscaling by n, will average a portion of nxn pixels from the original image into 1 for the render target.

var scale_up = ((argument[4] > 1 || argument[5] > 1) && argument[9] != 0), scale_down = (argument[4] < 1 || argument[5] < 1);

if (scale_up) {
    var texture = sprite_get_texture(argument[0], argument[1]);
    switch (argument[9]) {
        case 1:
            shader_set(sh_better_scaling_bicubic);
            shader_set_uniform_f(shader_get_uniform(sh_better_scaling_bicubic, "texel_size"), texture_get_texel_width(texture), texture_get_texel_height(texture));
            gpu_set_texfilter(true);
            break;
            
        case 2:
            shader_set(sh_better_scaling_hq4x);
            shader_set_uniform_f(shader_get_uniform(sh_better_scaling_hq4x, "texel_size"), texture_get_texel_width(texture), texture_get_texel_height(texture));
            gpu_set_texfilter(false);
            break;
            
        case 3:
            shader_set(sh_better_scaling_5xbra);
            shader_set_uniform_f(shader_get_uniform(sh_better_scaling_5xbra, "texel_size"), texture_get_texel_width(texture), texture_get_texel_height(texture));
            shader_set_uniform_f(shader_get_uniform(sh_better_scaling_5xbra, "texture_size"), 1 / texture_get_texel_width(texture), 1 / texture_get_texel_height(texture));
            shader_set_uniform_f(shader_get_uniform(sh_better_scaling_5xbra, "color"), color_get_red(argument[7]) / 255, color_get_green(argument[7]) / 255, color_get_blue(argument[7]) / 255, argument[8]);
            shader_set_uniform_f(shader_get_uniform(sh_better_scaling_5xbra, "color_to_make_transparent"), -1, -1, -1); // Channels from 0 to 1 for the RGB color you want to make transparent. -1 means disabled.
            gpu_set_texfilter(false);
            break;
        
        case 4:
            shader_set(sh_better_scaling_5xbrb);
            shader_set_uniform_f(shader_get_uniform(sh_better_scaling_5xbrb, "texel_size"), texture_get_texel_width(texture), texture_get_texel_height(texture));
            shader_set_uniform_f(shader_get_uniform(sh_better_scaling_5xbrb, "texture_size"), 1 / texture_get_texel_width(texture), 1 / texture_get_texel_height(texture));
            shader_set_uniform_f(shader_get_uniform(sh_better_scaling_5xbrb, "color"), color_get_red(argument[7]) / 255, color_get_green(argument[7]) / 255, color_get_blue(argument[7]) / 255, argument[8]);
            shader_set_uniform_f(shader_get_uniform(sh_better_scaling_5xbrb, "color_to_make_transparent"), -1, -1, -1); // Channels from 0 to 1 for the RGB color you want to make transparent. -1 means disabled.
            gpu_set_texfilter(false);
            break;
            
        case 5:
            shader_set(sh_better_scaling_5xbrc);
            shader_set_uniform_f(shader_get_uniform(sh_better_scaling_5xbrc, "texel_size"), texture_get_texel_width(texture), texture_get_texel_height(texture));
            shader_set_uniform_f(shader_get_uniform(sh_better_scaling_5xbrc, "texture_size"), 1 / texture_get_texel_width(texture), 1 / texture_get_texel_height(texture));
            shader_set_uniform_f(shader_get_uniform(sh_better_scaling_5xbrc, "color"), color_get_red(argument[7]) / 255, color_get_green(argument[7]) / 255, color_get_blue(argument[7]) / 255, argument[8]);
            shader_set_uniform_f(shader_get_uniform(sh_better_scaling_5xbrc, "color_to_make_transparent"), -1, -1, -1); // Channels from 0 to 1 for the RGB color you want to make transparent. -1 means disabled.
            gpu_set_texfilter(false);
            break;
    }
} else if (scale_down) {
    var texture, width, height, samples_x, samples_y, max_samples, offset_x, offset_y;
    texture = sprite_get_texture(argument[0], argument[1]);
    width = sprite_get_width(argument[0]); height = sprite_get_height(argument[0]);
    if (argument[4] == 0) samples_x = width; else samples_x = min(width, 1 / argument[4]);
    if (argument[5] == 0) samples_y = height; else samples_y = min(height, 1 / argument[5]);
    max_samples = max(samples_x, samples_y);
    offset_x = texture_get_texel_width(texture) * samples_x * 0.5; offset_y = texture_get_texel_height(texture) * samples_y * 0.5;
    if (max_samples <= 2) {
        shader_set(sh_better_scaling_supersampling_2x2);
        shader_set_uniform_f(shader_get_uniform(sh_better_scaling_supersampling_2x2, "offset"), offset_x, offset_y);
    } else if (max_samples <= 3) {
        shader_set(sh_better_scaling_supersampling_3x3);
        shader_set_uniform_f(shader_get_uniform(sh_better_scaling_supersampling_3x3, "offset"), offset_x, offset_y);
    } else {
        shader_set(sh_better_scaling_supersampling_4x4);
        shader_set_uniform_f(shader_get_uniform(sh_better_scaling_supersampling_4x4, "offset"), offset_x, offset_y);
    }
    gpu_set_texfilter(true);
}

draw_sprite_ext(argument[0], argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8]);

if (scale_up || scale_down) {
    if (scale_up) gpu_set_texfilter(true);
    shader_reset();
}

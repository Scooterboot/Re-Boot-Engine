attribute vec4 in_Position;
attribute vec4 in_Colour;
attribute vec2 in_TextureCoord;

varying vec4 v_vTexcoord[7];
varying vec4 v_vColour;

uniform vec2 texel_size;

void main() {
    float x = 0.5 * texel_size.x; float y = 0.5 * texel_size.y;
    vec2 dg1 = vec2(x, y);
    vec2 dg2 = vec2(-x, y);
    vec2 sd1 = dg1 * 0.5;
    vec2 sd2 = dg2 * 0.5;
    
    vec4 object_space_pos = vec4( in_Position.x, in_Position.y , in_Position.z, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    
    v_vTexcoord[0].xy = in_TextureCoord; //Current tx.
    v_vTexcoord[1].xy = v_vTexcoord[0].xy - sd1; //Current tx -0.25,-0.25.
    v_vTexcoord[2].xy = v_vTexcoord[0].xy - sd2; //Current tx  0.25,-0.25.
    v_vTexcoord[3].xy = v_vTexcoord[0].xy + sd1; //Current tx  0.25, 0.25.
    v_vTexcoord[4].xy = v_vTexcoord[0].xy + sd2; //Current tx -0.25, 0.25.
    v_vTexcoord[5].xy = v_vTexcoord[0].xy - dg1; //Current tx -0.50,-0.50.
    v_vTexcoord[6].xy = v_vTexcoord[0].xy + dg1; //Current tx  0.50, 0.50.
    v_vTexcoord[5].zw = v_vTexcoord[0].xy - dg2; //Current tx  0.50,-0.50.
    v_vTexcoord[6].zw = v_vTexcoord[0].xy + dg2; //Current tx -0.50, 0.50.
    
    v_vColour = in_Colour;
}

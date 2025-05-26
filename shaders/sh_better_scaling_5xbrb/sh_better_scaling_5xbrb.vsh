// Hyllian's 5xBR v3.7b (semi-rounded) Shader

attribute vec4 in_Position;
attribute vec2 in_TextureCoord;

varying vec4 v_vTexcoord[8];

uniform vec2 texel_size;

void main() {
    //     A1 B1 C1
    //  A0  A  B  C C4
    //  D0  D  E  F F4
    //  G0  G  H  I I4
    //     G5 H5 I5
    
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * in_Position;
    v_vTexcoord[0] = in_TextureCoord.xyxy;
    v_vTexcoord[1] = in_TextureCoord.xxxy + vec4(      -texel_size.x,             0, texel_size.x, -2.0 * texel_size.y);  //  A1 B1 C1
    v_vTexcoord[2] = in_TextureCoord.xxxy + vec4(      -texel_size.x,             0, texel_size.x,       -texel_size.y);  //   A  B  C
    v_vTexcoord[3] = in_TextureCoord.xxxy + vec4(      -texel_size.x,             0, texel_size.x,                   0);  //   D  E  F
    v_vTexcoord[4] = in_TextureCoord.xxxy + vec4(      -texel_size.x,             0, texel_size.x,        texel_size.y);  //   G  H  I
    v_vTexcoord[5] = in_TextureCoord.xxxy + vec4(      -texel_size.x,             0, texel_size.x,  2.0 * texel_size.y);  //  G5 H5 I5
    v_vTexcoord[6] = in_TextureCoord.xyyy + vec4(-2.0 * texel_size.x, -texel_size.y,            0,        texel_size.y);  //  A0 D0 G0
    v_vTexcoord[7] = in_TextureCoord.xyyy + vec4( 2.0 * texel_size.x, -texel_size.y,            0,        texel_size.y);  //  C4 F4 I4 
}

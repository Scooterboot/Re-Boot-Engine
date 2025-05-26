varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 offset;

void main() {
    gl_FragColor = v_vColour * (
        texture2D(gm_BaseTexture, v_vTexcoord + offset * vec2(-0.6666666667, -0.6666666667)) +
        texture2D(gm_BaseTexture, v_vTexcoord + offset * vec2(-0.6666666667, 0.0)) +
        texture2D(gm_BaseTexture, v_vTexcoord + offset * vec2(-0.6666666667, 0.6666666667)) +
        texture2D(gm_BaseTexture, v_vTexcoord + offset * vec2(0.0, -0.6666666667)) +
        texture2D(gm_BaseTexture, v_vTexcoord + offset * vec2(0.0, 0.0)) +
        texture2D(gm_BaseTexture, v_vTexcoord + offset * vec2(0.0, 0.6666666667)) +
        texture2D(gm_BaseTexture, v_vTexcoord + offset * vec2(0.6666666667, -0.6666666667)) +
        texture2D(gm_BaseTexture, v_vTexcoord + offset * vec2(0.6666666667, 0.0)) +
        texture2D(gm_BaseTexture, v_vTexcoord + offset * vec2(0.6666666667, 0.6666666667))
    ) * 0.1111111111;
}

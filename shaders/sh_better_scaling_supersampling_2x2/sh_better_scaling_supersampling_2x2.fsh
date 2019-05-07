varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 offset;

void main() {
    gl_FragColor = v_vColour * (
        texture2D(gm_BaseTexture, v_vTexcoord + offset * vec2(-0.5, -0.5)) +
        texture2D(gm_BaseTexture, v_vTexcoord + offset * vec2(-0.5, 0.5)) +
        texture2D(gm_BaseTexture, v_vTexcoord + offset * vec2(0.5, -0.5)) +
        texture2D(gm_BaseTexture, v_vTexcoord + offset * vec2(0.5, 0.5))
    ) * 0.25;
}

//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    vec4 originC = texture2D(gm_BaseTexture, v_vTexcoord) * v_vColour;

    float cR = originC.r + 0.8;
    float cG = originC.g + 0.8;
    float cB = originC.b + 0.8;
    float cA = originC.a;

    vec4 newColor = vec4(cR,cG,cB,cA);
    gl_FragColor = newColor;
}
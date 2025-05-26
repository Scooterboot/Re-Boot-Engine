//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

void main()
{
    vec4 originC = texture2D(gm_BaseTexture, v_vTexcoord) * v_vColour;

    float cA = originC.a;
    if(originC.a > 0.0)
    {
        cA = 1.0;
    }

    vec4 newColor = vec4(originC.r,originC.g,originC.b,cA);
    gl_FragColor = newColor;
}

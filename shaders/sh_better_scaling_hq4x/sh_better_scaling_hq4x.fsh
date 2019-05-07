varying vec4 v_vTexcoord[7];
varying vec4 v_vColour;

void main() {
    vec4 c = texture2D(gm_BaseTexture, v_vTexcoord[0].xy);
    vec4 i1 = texture2D(gm_BaseTexture, v_vTexcoord[1].xy);
    vec4 i2 = texture2D(gm_BaseTexture, v_vTexcoord[2].xy); 
    vec4 i3 = texture2D(gm_BaseTexture, v_vTexcoord[3].xy); 
    vec4 i4 = texture2D(gm_BaseTexture, v_vTexcoord[4].xy); 
    vec4 o1 = texture2D(gm_BaseTexture, v_vTexcoord[5].xy);
    vec4 o3 = texture2D(gm_BaseTexture, v_vTexcoord[6].xy); 
    vec4 o2 = texture2D(gm_BaseTexture, v_vTexcoord[5].zw);
    vec4 o4 = texture2D(gm_BaseTexture, v_vTexcoord[6].zw); 
    
    float ko1 = dot(abs(o1 - c), vec4(1.0));
    float ko2 = dot(abs(o2 - c), vec4(1.0));
    float ko3 = dot(abs(o3 - c), vec4(1.0));
    float ko4 = dot(abs(o4 - c), vec4(1.0));
    
    float k1 = min(dot(abs(i1 - i3), vec4(1.0)), max(ko1, ko3));
    float k2 = min(dot(abs(i2 - i4), vec4(1.0)), max(ko2, ko4));
    
    float w1 = k2; if (ko3 < ko1) w1 *= ko3 / ko1;
    float w2 = k1; if (ko4 < ko2) w2 *= ko4 / ko2;
    float w3 = k2; if (ko1 < ko3) w3 *= ko1 / ko3;
    float w4 = k1; if (ko2 < ko4) w4 *= ko2 / ko4;
    
    gl_FragColor = (w1 * o1 + w2 * o2 + w3 * o3 + w4 * o4 + 0.001 * c) / (w1 + w2 + w3 + w4 + 0.001) * v_vColour;
}

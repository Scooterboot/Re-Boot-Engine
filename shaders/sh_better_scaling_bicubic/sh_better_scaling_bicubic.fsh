varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec2 texel_size;

vec4 cubic(float v) {
    vec4 n = vec4(1.0, 2.0, 3.0, 4.0) - v;
    vec4 s = n * n * n;
    float x = s.x;
    float y = s.y - 4.0 * s.x;
    float z = s.z - 4.0 * s.y + 6.0 * s.x;
    float w = 6.0 - x - y - z;
    return vec4(x, y, z, w);
}

void main() {
    vec2 coord = v_vTexcoord / texel_size - 0.5;
    vec2 f = fract(coord);
    coord -= f;

    vec4 x_cubic = cubic(f.x);
    vec4 y_cubic = cubic(f.y);

    vec4 c = vec4(coord - 0.5, coord + 1.5);
    vec4 s = vec4(x_cubic.x + x_cubic.y, y_cubic.x + y_cubic.y, x_cubic.z + x_cubic.w, y_cubic.z + y_cubic.w);
    vec4 offset = c + vec4(x_cubic.y, y_cubic.y, x_cubic.w, y_cubic.w) / s;

    vec4 sample_0 = texture2D(gm_BaseTexture, offset.xy * texel_size);
    vec4 sample_1 = texture2D(gm_BaseTexture, offset.zy * texel_size);
    vec4 sample_2 = texture2D(gm_BaseTexture, offset.xw * texel_size);
    vec4 sample_3 = texture2D(gm_BaseTexture, offset.zw * texel_size);

    float t = s.x / (s.x + s.z);
    gl_FragColor = v_vColour * mix(mix(sample_3, sample_2, t), mix(sample_1, sample_0, t), s.y / (s.y + s.w));
}

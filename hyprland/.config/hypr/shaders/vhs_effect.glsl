precision mediump float;
varying vec2 v_texcoord;
uniform sampler2D tex;

// Function to create extremely soft scan lines
vec3 applyScanLines(vec3 color, float y) {
    float scanLine = 0.001 * sin(y * 30.0); // Extremely subtle scan line effect
    return color * (1.0 + scanLine);
}

void main() {
    vec4 color = texture2D(tex, v_texcoord);

    // Minimal distortion of color channels
    float rOffset = sin(v_texcoord.y * 5.0) * 0.001; // Minimal red channel offset
    float gOffset = sin(v_texcoord.y * 5.0 + 1.0) * 0.001; // Minimal green channel offset
    float bOffset = sin(v_texcoord.y * 5.0 + 2.0) * 0.001; // Minimal blue channel offset

    vec4 distortedColor = vec4(
        texture2D(tex, v_texcoord + vec2(rOffset, 0.0)).r,
        texture2D(tex, v_texcoord + vec2(gOffset, 0.0)).g,
        texture2D(tex, v_texcoord + vec2(bOffset, 0.0)).b,
        color.a
    );

    // Apply extremely soft scan lines
    vec3 finalColor = applyScanLines(distortedColor.rgb, v_texcoord.y);

    gl_FragColor = vec4(finalColor, color.a);
}

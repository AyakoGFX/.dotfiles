precision mediump float;
varying vec2 v_texcoord;
uniform sampler2D tex;
uniform float time; // Adding the time uniform for animation

// Function to create extremely soft scan lines
vec3 applyScanLines(vec3 color, float y) {
    float scanLine = 0.001 * sin(y * 30.0); // Extremely subtle scan line effect
    return color * (1.0 + scanLine);
}

// Function to generate grainy effect
float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    vec4 color = texture2D(tex, v_texcoord);
    
    // Convert to grayscale
    float gray = (color.r + color.g + color.b) / 3.0;
    vec3 grayscaleColor = vec3(gray);

    // Minimal distortion of color channels with slight animation
    float rOffset = sin(v_texcoord.y * 5.0 + time * 2.0) * 0.001; // Red channel offset
    float gOffset = sin(v_texcoord.y * 5.0 + time * 2.0 + 1.0) * 0.001; // Green channel offset
    float bOffset = sin(v_texcoord.y * 5.0 + time * 2.0 + 2.0) * 0.001; // Blue channel offset

    vec4 distortedColor = vec4(
        texture2D(tex, v_texcoord + vec2(rOffset, 0.0)).r,
        texture2D(tex, v_texcoord + vec2(gOffset, 0.0)).g,
        texture2D(tex, v_texcoord + vec2(bOffset, 0.0)).b,
        color.a
    );

    // Generate grainy effect
    float noise = rand(v_texcoord) * 0.01 - 0.005; // Adjust grain intensity
    vec3 finalColor = applyScanLines(grayscaleColor + vec3(noise), v_texcoord.y);

    gl_FragColor = vec4(finalColor, color.a);
}

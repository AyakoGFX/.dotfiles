precision mediump float;
varying vec2 v_texcoord;
uniform sampler2D tex;

// Simple random function based on UV coordinates
float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    vec4 color = texture2D(tex, v_texcoord);
    
    // Generate random noise
    float noise = rand(v_texcoord) * 0.1 - 0.05; // Adjust intensity

    // Apply noise to the image
    vec3 grainyColor = color.rgb + vec3(noise);

    gl_FragColor = vec4(grainyColor, color.a);
}

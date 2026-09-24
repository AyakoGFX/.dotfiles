#version 300 es
precision highp float;
in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;

// base hash
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453123);
}

// smooth interpolated noise (not hard pixel blocks)
float noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

// layered noise at a few scales = organic grain clumps instead of uniform static
float grainNoise(vec2 uv) {
    float n = 0.0;
    n += noise(uv * 1.0) * 0.5;
    n += noise(uv * 2.3) * 0.3;
    n += noise(uv * 4.7) * 0.2;
    return n;
}

void main() {
    vec4 pixColor = texture(tex, v_texcoord);

    // --- grayscale (perceptual luminance) ---
    float gray = dot(pixColor.rgb, vec3(0.299, 0.587, 0.114));

    // --- gentle contrast curve, like ink on paper ---
    gray = clamp((gray - 0.5) * 1.18 + 0.5, 0.0, 1.0);

    // --- posterize into a handful of gray "ink" levels ---
    float steps = 6.0;
    float posterized = floor(gray * steps + 0.5) / steps;

    // --- real film-style grain: layered noise, strongest in midtones ---
    float grainScale = 250.0; // lower = bigger grain clumps, higher = finer
    float grainAmount = 0.14; // overall strength
    float lumaMask = 1.0 - abs(posterized - 0.5) * 2.0; // grain fades out near pure black/white
    float grain = (grainNoise(v_texcoord * grainScale) - 0.5) * grainAmount * lumaMask;

    float finalGray = clamp(posterized + grain, 0.0, 1.0);

    // --- slight warm paper tint instead of pure neutral gray ---
    vec3 paper = mix(vec3(0.06, 0.05, 0.05), vec3(0.96, 0.95, 0.90), finalGray);

    fragColor = vec4(paper, pixColor.a);
}
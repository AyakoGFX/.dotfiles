#version 300 es
precision highp float;
in vec2 v_texcoord;
out vec4 fragColor;
uniform sampler2D tex;

void main() {
    vec4 pixColor = texture(tex, v_texcoord);
    vec3 inverted = vec3(1.0) - pixColor.rgb;
    fragColor = vec4(inverted, pixColor.a);
}
#version 300 es
precision highp float;
in vec2 v_texcoord;
uniform sampler2D tex;
out vec4 FragColor;
void main() {
    vec4 pixColor = texture(tex, v_texcoord);
   
    // Strong blue light filter: reduce blue channel and apply warm tint
    vec3 warm_tint = vec3(1.0, 0.45, 0.0); // Bias towards red/orange
    pixColor.rgb *= warm_tint;
    pixColor.b *= 0.1; // Further reduce blue intensity
   
    FragColor = pixColor;
}

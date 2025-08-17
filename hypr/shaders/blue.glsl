precision highp float;
varying vec2 v_texcoord;
uniform sampler2D tex;

void main() {
    vec4 pixColor = texture2D(tex, v_texcoord);
    
    // Strong blue light filter: reduce blue channel and apply warm tint
    vec3 warm_tint = vec3(1.0, 0.45, 0.0); // Bias towards red/orange
    pixColor.rgb *= warm_tint;
    pixColor.b *= 0.1; // Further reduce blue intensity
    
    gl_FragColor = pixColor;
}

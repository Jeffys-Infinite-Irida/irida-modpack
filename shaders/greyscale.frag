#pragma header

uniform float amt;

void main() {
    vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
    vec3 result = mix(color.rgb, vec3(dot(color.rgb, vec3(0.299, 0.587, 0.114))), amt);
    gl_FragColor = vec4(result, color.a);
}

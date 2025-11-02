#pragma header

#define round(a) floor(a + 0.5)
#define iResolution vec3(openfl_TextureSize, 0.0)
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D

uniform float r = 0.0;
uniform float g = 0.0;
uniform float b = 0.0;

uniform float threshold;
uniform float intensity;

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord.xy / iResolution.xy;
    vec3 color = texture(iChannel0, uv).rgb;
    float luminance = dot(color, vec3(0.299, 0.587, 0.114));
    vec3 modifiedColor = (luminance > threshold) ? vec3(r, g, b) : vec3(0.0, 0.0, 0.0);
    vec3 resultColor = mix(color, modifiedColor, step(0.01, threshold));
    fragColor = mix(vec4(resultColor, flixel_texture2D(bitmap, uv).w), flixel_texture2D(bitmap, uv), intensity);
}

void main() {
	mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}
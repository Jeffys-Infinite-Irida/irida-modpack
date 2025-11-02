#pragma header
vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main

uniform float Threshold;
uniform float Intensity;

vec4 blend(in vec2 Coord, in sampler2D Tex, in float MipBias) {
	vec2 TexelSize = MipBias/iResolution.xy;

	vec4 Color = texture(Tex, Coord);
    
    for (float i = 1.0; i <= 6.0; i += 1.0) {
        float inv = 1.0/i;
        Color += texture(Tex, Coord + vec2( TexelSize.x, TexelSize.y)*inv);
        Color += texture(Tex, Coord + vec2(-TexelSize.x, TexelSize.y)*inv);
        Color += texture(Tex, Coord + vec2( TexelSize.x,-TexelSize.y)*inv);
        Color += texture(Tex, Coord + vec2(-TexelSize.x,-TexelSize.y)*inv);
    }

	return Color/24.0;
}

void mainImage() {
	vec2 uv = (fragCoord.xy/iResolution.xy)*vec2(1.0,1.0);

	vec4 Color = texture(iChannel0, uv);

	vec4 Highlight = clamp(blend(uv, iChannel0, 4.0)-Threshold,0.0,1.0)*1.0/(1.0-Threshold);

	fragColor = 1.0-(1.0-Color)*(1.2-Highlight*Intensity);
}
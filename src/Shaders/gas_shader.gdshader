shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform vec4 base: source_color;
uniform sampler2D grain;
uniform float fps = 12.0;
uniform float PanY;
uniform float PanX;
uniform float grain_strength = 0.3;
uniform sampler2D vignette;
uniform float stretch = 0.5;

float make_grain(float time, vec2 uv) {
	vec2 ofs = vec2(PanX * time, PanY * time);
	return texture(grain, (uv + mod(ofs, vec2(1.0, 1.0))) * stretch).r;
}

void fragment() {
	vec4 c = textureLod(screen_texture, SCREEN_UV, 1.0).rgba;
	vec4 vignette_color = texture(vignette, UV).rgba;
	
	float v = dot(c, vec4(0.33333, 0.33333, 0.33333,0.33333));
	v = sqrt(v);
	
	float f =  (1.0 / fps);
	float g = make_grain(TIME - mod(TIME, f), SCREEN_UV);
	g = max(g, make_grain(TIME - mod(TIME, f) + f, UV) * 0.5);
	g = max(g, make_grain(TIME - mod(TIME, f) + f * 2.0, SCREEN_UV) * 0.25);
	
	COLOR.rgba = textureLod(screen_texture, SCREEN_UV, (1.0 - vignette_color.a) * 4.0).rgba;
	COLOR.rgba *= texture(vignette, UV).rgba;
	COLOR.rgba = base.rgba * v - vec4(g) * grain_strength;
	COLOR.rgba *= texture(vignette, UV).a;
	float ft = TIME * 0.002;
	
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

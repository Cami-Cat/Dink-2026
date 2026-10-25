shader_type spatial;

render_mode blend_add, depth_draw_never, cull_disabled;

uniform float fresnel_power : hint_range(0.1, 10.0) = 5.0;
uniform float edge_strength : hint_range(0.0, 10.0) = 4.0;
uniform float hue_speed : hint_range(0.0, 2.0) = 0.02;

varying vec3 world_pos;
vec3 hsv_to_rgb(vec3 hsv) {
	vec3 rgb = clamp(
		abs(mod(hsv.x * 6.0 + vec3(0.0, 4.0, 2.0), 6.0) - 3.0) - 1.0,
		0.0,
		1.0
	);
	
	rgb = rgb * rgb * (3.0 - 2.0 * rgb);
	
	return hsv.z * mix(vec3(1.0), rgb, hsv.y);
}
void vertex() {
	world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}
void fragment() {
	float fresnel = pow(
		1.0 - abs(dot(NORMAL, VIEW)),
		fresnel_power
	);
	fresnel = clamp(fresnel,0.0,1.0);
	float world_offset = (
	world_pos.x +
	world_pos.y +
	world_pos.z
) * 0.01;

float hue = fract(
	TIME * hue_speed +
	world_offset
);

	vec3 edge_color = hsv_to_rgb(
		vec3(
			hue,  // H
			1.0,  // S
			1.0   // V
		)
	);

	EMISSION = edge_color * fresnel * edge_strength;
	ALPHA = 0.2 + fresnel * 0.95;
}
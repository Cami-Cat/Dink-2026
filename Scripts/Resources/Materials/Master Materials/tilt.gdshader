shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;
uniform float tilt : hint_range(0.0, 1.0) = 0.4;

void fragment() {
	vec2 uv = SCREEN_UV;

	vec2 centered_uv = uv - vec2(0.5);

	float perspective = mix(
		1.0 + tilt,
		1.0 - tilt,
		uv.y
	);

	centered_uv.x /= perspective;
	centered_uv.y *= mix(
		0.9,
		1.1,
		uv.y
	);

	uv = centered_uv + vec2(0.5);

	if (
		uv.x < 0.0 || uv.x > 1.0 ||
		uv.y < 0.0 || uv.y > 1.0
	) {
		COLOR = vec4(0.0);
	} else {
		COLOR = texture(screen_texture, uv);
	}
}
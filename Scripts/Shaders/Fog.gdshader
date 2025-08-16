shader_type canvas_item;
uniform sampler2D noise_texture: repeat_enable, filter_nearest;
uniform float strength: hint_range(0.0, 1.0) = 0.25;
uniform float inverse_density: hint_range(1.0, 5.0) = 2.0;
uniform vec2 speed = vec2(-0.01, -0.02);
uniform float pixels : hint_range(200.0, 1920.0, 1.0) = 120.0;
uniform float number_of_shades: hint_range(1.0, 24.0, 1.0) = 8.0;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	//vec2 st = floor(UV/pixel_size)*pixel_size + speed * TIME;
	vec2 st = UV + speed * TIME;
	st = floor(st*pixels)/pixels;
	float noise = texture(noise_texture, st).r;
	float fog = clamp(noise * inverse_density - (inverse_density - 1.0), 0.0, 1.0);
	fog = floor(fog * number_of_shades - 1.0) / number_of_shades;
	COLOR.a *= fog * strength;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}

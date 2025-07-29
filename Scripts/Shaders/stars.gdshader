shader_type canvas_item;
uniform vec2 stars_speed = vec2(0.2,0.05);
uniform float stars_density: hint_range(0.0, 1.0, 0.001) = 0.002;

// 2D Random See: https://thebookofshaders.com/11/
float random (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123);
}
void vertex() {
	// Called for every vertex the material is visible on.
}

// Called on each pixel
void fragment() {
	vec2 st = UV.xy;
	st = floor(st * vec2(1920.,1080.)/5.); 
	st -= TIME * stars_speed;
	float brightness = step(random(floor(st)), stars_density);
	COLOR = COLOR * (1. - brightness) + vec4(255., 255., 255., 160.) * brightness;
}



//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}

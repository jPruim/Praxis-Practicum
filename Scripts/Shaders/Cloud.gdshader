shader_type canvas_item;
uniform vec2 stars_speed = vec2(0.1,0.0);
uniform float stars_density: hint_range(0.0, 1.0, 0.001) = 0.002;

// 2D Random See: 		https://thebookofshaders.com/11/
float random (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(12.9898,78.233)))*
        43758.5453123)*100.;
}
float hash(float p) { p = fract(p * 0.011); p *= p + 7.5; p *= p + p; return fract(p); }
float hash2d(vec2 p) {vec3 p3 = fract(vec3(p.xyx) * 0.13); p3 += dot(p3, p3.yzx + 3.333); return fract((p3.x + p3.y) * p3.z); }

// 2D Noise based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float custom_noise (vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Four corners in 2D of a tile
    float a = hash2d(i);
    float b = hash2d(i + vec2(1.0, 0.0));
    float c = hash2d(i + vec2(0.0, 1.0));
    float d = hash2d(i + vec2(1.0, 1.0));

    // Smoothing
    vec2 u = f*f*(3.0-2.0*f);

    // Mix 4 coorners percentages
    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}

float custom_partition(float value, float chunks){
	return floor(value * chunks)/chunks;
}

void vertex() {
	// Called for every vertex the material is visible on.
}

// Called on each pixel
void fragment() {
	vec2 st = VERTEX.xy;
	st *= 100.;
	st.x = custom_partition(st.x, 1920./600.);
	st.y = custom_partition(st.y, 1080./600.);
	st = (st
			+ TIME * stars_speed
			)
			//* TEXTURE_PIXEL_SIZE
			;
	float brightness = step( custom_noise(st), stars_density);
	COLOR = COLOR * (1. - brightness) + vec4(255., 255., 255., 160.) * brightness;
}



//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}

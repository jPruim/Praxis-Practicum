shader_type canvas_item;
uniform vec2 stars_speed = vec2(0.0,0.0);
uniform float stars_density: hint_range(0.0, 1.0, 0.001) = 0.002;

// 2D Random See: 		https://thebookofshaders.com/11/
float random (vec2 st) {
    return fract(sin(dot(st.xy,
                         vec2(23.98,98.233)))
                 * 43758.5453123)
				;
}
// 2D Noise based on Morgan McGuire @morgan3d
// https://www.shadertoy.com/view/4dS3Wd
float custom_noise (vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);

    // Four corners in 2D of a tile
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    // Smoothing
    vec2 u = f*f*(3.0-2.0*f);

    // Mix 4 coorners percentages
    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}

float custom_partition(float value, float chunks){
	return round(value * chunks)/ chunks;
}

void vertex() {
	// Called for every vertex the material is visible on.
}

// Called on each pixel
void fragment() {
	vec2 st = VERTEX;
	st.x = custom_partition(st.x, 400);
	st.y = custom_partition(st.y, 400);
	st = (st 
			+ TIME * stars_speed 
			)
			//* TEXTURE_PIXEL_SIZE
			;
	st = st * step(random(floor(st)), stars_density);
	COLOR = texture(TEXTURE,st);
    // Scale the coordinate system to see
    // some noise in action
    vec2 pos = vec2(st);

    // Use the noise function
    //float n = custom_noise(pos);
    //COLOR = vec4(vec3(n), 1.0);
	
	
}



//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}

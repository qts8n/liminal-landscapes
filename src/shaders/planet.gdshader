shader_type spatial;

const float EPS = 0.01;

uniform vec2 elevation_minmax;

uniform sampler2D regions;

varying vec3 local_pos;


float inverse_lerp_unclamped(float from, float to, float value) {
	return (value - from) / (to - from);
}


float inverse_lerp(float from, float to, float value) {
    return clamp(inverse_lerp_unclamped(from, to, value), EPS, 1);
}


void vertex() {
	local_pos = VERTEX;
}


void fragment() {
	float elevation = length(local_pos.xyz);

	float u = inverse_lerp(elevation_minmax.x, elevation_minmax.y, elevation);

	//ALBEDO = vec3(inverse_lerp(elevation_minmax.x, elevation_minmax.y, elevation));
	ALBEDO = texture(regions, vec2(u)).rgb;
}

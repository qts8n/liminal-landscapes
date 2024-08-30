shader_type spatial;

uniform vec4 elevation_minmax;

varying vec3 local_pos;


float inverse_lerp(float from, float to, float value) {
    return clamp((value - from) / (to - from), 0, 1);
}


void vertex() {
	local_pos = VERTEX;
}


void fragment() {
	float elevation = length(local_pos.xyz);
	
	ALBEDO = vec3(inverse_lerp(elevation_minmax.x, elevation_minmax.y, elevation));
}

shader_type spatial;
render_mode unshaded;

uniform sampler2D albedo_texture;


void vertex() {
	// TO DO - move quad to correct position
}


void fragment() {
	ALBEDO = texture(albedo_texture, UV).rgb;
}

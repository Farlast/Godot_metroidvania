shader_type canvas_item;

uniform vec4 color : source_color = vec4(0.0, 0.545, 1.0, 0.4);
uniform float blur_amount = 0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture,filter_linear_mipmap;


vec4 screen(vec4 base, vec4 blend){
	return 1.0 - (1.0 - base) * (1.0 - blend);
}

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	
	vec3 final_color = screen(texture(SCREEN_TEXTURE, SCREEN_UV,blur_amount), vec4(color)).rgb;
	COLOR = vec4(final_color,color.a);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}


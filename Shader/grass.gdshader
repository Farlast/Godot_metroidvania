shader_type canvas_item;
uniform float speed = 1;
uniform float wave_distance = 1;

void vertex() {
	// Called for every vertex the material is visible on.
	VERTEX.x += sin(TIME * speed) * wave_distance * (UV.y-1.0);
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

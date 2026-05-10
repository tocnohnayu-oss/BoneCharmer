shader_type canvas_item;

uniform float red = 0.0;
uniform float green = 0.0;
uniform float blue = 0.0;
uniform float alpha = 1.0;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
	if (COLOR.a != 0.0){
		COLOR.rgba = vec4(red, green, blue, alpha);
		}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}

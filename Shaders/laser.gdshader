shader_type spatial;

uniform sampler2D albedo : hint_default_white;
uniform float line_width = 1.0;
uniform float line_length = 1.0;
uniform bool correct_uv = true;

uniform vec4 color: source_color = vec4(1.0);
uniform float brightness = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
	VERTEX += vec3(0,0.5,0);

	VERTEX.y *= line_length;
	VERTEX.x *= line_width;

}

void fragment() {
	// Called for every pixel the material is visible on.
	 vec2 uv = UV;
	    if (correct_uv){
        uv.y *= line_length;
    }
 	vec4 _color = texture(albedo, uv);
	_color *= color;
	_color.r *= brightness;
	_color.g *= brightness;
	_color.b *= brightness;

	ALBEDO = vec3(_color.r, _color.g, _color.b);
	ALPHA = _color.a;
}

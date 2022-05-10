#version 330

// TODO: get values from fragment shader
in vec3 frag_color;
in vec3 frag_normal;
uniform float time;

float PI = 3.1415;
float TIME = time;
vec3 finalColor;
vec3 day_plane = vec3(0, 0.8, 0);
vec3 night_plane = vec3(0, 0.4, 0.3);
vec3 transaction_col;
layout(location = 0) out vec4 out_color;

void main()
{
	if(TIME >= 0 && TIME < PI){
		transaction_col = day_plane - night_plane;
		finalColor = night_plane + transaction_col * sin(TIME/2);

	}else if(TIME >= PI && TIME < 2 * PI){
		transaction_col = night_plane - day_plane;
		finalColor = day_plane - transaction_col * cos(TIME/2);
	}

	out_color = vec4(finalColor, 1.0);
}

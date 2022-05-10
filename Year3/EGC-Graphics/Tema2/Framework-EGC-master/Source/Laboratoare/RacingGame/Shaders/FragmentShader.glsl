#version 330

// TODO: get values from fragment shader
in vec3 frag_color;
in vec3 frag_normal;


uniform float time;


layout(location = 0) out vec4 out_color;

	float PI =3.1415;
	float TIME = time;

	vec3 night_color = vec3(0, 0, 0.25);
	vec3 morning_color = vec3(0.55, 0.55, 1);
	vec3 day_color = vec3(0.85, 0.85, 1);
	vec3 evening_color = vec3(0.3, 0, 0);
	vec3 Sky_color;
	vec3 transaction_color;

void main()
{
	if(TIME >= PI/2 && TIME < PI){
		transaction_color = day_color - morning_color;
		Sky_color = morning_color - transaction_color * cos(TIME);

	}else if(TIME >= PI && TIME < 3 * PI/ 2){
		transaction_color = evening_color - day_color;
		Sky_color = day_color - transaction_color * sin(TIME);

	}else if(TIME >= 3*PI/2 && TIME < 2 * PI){
		transaction_color = night_color - evening_color;
		Sky_color = evening_color + transaction_color* cos(TIME);

	}else if(TIME >= 0 && TIME < PI/2){
		transaction_color = morning_color - night_color;
		Sky_color = night_color +  transaction_color* sin(TIME);
	} 

	out_color = vec4(Sky_color, 1.0);

}
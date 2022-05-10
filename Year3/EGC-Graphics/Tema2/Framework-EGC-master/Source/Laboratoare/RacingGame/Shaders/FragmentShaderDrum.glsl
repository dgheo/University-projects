#version 330

// TODO: get values from fragment shader
in vec3 frag_color;
in vec3 frag_normal;

layout(location = 0) out vec4 out_color;


void main()
{
	// TODO: write pixel out color
	//vec3 culoare_drum = vec3(0.5,0.5,0.5);
	out_color = vec4(frag_normal, 1.0);

}

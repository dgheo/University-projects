#version 330

// TODO: get color value from vertex shader
in vec3 world_position;
in vec3 world_normal;

// Uniforms for light properties
uniform vec3 light_direction;
uniform vec3 light_position;
uniform vec3 eye_position;

uniform float material_kd;
uniform float material_ks;
uniform int material_shininess;

uniform vec3 object_color;
uniform int spot;

layout(location = 0) out vec4 out_color;

void main()
{

	vec3 L = normalize(light_position - world_position);
	vec3 V = normalize(eye_position - world_position);
	vec3 H = normalize(L + V);

	// TODO: define ambient light component
	float ambient_light = 0.25;
	ambient_light  *= material_kd;
	// TODO: compute diffuse light component
	float diffuse_light = 0;
	diffuse_light = material_kd * 1 * max(dot(world_normal, L), 0);


	// TODO: compute specular light component
	float specular_light = 0;

	if (diffuse_light > 0)
	{
		specular_light = material_ks * 1 * pow(max(dot(V, reflect(-L,world_normal)), 0), material_shininess); // # GLSL
	}

	// TODO: compute light
	float d = distance(light_position, world_position);
	
	float cut_off = radians(30.0f);
	float spot_light = dot(-L, light_direction);
	float spot_light_limit = cos(cut_off);

	// Quadratic attenuation
	float linear_att = (spot_light - spot_light_limit) / (1 - spot_light_limit);
	float light_att_factor = pow(linear_att, 2);

	float light = ambient_light + (diffuse_light + specular_light) * 1 / pow(d, 2);

	if (spot == 0) {

		out_color = vec4(light*object_color, 1);

	}
	else {
		if (spot_light > cos(cut_off))
		{
			// fragmentul este iluminat de spot, deci se calculeaza valoarea luminii conform  modelului Phong
			// se calculeaza atenuarea luminii
			out_color = vec4((ambient_light + (diffuse_light + specular_light) * light_att_factor)*object_color, 1);
		}
		else {
			out_color = vec4(ambient_light*object_color, 1);
		}

	}

	// TODO: write pixel out color
	//out_color = vec4(1);
	//out_color = vec4(light*object_color,1);

}
#version 330

layout(location = 0) in vec3 v_position;
layout(location = 1) in vec3 v_normal;
layout(location = 2) in vec2 v_texture_coord;

// Uniform properties
uniform mat4 Model;
uniform mat4 View;
uniform mat4 Projection;

// Uniforms for light properties
uniform vec3 light_position;
uniform vec3 eye_position;
uniform float material_kd;
uniform float material_ks;
uniform int material_shininess;

uniform vec3 object_color;

// Output value to fragment shader
out vec3 color;

void main()
{	
	// TODO: compute world space vectors
	vec3 world_pos = (Model * vec4(v_position, 1)).xyz;
	vec3 world_normal = normalize( mat3(Model) * v_normal );

	vec3 L = normalize( light_position - world_pos );
	vec3 V = normalize( eye_position - world_pos );
	vec3 H = normalize( L + V );

	// TODO: define ambient light component
	float ambient_light = 0.25;

	// TODO: compute diffuse light component
	float diffuse_light = material_kd * max(dot(v_normal, L),0);

	// TODO: compute specular light component
	vec3 R = reflect(L, v_normal);
	float primeste_lumina = 0;
	if (diffuse_light > 0)
	{
		 primeste_lumina = 1;
	}
	float specular_light = material_ks * primeste_lumina * pow(max(dot(V, R), 0), material_shininess);
	float factor_atenuare = 1/pow(distance(world_pos, light_position), 2);

	float light = ambient_light +factor_atenuare * (diffuse_light + specular_light);
	// TODO: compute light
	color = light * object_color;
	// TODO: send color light output to fragment shader
	gl_Position = Projection * View * Model * vec4(v_position, 1.0);
}

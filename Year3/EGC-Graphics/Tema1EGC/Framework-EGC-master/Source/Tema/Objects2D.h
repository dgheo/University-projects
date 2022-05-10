#pragma once

#include <string>

#include <include/glm.h>
#include <Core/GPU/Mesh.h>

const float PI = 3.14159265358979f;
namespace Objects2D
{

	// Create square with given bottom left corner, length and color
	//Mesh* makeCircle(std::string name, int n, float r, glm::vec3 center);
	Mesh* makeTriangle(float length, glm::vec3 center);
	Mesh* makePlatform(std::string name, glm::vec3 leftBottomCorner, float length, float heigth, glm::vec3 color, bool fill);
}
#include "Objects2D.h"
#include <Core/Engine.h>
#include <include/glm.h>
#include <vector>
#include <iostream>


/*Mesh* Objects2D::makeCircle(std::string name, int n, float r, glm::vec3 center) {
	float angle = 2 * PI / (int)n;
	glm::vec3 coordRaza = center + glm::vec3(r, 1, 1);
	std:: vector<VertexFormat> vertices;
	std:: vector<unsigned short> indices;
	vertices.push_back(VertexFormat(center, glm::vec3(1, 0, 1)));
	for (int i = 0; i < n; i++) {
		vertices.push_back(VertexFormat(coordRaza, glm::vec3(0, 1, 1)));
		coordRaza = Transform2D::Rotate(angle) * coordRaza;
		indices.push_back(0);
		indices.push_back(i + 1);
		indices.push_back(i + 2);
	}

	indices.push_back(0);
	indices.push_back(n);
	indices.push_back(1);

	Mesh* circle = new Mesh(name);
	circle->InitFromData(vertices, indices);

	return circle;
}
*/
Mesh* Objects2D::makeTriangle(float length, glm::vec3 center) {
	float h = length * sqrt(3) / (float)2;
	std::vector<VertexFormat> vertices = {
		VertexFormat(center + glm::vec3(0, 2 * h / 3, 0), glm::vec3(1, 0, 0)),
		VertexFormat(center + glm::vec3(-length / 2, -h / 3, 0), glm::vec3(0, 1, 0)),
		VertexFormat(center + glm::vec3(length / 2, -h / 3, 0), glm::vec3(0, 1, 0))
	};

	std::vector<unsigned short> indices = { 0, 1, 2 };

	Mesh *triangle = new Mesh("triangle");
	triangle->InitFromData(vertices, indices);
	return triangle;
}


Mesh* Objects2D::makePlatform(std::string name, glm::vec3 leftBottomCorner, float length, float heigth, glm::vec3 color, bool fill)
{
	glm::vec3 corner = leftBottomCorner;

	std::vector<VertexFormat> vertices =
	{
		VertexFormat(corner, color),
		VertexFormat(corner + glm::vec3(length, 0, 0), color),
		VertexFormat(corner + glm::vec3(length, heigth, 0), color),
		VertexFormat(corner + glm::vec3(0, heigth, 0), color)
	};

	Mesh* square = new Mesh(name);
	std::vector<unsigned short> indices = { 0, 1, 2, 3 };

	if (!fill) {
		square->SetDrawMode(GL_LINE_LOOP);
	}
	else {
		// draw 2 triangles. Add the remaining 2 indices
		indices.push_back(0);
		indices.push_back(2);
	}

	square->InitFromData(vertices, indices);
	return square;
}
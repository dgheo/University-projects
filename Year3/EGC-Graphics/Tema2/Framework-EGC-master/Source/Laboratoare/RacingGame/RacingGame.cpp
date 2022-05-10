#include "RacingGame.h"
#include <stdlib.h>
#include <stdio.h>
#include <fstream>
#include <vector>
#include <string>
#include <Core/Engine.h>

using namespace std;



RacingGame::RacingGame()
{
	std::ifstream ins;
	ins.open("Drum.txt");
	if (ins.fail()) {
		std::cout << "Nu se citeste fisierul cu date drum" << std::endl;
	}

	//citire fisier
	int numar_de_segmente;
	ins >> numar_de_segmente;
	configuratie = new int[numar_de_segmente];
	int start = 0;
	numar_de_cuburi = numar_de_segmente / distanta_intre_cuburi;


	while (!ins.eof()) {
		int numar_segment_in_directie;
		int directia;
		ins >> numar_segment_in_directie;
		ins >> directia;
		for (int i = start; i < start + numar_segment_in_directie; i++) {
			configuratie[i] = directia;
		}

		start = start + numar_segment_in_directie;
	}
	ins.close();
	//Translatari si scalari specicifice unui segment de drum
	glm::mat4 modelMatrix = glm::mat4(1);
	glm::mat4 translateOnly = glm::mat4(1);
	modelMatrix = glm::translate(modelMatrix, glm::vec3(0, 0, 0));
	modelMatrix *= Transform3D::Translate(-15.0f, 0.1f, 8.5f);
	modelMatrix *= Transform3D::Scale(15.0f, 0.9f, 0.1f);

	//Copiere prim segment in vectorii de model matrix primu se foloseste la generare drum al 2lea la generare obiecte pe drum
	modelMatrices.push_back(modelMatrix);
	translateOnlyMats.push_back(translateOnly);
	//construire drum conform datelor din fisier
	for (int i = 0; i < numar_de_segmente; i++) {
		

		if (configuratie[i] == 1) {
			translateOnly = glm::translate(translateOnly, glm::vec3(0, 0, 2.3*0.1));
			modelMatrix = glm::translate(modelMatrix, glm::vec3(0, 0, 2.3));
		}
		if (configuratie[i] == 2) {
			translateOnly = glm::translate(translateOnly, glm::vec3(0.01*15, 0, 2.3*0.1));
			modelMatrix = glm::translate(modelMatrix, glm::vec3(0.01, 0, 2.3));
		}
		if (configuratie[i] == 3) {
			translateOnly = glm::translate(translateOnly, glm::vec3(-0.01*15, 0, 2.3*0.1));
			modelMatrix = glm::translate(modelMatrix, glm::vec3(-0.01, 0, 2.3));
		}
		modelMatrices.push_back(modelMatrix);
		translateOnlyMats.push_back(translateOnly);
	}
	//construire model matrix obiecte drum
	for (int i = distanta_intre_cuburi, j = 0; i < translateOnlyMats.size(); i = i + distanta_intre_cuburi, j++) {
		if (j % 2 == 0) {
			translateOnlyMats[i] = glm::translate(translateOnlyMats[i], glm::vec3(5, 0, 0));
		}
		else {
			translateOnlyMats[i] = glm::translate(translateOnlyMats[i], glm::vec3(-5, 0, 0));
		}
	}
}

RacingGame::~RacingGame()
{
}

Mesh* RacingGame::CreateSquare(std::string name, glm::vec3 leftBottomCorner, float length, glm::vec3 color, bool fill)
{
	glm::vec3 corner = leftBottomCorner;

	std::vector<VertexFormat> vertices =
	{
		VertexFormat(corner, color),
		VertexFormat(corner + glm::vec3(length, 0, 0), color),
		VertexFormat(corner + glm::vec3(length, length, 0), color),
		VertexFormat(corner + glm::vec3(0, length, 0), color)
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
void RacingGame::Init()
{
	angularStep = 0;

	renderCameraTarget = true;			//folosita la schimbare camera third -firs person (tasta C)

	camera = new Camera();
	camera->Set(glm::vec3(0.0f, 2.8f, -8.0f), glm::vec3(0, 0, 0), glm::vec3(0, 1, 0));//Setare initiala camera
	
	//incarcarea obiectelor din obj-uri si crearea altor obiecte noi(cube)
	{
		Mesh* masina = new Mesh("masina");
		masina->LoadMesh(RESOURCE_PATH::MODELS + "Primitives", "masina.obj");
		meshes[masina->GetMeshID()] = masina;
	}


	Mesh* square1 = RacingGame::CreateSquare("square1", glm::vec3(0, 0, 0), 100, glm::vec3(0, 1, 0), true);
	AddMeshToList(square1);
	
	{
		Mesh* road = new Mesh("road");
		road->LoadMesh(RESOURCE_PATH::MODELS + "Primitives", "roadV2.obj");
		meshes[road->GetMeshID()] = road;

		Mesh* disk1s = new Mesh("disk1s");
		disk1s->LoadMesh(RESOURCE_PATH::MODELS + "Primitives", "disk.obj");
		meshes[disk1s->GetMeshID()] = disk1s;
	}
	{
		Mesh* disk1d = new Mesh("disk1d");
		disk1d->LoadMesh(RESOURCE_PATH::MODELS + "Primitives", "disk.obj");
		meshes[disk1d->GetMeshID()] = disk1d;
	}
	{
		Mesh* disk2s = new Mesh("disk2s");
		disk2s->LoadMesh(RESOURCE_PATH::MODELS + "Primitives", "disk.obj");
		meshes[disk2s->GetMeshID()] = disk2s;
	}
	{
		Mesh* disk2d = new Mesh("disk2d");
		disk2d->LoadMesh(RESOURCE_PATH::MODELS + "Primitives", "disk.obj");
		meshes[disk2d->GetMeshID()] = disk2d;
	}
	
	// Create a simple cube
	{
		vector<VertexFormat> vertices
		{
			VertexFormat(glm::vec3(-1, -1,  1), glm::vec3(0, 1, 1), glm::vec3(0.35, 0.87, 1)),
			VertexFormat(glm::vec3(1, -1,  1), glm::vec3(1, 0, 1), glm::vec3(0.35, 0.87, 1)),
			VertexFormat(glm::vec3(-1,  1,  1), glm::vec3(1, 0, 0), glm::vec3(0.35, 0.87, 1)),
			VertexFormat(glm::vec3(1,  1,  1), glm::vec3(0, 1, 0), glm::vec3(0.35, 0.87, 1)),
			VertexFormat(glm::vec3(-1, -1, -1), glm::vec3(1, 1, 1), glm::vec3(0.35, 0.87, 1)),
			VertexFormat(glm::vec3(1, -1, -1), glm::vec3(0, 1, 1), glm::vec3(0.35, 0.87, 1)),
			VertexFormat(glm::vec3(-1,  1, -1), glm::vec3(1, 1, 0), glm::vec3(0.35, 0.87, 1)),
			VertexFormat(glm::vec3(1,  1, -1), glm::vec3(0, 0, 1), glm::vec3(0.35, 0.87, 1)),
		};

		vector<unsigned short> indices =
		{
			0, 1, 2,		1, 3, 2,
			2, 3, 7,		2, 7, 6,
			1, 7, 3,		1, 5, 7,
			6, 7, 4,		7, 5, 4,
			0, 4, 1,		1, 4, 5,
			2, 6, 4,		0, 2, 4,
		};

		CreateMesh("cube", vertices, indices);
	}

	// Create a shader program for drawing face polygon with the color of the normal
	{
		Shader *shader = new Shader("ShaderIarba");
		shader->AddShader("Source/Laboratoare/RacingGame/Shaders/VertexShaderPamant.glsl", GL_VERTEX_SHADER);
		shader->AddShader("Source/Laboratoare/RacingGame/Shaders/FragmentShaderPamant.glsl", GL_FRAGMENT_SHADER);
		shader->CreateAndLink();
		shaders[shader->GetName()] = shader;
	}
	{
		Shader *shader = new Shader("ShaderCicluZi");
		shader->AddShader("Source/Laboratoare/RacingGame/Shaders/VertexShader.glsl", GL_VERTEX_SHADER);
		shader->AddShader("Source/Laboratoare/RacingGame/Shaders/FragmentShader.glsl", GL_FRAGMENT_SHADER);
		shader->CreateAndLink();
		shaders[shader->GetName()] = shader;
	}
	{
		Shader *shader = new Shader("ShaderDrum");
		shader->AddShader("Source/Laboratoare/RacingGame/Shaders/VertexShaderDrum.glsl", GL_VERTEX_SHADER);
		shader->AddShader("Source/Laboratoare/RacingGame/Shaders/FragmentShaderDrum.glsl", GL_FRAGMENT_SHADER);
		shader->CreateAndLink();
		shaders[shader->GetName()] = shader;
	}
	projectionMatrix = glm::perspective(RADIANS(60), window->props.aspectRatio, 0.01f, 2000.0f);

}


Mesh* RacingGame::CreateMesh(const char *name, const std::vector<VertexFormat> &vertices, const std::vector<unsigned short> &indices)
{
	unsigned int VAO = 0;
	//Create the VAO and bind it
	glGenVertexArrays(1, &VAO);
	glBindVertexArray(VAO);

	// Create the VBO and bind it
	unsigned int VBO;
	glGenBuffers(1, &VBO);
	glBindBuffer(GL_ARRAY_BUFFER, VBO);

	// Send vertices data into the VBO buffer
	glBufferData(GL_ARRAY_BUFFER, sizeof(vertices[0]) * vertices.size(), &vertices[0], GL_STATIC_DRAW);

	// Crete the IBO and bind it
	unsigned int IBO;
	glGenBuffers(1, &IBO);
	glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, IBO);

	// Send indices data into the IBO buffer
	glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices[0]) * indices.size(), &indices[0], GL_STATIC_DRAW);

	// ========================================================================
	// This section describes how the GPU Shader Vertex Shader program receives data

	// set vertex position attribute
	glEnableVertexAttribArray(0);
	glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, sizeof(VertexFormat), 0);

	// set vertex normal attribute
	glEnableVertexAttribArray(1);
	glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, sizeof(VertexFormat), (void*)(sizeof(glm::vec3)));

	// set texture coordinate attribute
	glEnableVertexAttribArray(2);
	glVertexAttribPointer(2, 2, GL_FLOAT, GL_FALSE, sizeof(VertexFormat), (void*)(2 * sizeof(glm::vec3)));

	// set vertex color attribute
	glEnableVertexAttribArray(3);
	glVertexAttribPointer(3, 3, GL_FLOAT, GL_FALSE, sizeof(VertexFormat), (void*)(2 * sizeof(glm::vec3) + sizeof(glm::vec2)));
	// ========================================================================

	// Unbind the VAO
	glBindVertexArray(0);

	// Check for OpenGL errors
	CheckOpenGLError();

	// Mesh information is saved into a Mesh object
	meshes[name] = new Mesh(name);
	meshes[name]->InitFromBuffer(VAO, static_cast<unsigned short>(indices.size()));
	meshes[name]->vertices = vertices;
	meshes[name]->indices = indices;
	return meshes[name];
}


void RacingGame::FrameStart()
{
	// clears the color buffer (using the previously set color) and depth buffer
	glClearColor(0, 0, 0, 1);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	glm::ivec2 resolution = window->GetResolution();
	// sets the screen area where to draw
	glViewport(0, 0, resolution.x, resolution.y);
}

void RacingGame::Update(float deltaTimeSeconds)
{
	//caluculare timp pentru schimbare shadere(pamant si cer)
	if (time >= 2 * 3.1415) {
		time = 0;
	}
	time = time + deltaTimeSeconds;

	glm::ivec2 resolution = window->GetResolution();
	// sets the screen area where to draw
	glViewport(0, 0, resolution.x, resolution.y);
	//desenare drum
	for (int i = 0; i < modelMatrices.size(); i++) {
		RenderSimpleMesh(meshes["road"], shaders["ShaderDrum"], modelMatrices[i]);
	}
	//variabile folosite pentru calculare distanta pe OZ si OX
	distance = distance + deltaTimeSeconds * velocity;
	distancePer = distancePer + deltaTimeSeconds * velocityPer;

	//Camera first person
	camera->Set(glm::vec3(0.0f, 2.8f, -8.0f), glm::vec3(0, 0, 0), glm::vec3(0, 1, 0));
	if (!renderCameraTarget) {
		camera->TranslateForward(9);
		camera->TranslateUpword(-1.3);
	}
	//Camera third person
	camera->TranslateForward(distance);
	camera->TranslateRight(-distancePer);
	angularStepX += deltaTimeSeconds * velocity;
	//Calculare unghi de rotire a partii din fata a masinii la hold A sau D
	if (angularStep + deltaTimeSeconds * unghi_rotatie< RADIANS(20) && angularStep + deltaTimeSeconds * unghi_rotatie >  -RADIANS(20)) {
		angularStep = angularStep + deltaTimeSeconds * unghi_rotatie;
	}

	//rotire camera firs person cu unghi rotire masina
	if (!renderCameraTarget) {
		camera->RotateFirstPerson_OY(angularStep);
	}
	 //desenare masina 
	{
		glm::mat4 modelMatrix = glm::mat4(1);
		modelMatrix = glm::translate(modelMatrix, glm::vec3(distancePer, 0, distance));
		modelMatrix *= Transform3D::Translate(0.0f, 0.8f, -1.75f);
		modelMatrix *= Transform3D::Scale(0.3f, 0.3f, 0.3f);
		modelMatrix *= Transform3D::RotateOY(angularStep);

		RenderSimpleMesh(meshes["masina"], shaders["VertexNormal"], modelMatrix);
	}
	//desenare roti
	{
		glm::mat4 modelMatrix = glm::mat4(1);

		modelMatrix = glm::translate(modelMatrix, glm::vec3(distancePer, 0, distance));
		modelMatrix *= Transform3D::Translate(0.0f, +0.8f, -1.75f);
		modelMatrix *= Transform3D::RotateOY(angularStep);
		modelMatrix *= Transform3D::Translate(0.0f, -0.8f, +1.75f);

		modelMatrix *= Transform3D::Translate(1.1f, 0.43f, 0.0f);
		modelMatrix *= Transform3D::Scale(0.85f, 0.85f, 0.85f);
		modelMatrix *= Transform3D::RotateOY(30);
		modelMatrix *= Transform3D::RotateOY(angularStep);

		modelMatrix = glm::rotate(modelMatrix, -angularStepX, glm::vec3(0, 0, 1));

		RenderSimpleMesh(meshes["disk1s"], shaders["VertexNormal"], modelMatrix); //roata fata stanga
	}
	{
		glm::mat4 modelMatrix = glm::mat4(1);

		modelMatrix = glm::translate(modelMatrix, glm::vec3(distancePer, 0, distance));


		modelMatrix *= Transform3D::Translate(0.0f, +0.8f, -1.75f);
		modelMatrix *= Transform3D::RotateOY(angularStep);
		modelMatrix *= Transform3D::Translate(0.0f, -0.8f, +1.75f);

		modelMatrix *= Transform3D::Translate(-1.1f, 0.43f, 0.0f);
		modelMatrix *= Transform3D::Scale(0.85f, 0.85f, 0.85f);
		modelMatrix *= Transform3D::RotateOY(-30);
		modelMatrix *= Transform3D::RotateOY(angularStep);

		modelMatrix = glm::rotate(modelMatrix, angularStepX, glm::vec3(0, 0, 1));

		RenderSimpleMesh(meshes["disk1d"], shaders["VertexNormal"], modelMatrix);//roata fata dreapta
	}
	{
		glm::mat4 modelMatrix = glm::mat4(1);
		modelMatrix = glm::translate(modelMatrix, glm::vec3(distancePer, 0, distance));

		modelMatrix *= Transform3D::Translate(0.0f, +0.8f, -1.75f);
		modelMatrix *= Transform3D::RotateOY(angularStep);
		modelMatrix *= Transform3D::Translate(0.0f, -0.8f, +1.75f);

		modelMatrix *= Transform3D::Translate(1.1f, 0.43f, -3.5f);
		modelMatrix *= Transform3D::Scale(0.85f, 0.85f, 0.85f);
		modelMatrix *= Transform3D::RotateOY(-30);
		modelMatrix *= Transform3D::RotateOY(angularStep);
		modelMatrix = glm::rotate(modelMatrix, angularStepX, glm::vec3(0, 0, 1));

		RenderSimpleMesh(meshes["disk2s"], shaders["VertexNormal"], modelMatrix);//roata spate stanga
	}
	{
		glm::mat4 modelMatrix = glm::mat4(1);
		modelMatrix = glm::translate(modelMatrix, glm::vec3(distancePer, 0, distance));

		modelMatrix *= Transform3D::Translate(0.0f, +0.8f, -1.75f);
		modelMatrix *= Transform3D::RotateOY(angularStep);
		modelMatrix *= Transform3D::Translate(0.0f, -0.8f, +1.75f);

		modelMatrix *= Transform3D::Translate(-1.1f, 0.43f, -3.5f);
		modelMatrix *= Transform3D::Scale(0.85f, 0.85f, 0.85f);
		modelMatrix *= Transform3D::RotateOY(30);
		modelMatrix *= Transform3D::RotateOY(angularStep);

		modelMatrix = glm::rotate(modelMatrix, -angularStepX, glm::vec3(0, 0, 1));

		RenderSimpleMesh(meshes["disk2d"], shaders["VertexNormal"], modelMatrix);//roata spate dreapta

	}


	{//desenare cub mare in interiorul caruia sunt amplasate obiecte si scena de joc
		glm::mat4 modelMatrix = glm::mat4(1);
		modelMatrix = glm::translate(modelMatrix, glm::vec3(distancePer, 0, distance));
		modelMatrix = glm::scale(modelMatrix, glm::vec3(100, 100, 100));
		RenderSimpleMesh(meshes["cube"], shaders["ShaderCicluZi"], modelMatrix);//shader cub

	}
	{//desenare plan verde care reprezinta iarba pamantul
		glm::mat4 modelMatrix = glm::mat4(1);
		modelMatrix *= Transform3D::Translate(-100, 0, -100);
		modelMatrix *= Transform3D::Scale(1000, 1, 1000);
		modelMatrix = glm::rotate(modelMatrix, RADIANS(90), glm::vec3(1, 0, 0));

		RenderSimpleMesh(meshes["square1"], shaders["ShaderIarba"], modelMatrix);
	}
	//desenare obstavole pe drum 
	for (int i = distanta_intre_cuburi; i < translateOnlyMats.size(); i = i + distanta_intre_cuburi) {
		RenderSimpleMesh(meshes["cube"], shaders["VertexColor"], translateOnlyMats[i]);

	}
}

void RacingGame::FrameEnd()
{
	DrawCoordinatSystem(camera->GetViewMatrix(), projectionMatrix);

}

void RacingGame::RenderSimpleMesh(Mesh *mesh, Shader *shader, const glm::mat4 & modelMatrix)
{
	if (!mesh || !shader || !shader->GetProgramID())
		return;

	// render an object using the specified shader and the specified position
	glUseProgram(shader->program);

	// get shader location for uniform mat4 "Model"
	GLint ModelLocation = shader->GetUniformLocation("Model");
	//set shader uniform "Model" to modelMatrix
	glUniformMatrix4fv(ModelLocation, 1, GL_FALSE, glm::value_ptr(modelMatrix));
	//  get shader location for uniform mat4 "View"
	GLint ModelView = shader->GetUniformLocation("View");
	// set shader uniform "View" to viewMatrix
	glm::mat4 viewMatrix = camera->GetViewMatrix();

	// get shader location for uniform mat4 "Projection"
	GLint ModelPojection = shader->GetUniformLocation("Projection");
	// set shader uniform "Projection" to projectionMatrix
	glUniformMatrix4fv(ModelPojection, 1, GL_FALSE, glm::value_ptr(projectionMatrix));
	glUniformMatrix4fv(ModelView, 1, GL_FALSE, glm::value_ptr(viewMatrix));
	// Draw the object

	GLint TimeLocation = shader->GetUniformLocation("time");
	glUniform1f(TimeLocation, time);

	glBindVertexArray(mesh->GetBuffers()->VAO);
	glDrawElements(mesh->GetDrawMode(), static_cast<int>(mesh->indices.size()), GL_UNSIGNED_SHORT, 0);
}

// Documentation for the input functions can be found in: "/Source/Core/Window/InputController.h" or
// https://github.com/UPB-Graphics/Framework-EGC/blob/master/Source/Core/Window/InputController.h

void RacingGame::OnInputUpdate(float deltaTime, int mods)
{	//Setare butoare A-dreapta W-accelerare in fata S-reducere viteza si accelerare in spate D-varare dreapta
	if (window->KeyHold(GLFW_KEY_W)) {
		velocity = velocity + deltaTime * 15;
		unghi_rotatie = 0;
	}

	if (window->KeyHold(GLFW_KEY_S)) {
		velocity = velocity - deltaTime * 15;
		unghi_rotatie = 0;
	}

	if (window->KeyHold(GLFW_KEY_D)) {
		velocityPer = velocityPer - deltaTime * 25;
		unghi_rotatie = -5;
	}
	
	if (window->KeyHold(GLFW_KEY_A)) {
		velocityPer = velocityPer + deltaTime * 25;
		unghi_rotatie = 5;

	
	}
	if (window->KeyHold(GLFW_KEY_F)) {
		camera->Set(glm::vec3(0.0f, 2.8f, -8.0f), glm::vec3(0, 0, 0), glm::vec3(0, 1, 0));
	}

}

void RacingGame::OnKeyPress(int key, int mods)
{//Setare buton schimbare camera third to first sau invers tasta C
	if (key == GLFW_KEY_C) {
		if (renderCameraTarget) {
			renderCameraTarget = false;
		}
		else {
			renderCameraTarget = true;
		}
	}
	//Afisare scor
	std::cout << "Scorul este:" << (int)distance << std::endl;
}

void RacingGame::OnKeyRelease(int key, int mods)
{
	// add key release event
}

void RacingGame::OnMouseMove(int mouseX, int mouseY, int deltaX, int deltaY)
{
	// add mouse move event
}

void RacingGame::OnMouseBtnPress(int mouseX, int mouseY, int button, int mods)
{
	// add mouse button press event
}

void RacingGame::OnMouseBtnRelease(int mouseX, int mouseY, int button, int mods)
{
	// add mouse button release event
}

void RacingGame::OnMouseScroll(int mouseX, int mouseY, int offsetX, int offsetY)
{
}

void RacingGame::OnWindowResize(int width, int height)
{
}

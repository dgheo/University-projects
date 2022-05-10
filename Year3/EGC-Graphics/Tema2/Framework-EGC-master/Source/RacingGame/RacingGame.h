#pragma once
#include <Component/SimpleScene.h>
#include <Core/GPU/Mesh.h>
#include "Transform3D.h"
#include "Camera.h"
#include <Laboratoare\Laborator3\Object2D.h>

class RacingGame : public SimpleScene
{
public:
	RacingGame();
	~RacingGame();

	void Init() override;

	Mesh * CreateMesh(const char * name, const std::vector<VertexFormat> &vertices, const std::vector<unsigned short> &indices);

private:
	void OnInputUpdate(float deltaTime, int mods) override;
	void OnKeyPress(int key, int mods) override;
	void OnKeyRelease(int key, int mods) override;
	void OnMouseMove(int mouseX, int mouseY, int deltaX, int deltaY) override;
	void OnMouseBtnPress(int mouseX, int mouseY, int button, int mods) override;
	void OnMouseBtnRelease(int mouseX, int mouseY, int button, int mods) override;
	void OnMouseScroll(int mouseX, int mouseY, int offsetX, int offsetY) override;
	void OnWindowResize(int width, int height) override;

	float velocity = 0;
	float distance = 0;
	float angularStep = 0;
	float velocityPer = 0;
	float distancePer = 0;

	Camera *camera;
	glm::mat4 projectionMatrix;
	bool renderCameraTarget;

	bool perspectiva;
	float variabila;

	std::vector<glm::mat4> modelMatrices;
	std::vector<glm::mat4> modelMatricesCube;
	std::vector<glm::mat4> translateOnlyMats;


	int *configuratie;
	int numar_de_segmente;
	int numar_de_cuburi;
	int distanta_intre_cuburi = 200;
	float unghi_rotatie = 0;
	float angularStepX = 0;
	float time = 0;

	void FrameStart() override;
	void Update(float deltaTimeSeconds) override;
	void FrameEnd() override;

	void RenderSimpleMesh(Mesh *mesh, Shader *shader, const glm::mat4 &modelMatrix);

};

#pragma once

#include <Component/SimpleScene.h>
#include <string>
#include <Core/Engine.h>
#include "Collision.h"
#include "RectangleCollision.h"

class  Astrokitty : public SimpleScene
{
public:
	Astrokitty();
	~Astrokitty();
	const float PI = 3.14159265358979f;

	void Init() override;

private:

	//Mesh* makeTriangle(float length, glm::vec3 center);
	Mesh* makeCircle(std::string name, int n, float r, glm::vec3 center);
	//Mesh* makePlatform(std::string name, glm::vec3 leftBottomCorner, float length, float heigth, glm::vec3 color, bool fill);*/
	void FrameStart() override;
	void Update(float deltaTimeSeconds) override;
	void FrameEnd() override;
	bool Coliziune(Collision a, Collision b);

	void OnInputUpdate(float deltaTime, int mods) override;
	void OnKeyPress(int key, int mods) override;
	void OnKeyRelease(int key, int mods) override;
	void OnMouseMove(int mouseX, int mouseY, int deltaX, int deltaY) override;
	void OnMouseBtnPress(int mouseX, int mouseY, int button, int mods) override;
	void OnMouseBtnRelease(int mouseX, int mouseY, int button, int mods) override;
	void OnMouseScroll(int mouseX, int mouseY, int offsetX, int offsetY) override;
	void OnWindowResize(int width, int height) override;

protected:
	glm::mat3 modelMatrix;
	glm::vec3 trianglePos;

	float translateX, translateY, scaleX, scaleY;
	float h;

	bool incrementTranslateX, incrementTranslateY, incrementScaleX, incrementScaleY;

	float angle;
	float angularStep;
	bool moving, window_close;
	bool colision, colision1, colision2;
	bool draw, draw1, draw2;
	bool reflexieX, reflexieY;

	Collision triunghi, cerc, platforma, cerc1, cerc2, cerc4, cerc5;
	Collision triunghiInit, cercInit, cerc1Init, cerc2Init, cerc4Init, cerc5Init;
	RectangleCollision platformaCol, platforma_2Col, platforma_3Col;
	RectangleCollision platformaInit, platforma2Init, platforma3Init;
};

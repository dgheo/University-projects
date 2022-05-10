#include "Astrokitty.h"

#include <vector>
#include <iostream>

#include <Core/Engine.h>
#include "Transform2D.h"
#include "Collision.h"
#include "Objects2D.h"


using namespace std;

Astrokitty::Astrokitty()
{
}

Astrokitty::~Astrokitty()
{
}

//functie ce creaza un cerc(poligon cu n varfuri si de raza r) poligonul este alcatuit din n triunghiri cu varfurile orientate spre centru
Mesh* Astrokitty::makeCircle(std::string name, int n, float r, glm::vec3 center) {
	float angle = 2 * PI / (int)n;
	glm::vec3 coordRaza = center + glm::vec3(r, 1, 1);
	vector<VertexFormat> vertices;
	vector<unsigned short> indices;
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
	//creare obiect cerc cu numele trimis ca parametru
	Mesh* circle = new Mesh(name);
	circle->InitFromData(vertices, indices);

	return circle;
}

//Functie ce verifica coleziunea intre 2 cercuri, cercul rachetei(triunghiului) si cercul meteoritilor,
//daca sa produs coleziune functia returneaza true altfel faulse.
bool Astrokitty::Coliziune(Collision a, Collision b) {
	float dx = a.centru.x - b.centru.x;
	float dy = a.centru.y - b.centru.y;
	float distance = sqrt(dx * dx + dy * dy);

	float aRadius, bRadius;
	aRadius = sqrt(pow((a.centru.x - a.punct.x), 2) + pow((a.centru.y - a.punct.y), 2));
	bRadius = sqrt(pow((b.centru.x - b.punct.x), 2) + pow((b.centru.y - b.punct.y), 2));
	if (distance < aRadius + bRadius) {
		return true;
	}
	return false;
}

void Astrokitty::Init()
{
	//initializare variabile booleene de stari
	moving = false;								//variabila care defineste miscarea rachetei
	
	//variabile ce definesc coleziunea si care devin adevarate cand sa realizat coleziunea intre racheta si meteorit1, meteorit2 sau meterit 3 ...
	colision = false;							
	colision1 = false;
	colision2 = false;

	//variabile booliene ce definiesc coleziunile se folosec pentru reflexia pe meteoriti in momentul coleziunii
	draw = true;
	draw1 = true;
	draw2 = true;

	//variabile booleene ce definesc starea de reflexie pe axele OX si OY
	reflexieX = false;
	reflexieY = false;

	window_close = false;
	//definire si intializare caracteristici dreptunghi.
	glm::vec3 corner = glm::vec3(0, 0, 1);
	float lenght = 200;
	float heigth = 40;

	// Initializare tx, si ty folosite la translare
	translateX = 250;
	translateY = 300;

	// initialize sx and sy (the scale factors)
	scaleX = 1;
	scaleY = 1;
	angularStep = 0;
	
	glm::ivec2 resolution = window->GetResolution();	//salvare rezolutie fereastra
	auto camera = GetSceneCamera();
	camera->SetOrthographic(0, (float)resolution.x, 0, (float)resolution.y, 0.01f, 400);
	camera->SetPosition(glm::vec3(0, 0, 50));
	camera->SetRotation(glm::vec3(0, 0, 0));
	camera->Update();
	GetCameraInput()->SetActive(false);

	//definire pozitie initiala triunghi si creare obiect
	trianglePos = glm::vec3(resolution.x/2, resolution.y/2, 1);
	Mesh *triangle = Objects2D::makeTriangle(45, glm::vec3(0, 0, 1));
	AddMeshToList(triangle);

	//salvare inaltime, coordonate initiale centru si varf cosmonaut(triunghi)
	h = 25 * sqrt(3) / (float)2;
	triunghiInit.centru = glm::vec3(0, 0, 1);
	triunghiInit.punct = glm::vec3(0, 0, 1) + glm::vec3(2 * h / (float)3, 0, 0);

	//Creare obiecte asteroizi si salvare coordoanatelor centrelor si a unui punct.

	Mesh *circle = makeCircle("cerc", 8, 45, glm::vec3(0, 0, 1));
	AddMeshToList(circle);

	cercInit.centru = glm::vec3(0, 0, 1);
	cercInit.punct = cercInit.centru + glm::vec3(50, 0, 0);

	
	Mesh *cerc1 = makeCircle("cerc1", 10, 40, glm::vec3(1, 0, 1));
	AddMeshToList(cerc1);

	cerc1Init.centru = glm::vec3(0, 0, 1);
	cerc1Init.punct = cerc1Init.centru + glm::vec3(50, 0, 0);

	Mesh *cerc2 = makeCircle("cerc2", 12, 35, glm::vec3(1, 0, 1));
	AddMeshToList(cerc2);

	cerc2Init.centru = glm::vec3(0, 0, 1);
	cerc2Init.punct = cerc2Init.centru + glm::vec3(50, 0, 0);


	//Creare obiecte platforme si salvare coordonate initiale muchii pe axele OX OY.

	Mesh* platforma1 = Objects2D::makePlatform("platforma1", corner, lenght, heigth, glm::vec3(1, 0, 0), true);
	AddMeshToList(platforma1);
	platformaInit.left_x = corner;
	platformaInit.right_x = corner + glm::vec3(lenght, 0, 0);
	platformaInit.left_y = corner + glm::vec3(0, heigth, 0);
	platformaInit.right_y = corner + glm::vec3(lenght, heigth, 0);


	Mesh* platforma2 = Objects2D::makePlatform("platforma2", corner, lenght, heigth, glm::vec3(1, 1, 0), true);
	AddMeshToList(platforma2);
	platforma2Init.left_x = corner;
	platforma2Init.right_x = corner + glm::vec3(lenght, 0, 0);
	platforma2Init.left_y = corner + glm::vec3(0, heigth, 0);
	platforma2Init.right_y = corner + glm::vec3(lenght, heigth, 0);

	Mesh* platforma3 = Objects2D::makePlatform("platforma3", corner, lenght, heigth, glm::vec3(1, 1, 1), true);
	AddMeshToList(platforma3);
	platforma3Init.left_x = corner;
	platforma3Init.right_x = corner + glm::vec3(lenght, 0, 0);
	platforma3Init.left_y = corner + glm::vec3(0, heigth, 0);
	platforma3Init.right_y = corner + glm::vec3(lenght, heigth, 0);

}

void Astrokitty::FrameStart()
{
	// clears the color buffer (using the previously set color) and depth buffer
	glClearColor(0, 0, 0, 1);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);


	// get frame resolution.
	glm::ivec2 resolution = window->GetResolution();
	// sets the screen area where to draw
	glViewport(0, 0, resolution.x, resolution.y);
}

void Astrokitty::Update(float deltaTimeSeconds)
{


	float apex_y = (float)2 * h * 1 / 3;

	glm::vec3 apexInit = glm::vec3(0, apex_y, 1);
	glm::vec3 apex;


	//translatie pe y
	if (translateY > 700) {
		incrementTranslateY = false;
	}
	else if (translateY < 200) {
		incrementTranslateY = true;
	}
	if (incrementTranslateY) {
		translateY += deltaTimeSeconds * 100;
	}
	else {
		translateY = translateY - deltaTimeSeconds * 100;
	}


	//translatie pe x
	if (translateX > 800) {
		incrementTranslateX = false;
	}
	else if (translateX < 300) {
		incrementTranslateX = true;
	}
	if (incrementTranslateX) {
		translateX += deltaTimeSeconds * 100;
	}
	else {
		translateX = translateX - deltaTimeSeconds * 100;
	}


	//scalare asteroid
	if (scaleX > 1.3) {
		incrementScaleX = false;
	}
	else if (scaleX < 1) {
		incrementScaleX = true;
	}
	if (scaleY > 1.3) {
		incrementScaleY = false;
	}
	else if (scaleY < 1) {
		incrementScaleY = true;
	}
	if (incrementScaleX) {
		scaleX += deltaTimeSeconds;
	}
	else {
		scaleX = scaleX - deltaTimeSeconds;
	}
	if (incrementScaleY) {
		scaleY += deltaTimeSeconds;
	}
	else {
		scaleY = scaleY - deltaTimeSeconds;
	}

	//calculare dimensiune frame lungime si latime
	glm::ivec2 resolution = window->GetResolution();
	modelMatrix = glm::mat3(1);
	float borderX = (float)resolution.x;
	float borderY = (float)resolution.y;

//tratare eveniment de miscare, racheta se misca in directia unde a fost plasat mouse-ul(si sa executat click stanga)	
	if (moving) {
		trianglePos =
				Transform2D::Rotate(angle) *
				Transform2D::Translate(500 * deltaTimeSeconds, 0) *
				Transform2D::Rotate(-angle) * trianglePos;
	
	}
	

	modelMatrix = Transform2D::Translate(trianglePos.x, trianglePos.y) *
		Transform2D::Rotate(angle - PI/2 ) * modelMatrix;

	//calculare centru si varf racheta la fiecare frame(update)
	triunghi.centru = modelMatrix * triunghiInit.centru;
	triunghi.punct = modelMatrix * triunghiInit.punct;
	//calculare varf racheta la fiecare frame
	apex = modelMatrix * apexInit;
	

	//se verifica daca varful rachetei a atins vrio margina de frame. Daca da atunci se executa reflexia 
	if (!(apex.x > 0 && apex.x < borderX)) {
		reflexieX = true;
	}

	if (!(apex.y > 0 && apex.y < borderY)) {
		reflexieY = true;
	}
	//se face update la angularSteap
	angularStep = angularStep + deltaTimeSeconds*10;

	//creare racketa pe ecran
	RenderMesh2D(meshes["triangle"], shaders["VertexColor"], modelMatrix);


	//Creare metorit 1 si calculare coordonate centru si un punct
	modelMatrix = Transform2D::Translate(translateX, 500);
	modelMatrix *= Transform2D::Rotate(angularStep);
	cerc.centru = modelMatrix * cercInit.centru;
	cerc.punct = modelMatrix * cercInit.punct;

	//se verifica daca sa produs evenimentul de coleziune intre meteoritul 1 si racketa
	if (draw) {
		colision = Coliziune(cerc, triunghi);
	}
	//daca sa produs o coleziune intre racheta1 si meteorit atunci se executa reflexia pe asteroid si variabilele de stare se updateaza
	if (colision) {
		draw = false;
		colision = false;
		angle = angle - PI / 2;
	}
	//daca nu a avut loc coleziunea atunci se afiseaza meteoritul 1 pe ecran.
	if (draw) {
		RenderMesh2D(meshes["cerc"], shaders["VertexColor"], modelMatrix);
	}


	//Creare meteorit 2 si calculare coordonate centru si un punct
	modelMatrix = Transform2D::Translate(160, translateY);
	modelMatrix *= Transform2D::Rotate(angularStep);
	modelMatrix *= Transform2D::Scale(scaleX, scaleY);

	cerc1.centru = modelMatrix * cerc1Init.centru;
	cerc1.punct = modelMatrix * cerc1Init.punct;

	//se verifica daca sa produs evenimentul de coleziune intre meteoritul 2 si racketa
	if (draw1) {
		colision1 = Coliziune(cerc1, triunghi);
	}
	//daca sa produs o coleziune intre racheta si meteorit 2 atunci se executa reflexia pe asteroid si variabilele de stare se updateaza
	if (colision1) {
		draw1 = false;
		colision1 = false;
		angle = angle - PI / 2;
	}
	//daca nu a avut loc coleziunea atunci se afiseaza meteoritul 2 pe ecran.
	if (draw1) {
		RenderMesh2D(meshes["cerc1"], shaders["VertexColor"], modelMatrix);
	}
	//Creare metorit 3 si calculare coordonate centru si un punct
	modelMatrix = Transform2D::Translate(1200, translateY);
	modelMatrix *= Transform2D::Rotate(angularStep);
	modelMatrix *= Transform2D::Scale(scaleX, scaleY);

	cerc2.centru = modelMatrix * cerc1Init.centru;
	cerc2.punct = modelMatrix * cerc1Init.punct;

	//se verifica daca sa produs evenimentul de coleziune intre meteoritul 3 si racketa
	if (draw2) {
		colision2 = Coliziune(cerc2, triunghi);
	}
	//daca sa produs o coleziune intre racheta si meteorit 3 atunci se executa reflexia pe asteroid si variabilele de stare se updateaza meteoritul dispare
	if (colision2) {
		draw2 = false;
		colision2 = false;
		angle = angle - PI / 2;
	}
	//daca nu sa pprodus coleziune se afiseaza meteoritul 3
	if (draw2) {
		RenderMesh2D(meshes["cerc2"], shaders["VertexColor"], modelMatrix);
	}
	//Creare platforma 1 - de reflexie, calculare coordonate varfuri la fiecare frame
	modelMatrix = Transform2D::Translate(500, 600);
	platformaCol.left_x = modelMatrix * platformaInit.left_x;
	platformaCol.right_x = modelMatrix * platformaInit.right_x;
	platformaCol.left_y = modelMatrix * platformaInit.left_y;
	platformaCol.right_y = modelMatrix * platformaInit.right_y;
	//salvare coordonate varfuri
	float x1, x2, y1, y2;
	x1 = platformaCol.left_x.x;
	y1 = platformaCol.left_x.y;
	x2 = platformaCol.right_y.x;
	y2 = platformaCol.right_y.y;
	//Tratare eveniment de reflexie pe platforma1, daca varful rechetei ajunge pe un punct de platforma atunci racheta isi modifica directia in reflexie
	if (abs(apex.y - y1) < 5 && apex.x > x1 && apex.x < x2) reflexieY = true;
	if (abs(apex.y - y2) < 5 && apex.x > x1 && apex.x < x2) reflexieY = true;
	if (abs(apex.x - x1) < 5 && apex.y > y1 && apex.y < y2) reflexieX = true;
	if (abs(apex.x - x2) < 5 && apex.y > y1 && apex.y < y2) reflexieX = true;

	//reflexie pe axa OY
	if (reflexieY) {
		angle = 2 * PI - angle;
		reflexieY = false;
	}
	//reflexie pe axa OX
	if (reflexieX) {
		angle = PI - angle;
		reflexieX = false;
	}

	//Afisare platforma1 pe ecran
	RenderMesh2D(meshes["platforma1"], shaders["VertexColor"], modelMatrix);

	//Creare platforma2 - de stationare. Salvare coordonatele varfurilor platformei
	modelMatrix = Transform2D::Translate(800, 200);

	platforma_2Col.left_x = modelMatrix * platforma2Init.left_x;
	platforma_2Col.right_x = modelMatrix * platforma2Init.right_x;
	platforma_2Col.left_y = modelMatrix * platforma2Init.left_y;
	platforma_2Col.right_y = modelMatrix * platforma2Init.right_y;

	
	float x_p1, x_p2, y_p1, y_p2;
	x_p1 = platforma_2Col.left_x.x;
	y_p1 = platforma_2Col.left_x.y;
	x_p2 = platforma_2Col.right_y.x;
	y_p2 = platforma_2Col.right_y.y;
	//Se verifica daca varful rachetei a ajuns in zona de coordonate unde este platforma 2, daca da atunci racheta stationaeaza cu varful in sus.
	if (abs(apex.y - y_p1) < 5 && apex.x > x_p1 && apex.x < x_p2) { angle = 3*PI/2; moving = false; }
	if (abs(apex.y - y_p2) < 5 && apex.x > x_p1 && apex.x < x_p2) { angle = PI / 2; moving = false; }
	if (abs(apex.x - x_p1) < 5 && apex.y > y_p1 && apex.y < y_p2) { angle = PI;  moving = false; }
	if (abs(apex.x - x_p2) < 5 && apex.y > y_p1 && apex.y < y_p2) { angle = 2*PI; moving = false; }
	//afisare platforma 2
	RenderMesh2D(meshes["platforma2"], shaders["VertexColor"], modelMatrix);

	//Creare platforma 3 -game over. La atungerea acestei platforme jocul se termina si reincepe din stare intiala
	modelMatrix = Transform2D::Translate(100, 100);
	//Calculare coordonatele varfurilor platformei 3.
	platforma_3Col.left_x = modelMatrix * platforma3Init.left_x;
	platforma_3Col.right_x = modelMatrix * platforma3Init.right_x;
	platforma_3Col.left_y = modelMatrix * platforma3Init.left_y;
	platforma_3Col.right_y = modelMatrix * platforma3Init.right_y;
	//salvare coordonate.
	float x_pl1, x_pl2, y_pl1, y_pl2;
	x_pl1 = platforma_3Col.left_x.x;
	y_pl1 = platforma_3Col.left_x.y;
	x_pl2 = platforma_3Col.right_y.x;
	y_pl2 = platforma_3Col.right_y.y;
	//Se verifica daca racheta a atins platforma 3. Daca da atunci jocul se termina din starea initiala
	if (abs(apex.y - y_pl1) < 5 && apex.x > x_pl1 && apex.x < x_pl2) { window_close = true; }
	if (abs(apex.y - y_pl2) < 5 && apex.x > x_pl1 && apex.x < x_pl2) { window_close = true; }
	if (abs(apex.x - x_pl1) < 5 && apex.y > y_pl1 && apex.y < y_pl2) { window_close = true; }
	if (abs(apex.x - x_pl2) < 5 && apex.y > y_pl1 && apex.y < y_pl2) { window_close = true; }

	if (window_close) {
		//Init();
		exit(0);
	}
	//Creare platforma 3 - platforma de game over
	RenderMesh2D(meshes["platforma3"], shaders["VertexColor"], modelMatrix);

}

void Astrokitty::FrameEnd()
{

}

void Astrokitty::OnInputUpdate(float deltaTime, int mods)
{

}

void Astrokitty::OnKeyPress(int key, int mods)
{
	// add key press event
}

void Astrokitty::OnKeyRelease(int key, int mods)
{
	// add key release event
}
//Tratare eveniment de miscare mouse. La acest eveniment racheta isi indreapta varful in aceeasi directie cu mouse-ul.
void Astrokitty::OnMouseMove(int mouseX, int mouseY, int deltaX, int deltaY)
{
	if (!moving) {
		angle = atan((trianglePos.x - mouseX) / (trianglePos.y - mouseY));
		if (mouseY > trianglePos.y) {
			angle = PI + angle;
		}
		angle = angle + PI / 2;
	}	

}
//Tratare eveniment de click. La acest eveniment racheta isi incepe miscarea spre locul unde a fost plasat mouse-ul.
void Astrokitty::OnMouseBtnPress(int mouseX, int mouseY, int button, int mods)
{
	moving = true;
}

void Astrokitty::OnMouseBtnRelease(int mouseX, int mouseY, int button, int mods)
{
	// add mouse button release event
}

void Astrokitty::OnMouseScroll(int mouseX, int mouseY, int offsetX, int offsetY)
{
}

void Astrokitty::OnWindowResize(int width, int height)
{
}

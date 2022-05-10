									Readme

DIGORI GHEORGHE 331CC

									Tema 1 EGC
									AstroKitty

	In cadrul acestei teme am realizat un joc 2D ce utilizeaza concepte predate in prime le 3 laboratoare de EGC si anume: 
*constructia de meshe simple
*tratarea evenimentelor pentru mouse
*utilizarea transformarilor 2D: translatie, rotatie, scalare

Am abordat toate cerintele obligatorii prezentate in tema. Am creat o racheta(triunghi) a carei directie se modifica in functie de directia mouse-lui si la click se deplasease in  directia unde se afla mouse-ul.
 
Jocul prezinta 3 meteoriti ce sunt realizati din triunguiri si se prezinte ca niste poligoane care au peste 8, 10 laturi. Aesti meteroriti prezinta efecte de translatie rotatie si scalare. La coleziunea rachetei cu meteoritii, acestia dispar iar racheta is modifica directie de deplasare in reflexie fata de punctul de coleziune. 

La coleziune cu limitele frame-ul racheta se intoarce in spatiul de joc sub un unghi de reflexie. 

Am creat 3 platforme: 1 de reflexie(ROSIE), 1 de stationare si 1 la atingerea careia sa opreste jocul. Platformele au forma dreptunghiulara fiind alcatuite din 2 triunghiuri.

La coleziune cu platforma de reflexie racheta is modifica traectoria sub un unghi de reflexie.

La coleziune cu platfrma de stationare(GALBENA). Racheta se va opri pe platforma cu varful in sus(adica opus bazei care se afla pe platforma), iar la executarea unui click aceasta va reporni.

La coleziune cu platforma de game over(ALBA). Jocul se termina si frame-ul se inchide.

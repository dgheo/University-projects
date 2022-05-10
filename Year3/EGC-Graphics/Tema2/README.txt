				Readme

DIGORI GHEORGHE 331CC

									Tema 2 EGC
									Racing Game

	In cadrul acestei teme am realizat un joc 3D ce utilizeaza concepte predate in prime le 6 laboratoare de EGC si anume: 
*constructia de meshe simple
*tratarea evenimentelor pentru mouse
*utilizarea transformarilor 3D: translatie, rotatie, scalare
*utilizarea camerii 
*shadere
*etc.

Am abordat toate cerintele obligatorii prezentate in tema mai putin cerinta cu coleziune. Astfel am jocul meu prezinta un spatiu 3D in care are loc actiunea, actiunea se petrece intrun cub mare laturile superiare ale caruia reprezinta cerul. Pamantul este reprezentat de o platforma. Culoarea cerului si a pamantului variaza ciclic simuland ciclul zi noapte.

Drumul e generat de un numar de fragmente citit din fisier.
Drumul prezinta portiuni drepte si curbe la dreapta si stanga.
Pe drum sunt amplasate obstacoloe in forma de cub. Coleziunea cu acestea nu a fost implementata.

Masina e un obiect obj si rotile sunt obiecte separate, masina prezinta toate functionalitatile descrise in enuntul temei.

Miscarea masinii se realizeaza cu press taste: miscare inainte-W, inapoi-S, dreata-D, stanga-A

Am implementat camera first person si third person, mutarea camenerei se face cu tasta C


Pentru redarea iluziei de zi noapte am creat shadere pentru cub si platforma care variaza in intervalul 0-2Pi modificanduse culoarea in functie de timpul sistemuli.



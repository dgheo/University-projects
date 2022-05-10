--	@C:\Users\alina\Desktop\bd2_lab7\ex2b.sql


--  Să se scrie o funcție stocată, f_puncte, 
-- care calculează numărul de puncte acumulate de angajați 
-- în vederea numirii unui șef pe fiecare departament

-- Pentru stocarea punctelor acumulate de fiecare angajat, 
-- se va crea o tabelă temp_puncte care are următoarele coloane: idAng, nrPuncte, idDep


-- PAS I: creare tabela
create table temp_puncte
(
	idAng number(4),
	nrPuncte number(3),
	idDept number(2)
);

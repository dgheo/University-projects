--	@C:\Users\alina\Desktop\bd2_lab7\ex2.sql


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
/

-- PAS II: creare functie stocata
create or replace function f_puncte(p_idAng in number)
return number
is
	dataAng emp.hiredate%type;
	idDept dept.deptno%type;
	salariu emp.sal%type;
	comision emp.comm%type;
	salMax number;
	puncte number := 0;
begin
	-- iau informatiile de care am nevoie
	select hiredate, deptno, sal, nvl(comm, 0)
		into dataAng, idDept, salariu, comision
		from emp where empno = p_idAng;
		
	-- calculez puncte in funcție de vechime
	if months_between(sysdate, dataAng) > 32*12 then
		puncte := puncte + 30;
	else
		puncte := puncte + 15;
	end if;
	
	-- iau salariul maxim din departament
	select max(sal) into salMax from emp where deptno = idDept;
	
	-- calculez puncte in funcție de salariu
	if salMax = salariu then
		puncte := puncte + 20;
	else
		puncte := puncte + 10;
	end if;

	-- calculez puncte in functie de comision
	if comision > 0 then
		puncte := puncte + 10;
	else 
		puncte := puncte + 5;
	end if;
	
	return puncte;
end f_puncte;
/

-- PAS III: creare bloc apelant

set serveroutput on;
declare
	puncte number;
	cursor c_angajati is select empno, ename, deptno from emp;
	numeDept dept.dname%type;
	idMgr emp.mgr%type;
	numeAng emp.ename%type;
	dataAng emp.hiredate%type;
	aniVechime number;
	salMaxDept number;
	comision emp.comm%type;
begin
	-- sterg informatiile din tabel
	delete from temp_puncte;
	
	-- calculez punctajul pt fiecare angajat si
	-- inserez informatiile in tabelul temp_puncte
	for angajat in c_angajati
	loop
		puncte := f_puncte(angajat.empno);
		insert into temp_puncte values(angajat.empno, puncte, angajat.deptno);
	end loop;
	
	-- antetul listei
	dbms_output.put_line(rpad('Departament', 20) || rpad('Salariu max', 20)
		|| rpad('Nume angajat', 20) || rpad('Ani vechime', 20) 
		|| rpad('Comision', 20) || rpad('Puncte angajat', 20));
	dbms_output.put_line(rpad('=', 120, '='));
	
	-- folosind un cursor selectez max de puncte pt fiecare departament
	for contor1 in (select max(nrPuncte) maxPuncte, idDept
						from temp_puncte group by idDept order by idDept)
	loop
		-- folosind un cursor selectez toti angajatii care sunt din departamentul
		-- selectat de primul cursor si au max de puncte din departament
		for contor2 in (select idAng from temp_puncte
			where nrPuncte = contor1.maxPuncte and idDept = contor1.idDept)
		loop
			-- selectez nume departament
			select dname into numeDept from dept where deptno = contor1.idDept;
			
			-- selectez salariul max din departament
			select max(sal) into salMaxDept from emp where deptno = contor1.idDept;
			
			-- selectez informatiile despre angajat
			select hiredate, nvl(comm, 0), ename into dataAng, comision, numeAng
				from emp where empno = contor2.idAng;
				
			-- calculez vechime angajat
			aniVechime := trunc(months_between(sysdate, dataAng)/12);
			
			-- afisez informatiile cerute
			dbms_output.put_line(rpad(numeDept, 20) || rpad(salMaxDept, 20)
				|| rpad(numeAng, 20) || rpad(aniVechime, 20) 
				|| rpad(comision, 20) || rpad(contor1.maxPuncte, 20));
		end loop;
	end loop;
end;
/

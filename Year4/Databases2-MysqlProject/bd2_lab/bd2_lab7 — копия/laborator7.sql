--	@C:\Users\alina\Desktop\bd2_lab7\laborator7.sql

-- Sa se scrie un program principal si o functie PL/SQL
-- pt a face o lista cu toti angajatii care pot candida
-- la un post de sef de departament in departamentul din care fac parte.

-- Conditii:
-- dept din care face parte candidat sa aiba cel mult 2 sefi
-- vechime minima 30 ani
-- sa nu fie deja sef

-- LISTA CANDIDATI
-- DEN_DEPT		NR_SEFI		NUME_CANDIDAT	DATA_ANG	ANI_VECHIME		SEF(y/n)


-- PAS I: creare functie
create or replace function f_candidat(p_idAng in number, aniVechime out number,
							nrSefiDept out number, isSef out varchar2)
return number
is
	dataAng emp.hiredate%type;
	idDept dept.deptno%type;
	functie emp.job%type;
	forSef number;
	esteCandidat number; -- 1=fals, 0=true
begin
	-- iau informatiile de care am nevoie
	select hiredate, deptno, job
		into dataAng, idDept, functie
		from emp where empno = p_idAng;

	-- verific daca angajatul este sef de departament
	select count(empno) into forSef from emp where mgr=p_idAng;
	if forSef > 0 then
		isSef := 'yes';
	else
		isSef := 'no';
	end if;

	-- determin nr de sefi din departament din care face parte angajatul
	select count(empno) into nrSefiDept from emp
		where deptno=idDept and empno in (select mgr from emp);

	-- calculez vechime angajat
	aniVechime := trunc(months_between(sysdate, dataAng)/12);

	-- determin daca angajatul este candidat sau nu
	if (nrSefiDept<2 and aniVechime >= 30 and forSef = 0) then
		esteCandidat := 0;
	else
		esteCandidat := 1;
	end if;

	return esteCandidat;
end f_candidat;
/


-- PAS II: creare bloc apelant
set serveroutput on;
declare
	valFunctie number;
	cursor c_angajati is select empno, ename, deptno from emp;
	numeDept dept.dname%type;
	aniVechime number;
	nrSefi number;
	isSef varchar2(3);
begin
	-- antetul listei
	dbms_output.put_line(rpad('LISTA CANDIDATI', 30,' '));
	dbms_output.put_line(rpad('DEN_DEPT', 20) || rpad('NR_SEFI', 20)
		|| rpad('NUME_CANDIDAT', 20) || rpad('DATA_ANG', 20)
		|| rpad('ANI_VECHIME', 20) || rpad('SEF(y/n)', 20));
	dbms_output.put_line(rpad('=', 120, '='));

	-- folosind un cursor selectez angajatii
	for contor2 in (select * from emp)
	loop
		valFunctie := f_candidat(contor2.empno, aniVechime, nrSefi, isSef);

		-- selectez nume departament
		select dname into numeDept from dept where deptno = contor2.deptno;

		-- afisez candidatii
		if valFunctie = 0 then
			dbms_output.put_line(rpad(numeDept, 20) || rpad(nrSefi, 20)
				|| rpad(contor2.ename, 20) || rpad(contor2.hiredate, 20)
				|| rpad(aniVechime, 20) || rpad(isSef, 20));
		end if;

	end loop;
end;
/

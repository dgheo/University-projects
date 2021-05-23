--	@C:\Users\alina\Desktop\bd2_lab7\ex2a.sql

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
	dbms_output.put_line(rpad('=', 120, '=');
	
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

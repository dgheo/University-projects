--	@C:\Users\alina\Desktop\bd2_lab5\ex10.sql


-- Să se facă o listă cu angajații care fac parte dintr-un departament specificat,
-- au o anumită funcție și
-- au venit în companie la o anumită dată specificată. 
-- Aceste condiții să fie transmise ca parametri unui cursor.

set serveroutput on;
declare
	cursor c_angajati(idDept number, functie char, dataAng date) is
		select deptno, ename, job, hiredate from emp
			where deptno=idDept and lower(job)=lower(functie) and hiredate>dataAng;
	angajat c_angajati%rowtype;
begin
	open c_angajati(10, 'clerk', '1-JUL-81');
	loop
		fetch c_angajati into angajat;
		exit when c_angajati%NOTFOUND;
		dbms_output.put_line(rpad(angajat.deptno, 10) || rpad(angajat.ename, 20) ||
			rpad(angajat.job, 20) || lpad(angajat.hiredate, 10));
	end loop;
	close c_angajati;

	open c_angajati(idDept => 20, functie => 'clerk', dataAng => '1-JUL-81');
	loop
		fetch c_angajati into angajat;
		exit when c_angajati%NOTFOUND;
		dbms_output.put_line(rpad(angajat.deptno, 10) || rpad(angajat.ename, 20) ||
			rpad(angajat.job, 20) || lpad(angajat.hiredate, 10));
	end loop;
	close c_angajati;

	open c_angajati(functie => 'clerk', dataAng => '1-JUL-81', idDept => 10);
	loop
		fetch c_angajati into angajat;
		exit when c_angajati%NOTFOUND;
		dbms_output.put_line(rpad(angajat.deptno, 10) || rpad(angajat.ename, 20) ||
			rpad(angajat.job, 20) || lpad(angajat.hiredate, 10));
	end loop;
	close c_angajati;

	open c_angajati(20, functie => 'clerk', dataAng => '1-JUL-81');
	loop
		fetch c_angajati into angajat;
		exit when c_angajati%NOTFOUND;
		dbms_output.put_line(rpad(angajat.deptno, 10) || rpad(angajat.ename, 20) ||
			rpad(angajat.job, 20) || lpad(angajat.hiredate, 10));
	end loop;
	close c_angajati;

	open c_angajati(10, 'clerk', dataAng => '1-JUL-81');
	loop
		fetch c_angajati into angajat;
		exit when c_angajati%NOTFOUND;
		dbms_output.put_line(rpad(angajat.deptno, 10) || rpad(angajat.ename, 20) ||
			rpad(angajat.job, 20) || lpad(angajat.hiredate, 10));
	end loop;
	close c_angajati;
	
end;
/

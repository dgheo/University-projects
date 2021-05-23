--	@C:\Users\alina\Desktop\bd2_lab5\ex14.sql


-- Să se scrie un cursor explicit PL/SQL care face o listă 
-- pentru acordarea de comisioane tuturor șefilor de departament
-- (care se identifică în coloana mgr din tabela EMP), după următorul algoritm:
-- * Dacă salariu_sef < salariu_mediu_departament atunci
-- comision_sef = 10% * salariu_mediu_departament
-- * Dacă salariu_sef >= salariu_mediu_departament atunci
-- comision_sef = 20% * salariu_mediu_departament


set serveroutput on;
declare
	cursor c_sef is 
		select distinct mgr from emp where mgr is not null;
		numeAng emp.ename%type;
		idDept emp.deptno%type;
		numeDept dept.dname%type;
		salariu emp.sal%type;
		idAng emp.empno%type;
		salMediu number;
		comision number;
begin
	dbms_output.put_line(rpad('LISTA ACORDARE COMISIOANE', 30,' '));
	dbms_output.put_line(rpad('Departament', 20) || rpad('Salariu mediu', 15)
		|| rpad('Nume', 20) || lpad('Salariu', 10) || lpad('Comision', 10);
	dbms_output.put_line(rpad('=', 20, '=') || rpad('=', 15, '=')
		|| rpad('=', 20, '=') || lpad('=', 10, '=') || lpad('=', 10, '='));
		
	for rec in c_sef
	loop
		select ename, deptno, sal, empno into numeAng, idDept, salariu, idAng
			from emp where empno = rec.mgr;
			
		select round(avg(sal)) into salMediu from emp
			where deptno = idDept;
			
		select dname into numeDept from dept where deptno = idDept;

		if salariu < salMediu then
			comision := round(0.1*salMediu);
		else
			comision := round(0.2*salMediu);
		end if;

		dbms_output.put_line(rpad(numeDept, 20) || rpad(salMediu, 15)
			|| rpad(numeAng, 20) || lpad(salariu, 10) || lpad(comision, 10));
			
	end loop;
end;
/
										
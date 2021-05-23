--	@C:\Users\alina\Desktop\bd2_lab5\enunt.sql

--											LISTA PRIME
--   DEN_DEP_SEF	SAL_MED_DEP	NUME_SEF	NUME_SEF	SAL_SEF OBS

--PRIMA=(5% * SAL_SEF)*NR_SUB

-- Sa se scrie un bloc care sa contina un cursor
-- pt a face o lista de premiere pt sefii de departament
-- Prima e 5% din sal pt fiecare ang din subordinea sa
-- Daca prima > 20% din sal_med_dept, atunci se va trata ca o exceptie si 
-- pe col de obs se va specifica 'Depasire_suma'

set serveroutput on;
declare
	cursor c_sef is 
		select distinct mgr from emp where mgr is not null;
		numeAng emp.ename%type;
		idDept emp.deptno%type;
		numeDept dept.dname%type;
		salSef emp.sal%type;
		idAng emp.empno%type;
		salMedDept number;
		nrSub number;
		prima number := 0;
begin
	dbms_output.put_line(rpad('LISTA PRIME', 30,' '));
	dbms_output.put_line(rpad('DEN_DEP_SEF', 20) || rpad('SAL_MED_DEP', 10) ||
		rpad('NUME_SEF', 20) || rpad('SAL_SEF', 10) ||
		rpad('PRIMA', 10) || lpad('OBS', 20));
	dbms_output.put_line(rpad('=', 20, '=') || rpad('=', 10, '=') ||
		rpad('=', 20, '=') || rpad('=', 10, '=') ||
		rpad('=', 10, '=') || lpad('=', 20, '='));
		
	for rec in c_sef
	loop
		select ename, deptno, sal, empno into numeAng, idDept, salSef, idAng
			from emp where empno = rec.mgr;
			
		select round(avg(sal)) into salMedDept from emp
			where deptno = idDept;
			
		select dname into numeDept from dept where deptno = idDept;
		
		select count(mgr) into nrSub from emp where mgr = idAng;
		
		prima := round(0.05*salSef)*nrSub;
		
		if prima > round(0.2*salMedDept) then
			dbms_output.put_line(rpad(numeDept, 20) || rpad(salMedDept, 10) ||
				rpad(numeAng, 20) || rpad(salSef, 10) ||
				rpad('-', 10) || lpad('Depasire suma', 20));
		else
			dbms_output.put_line(rpad(numeDept, 20) || rpad(salMedDept, 10) ||
				rpad(numeAng, 20) || rpad(salSef, 10) ||
				rpad(prima, 10) || lpad('-', 20));
		end if;
			
	end loop;
end;
/
										
--   @C:\Users\alina\Desktop\bd2_lab6\ex2.txt

set serveroutput on;
declare
	procedure salariu (deptId in number,
		functie in out varchar2, salariuMaxim out number)
	is
		salmax number;
	begin
		select max(sal) into salmax from emp
			where deptno = deptId and lower(job) = lower(functie) group by deptno;
		salariuMaxim := salmax;
		
		functie := case upper(functie)
					when 'ANALYST' then 'Analist'
					when 'SALESMAN' then 'Vanzator'
					when 'CLERK' then 'Functionar'
					when 'PRESIDENT' then 'Presedinte'
					when 'MANAGER' then 'Director'
					else 'Nu avem functia'
				end;
	exception
		when no_data_found then
			dbms_output.put_line('Nu a fost gasita nici o inregistrare');
	end;
begin
	declare
		numeDepartament emp.ename%type;
		idDept emp.deptno%type;
		functie varchar(40);
		salMax number;
	begin
		idDept := &idDepartament;
		functie := '&numeFunctie';
		
		select dname into numeDepartament from dept where deptno = idDept;
		salariu(idDept, functie, salMax);
		
		dbms_output.put_line('In departamentul ' || numeDepartament
			|| ' salariu maxim pt functia ' || functie
			|| ' este ' || salMax);
			
		exception
			when no_data_found then
				dbms_output.put_line('Departament inexistent');
	end;
end;
/







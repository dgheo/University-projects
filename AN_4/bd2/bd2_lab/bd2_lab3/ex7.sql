set serveroutput on;
declare
	nume emp.ename%type;
	functie varchar2(30);
begin
	select e.ename, (case e.job
					when 'ANALYST' then 'Analist'
					when 'SALESMAN' then 'Vanzator'
					when 'CLERK' then 'Functionar'
					when 'PRESIDENT' then 'Presedinte'
					when 'MANAGER' then 'Director'
					else 'Nu avem functia'
					end)
		into nume, functie
		from emp e where empno = &idEmp;
	dbms_output.put_line(nume || ' are functia=' || functie);
end;
/		
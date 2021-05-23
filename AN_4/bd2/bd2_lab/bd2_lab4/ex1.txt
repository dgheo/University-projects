--@E:\bd2_lab4\ex1.txt
set serveroutput on;
declare
	idDept number(4);
	numeDepartament dept.dname%type;
begin
	idDept :=&idDept;
	select dname into numeDepartament
		from dept where deptno=idDept;
	dbms_output.put_line('Numele departamentului ' || idDept
		|| ' este ' || numeDepartament);
	exception
		when no_data_found then
			dbms_output.put_line('Departamentul ' || idDept ||
				' nu exista in baza de date.');
end;
/
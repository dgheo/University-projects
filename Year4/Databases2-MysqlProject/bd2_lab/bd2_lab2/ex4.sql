set serveroutput on;
declare
	numeAngajat emp.ename%type;
	venit emp.sal%type;
	idDepartament emp.deptno%type;
	departament dept%rowtype;
	
begin
	select deptno, ename, sal+nvl(comm, 0)
		into idDepartament, numeAngajat, venit
		from emp where empno=&idAngajat;
	select * into departament from dept
		where deptno = idDepartament;
	dbms_output.put_line(numeAngajat ||
		' face parte din departamentul ' || departament.dname);
	exception
		when no_data_found then
			dbms_output.put_line('Angajatul nu se gaseste in baza de date');
end;
/
		
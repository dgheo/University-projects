set serveroutput on;
declare
	numeAngajat varchar2(20);
	functie string(30);
	idDepartament integer;
	numeDepartament varchar(20);
	venituriMaxime emp.sal%type;
begin
	idDepartament := &idDepartament;
	dbms_output.put_line(CHR(9) || 'VENITURI MAXIME');
	select max((sal + nvl(comm, 0))) into venituriMaxime from emp
	where deptno = idDepartament;
	select ename, job
		into numeAngajat, functie
		from emp where deptno = idDepartament AND (sal + nvl(comm, 0)) = venituriMaxime;
	select dname into numeDepartament
		from dept where deptno = idDepartament;
	dbms_output.put_line('Angajatul ' || numeAngajat ||
		' are venit maxim = ' || venituriMaxime ||
		' si are functia ' || functie ||
		' in departamentul ' || numeDepartament);
	exception
		when too_many_rows then
			dbms_output.put_line('Exista mai multi angajati cu venit maxim in departamentul '
			|| numeDepartament);
end;
/
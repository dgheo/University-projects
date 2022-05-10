Sa se scrie un bloc PL/SQL pt a afisa angajatul care are
cel mai mare venit pt un dept introdus de la tastatura.

venit = sal + comm

blocukl va afisa: 'Angajatul x are venit maxim = y si are functia z in departamentul t 

Tabela emp

exceptii: mai multi angajati cu venit maxim: 'Exista mai multi angajati 
cu venit maxim in departamentul t'

Venituri maxime (titlu lista)

set serveroutput on;
declare
	numeAngajat varchar2(20);
	functie string(30);
	idDepartament integer;
	numeDepartament varchar(20);
	venituriMaxime emp.sal%type;
begin
	idDepartament := &idDepartament;
	select max(sal + nvl(comm, 0)) into venituriMaxime from emp;
	select ename, job
		into numeAngajat, functie
		from emp where deptno = idDepartament AND (sal + nvl(comm, 0)) = venituriMaxime;
	select dname into numeDepartament
		from dept where deptno = idDepartament;
	dbms_output.put_line('Angajatul ' || numeAngajat ||
		' are venit maxim = ' || venitMax ||
		' si are functia ' || functie ||
		' in departamentul ' || numeDepartament);
	exception
		when too_many_rows then
			dbms_output.put_line('Exista mai multi angajati cu venit maxim in departamentul '
			|| numeDepartament);
end;
/
		
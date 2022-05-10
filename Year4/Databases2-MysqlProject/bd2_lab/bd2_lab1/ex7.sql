set serveroutput on;
set lines 150;
set pages 100;

declare
	numeDepartament varchar2(40);
	salariu number;
begin
	select sum(sal+nvl(comm, 0)) into salariu from emp
		where deptno=&&idDept and job='&job' group by deptno;
	select dname into numeDepartament from dept
		where deptno=&idDept;
	insert into mesaje values('Suma veniturilor in departamentul '
		|| &idDept, 'este ' || to_char(salariu));
	exception
		when no_data_found then
			insert into mesaje(mesaj1) values('In departamentul '
				|| &idDept || ' nu exista angajati');
end;
/

undef idDept;

select *  from mesaje;
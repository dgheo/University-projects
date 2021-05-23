--	@C:\Users\alina\Desktop\bd2_lab5\ex9.sql


-- Să se șteargă din tabela EMP toți angajații care au comision

set serveroutput on;
declare
	cursor c_angajati is
		select d.dname, e.empno, e.ename, e.sal, e.comm, e.hiredate
			from emp e inner join dept d on d.deptno = e.deptno for update;
	angajat c_angajati%rowtype;
	comisionNou number default 0;
begin
	for angajat in c_angajati
	loop
		if not (nvl(angajat.comm, 0) = 0) then
			delete from emp where current of c_angajati;
		end if;
	end loop;
end;
/

--	@C:\Users\alina\Desktop\bd2_lab5\ex8.sql


-- Să se modifice comisionul cu 10% din salariu pentru angajații
-- care au peste 20 ani vechime în companie

set serveroutput on;
declare
	cursor c_angajati is
		select d.dname, e.empno, e.ename, e.sal, e.comm, e.hiredate
			from emp e inner join dept d on d.deptno = e.deptno for update of comm;
	angajat c_angajati%rowtype;
	comisionNou number default 0;
begin
	open c_angajati;
	loop
		fetch c_angajati into angajat;
		exit when c_angajati%NOTFOUND;
		if add_months(angajat.hiredate, 240) < sysdate then
			comisionNou := nvl(angajat.comm, 0) + round(0.1 * angajat.sal, 0);
			update emp set comm = comisionNou where current of c_angajati;
		end if;
	end loop;
	close c_angajati;
end;
/

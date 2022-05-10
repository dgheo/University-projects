--	@C:\Users\alina\Desktop\bd2_lab5\ex4.sql


--  Să se declare un cursor care selectează
-- denumirea departamentului, numele angajatului, salariul și data angajării
-- pentru acei angajati care au venit în companie în 1981

set serveroutput on;
declare
	cursor c_angajati is
		select d.dname, e.empno, e.ename, e.sal, e.hiredate
			from emp e inner join dept d on d.deptno = e.deptno
			where e.hiredate like '%81'
			order by hiredate;
		v_angajat c_angajati%rowtype;
begin
	open c_angajati;
	loop
		fetch c_angajati into v_angajat;
		exit when c_angajati%NOTFOUND;
		dbms_output.put_line(v_angajat.dname || ' ' || v_angajat.empno || ' ' ||
			v_angajat.ename || ' ' || v_angajat.sal || ' ' || v_angajat.hiredate);
	end loop;
	close c_angajati;
end;
/

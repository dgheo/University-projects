--	@C:\Users\alina\Desktop\bd2_lab5\ex5.sql


-- Sa se foloseasca un cursor pt a face o lista cu veniturile managerilor din companie

set serveroutput on;
declare
	cursor c_angajati is
		select d.dname, e.empno, e.ename, e.sal, e.comm
			from emp e inner join dept d on d.deptno = e.deptno
			where lower(e.job) like lower('Manager');
	angajat c_angajati%rowtype;
	venit number := 0;
begin
	open c_angajati;
	dbms_output.put_line(rpad('ECUSON', 10) || rpad('NUME', 20) ||
		rpad('DEPARTAMENT', 20) || lpad('VENIT', 10));
	dbms_output.put_line(rpad('=', 10, '=') || rpad('=', 20, '=') ||
		rpad('=', 20, '=') || lpad('=', 10, '='));
	loop
		fetch c_angajati into angajat;
		exit when c_angajati%NOTFOUND;
		venit := round(angajat.sal + nvl(angajat.comm, 0));
		dbms_output.put_line(rpad(angajat.empno, 10) || rpad(angajat.ename, 20) ||
			rpad(angajat.dname, 20) || lpad(venit, 10));
		venit := 0;
	end loop;
	close c_angajati;
end;
/

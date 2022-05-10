--	@C:\Users\alina\Desktop\bd2_lab5\ex12.sql


-- Să se listeze toți angajatii din tabela EMP

set serveroutput on;
declare
	c_emp SYS_REFCURSOR;
	angajat emp%rowtype;
begin
	open c_emp for select * from emp;
	loop
		fetch c_emp into angajat;
		exit when c_emp%NOTFOUND;
		dbms_output.put_line(angajat.ename || ' ' ||
			angajat.job || ' ' || angajat.sal);
	end loop;
	close c_emp;
end;
/

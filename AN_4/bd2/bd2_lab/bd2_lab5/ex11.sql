--	@C:\Users\alina\Desktop\bd2_lab5\ex11.sql


-- Să se facă o listă cu toate departamentele
-- UTIL PT TRANSMITERE SETURI DE DATE LA SUBPROGRAME

set serveroutput on;
declare
	type r_cursor is REF CURSOR;
	c_dept r_cursor;
	depart dept.dname%type;
begin
	open c_dept for select dname from dept;
	loop
		fetch c_dept into depart;
		exit when c_dept%NOTFOUND;
		dbms_output.put_line(depart);
	end loop;
	close c_dept;
end;
/

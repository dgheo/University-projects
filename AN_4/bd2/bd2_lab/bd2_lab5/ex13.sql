--	@C:\Users\alina\Desktop\bd2_lab5\ex13.sql


-- Să se folosească un record pentru a păstra
-- numele, funcția și salariul pentru toți angajații

set serveroutput on;
declare
	type r_cursor is REF CURSOR;
	type rec_ang is record(
		nume emp.ename%type,
		functie emp.job%type,
		salariu emp.sal%type
	);
	c_ang r_cursor;
	angajat rec_ang;
begin
	open c_ang for select ename, job, sal from emp;
	loop
		fetch c_ang into angajat;
		exit when c_ang%NOTFOUND;
		dbms_output.put_line(angajat.ename || ' ' ||
			angajat.functie || ' ' || angajat.salariu);
	end loop;
	close c_ang;
end;
/

set serveroutput on;
declare
	type vector is varray(4) of dept.deptno%type;
	myVector vector;
	contor integer;
begin
	dbms_output.put_line('folosire bulk collect into varray');
	select deptno bulk collect into myVector from dept;
	for contor in myVector.first .. myVector.last
	loop
		dbms_output.put_line('myVector(' || contor || ')=' || myVector(contor));
	end loop;
end;
/
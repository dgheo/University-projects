set serveroutput on;
declare
	type tableIndexat is table of dept%rowtype index by binary_integer;
	contor integer;
	tblIndexat tableIndexat;
begin
	dbms_output.put_line('folosire bulk collect into index-by table');
	select * bulk collect into tblIndexat from dept;
	for contor in tblIndexat.first .. tblIndexat.last
	loop
		dbms_output.put_line('contor=' || contor
			|| ' tblIndexat.deptno=' || tblIndexat(contor).deptno
			|| ' tblIndexat.dname=' || tblIndexat(contor).dname
			|| ' tblIndexat.loc=' || tblIndexat(contor).loc);
	end loop;
end;
/
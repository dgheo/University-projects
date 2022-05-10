set serveroutput on;
declare
	type myRecord is record(
		numeAngajat emp.ename%type,
		numeDepartament dept.dname%type
	);
	type myTabel is table of myRecord;
	tbl myTabel;
	contor integer;
begin
	select e.ename, d.dname bulk collect into tbl
		from emp e natural join dept d;
	for contor in tbl.first .. tbl.last
	loop
		dbms_output.put_line(tbl(contor).numeAngajat || ' lucreaza in departamentul '
			|| tbl(contor).numeDepartament);
	end loop;
end;
/
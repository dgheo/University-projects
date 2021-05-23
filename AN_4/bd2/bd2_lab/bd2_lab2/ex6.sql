set serveroutput on;
declare
	type myRecord is record
	(
		idDepartament dept.deptno%type,
		numeDepartament dept.dname%type,
		locatie dept.loc%type
	);
	deptRecord myRecord;
	deptRecordUpdate myRecord;
	deptRecordInsert myRecord;
begin
	deptRecordInsert.idDepartament := 50;
	deptRecordInsert.numeDepartament := 'IT Departament';
	deptRecordInsert.locatie := 'Bucuresti';
	-- insert folosind record
	insert into dept
		values(deptRecordInsert.idDepartament,
		deptRecordInsert.numeDepartament,
		deptRecordInsert.locatie);
	-- select folosind record
	select * into deptRecord from dept
		where deptno = deptRecordInsert.idDepartament;
	dbms_output.put_line('Informatii dupa insert ' || 
		deptRecord.idDepartament || ' ' ||
		deptRecord.numeDepartament || ' ' || deptRecord.locatie);
	deptRecordUpdate.idDepartament := 50;
	deptRecordUpdate.numeDepartament := 'IT Departament';
	deptRecordUpdate.locatie := 'Bucuresti';
end;
/
set serveroutput on;
declare
	type deptRecord is record
	(
		idDept number(2),
		numeDept varchar2(14),
		locatie varchar2(13)
	);
	recDept deptRecord;
	deptInfo dept%rowtype;
begin
	select * into deptInfo from dept where deptno = 10;
	recDept := deptInfo;
	dbms_output.put_line('Denumirea departamentului ' || recDept.idDept ||
		' este ' || recDept.numeDept);
end;
/
		
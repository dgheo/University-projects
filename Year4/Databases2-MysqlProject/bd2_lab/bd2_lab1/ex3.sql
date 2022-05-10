declare
	functie varchar2(9) := 'Analyst';
	comision integer;
	ecuson emp.empno%type := &empid;
	nume emp.ename%type;
begin
	begin
		nume := 'Ionescu';
		insert into emp(empno, ename, job)
			values(ecuson, nume, upper(functie));
	end;
	begin
		comision := 200;
		update emp set comm = comision where empno = ecuson;
	end;
end;
/

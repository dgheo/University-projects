set serveroutput on;
declare
	idDepartament number(4);
	idAngajat number(4);
	numeAngajat varchar(30);
	comision number(10);
	dataAngajare date;
begin
	idDepartament := &idDept;
	idAngajat := &idAng;
	begin
		select ename, hiredate, comm into numeAngajat, dataAngajare, comision
			from emp where empno = idAngajat and deptno=idDepartament;
		dbms_output.put_line(rpad('Nume', 30, ' ') ||
			rpad('Data Angajare', 15, ' ') || lpad('Comision', 10, ' '));
		dbms_output.put_line(rpad(numeAngajat, 30, ' ') ||
			rpad(dataAngajare, 15, ' ') || lpad(comision, 10, ' '));
		exception
			when no_data_found then null;
	end;
end;
/
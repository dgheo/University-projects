set serveroutput on;
declare
	numeAngajat nvarchar2(20);
	idDepartament integer;
	numeDepartament varchar(20);
	dataAngajare date;
	idAngajat number(6);
	stare boolean := true;
	venit float;
	zileLucrate number(7);
	venitOrar real;
	zileLuna constant smallint := 21;
begin
	idAngajat := &idAngajat;
	select deptno, ename, sal + nvl(comm, 0), hiredate
		into idDepartament, numeAngajat, venit, dataAngajare
		from emp where empno = idAngajat;
	select dname into numeDepartament
		from dept where deptno = idDepartament;
	venitOrar := round(venit/(zileLuna*8),2);
	zileLucrate := sysdate - dataAngajare;
	dbms_output.put_line(numeAngajat || ' are un venit orar de ' ||
		venitOrar || ' si face parte din departamentul ' ||
		numeDepartament || '.' || chr(13) || chr(10) ||
		'A lucrat in firma un numar total de ' || zileLucrate || ' zile.' );
	exception
		when no_data_found then
			stare := false;
			dbms_output.put_line('Angajatul nu se afla in baza de date!');
end;
/
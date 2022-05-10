set serveroutput on;
declare
	deptId integer;
	contor integer := 7000;
	numeAngajat varchar2(20);
	venit number;
	dataAngajare date;
	numeDepartament dept.dname%type;
begin
	deptId := &idDept;
	select dname into numeDepartament from dept where deptno = deptId;
	dbms_output.put_line(rpad('Nume', 30, '=') ||
		rpad('Data Angajare', 15, '=') ||
		rpad('Venit', 10, '='));
		
	loop
		contor := contor + 1;
		begin
			select ename, hiredate, sal+nvl(comm, 0)
				into numeAngajat, 
		
		
		
	select grade  into gradSalariu from salgrade
		where losal<=venit and venit<=hisal;
		
	<<mycase>> -- exemplu de folosire eticheta(nu este obligatorie)
	case gradSalariu
		when 1 then impozit := venit*0.10;
		when 2 then impozit := venit*0.15;
		when 3 then impozit := venit*0.20;
		when 4 then impozit := venit*0.25;
	else
		impozit := venit*0.30;
	end case mycase;
	
	dbms_output.put_line('Angajatul ' || numeAngajat ||
		' are venitul=' || venit || ' si un impozit=' || impozit);
	exception 
		when no_data_found then 
			dbms_output.put_line('Nu exista angajat cu ecusonul = ' || ecuson);
end;
/		


























	select ename, job, comm into numeAngajat, functie, comAngajat 
		from emp 
		where empno = ecuson; 
	if lower(functie) = 'manager' and (comAngajat = 0 or comAngajat is null)
	then 
		update emp set comm = 0.1*sal where empno = ecuson; 
		dbms_output.put_line('Comisionul lui ' ||
			numeAngajat || ' a fost modificat!');
	end if;
	exception 
		when no_data_found then 
			dbms_output.put_line('Nu exista angajat cu empno = ' || ecuson);
end;
/



INSERT INTO EMP VALUES
        (7369, 'SMITH',  'CLERK',     7902,
        TO_DATE('17-12-1980', 'DD-MM-YYYY'),  800, NULL, 20);


		CREATE TABLE PRIME
        (DEN_DEPARTAMENT dept.dname%type,
		 NMUE_ANGAJAT varchar2(20), 
		 JOB varchar2(15), 
		 SALARIU emp.sal%type, 
		 COMISION number, 
		 SAL_MED_DEPT emp.sal%type, 
		 PRIMA emp.sal%type);

		 
	
